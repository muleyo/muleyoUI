-- Big Healthbar (WoW Forever, default portrait unit frames), and the frame
-- layout shared with Retail Textures (RetailTextures.lua).
--
-- Ported from BetterBlizzFrames by Bodify:
--   forever/modules/bigPlayerHealthbar.lua  (player bar, art, combat glow)
--   forever/modules/healthbarLayouts.lua    (target / focus layout and art)
--   shared/healthbarMirror.lua              (target / focus mirror bar)
--   forever/modules/camelotFrames.lua       (player mana height, group icons,
--                                            target mana on retail art)
--
-- Kept as in BBF's defaults: "Reduced" size (not Extra Large), name above the
-- bar, mana bar shown. The two options change the same bars, so this file lays
-- the frames out for every combination of them:
--   Big Healthbar only:  standard Forever art, the health bar grows into the
--                        name row.
--   Retail Textures:     retail art (big or normal) with the bars put into the
--                        art's bar slots.
--   Player:         the real bars are moved and resized. Frame layout changes
--                   wait for the end of combat, like in BBF.
--   Target / Focus: Blizzard re-lays these bars out on every target change, so
--                   BBF shows a separate "mirror" bar and hides the real one;
--                   the mirror copies value, colour, texture, heal prediction
--                   and absorbs from it.

local BigHealthbar = mUI:NewModule("mUI.Modules.Unitframes.BigHealthbar")

local MEDIA = "Interface\\AddOns\\mUI\\Media\\Textures\\BigHealthbar\\"
local ART = MEDIA .. "Player-PortraitOn-BigHealthbar-Reduced.png"
local ART_ALT = MEDIA .. "Player-PortraitOn-ClassResource-BigHealthbar-Reduced.png"
local ART_FLASH = MEDIA .. "Player-PortraitOn-InCombat-BigHealthbar-Reduced.png"
local ART_STATUS = MEDIA .. "Player-PortraitOn-Status-BigHealthbar-Reduced.png"

local PLAYER_MASK = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health-Mask"
local TARGET_MASK = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Mask"
local PLAYER_ATLAS = "UI-HUD-UnitFrame-Player-PortraitOn"
local PLAYER_ALT_ATLAS = "UI-HUD-UnitFrame-Player-PortraitOn-ClassResource"
local HELPER_TEXTURE = "Interface\\Buttons\\WHITE8x8"

-- Group (leader / guide) icons drop below the raised top edge of the bar.
local GROUP_ICON_DROP = 10
-- Target threat number moves up with the big bar (Forever art).
local THREAT_RAISE = 5
-- Unit names sit above the big bar (BBF: 9 for the Reduced size). On the
-- retail Big Healthbar arts the name is centred on the art's name strip.
local NAME_RAISE = 9
-- Retail art: the health text left of the bar keeps clear of the portrait.
local RETAIL_LEFT_TEXT_X = 6
-- Retail art, big bar: player role icon and target name background move up.
local RETAIL_ROLE_RAISE = 8
local RETAIL_NAME_BG_RAISE = 7.5

local bigOn, retailOn, symOn = false, false, false
local applying = false

local function On()
    return bigOn or (retailOn and mUI.UFRetail ~= nil)
end

local function Retail()
    return retailOn and mUI.UFRetail or nil
end

-- Symmetric Player Frame: only on retail art.
local function Symmetric()
    return symOn and Retail() ~= nil
end

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------
local pending = {}
local combatFrame = CreateFrame("Frame")
combatFrame:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    local list = pending
    pending = {}
    for func in pairs(list) do
        func()
    end
end)

local function RunAfterCombat(func)
    pending[func] = true
    combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

-- The client can hand back secret values (12.x); those are never compared,
-- added or stored.
local function IsSecret(v)
    return issecretvalue and issecretvalue(v) or false
end

local function Number(v)
    if type(v) == "number" and not IsSecret(v) then return v end
end

-- Anchors of a region, skipping any the client will not read back.
local function SavePoints(region)
    local points = {}
    if not region then return points end
    local ok, count = pcall(region.GetNumPoints, region)
    if not ok or not Number(count) then return points end
    for i = 1, count do
        local okPoint, point, relativeTo, relativePoint, x, y = pcall(region.GetPoint, region, i)
        x, y = Number(x), Number(y)
        if okPoint and point and x and y then
            points[#points + 1] = { point, relativeTo, relativePoint, x, y }
        end
    end
    return points
end

local function RestorePoints(region, points)
    if not region or not points or #points == 0 then return end
    region:ClearAllPoints()
    for _, p in ipairs(points) do
        region:SetPoint(p[1], p[2], p[3], p[4], p[5])
    end
end

local function SetSizeIf(region, width, height)
    width, height = Number(width), Number(height)
    if region and width and height and width > 0 and height > 0 then
        region:SetSize(width, height)
    end
end

local function Size(region)
    if not region then return end
    local ok, width, height = pcall(region.GetSize, region)
    if ok then return Number(width), Number(height) end
end

-- A texture's art, size and anchors, to put back later.
local function SnapTex(tex)
    if not tex then return end
    local ok, atlas = pcall(function() return tex.GetAtlas and tex:GetAtlas() or nil end)
    atlas = ok and type(atlas) == "string" and atlas or nil
    local file
    if not atlas and tex.GetTexture then
        local okFile, value = pcall(tex.GetTexture, tex)
        if okFile and not IsSecret(value) then file = value end
    end
    local width, height = Size(tex)
    return {
        atlas = atlas,
        file = file,
        width = width,
        height = height,
        points = SavePoints(tex),
    }
end

-- Layout errors: one red line in chat per place, and the full text (with
-- the call stack) in mUI's saved settings, under global.bigHealthbarErrors.
local reported = {}

local function Traceback(err)
    return tostring(err) .. "\n" .. (debugstack and debugstack(2, 12, 0) or "")
end

local function Report(where, err)
    local text = tostring(err)
    local global = mUI.db and mUI.db.global
    if global then
        global.bigHealthbarErrors = global.bigHealthbarErrors or {}
        local log = global.bigHealthbarErrors
        if #log < 10 then log[#log + 1] = where .. ": " .. text end
    end
    if not reported[where] then
        reported[where] = true
        print("|cffff4040mUI Big Healthbar / Retail Textures error (" .. where .. "):|r " .. (text:match("^[^\n]*") or text))
    end
end

local function RestoreTex(tex, s, isMask)
    if not tex or not s then return end
    if mUI.UFRetail then mUI.UFRetail.Forget(tex) end
    if s.atlas then
        tex:SetAtlas(s.atlas, false)
    elseif s.file then
        if isMask then
            tex:SetTexture(s.file, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        else
            tex:SetTexture(s.file)
            tex:SetTexCoord(0, 1, 0, 1)
        end
    end
    SetSizeIf(tex, s.width, s.height)
    RestorePoints(tex, s.points)
end

-- Moves a region up by `shift` and keeps it there when Blizzard re-anchors it.
local function ShiftRegionY(region, shift)
    if not region or region:GetNumPoints() == 0 then return end
    shift = shift or 0
    if shift == 0 and not region.mUIBigShiftY then return end
    if not region.mUIBigShiftHooked then
        region.mUIBigShiftHooked = true
        hooksecurefunc(region, "SetPoint", function(self)
            if self.mUIBigShifting or not self.mUIBigShiftY then return end
            local wanted = self.mUIBigShiftY
            self.mUIBigShiftY = nil
            ShiftRegionY(self, wanted)
        end)
    end
    local old = region.mUIBigShiftY or 0
    if old == shift then return end
    local point, rel, relPoint, x, y = region:GetPoint(1)
    region.mUIBigShifting = true
    region:SetPoint(point, rel, relPoint, x, y - old + shift)
    region.mUIBigShifting = nil
    region.mUIBigShiftY = shift ~= 0 and shift or nil
end

-- Unit name: raised above the big bar; 0 puts it back. A Blizzard re-anchor
-- of the name is raised too.
local function RaiseName(name, raise)
    if not name then return end
    local old = name.mUIBigNameRaise or 0
    if raise == old then return end
    if not name.mUIBigNameHooked then
        name.mUIBigNameHooked = true
        hooksecurefunc(name, "SetPoint", function(self, point)
            local shift = self.mUIBigNameRaise
            if self.mUIBigNameShifting or not shift or type(point) ~= "string" then return end
            point = point:upper()
            for i = 1, self:GetNumPoints() do
                local p, rel, relPoint, x, y = self:GetPoint(i)
                if p == point then
                    self.mUIBigNameShifting = true
                    self:SetPoint(p, rel, relPoint, x, y + shift)
                    self.mUIBigNameShifting = nil
                    return
                end
            end
        end)
    end
    local points = SavePoints(name)
    name.mUIBigNameShifting = true
    name:ClearAllPoints()
    for _, p in ipairs(points) do
        name:SetPoint(p[1], p[2], p[3], p[4], p[5] - old + raise)
    end
    name.mUIBigNameShifting = nil
    name.mUIBigNameRaise = raise ~= 0 and raise or nil
end

-- Name centred on the art's name strip (retail Big Healthbar arts). Turning
-- it off puts Blizzard's anchor back; a Blizzard re-anchor of the name while
-- it is on goes back onto the strip.
local function PinName(name)
    name.mUIStripPinning = true
    name:ClearAllPoints()
    name:SetPoint("CENTER", name.mUIStripTex, "TOPLEFT", name.mUIStripX, -name.mUIStripY)
    name.mUIStripPinning = nil
end

local function SetNameOnStrip(name, tex, R)
    if not name then return end
    local x, y
    if tex and R then x, y = R.NameStrip(tex) end
    if x then
        if not name.mUIStripSaved then
            name.mUIStripSaved = { points = SavePoints(name), justify = name:GetJustifyH() }
        end
        if not name.mUIStripHooked then
            name.mUIStripHooked = true
            hooksecurefunc(name, "SetPoint", function(self)
                if self.mUIStripTex and not self.mUIStripPinning then PinName(self) end
            end)
        end
        name.mUIStripTex, name.mUIStripX, name.mUIStripY = tex, x, y
        PinName(name)
        name:SetJustifyH("CENTER")
    elseif name.mUIStripSaved then
        local s = name.mUIStripSaved
        name.mUIStripTex, name.mUIStripSaved = nil, nil
        RestorePoints(name, s.points)
        if s.justify then name:SetJustifyH(s.justify) end
    end
end

-- Power value right-aligned under the health value: its right edge goes to
-- the health text's right edge, it keeps its own height on the power bar.
-- Done with anchors only, through an invisible guide frame whose right edge
-- follows the health text and whose bottom sits on the power bar's middle:
-- the client does not hand back positions on the player frame, and the
-- anchors keep following both texts by themselves. A re-anchor of the text
-- by the game is aligned again.

-- The power bar texts that sit on its right side: RightText, and on the
-- Forever player frame also ManaBarText.
local POWER_TEXTS = { "RightText", "ManaBarText" }

local function IsRightPoint(p)
    return type(p[1]) == "string" and p[1]:upper():find("RIGHT") ~= nil
end

-- A text showing its value on the right: anchored by a right point, or
-- right-justified.
local function OnRightSide(text, points)
    if not points or #points == 0 then return false end
    for _, p in ipairs(points) do
        if IsRightPoint(p) then return true end
    end
    return text:GetJustifyH() == "RIGHT"
end

-- The text's height on the bar: its own vertical offset when its first
-- anchor is centred vertically (LEFT / RIGHT / CENTER), else the middle.
local function MiddleOffset(points)
    local first = points[1]
    if not first then return 0 end
    local point = tostring(first[1]):upper()
    local relativePoint = tostring(first[3] or first[1]):upper()
    if point:find("TOP") or point:find("BOTTOM") or relativePoint:find("TOP") or relativePoint:find("BOTTOM") then
        return 0
    end
    return first[5] or 0
end

-- `always`: RightText is the value on the right whatever its anchor reads
-- back as (on the player frame the client does not hand its anchor back).
local function AlignText(text, manaBar, healthText, always)
    if not text.mUIAlignPoints then
        local points = SavePoints(text)
        if not always and not OnRightSide(text, points) then return end
        text.mUIAlignPoints = points
    end
    text.mUIAlignBar, text.mUIAlignHealth, text.mUIAlignAlways = manaBar, healthText, always
    if not text.mUIAlignHooked then
        text.mUIAlignHooked = true
        hooksecurefunc(text, "SetPoint", function(self)
            if self.mUIAligning or not self.mUIAlignPoints then return end
            local points = SavePoints(self)
            if not self.mUIAlignAlways and not OnRightSide(self, points) then return end
            if #points > 0 then self.mUIAlignPoints = points end
            AlignText(self, self.mUIAlignBar, self.mUIAlignHealth, self.mUIAlignAlways)
        end)
    end
    local guide = manaBar.mUIAlignGuide
    if not guide then
        guide = CreateFrame("Frame", nil, manaBar)
        guide:EnableMouse(false)
        manaBar.mUIAlignGuide = guide
    end
    guide:ClearAllPoints()
    guide:SetPoint("TOPRIGHT", healthText, "TOPRIGHT")
    guide:SetPoint("BOTTOMLEFT", manaBar, "LEFT")
    text.mUIAligning = true
    text:ClearAllPoints()
    text:SetPoint("RIGHT", guide, "BOTTOMRIGHT", 0, MiddleOffset(text.mUIAlignPoints))
    text.mUIAligning = nil
end

local AlignPowerText

AlignPowerText = function(manaBar, healthText)
    if not manaBar or not healthText then return end
    for _, key in ipairs(POWER_TEXTS) do
        local text = manaBar[key]
        if text then AlignText(text, manaBar, healthText, key == "RightText") end
    end
end

local function RestorePowerText(manaBar)
    if not manaBar then return end
    for _, key in ipairs(POWER_TEXTS) do
        local text = manaBar[key]
        if text and text.mUIAlignPoints then
            local points = text.mUIAlignPoints
            text.mUIAlignPoints = nil
            if #points > 0 then
                RestorePoints(text, points)
            else
                -- Its anchor could not be read back: the stock place.
                text:ClearAllPoints()
                text:SetPoint("RIGHT", manaBar, "RIGHT", -2, 0)
            end
        end
    end
end

local function SetGroupIconsDropped(context, point, x, y, dropped)
    if not context then return end
    for _, icon in ipairs({ context.LeaderIcon, context.GuideIcon }) do
        if icon then
            if dropped then
                icon.mUIBigPoints = icon.mUIBigPoints or SavePoints(icon)
                icon:ClearAllPoints()
                icon:SetPoint(point, x, y - GROUP_ICON_DROP)
            elseif icon.mUIBigPoints then
                RestorePoints(icon, icon.mUIBigPoints)
                icon.mUIBigPoints = nil
            end
        end
    end
end

-------------------------------------------------------------------------------
-- Player
-------------------------------------------------------------------------------
local PLAYER_TEXTS = { "HealthBarText", "LeftText", "RightText" }
local playerSaved

local function PlayerMain()
    return PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
end

local function PlayerContextual()
    return PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
end

local function PlayerHealth()
    local hp = PlayerFrame_GetHealthBarContainer and PlayerFrame_GetHealthBarContainer() or PlayerMain().HealthBarsContainer
    return hp, hp.HealthBar, hp.HealthBarMask
end

local function PlayerMana()
    return PlayerFrame_GetManaBar and PlayerFrame_GetManaBar() or PlayerMain().ManaBarArea.ManaBar
end

-- Heal prediction and absorb segments draw Blizzard's bar art, which has a
-- dark rim and shading of its own. Next to mUI's flat bar texture that rim
-- makes them look thinner than the health fill, so while the layout is on
-- they take the health bar's texture (keeping their own colour).
local SEGMENT_KEYS = { "MyHealPredictionBar", "OtherHealPredictionBar", "HealAbsorbBar", "TotalAbsorbBar" }

-- The bar texture's file when it is a plain texture (mUI's bar texture),
-- nil when it is Blizzard's art.
local function FlatBarFile(barTexture)
    if not barTexture or barTexture:GetAtlas() then return nil end
    local file = barTexture:GetTexture()
    if file == nil or IsSecret(file) then return nil end
    return file
end

-- `file` nil puts Blizzard's art back.
local function SetFlatFill(fill, file)
    if file then
        if fill.mUIStockAtlas == nil then
            fill.mUIStockAtlas = fill:GetAtlas() or false
        end
        fill:SetTexture(file)
        fill:SetTexCoord(0, 1, 0, 1)
    elseif fill.mUIStockAtlas ~= nil then
        if fill.mUIStockAtlas then
            fill:SetAtlas(fill.mUIStockAtlas, TextureKitConstants.IgnoreAtlasSize)
        end
        fill.mUIStockAtlas = nil
    end
end

local function SetPlayerSegmentFills(on)
    local _, bar = PlayerHealth()
    local file = on and FlatBarFile(bar:GetStatusBarTexture()) or nil
    for _, key in ipairs(SEGMENT_KEYS) do
        local segment = bar[key]
        if segment and segment.Fill then
            SetFlatFill(segment.Fill, file)
        end
    end
end

local function PlayerAltBar()
    return PlayerFrame_GetAlternatePowerBar and PlayerFrame_GetAlternatePowerBar() or nil
end

-- The art in use: the class resource variant when Blizzard shows it.
local function PlayerArtTexture()
    local container = PlayerFrame.PlayerFrameContainer
    local altTex = container.AlternatePowerFrameTexture
    if altTex and altTex:IsShown() then return altTex end
    return container.FrameTexture
end

-- The stock layout, read once before the first change so it can be put back.
local function SavePlayer()
    if playerSaved then return end
    local container = PlayerFrame.PlayerFrameContainer
    local hp, bar, mask = PlayerHealth()
    local mana = PlayerMana()
    local s = {
        frameTex = SnapTex(container.FrameTexture),
        altTex = SnapTex(container.AlternatePowerFrameTexture),
        flash = SnapTex(container.FrameFlash),
        status = SnapTex(PlayerMain().StatusTexture),
        portraitMask = SnapTex(container.PlayerPortraitMask),
        hpPoints = SavePoints(hp),
        barPoints = SavePoints(bar),
        mask = SnapTex(mask),
        texts = {},
        manaPoints = SavePoints(mana),
        manaMask = SnapTex(mana.ManaBarMask),
        namePoints = SavePoints(PlayerName),
    }
    s.hpWidth, s.hpHeight = Size(hp)
    s.barWidth, s.barHeight = Size(bar)
    s.manaWidth, s.manaHeight = Size(mana)
    if container.PlayerPortrait then
        s.portraitWidth, s.portraitHeight = Size(container.PlayerPortrait)
        s.portraitPoints = SavePoints(container.PlayerPortrait)
    end
    for _, key in ipairs(PLAYER_TEXTS) do
        if hp[key] then s.texts[key] = SavePoints(hp[key]) end
    end
    local loss = hp.PlayerFrameHealthBarAnimatedLoss
    if loss then
        s.lossWidth, s.lossHeight = Size(loss)
        s.lossPoints = SavePoints(loss)
    end
    local altBar = PlayerAltBar()
    if altBar then
        s.altBarWidth, s.altBarHeight = Size(altBar)
        s.altBarPoints = SavePoints(altBar)
        s.altBarMask = SnapTex(altBar.PowerBarMask)
    end
    playerSaved = s
end

-- Puts every saved piece back. `art` false leaves the frame art alone (vehicle).
local function RestorePlayerStock(art)
    local s = playerSaved
    if not s then return end
    local container = PlayerFrame.PlayerFrameContainer
    local hp, bar, mask = PlayerHealth()
    local mana = PlayerMana()

    if art then
        RestoreTex(container.FrameTexture, s.frameTex)
        if not (s.frameTex and (s.frameTex.atlas or s.frameTex.file)) then
            container.FrameTexture:SetAtlas(PLAYER_ATLAS)
        end
        RestoreTex(container.AlternatePowerFrameTexture, s.altTex)
        RestoreTex(container.FrameFlash, s.flash)
        RestoreTex(PlayerMain().StatusTexture, s.status)
        RestoreTex(container.PlayerPortraitMask, s.portraitMask, true)
        if container.PlayerPortrait and s.portraitPoints then
            SetSizeIf(container.PlayerPortrait, s.portraitWidth, s.portraitHeight)
            RestorePoints(container.PlayerPortrait, s.portraitPoints)
        end
        local corner = PlayerContextual().PlayerPortraitCornerIcon
        if corner and corner.mUISymAlpha then
            corner:SetAlpha(corner.mUISymAlpha)
            corner.mUISymAlpha = nil
        end
    end

    SetSizeIf(hp, s.hpWidth, s.hpHeight)
    RestorePoints(hp, s.hpPoints)
    SetSizeIf(bar, s.barWidth, s.barHeight)
    RestorePoints(bar, s.barPoints)
    RestoreTex(mask, s.mask, true)
    for key, points in pairs(s.texts) do
        RestorePoints(hp[key], points)
    end
    local loss = hp.PlayerFrameHealthBarAnimatedLoss
    if loss and s.lossPoints then
        RestorePoints(loss, s.lossPoints)
        SetSizeIf(loss, s.lossWidth, s.lossHeight)
    end
    SetPlayerSegmentFills(false)

    RestorePowerText(mana)
    SetSizeIf(mana, s.manaWidth, s.manaHeight)
    RestorePoints(mana, s.manaPoints)
    RestoreTex(mana.ManaBarMask, s.manaMask, true)
    local altBar = PlayerAltBar()
    if altBar and s.altBarPoints then
        SetSizeIf(altBar, s.altBarWidth, s.altBarHeight)
        RestorePoints(altBar, s.altBarPoints)
        RestoreTex(altBar.PowerBarMask, s.altBarMask, true)
    end

    SetGroupIconsDropped(PlayerContextual(), "TOPLEFT", 86, -10, false)
    ShiftRegionY(PlayerContextual().RoleIcon, 0)
    RaiseName(PlayerName, 0)
    SetNameOnStrip(PlayerName, nil)
    RestorePoints(PlayerName, s.namePoints)
end

-- Frame art for the current options. PlayerFrame.state is still nil at login,
-- so only the vehicle state is skipped.
local function SetPlayerArt()
    if not On() or PlayerFrame.state == "vehicle" then return end
    local container = PlayerFrame.PlayerFrameContainer
    local frameTex, altTex = container.FrameTexture, container.AlternatePowerFrameTexture
    local R = Retail()
    if R and Symmetric() then
        -- The target art mirrored; the class resource variants are drawn
        -- mirrored already.
        if bigOn then
            R.SetFile(frameTex, "Target-BigHealthbar-Reduced", true, 192, 67)
            if altTex then
                R.SetFile(altTex, "Target-BigHealthbar-Reduced-Alt", false)
                altTex:ClearAllPoints()
                altTex:SetAllPoints(frameTex)
            end
        else
            R.SetSheet(frameTex, "Target-PortraitOn", true, 192, 67)
            if altTex then
                R.SetFile(altTex, "UI-HUD-UnitFrame-Target-PortraitOn-Alt", false, 192, 67)
                altTex:ClearAllPoints()
                altTex:SetPoint("CENTER", container, "CENTER", 0, -0.5)
            end
        end
        return
    end
    if R then
        if bigOn then
            R.SetFile(frameTex, "Player-BigHealthbar-Reduced", false, 198, 71)
            R.SetFile(altTex, "Player-ClassResource-BigHealthbar-Reduced", false, 198, 74)
        else
            R.SetSheet(frameTex, "Player-PortraitOn")
            R.SetSheet(altTex, "Player-PortraitOn-ClassResource")
        end
        return
    end
    frameTex:SetTexture(ART)
    frameTex:SetTexCoord(0, 1, 0, 1)
    if altTex then
        altTex:SetTexture(ART_ALT)
        altTex:SetTexCoord(0, 1, 0, 1)
    end
end

-- Combat flash and rest glow matching the art.
local function UpdatePlayerGlows()
    if not On() or PlayerFrame.state == "vehicle" or UNIT_FRAME_SHOW_HEALTH_ONLY then return end
    local container = PlayerFrame.PlayerFrameContainer
    local flash = container.FrameFlash
    local status = PlayerMain().StatusTexture
    local R = Retail()
    if R and Symmetric() then
        local altTex = container.AlternatePowerFrameTexture
        local altShown = altTex and altTex:IsShown()
        if flash then
            flash:ClearAllPoints()
            if bigOn then
                R.SetFile(flash, "Target-InCombat-BigHealthbar-Reduced", true, 188, 67)
                flash:SetPoint("CENTER", container, "CENTER", 0.5, 2)
            elseif altShown then
                R.SetFile(flash, "UI-HUD-UnitFrame-Player-PortraitOn-InCombat-Alt-Mirror", false, 192, 67.5)
                flash:SetPoint("CENTER", container, "CENTER", 0, 1.5)
            else
                R.SetSheet(flash, "Target-PortraitOn-InCombat", true, 188, 67)
                flash:SetPoint("CENTER", container, "CENTER", 0.5, 1)
            end
        end
        if status then
            if bigOn then
                R.SetFile(status, "Target-Status-BigHealthbar-Reduced", true, 194, 70)
            else
                R.SetSheet(status, "Target-MinusMob-PortraitOn-Status", true, 194, 70)
            end
            status:ClearAllPoints()
            status:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -13.5)
        end
        return
    end
    if R then
        local alt = PlayerAltBar()
        if flash then
            R.SetSheet(flash, alt and "Player-PortraitOn-ClassResource-InCombat" or "Player-PortraitOn-InCombat")
            flash:ClearAllPoints()
            if alt then
                flash:SetPoint("CENTER", container, "CENTER", -2, 0.5)
            else
                flash:SetPoint("CENTER", container, "CENTER", -1.5, 1)
            end
            if bigOn then
                R.SetFile(flash, "Player-" .. (alt and "ClassResource-InCombat" or "InCombat") .. "-BigHealthbar-Reduced", false, false)
            end
        end
        if status then
            status:ClearAllPoints()
            status:SetPoint("TOPLEFT", container, "TOPLEFT", 18, -14)
            if bigOn then
                R.SetFile(status, "Player-Status-BigHealthbar-Reduced", false, 196, 71)
            else
                R.SetSheet(status, "Player-PortraitOn-Status")
            end
        end
        return
    end
    if flash then
        flash:SetTexture(ART_FLASH)
        flash:SetTexCoord(0, 1, 0, 1)
        flash:SetSize(198, 71)
        flash:ClearAllPoints()
        flash:SetPoint("CENTER", container, "CENTER", 0, 0)
    end
    if status then
        status:SetTexture(ART_STATUS)
        status:SetTexCoord(0, 1, 0, 1)
        status:SetSize(198, 71)
    end
end

local function SetPlayerTextOffset(hp, y, leftX)
    local anchors = {
        HealthBarText = { "CENTER", 0 },
        LeftText = { "LEFT", leftX or 2 },
        RightText = { "RIGHT", -2 },
    }
    for key, a in pairs(anchors) do
        local text = hp[key]
        if text then
            text:ClearAllPoints()
            text:SetPoint(a[1], hp, a[1], a[2], y)
        end
    end
end

-- mUI's own name background on the player frame would sit on top of the bar.
local function SetPlayerNameBgHidden(hidden)
    local rep = PlayerMain().ReputationColor
    if rep then
        rep:SetAlpha(hidden and 0 or 1)
    end
end

local function PlaceRetailPlayerName()
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", PlayerMain(), "TOPLEFT", PlayerFrame.unit == "vehicle" and 96 or 88, -27)
end

-- Big Healthbar on the Forever art.
local function LayoutPlayerForever()
    local hp, bar, mask = PlayerHealth()
    hp:SetHeight(30)
    bar:ClearAllPoints()
    bar:SetPoint("TOPLEFT", hp, "TOPLEFT", 0, 9.5)
    bar:SetHeight(24)
    mask:SetAtlas(PLAYER_MASK, true)
    mask:ClearAllPoints()
    mask:SetPoint("TOPLEFT", bar, "TOPLEFT", -2, 18)
    mask:SetSize(129, 60)
    SetPlayerTextOffset(hp, 11.5)

    -- BBF's mana bar fit for this art.
    local mana = PlayerMana()
    mana:SetHeight(11)
    local point, relativeTo, relativePoint, _, y = mana:GetPoint()
    mana:SetWidth(125.5)
    mana:SetPoint(point, relativeTo, relativePoint, 86, y)
    local manaMask = mana.ManaBarMask
    if manaMask then
        manaMask:SetWidth(129)
        manaMask:ClearAllPoints()
        manaMask:SetPoint("TOPLEFT", mana, "TOPLEFT", -1.5, 2)
    end

    SetGroupIconsDropped(PlayerContextual(), "TOPLEFT", 86, -10, true)
end

-- Retail art, big or normal: the bars go into the art's slots.
local function LayoutPlayerRetail(R)
    local container = PlayerFrame.PlayerFrameContainer
    local hp, bar, mask = PlayerHealth()
    local mana = PlayerMana()
    local portraitMask = container.PlayerPortraitMask
    if Symmetric() then
        -- Round portrait in the mirrored ring, no corner piece.
        if portraitMask then
            portraitMask:SetAtlas("CircleMask")
            portraitMask:ClearAllPoints()
            portraitMask:SetPoint("TOPLEFT", container, "TOPLEFT", 27, -20)
            portraitMask:SetSize(56, 56)
        end
        local portrait = container.PlayerPortrait
        if portrait then
            portrait:SetSize(58.5, 58.5)
            portrait:ClearAllPoints()
            portrait:SetPoint("TOPLEFT", container, "TOPLEFT", 26, -18)
        end
        local corner = PlayerContextual().PlayerPortraitCornerIcon
        if corner then
            if corner.mUISymAlpha == nil then corner.mUISymAlpha = corner:GetAlpha() end
            corner:SetAlpha(0)
        end
    elseif portraitMask then
        portraitMask:SetTexture(R.File("base\\Player-PortraitMask"), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        portraitMask:ClearAllPoints()
        portraitMask:SetAllPoints(container.FrameTexture)
    end
    local tex = PlayerArtTexture()
    if R.FitBars(tex, hp, mask, mana, mana.ManaBarMask) then
        bar:ClearAllPoints()
        bar:SetAllPoints(hp)
        local altBar = PlayerAltBar()
        if altBar and R.FitSlot(altBar, tex, "power") then
            R.MaskSlot(altBar.PowerBarMask, tex, "power")
        end
    end
    SetPlayerTextOffset(hp, 0, RETAIL_LEFT_TEXT_X)
    ShiftRegionY(PlayerContextual().RoleIcon, bigOn and RETAIL_ROLE_RAISE or 0)
end

local function ApplyPlayerNow()
    SavePlayer()
    RestorePlayerStock(true)
    SetPlayerArt()
    UpdatePlayerGlows()
    local R = Retail()
    if R then
        LayoutPlayerRetail(R)
    else
        LayoutPlayerForever()
    end
    -- The red "health lost" flash has its own fixed size: fit it to the bar.
    local hp, bar = PlayerHealth()
    local loss = hp.PlayerFrameHealthBarAnimatedLoss
    if loss then
        loss:ClearAllPoints()
        loss:SetAllPoints(bar)
    end
    SetPlayerSegmentFills(true)
    SetPlayerNameBgHidden(bigOn)
    if R and bigOn then
        SetNameOnStrip(PlayerName, PlayerArtTexture(), R)
    else
        if R then PlaceRetailPlayerName() end
        RaiseName(PlayerName, bigOn and NAME_RAISE or 0)
    end
    AlignPowerText(PlayerMana(), hp.RightText)
end

-- The game lays the player frame out itself when the world loads
-- (PlayerFrame_ToPlayerArt and the bar visuals it calls). The stock layout
-- saved for putting things back must be that one, not the one at login, so
-- nothing is laid out before the world has loaded, and a re-layout by the
-- game is followed one frame later, once it has finished.
local worldReady = false

local function ApplyPlayer()
    if not On() or not worldReady then return end
    if PlayerFrame.state == "vehicle" then return end
    if InCombatLockdown() then
        RunAfterCombat(ApplyPlayer)
        return
    end
    applying = true
    local ok, err = xpcall(ApplyPlayerNow, Traceback)
    applying = false
    if not ok then Report("player", err) end
end

local applyQueued = false

local function QueueApplyPlayer()
    if applyQueued or not On() then return end
    applyQueued = true
    C_Timer.After(0, function()
        applyQueued = false
        ApplyPlayer()
    end)
end

local worldFrame = CreateFrame("Frame")
worldFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
worldFrame:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    C_Timer.After(0, function()
        worldReady = true
        ApplyPlayer()
    end)
end)

local function RestorePlayerNow()
    RestorePlayerStock(PlayerFrame.state ~= "vehicle")
    SetPlayerNameBgHidden(false)
end

local function RestorePlayer()
    if On() or not playerSaved then return end
    if InCombatLockdown() then
        RunAfterCombat(RestorePlayer)
        return
    end
    applying = true
    local ok, err = xpcall(RestorePlayerNow, Traceback)
    applying = false
    if not ok then Report("player restore", err) end
end

-------------------------------------------------------------------------------
-- Target / Focus: mirror health bar
-------------------------------------------------------------------------------
local SEGMENTS = {
    { key = "HealAbsorbBar", template = "HealAbsorbBarTemplate" },
    { key = "MyHealPredictionBar", template = "MyHealPredictionBarTemplate" },
    { key = "OtherHealPredictionBar", template = "OtherHealPredictionBarTemplate" },
    { key = "TotalAbsorbBar", template = "TotalAbsorbBarTemplate" },
}
local SEGMENT_TEXTURES = { "Fill", "TiledFillOverlay", "LeftShadow", "RightShadow" }
local SHADOWS = { "LeftShadow", "RightShadow" }
local GLOWS = {
    OverAbsorbGlow = "OverAbsorbGlowTemplate",
    OverHealAbsorbGlow = "OverHealAbsorbGlowTemplate",
}
local HELPER_SCALE = 0.01
local TARGET_TEXTS = { "HealthBarText", "LeftText", "RightText", "DeadText", "UnconsciousText" }

local function StretchedTargetMask(height)
    return { atlas = TARGET_MASK, x = -1, y = height * 0.3, width = 128, height = height * 1.6 }
end

local function Texts(y, left, center)
    return {
        HealthBarText = { "CENTER", center, y },
        LeftText = { "LEFT", left, y },
        RightText = { "RIGHT", -5, y },
        DeadText = { "CENTER", 0, y },
        UnconsciousText = { "CENTER", 0, y },
    }
end

-- BBF layouts: Forever art "defaultBigReduced", retail "retail",
-- "retailMinus" and "retailBigReduced". On retail art the point and size are
-- replaced by the art's health slot.
local TARGET_LAYOUT = {
    point = { "TOPLEFT", "LEFT", 21, 16 }, width = 126, height = 25, glowOffset = -7,
    mask = { atlas = PLAYER_MASK, x = -2, y = 17.5, width = 129.5, height = 60 },
    texts = Texts(-1, 3, 1),
}
local RETAIL_LAYOUT = {
    point = { "TOPLEFT", "LEFT", 23, 10 }, width = 126, height = 20, glowOffset = -7,
    mask = { atlas = TARGET_MASK, atlasSize = true, x = -1, y = 6 },
    texts = Texts(-0.5, 3, 1),
}
local RETAIL_MINUS_LAYOUT = {
    point = { "TOPLEFT", "LEFT", 23, 11 }, width = 125, height = 12, glowOffset = -7,
    mask = StretchedTargetMask(12),
    texts = Texts(-0.5, 3, 1),
}
local RETAIL_BIG_LAYOUT = {
    point = { "TOPLEFT", "LEFT", 23, 17.5 }, width = 126, height = 27.5, glowOffset = -7,
    mask = StretchedTargetMask(27.5),
    texts = Texts(0, 2, 0),
}

local mirrors = {}

local function TargetMain(frame)
    return frame.TargetFrameContent.TargetFrameContentMain
end

local function Classification(frame)
    return UnitExists(frame.unit) and UnitClassification(frame.unit) or nil
end

local function CreateHelper(parent)
    local helper = CreateFrame("StatusBar", nil, parent)
    helper:SetScale(HELPER_SCALE)
    helper:SetStatusBarTexture(HELPER_TEXTURE)
    local tex = helper:GetStatusBarTexture()
    tex:SetAlpha(0)
    tex:SetSnapToPixelGrid(false)
    tex:SetTexelSnappingBias(0)
    return helper
end

local function AddMask(mirror, region)
    if region and region.AddMaskTexture then
        region:AddMaskTexture(mirror.mask)
    end
end

local function HideSource(mirror)
    local spec = mirror.spec
    mirror.guard = true
    spec.source:SetAlpha(0)
    if spec.tempLoss then spec.tempLoss:SetAlpha(0) end
    mirror.guard = false
end

local function ShowSource(mirror)
    local spec = mirror.spec
    mirror.guard = true
    spec.source:SetAlpha(1)
    if spec.tempLoss then spec.tempLoss:SetAlpha(1) end
    mirror.guard = false
end

local function CopyColor(mirror)
    local r, g, b = mirror.spec.source:GetStatusBarColor()
    mirror.bar:SetStatusBarColor(r, g, b)
end

-- The segment fills take the health fill's flat texture when it has one
-- (see FlatBarFile), the source segment's art otherwise.
local function SyncSegmentFill(mirror, seg)
    local src = seg.source
    local file = FlatBarFile(mirror.fill)
    local atlas = not file and src.Fill and src.Fill:GetAtlas()
    local fill = file or atlas or (src.Fill and src.Fill:GetTexture())
    if fill and fill ~= seg.mUIBigFill then
        seg.mUIBigFill = fill
        if atlas then
            seg.Fill:SetAtlas(atlas, TextureKitConstants.IgnoreAtlasSize)
        else
            seg.Fill:SetTexture(fill)
            seg.Fill:SetTexCoord(0, 1, 0, 1)
        end
    end
end

local CopyTexture

local function HookFill(mirror, src)
    if src.mUIBigMirror then return end
    src.mUIBigMirror = mirror
    hooksecurefunc(src, "SetVertexColor", function(self, r, g, b)
        if self.mUIBigMirror ~= mirror or not mirror.active then return end
        mirror.fill:SetVertexColor(r, g, b)
    end)
    hooksecurefunc(src, "SetDesaturated", function(self, desaturated)
        if self.mUIBigMirror ~= mirror or not mirror.active then return end
        mirror.fill:SetDesaturated(desaturated)
    end)
    hooksecurefunc(src, "SetAtlas", function(self)
        if self.mUIBigMirror ~= mirror or not mirror.active then return end
        CopyTexture(mirror)
    end)
    -- mUI's statusbar texture option writes the fill with SetTexture.
    hooksecurefunc(src, "SetTexture", function(self)
        if self.mUIBigMirror ~= mirror or not mirror.active then return end
        CopyTexture(mirror)
    end)
end

CopyTexture = function(mirror)
    local src = mirror.spec.source:GetStatusBarTexture()
    if not src then return end
    local dst = mirror.fill
    local atlas = src:GetAtlas()
    if atlas then
        dst:SetAtlas(atlas, false)
    else
        dst:SetTexture(src:GetTexture())
    end
    dst:SetTexCoord(src:GetTexCoord())
    if dst.SetSnapToPixelGrid then
        dst:SetSnapToPixelGrid(src:IsSnappingToPixelGrid())
        dst:SetTexelSnappingBias(src:GetTexelSnappingBias())
    end
    dst:SetDrawLayer(src:GetDrawLayer())
    dst:SetAlpha(1)
    CopyColor(mirror)
    -- mUI's class / reaction colours tint the fill texture itself.
    dst:SetVertexColor(src:GetVertexColor())
    dst:SetDesaturated(src:IsDesaturated())
    HookFill(mirror, src)
    for _, seg in ipairs(mirror.segments) do
        SyncSegmentFill(mirror, seg)
    end
end

local function SegmentEnd(segment)
    if segment and segment.source:IsShown() then
        return segment.sizeHelper:GetStatusBarTexture()
    end
end

local function SegmentAnchor(mirror, seg)
    if seg.key == "OtherHealPredictionBar" then
        return SegmentEnd(mirror.MyHealPredictionBar) or mirror.fill, false
    end
    if seg.key == "TotalAbsorbBar" then
        local healAbsorb = mirror.HealAbsorbBar
        if healAbsorb and healAbsorb.source:IsShown() then
            return mirror.fill, true
        end
        return SegmentEnd(mirror.OtherHealPredictionBar) or SegmentEnd(mirror.MyHealPredictionBar) or mirror.fill, true
    end
    return mirror.fill, false
end

local function UpdateSegment(mirror, seg)
    local src = seg.source
    if not seg.hasData then
        seg:Hide()
        return
    end
    local anchor, noOffset = SegmentAnchor(mirror, seg)
    if seg.anchor ~= anchor then
        seg.anchor = anchor
        seg.offsetHelper:ClearAllPoints()
        seg.offsetHelper:SetPoint("TOPRIGHT", anchor, "TOPRIGHT")
        seg.offsetHelper:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT")
    end
    if noOffset then
        seg.offsetHelper:SetValue(0)
    else
        seg.offsetHelper:SetValue(seg.lastOffset)
    end
    seg.sizeHelper:SetValue(seg.lastFill)
    SyncSegmentFill(mirror, seg)
    seg:SetShown(src:IsShown())
end

local function CreateSegment(mirror, src, info)
    local seg = CreateFrame("Frame", nil, mirror.bar, mirror.spec.segmentTemplate .. ", " .. info.template)
    seg:Initialize()
    seg.source = src
    seg.offsetHelper = CreateHelper(mirror.bar)
    seg.offsetHelper:SetMinMaxValues(-1, 0)
    seg.offsetHelper:SetValue(0)
    seg.sizeHelper = CreateHelper(mirror.bar)
    local offsetFill = seg.offsetHelper:GetStatusBarTexture()
    seg.sizeHelper:SetPoint("TOPLEFT", offsetFill, "TOPRIGHT")
    seg.sizeHelper:SetPoint("BOTTOMLEFT", offsetFill, "BOTTOMRIGHT")
    seg.FillMask:ClearAllPoints()
    seg.FillMask:SetPoint("TOPLEFT", offsetFill, "TOPRIGHT")
    seg.FillMask:SetPoint("BOTTOMRIGHT", seg.sizeHelper:GetStatusBarTexture(), "BOTTOMRIGHT")
    for _, key in ipairs(SEGMENT_TEXTURES) do
        AddMask(mirror, seg[key])
    end
    seg:Hide()
    seg.key = info.key

    hooksecurefunc(src, "UpdateFillPosition", function(_, _, fillValue, xOffsetPercent)
        if type(xOffsetPercent) == "nil" then
            xOffsetPercent = 0
        end
        seg.lastFill = fillValue
        seg.lastOffset = xOffsetPercent
        seg.hasData = true
        if mirror.active then
            UpdateSegment(mirror, seg)
        end
    end)
    hooksecurefunc(src, "Hide", function()
        if mirror.active then seg:Hide() end
    end)
    for _, key in ipairs(SHADOWS) do
        local srcShadow, shadow = src[key], seg[key]
        if srcShadow and shadow then
            hooksecurefunc(srcShadow, "SetShown", function(_, shown)
                shadow.mUIBigShown = shown
                if mirror.active then
                    shadow:SetAlphaFromBoolean(shown, 1, 0)
                end
            end)
        end
    end
    return seg
end

local function CreateGlow(mirror, key, template)
    local src = mirror.spec.source[key]
    if not src then return end
    local glow = mirror.bar:CreateTexture(nil, "ARTWORK", template)
    AddMask(mirror, glow)
    glow:SetShown(src:IsShown())
    hooksecurefunc(src, "Show", function()
        if mirror.active then glow:Show() end
    end)
    hooksecurefunc(src, "Hide", function()
        if mirror.active then glow:Hide() end
    end)
    glow.source = src
    mirror.glows[key] = glow
end

local function PlaceGlows(mirror, offset)
    local bar = mirror.bar
    local glow = mirror.glows.OverAbsorbGlow
    if glow then
        glow:ClearAllPoints()
        glow:SetPoint("TOPLEFT", bar, "TOPRIGHT", offset, 0)
        glow:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", offset, 0)
    end
    glow = mirror.glows.OverHealAbsorbGlow
    if glow then
        glow:ClearAllPoints()
        glow:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -offset, 0)
        glow:SetPoint("TOPRIGHT", bar, "TOPLEFT", -offset, 0)
    end
end

local function TempLossPercent(mirror)
    local unit = mirror.spec.source.unit
    if not unit or not GetUnitTotalModifiedMaxHealthPercent then return 0 end
    if not C_CVar.GetCVarBool("showTempMaxHealthLoss") then return 0 end
    local percent = GetUnitTotalModifiedMaxHealthPercent(unit)
    if type(percent) ~= "number" or (issecretvalue and issecretvalue(percent)) then return 0 end
    return Clamp(percent, 0, 1)
end

local RelayoutMirror

local function CreateTempLoss(mirror)
    local src = mirror.spec.tempLoss
    if not src then return end
    local tempLoss = CreateFrame("StatusBar", nil, mirror.holder)
    tempLoss:SetAllPoints(mirror.holder)
    local srcTex = src:GetStatusBarTexture()
    local atlas = srcTex and srcTex:GetAtlas()
    if atlas then
        tempLoss:SetStatusBarTexture(atlas)
    else
        tempLoss:SetStatusBarTexture(HELPER_TEXTURE)
    end
    tempLoss:GetStatusBarTexture():SetDrawLayer("BACKGROUND")
    tempLoss:SetFillStyle(Enum.StatusBarFillStyle.Reverse)
    tempLoss:SetMinMaxValues(0, 1)
    tempLoss:SetValue(0)
    AddMask(mirror, tempLoss:GetStatusBarTexture())
    mirror.tempLoss = tempLoss

    local function Refresh()
        if mirror.active then RelayoutMirror(mirror) end
    end
    hooksecurefunc(src, "SetValue", Refresh)
    hooksecurefunc(src, "Show", Refresh)
    hooksecurefunc(src, "Hide", Refresh)
end

local function CreateMirror(frame)
    if not frame.TargetFrameContent then return end
    local main = TargetMain(frame)
    local container = main.HealthBarsContainer
    local source = container and container.HealthBar
    if not source then return end

    local mirror = {
        spec = {
            frame = frame,
            parent = main,
            container = container,
            source = source,
            segmentTemplate = "TargetFrameBarSegmentTemplate",
            tempLoss = container.TempMaxHealthLoss,
        },
        glows = {},
        segments = {},
    }

    local holder = CreateFrame("Frame", nil, main)
    -- Secure frames can hand back secret strata/levels; then the parent's stay.
    local strata, level = source:GetFrameStrata(), source:GetFrameLevel()
    if not (issecretvalue and issecretvalue(strata)) then holder:SetFrameStrata(strata) end
    if not (issecretvalue and issecretvalue(level)) then holder:SetFrameLevel(level) end
    holder:EnableMouse(false)
    holder:Hide()
    mirror.holder = holder

    local bar = CreateFrame("StatusBar", nil, holder)
    bar:SetFrameLevel(holder:GetFrameLevel())
    bar:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 0)
    bar:SetStatusBarTexture(HELPER_TEXTURE)
    mirror.bar = bar
    mirror.fill = bar:GetStatusBarTexture()
    mirror.fill:SetDrawLayer("BACKGROUND")

    local mask = bar:CreateMaskTexture()
    mask:SetAtlas(PLAYER_MASK)
    mask:SetAllPoints(holder)
    mirror.mask = mask
    AddMask(mirror, mirror.fill)

    mirror.text = CreateFrame("Frame", nil, holder)
    mirror.text:SetAllPoints(holder)
    mirror.text:SetFrameLevel(holder:GetFrameLevel() + 1)

    for _, info in ipairs(SEGMENTS) do
        local src = source[info.key]
        if src and src.UpdateFillPosition then
            local seg = CreateSegment(mirror, src, info)
            mirror.segments[#mirror.segments + 1] = seg
            mirror[info.key] = seg
        end
    end
    for key, template in pairs(GLOWS) do
        CreateGlow(mirror, key, template)
    end
    CreateTempLoss(mirror)

    hooksecurefunc(source, "SetValue", function(_, value)
        if mirror.active then bar:SetValue(value) end
    end)
    hooksecurefunc(source, "SetMinMaxValues", function(_, minValue, maxValue)
        if not mirror.active then return end
        bar:SetMinMaxValues(minValue, maxValue)
        for _, seg in ipairs(mirror.segments) do
            seg.sizeHelper:SetMinMaxValues(minValue, maxValue)
        end
    end)
    hooksecurefunc(source, "SetStatusBarColor", function()
        if mirror.active then CopyColor(mirror) end
    end)
    hooksecurefunc(source, "SetStatusBarDesaturated", function(_, desaturated)
        if mirror.active then bar:SetStatusBarDesaturated(desaturated) end
    end)
    hooksecurefunc(source, "SetStatusBarTexture", function()
        if mirror.active then CopyTexture(mirror) end
    end)
    hooksecurefunc(source, "SetAlpha", function()
        if mirror.active and not mirror.guard then HideSource(mirror) end
    end)

    mirrors[frame] = mirror
    return mirror
end

local function Snapshot(mirror)
    local source, bar = mirror.spec.source, mirror.bar
    local minValue, maxValue = source:GetMinMaxValues()
    bar:SetMinMaxValues(minValue, maxValue)
    bar:SetValue(source:GetValue())
    CopyTexture(mirror)
    for _, seg in ipairs(mirror.segments) do
        seg.sizeHelper:SetMinMaxValues(minValue, maxValue)
    end
    for _, seg in ipairs(mirror.segments) do
        UpdateSegment(mirror, seg)
        for _, key in ipairs(SHADOWS) do
            local shadow = seg[key]
            if shadow and type(shadow.mUIBigShown) ~= "nil" then
                shadow:SetAlphaFromBoolean(shadow.mUIBigShown, 1, 0)
            end
        end
    end
    for _, glow in pairs(mirror.glows) do
        glow:SetShown(glow.source:IsShown())
    end
end

local function PlaceTexts(mirror, layout)
    local container = mirror.spec.container
    for _, key in ipairs(TARGET_TEXTS) do
        local text = container[key]
        local anchor = layout.texts[key]
        if text and anchor then
            if not text.mUIBigMoved then
                text.mUIBigMoved = true
                text.mUIBigParent = text:GetParent()
                text.mUIBigPoints = SavePoints(text)
            end
            text:SetParent(mirror.text)
            text:ClearAllPoints()
            text:SetPoint(anchor[1], mirror.bar, anchor[1], anchor[2], anchor[3])
        end
    end
end

local function RestoreTexts(mirror)
    local container = mirror.spec.container
    for _, key in ipairs(TARGET_TEXTS) do
        local text = container[key]
        if text and text.mUIBigMoved then
            text:SetParent(text.mUIBigParent or container)
            RestorePoints(text, text.mUIBigPoints)
            text.mUIBigMoved, text.mUIBigParent, text.mUIBigPoints = nil, nil, nil
        end
    end
end

local function PlaceMask(mirror, layout)
    local mask, info = mirror.mask, layout.mask
    mask:ClearAllPoints()
    if info.retailSlot then
        local R = mUI.UFRetail
        if R and R.MaskSlot(mask, mirror.spec.frame.TargetFrameContainer.FrameTexture, "health") then return end
        mask:SetTexture(HELPER_TEXTURE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(mirror.holder)
        return
    end
    mask:SetAtlas(info.atlas, info.atlasSize and true or false)
    mask:SetPoint("TOPLEFT", mirror.holder, "TOPLEFT", info.x or 0, info.y or 0)
    if not info.atlasSize then
        mask:SetSize(info.width, info.height)
    end
end

RelayoutMirror = function(mirror)
    local layout = mirror.layout
    if not layout then return end
    local percent = TempLossPercent(mirror)
    local width = layout.width * (1 - percent)
    mirror.bar:SetSize(width, layout.height)
    for _, seg in ipairs(mirror.segments) do
        seg.offsetHelper:SetWidth(width / HELPER_SCALE)
        seg.sizeHelper:SetWidth(width / HELPER_SCALE)
    end
    if mirror.tempLoss then
        mirror.tempLoss:SetValue(percent)
        mirror.tempLoss:SetShown(percent > 0)
    end
end

local function ApplyMirrorLayout(frame, mirror, layout)
    mirror.layout = layout
    local holder = mirror.holder
    local point = layout.point
    holder:ClearAllPoints()
    holder:SetPoint(point[1], layout.relativeTo or frame, point[2], point[3], point[4])
    holder:SetSize(layout.width, layout.height)
    PlaceMask(mirror, layout)
    PlaceGlows(mirror, layout.glowOffset)
    PlaceTexts(mirror, layout)
    RelayoutMirror(mirror)
end

local function EnableMirror(frame, layout)
    local mirror = mirrors[frame] or CreateMirror(frame)
    if not mirror then return end
    ApplyMirrorLayout(frame, mirror, layout)
    if mirror.active then return end
    mirror.active = true
    Snapshot(mirror)
    HideSource(mirror)
    mirror.holder:Show()
end

local function DisableMirror(frame)
    local mirror = mirrors[frame]
    if not mirror or not mirror.active then return end
    mirror.active = false
    mirror.holder:Hide()
    ShowSource(mirror)
    RestoreTexts(mirror)
end

-- A retail layout with the art's own health slot.
local function RetailSlotLayout(frame, base, R)
    local tex = frame.TargetFrameContainer.FrameTexture
    local point, width, height = R.SlotPoint(tex, "health")
    if not point then return base end
    local layout = {}
    for k, v in pairs(base) do layout[k] = v end
    layout.relativeTo = tex
    layout.mask = { retailSlot = true }
    layout.point, layout.width, layout.height = point, width, height
    return layout
end

-------------------------------------------------------------------------------
-- Target / Focus: frame art and decorations
-------------------------------------------------------------------------------
local targetSaved = {}

local function SaveTarget(frame)
    if targetSaved[frame] then return end
    local container = frame.TargetFrameContainer
    local manaBar = TargetMain(frame).ManaBar
    targetSaved[frame] = {
        frameTexturePoints = SavePoints(container.FrameTexture),
        flashPoints = SavePoints(container.Flash),
        portraitWidth = container.Portrait:GetWidth(),
        portraitHeight = container.Portrait:GetHeight(),
        portraitPoints = SavePoints(container.Portrait),
        manaWidth = manaBar and manaBar:GetWidth(),
        manaHeight = manaBar and manaBar:GetHeight(),
        manaPoints = manaBar and SavePoints(manaBar),
        manaMask = manaBar and SnapTex(manaBar.ManaBarMask),
    }
end

-- Blizzard's art for the unit's classification, as BBF puts it back.
local function SetBlizzardTargetArt(frame)
    local container = frame.TargetFrameContainer
    local frameTexture, flash = container.FrameTexture, container.Flash
    local classification = Classification(frame)
    if classification == "minus" then
        frameTexture:SetAtlas("UI-HUD-UnitFrame-Target-MinusMob-PortraitOn", TextureKitConstants.UseAtlasSize)
        flash:SetAtlas("UI-HUD-UnitFrame-Target-MinusMob-PortraitOn-InCombat", TextureKitConstants.UseAtlasSize)
    else
        if classification == "rare" or classification == "rareelite" then
            frameTexture:SetAtlas("UI-HUD-UnitFrame-Target-Rare-PortraitOn", TextureKitConstants.UseAtlasSize)
        else
            frameTexture:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn", TextureKitConstants.UseAtlasSize)
        end
        flash:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-InCombat", TextureKitConstants.UseAtlasSize)
    end
end

-- Points and portrait back to the stock layout (the Forever big art moves them).
local function RestoreTargetPoints(frame)
    local saved = targetSaved[frame]
    if not saved then return end
    local container = frame.TargetFrameContainer
    RestorePoints(container.FrameTexture, saved.frameTexturePoints)
    RestorePoints(container.Flash, saved.flashPoints)
    SetSizeIf(container.Portrait, saved.portraitWidth, saved.portraitHeight)
    RestorePoints(container.Portrait, saved.portraitPoints)
end

local function SetTargetArt(frame)
    local container = frame.TargetFrameContainer
    local frameTexture, flash, portrait = container.FrameTexture, container.Flash, container.Portrait
    if frameTexture.mUIBigChanging then return end
    frameTexture.mUIBigChanging = true
    local R = Retail()
    if R then
        if frameTexture.mUIBigArt then
            frameTexture.mUIBigArt = nil
            RestoreTargetPoints(frame)
        end
        frameTexture.mUIRetailArt = true
        flash:ClearAllPoints()
        flash:SetPoint("CENTER", container, "CENTER", 0, 2)
        if bigOn then
            R.SetFile(frameTexture, "Target-BigHealthbar-Reduced", false, 192, 67)
            R.SetFile(flash, "Target-InCombat-BigHealthbar-Reduced", false, 188, 67)
        else
            local c = Classification(frame)
            local art = "Target-PortraitOn"
            if c == "minus" then
                art = "Target-MinusMob-PortraitOn"
            elseif c == "rare" or c == "rareelite" then
                art = "Target-Rare-PortraitOn"
            end
            R.SetSheet(frameTexture, art)
            R.SetSheet(flash, c == "minus" and "Target-MinusMob-PortraitOn-InCombat" or "Target-PortraitOn-InCombat")
        end
    elseif bigOn then
        if frameTexture.mUIRetailArt then
            frameTexture.mUIRetailArt = nil
            if mUI.UFRetail then
                mUI.UFRetail.Forget(frameTexture)
                mUI.UFRetail.Forget(flash)
            end
        end
        frameTexture.mUIBigArt = true
        -- The player art, mirrored: portrait on the right.
        frameTexture:SetTexture(ART)
        frameTexture:SetTexCoord(1, 0, 0, 1)
        frameTexture:SetSize(198, 71)
        frameTexture:ClearAllPoints()
        frameTexture:SetPoint("CENTER", container, "CENTER", 0.5, 2)
        flash:ClearAllPoints()
        flash:SetTexture(ART_FLASH)
        flash:SetAllPoints(frameTexture)
        flash:SetTexCoord(1, 0, 0, 1)
        portrait:SetSize(60, 60)
        portrait:ClearAllPoints()
        portrait:SetPoint("TOPRIGHT", container, "TOPRIGHT", -24, -16.5)
    elseif frameTexture.mUIBigArt or frameTexture.mUIRetailArt then
        frameTexture.mUIBigArt, frameTexture.mUIRetailArt = nil, nil
        if mUI.UFRetail then
            mUI.UFRetail.Forget(frameTexture)
            mUI.UFRetail.Forget(flash)
        end
        SetBlizzardTargetArt(frame)
        RestoreTargetPoints(frame)
    end
    frameTexture.mUIBigChanging = false
end

-- Name background (ReputationColor) on the Forever big art: the bar covers
-- its row, so it is kept hidden.
local function KeepNameBgHidden(rep)
    if rep.mUIBigHidden and not rep.mUIBigKeeping and rep:GetAlpha() ~= 0 then
        rep.mUIBigKeeping = true
        rep:SetAlpha(0)
        rep.mUIBigKeeping = nil
    end
end

local function SetNameBgHidden(frame, hidden)
    local rep = TargetMain(frame).ReputationColor
    if not rep then return end
    if hidden then
        rep.mUIBigHidden = true
        if not rep.mUIBigHooked then
            rep.mUIBigHooked = true
            for _, method in ipairs({ "SetAlpha", "Show", "SetShown", "SetAtlas", "SetTexture", "SetVertexColor", "SetDesaturated" }) do
                hooksecurefunc(rep, method, KeepNameBgHidden)
            end
        end
        KeepNameBgHidden(rep)
    elseif rep.mUIBigHidden then
        rep.mUIBigHidden = nil
        rep:SetAlpha(1)
    end
end

-- Name background on retail art: it moves into the frame art and takes the
-- retail piece; with the big bar it is the narrower "Reduced" strip, drawn in
-- two parts so it reaches the art's edge.
local NAME_BG_SPLIT = 270 / 300

local function SyncNameBgExt(rep)
    local ext = rep.mUINameBgExt
    if not ext then return end
    ext:SetVertexColor(rep:GetVertexColor())
    ext:SetDesaturated(rep:IsDesaturated())
    ext:SetAlpha(rep:GetAlpha())
    ext:SetShown(rep.mUINameBgBig and rep:IsShown() or false)
end

local function SetRetailNameBg(frame, R)
    local rep = TargetMain(frame).ReputationColor
    if not rep then return end
    if R then
        if not rep.mUIRetailSaved then
            local layer, sublevel = rep:GetDrawLayer()
            rep.mUIRetailSaved = { parent = rep:GetParent(), layer = layer, sublevel = sublevel, atlas = rep:GetAtlas() }
        end
        rep:SetParent(frame.TargetFrameContainer)
        rep:SetDrawLayer("ARTWORK", 0)
        if bigOn then
            local ext = rep.mUINameBgExt
            if not ext then
                ext = frame.TargetFrameContainer:CreateTexture(nil, "ARTWORK")
                ext:SetPoint("TOPLEFT", rep, "TOPRIGHT")
                ext:SetPoint("BOTTOMLEFT", rep, "BOTTOMRIGHT")
                ext:SetWidth(15)
                rep.mUINameBgExt = ext
                for _, method in ipairs({ "SetVertexColor", "SetDesaturated", "SetAlpha", "Show", "Hide", "SetShown" }) do
                    hooksecurefunc(rep, method, SyncNameBgExt)
                end
            end
            rep.mUINameBgBig = true
            rep:SetTexture(R.File("Target-NameBg-Reduced"))
            rep:SetTexCoord(0, NAME_BG_SPLIT, 0, 1)
            ext:SetTexture(R.File("Target-NameBg-Reduced"))
            ext:SetTexCoord(NAME_BG_SPLIT, 1, 0, 1)
        else
            rep.mUINameBgBig = nil
            R.SetSheet(rep, "Target-PortraitOn-Type", false, false)
        end
        SyncNameBgExt(rep)
        ShiftRegionY(rep, bigOn and RETAIL_NAME_BG_RAISE or 0)
    elseif rep.mUIRetailSaved then
        local s = rep.mUIRetailSaved
        rep.mUIRetailSaved, rep.mUINameBgBig = nil, nil
        ShiftRegionY(rep, 0)
        rep:SetParent(s.parent)
        rep:SetDrawLayer(s.layer, s.sublevel)
        if mUI.UFRetail then mUI.UFRetail.Forget(rep) end
        if s.atlas then rep:SetAtlas(s.atlas) end
        SyncNameBgExt(rep)
    end
end

local function SetManaMaskWidth(frame, width)
    local manaBar = TargetMain(frame).ManaBar
    local mask = manaBar and manaBar.ManaBarMask
    if not mask then return end
    if width then
        mask.mUIBigBaseWidth = mask.mUIBigBaseWidth or mask:GetWidth()
        mask:SetWidth(width)
    elseif mask.mUIBigBaseWidth then
        mask:SetWidth(mask.mUIBigBaseWidth)
        mask.mUIBigBaseWidth = nil
    end
end

local RefreshTargets

-- Target mana bar on retail art: into the art's mana slot.
local function FitTargetMana(frame, R)
    local manaBar = TargetMain(frame).ManaBar
    if not manaBar then return end
    local tex = frame.TargetFrameContainer.FrameTexture
    manaBar.mUIRetailMana = true
    if InCombatLockdown() then
        RunAfterCombat(RefreshTargets)
    else
        R.FitSlot(manaBar, tex, "mana")
    end
    R.MaskSlot(manaBar.ManaBarMask, tex, "mana")
    local container = TargetMain(frame).HealthBarsContainer
    AlignPowerText(manaBar, container and container.RightText)
end

local function RestoreTargetMana(frame)
    local manaBar = TargetMain(frame).ManaBar
    local s = targetSaved[frame]
    if not manaBar or not manaBar.mUIRetailMana or not s then return end
    if InCombatLockdown() then
        RunAfterCombat(RefreshTargets)
        return
    end
    manaBar.mUIRetailMana = nil
    SetSizeIf(manaBar, s.manaWidth, s.manaHeight)
    RestorePoints(manaBar, s.manaPoints)
    RestoreTex(manaBar.ManaBarMask, s.manaMask, true)
end

-- Minus mobs get the normal bar art with the big bar (no minus version).
-- Only with Blizzard's own bar textures: mUI's texture option paints its own.
local function NormalMinusHealthArt(frame)
    if mUI.db.profile.unitframes.textures.unitframes ~= "None" then return end
    if Classification(frame) ~= "minus" then return end
    local container = TargetMain(frame).HealthBarsContainer
    container.HealthBar.HealthBarTexture:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health", TextureKitConstants.UseAtlasSize)
    local tempLoss = container.TempMaxHealthLoss
    if tempLoss and tempLoss.TempMaxHealthLossTexture then
        tempLoss.TempMaxHealthLossTexture:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Bar-TempHPLoss", TextureKitConstants.UseAtlasSize)
    end
end

local function UpdateTargetNow(frame)
    local main = TargetMain(frame)
    local R = Retail()
    if On() then SaveTarget(frame) end
    if bigOn then NormalMinusHealthArt(frame) end
    SetTargetArt(frame)
    if R then
        local base = RETAIL_LAYOUT
        if bigOn then
            base = RETAIL_BIG_LAYOUT
        elseif Classification(frame) == "minus" then
            base = RETAIL_MINUS_LAYOUT
        end
        EnableMirror(frame, RetailSlotLayout(frame, base, R))
        SetManaMaskWidth(frame, nil)
        FitTargetMana(frame, R)
    elseif bigOn then
        EnableMirror(frame, TARGET_LAYOUT)
        RestoreTargetMana(frame)
        SetManaMaskWidth(frame, 258.5)
    else
        DisableMirror(frame)
        SetManaMaskWidth(frame, nil)
        RestoreTargetMana(frame)
    end
    SetRetailNameBg(frame, R)
    SetNameBgHidden(frame, bigOn and not R)
    if R and bigOn then
        RaiseName(main.Name, 0)
        SetNameOnStrip(main.Name, frame.TargetFrameContainer.FrameTexture, R)
    else
        SetNameOnStrip(main.Name, nil)
        RaiseName(main.Name, bigOn and NAME_RAISE or 0)
    end
    local contextual = frame.TargetFrameContent.TargetFrameContentContextual
    if contextual then
        local foreverBig = bigOn and not R
        ShiftRegionY(contextual.NumericalThreat, foreverBig and THREAT_RAISE or 0)
        SetGroupIconsDropped(contextual, "TOPRIGHT", -85, -8, foreverBig)
    end
    local healthText = main.HealthBarsContainer and main.HealthBarsContainer.RightText
    if On() then
        AlignPowerText(main.ManaBar, healthText)
    else
        RestorePowerText(main.ManaBar)
    end
end

local function UpdateTarget(frame)
    if not frame or not frame.TargetFrameContent then return end
    local ok, err = xpcall(function() UpdateTargetNow(frame) end, Traceback)
    if not ok then Report(frame == FocusFrame and "focus" or "target", err) end
end

RefreshTargets = function()
    UpdateTarget(TargetFrame)
    UpdateTarget(FocusFrame)
end

-------------------------------------------------------------------------------
-- Hooks (installed once; they do nothing while both options are off)
-------------------------------------------------------------------------------
local hooked = false

-- Runs `func`, reporting an error instead of letting it break the caller.
local function Guarded(where, func)
    local ok, err = xpcall(func, Traceback)
    if not ok then Report(where, err) end
end

local function InstallHooks()
    if hooked then return end
    hooked = true

    for _, func in ipairs({ "PlayerFrame_ToPlayerArt", "PlayerFrame_UpdateHealthBarVisuals", "PlayerFrame_UpdateManaBarVisuals" }) do
        if _G[func] then
            hooksecurefunc(func, function()
                if not applying then QueueApplyPlayer() end
            end)
        end
    end
    local function Glows()
        if not applying then Guarded("player glow", UpdatePlayerGlows) end
    end
    for _, func in ipairs({ "PlayerFrame_UpdateFlashTextureVisuals", "PlayerFrame_UpdateStatusTextureVisuals" }) do
        if _G[func] then hooksecurefunc(func, Glows) end
    end
    if PlayerFrame_UpdatePlayerNameTextAnchor then
        hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
            if retailOn and PlayerFrame.state ~= "vehicle" and not PlayerName.mUIStripTex then
                Guarded("player name", PlaceRetailPlayerName)
            end
        end)
    end

    local container = PlayerFrame.PlayerFrameContainer
    hooksecurefunc(container.FrameTexture, "SetAtlas", function(_, atlas)
        if atlas == PLAYER_ATLAS and not applying then Guarded("player art", SetPlayerArt) end
    end)
    if container.AlternatePowerFrameTexture then
        hooksecurefunc(container.AlternatePowerFrameTexture, "SetAtlas", function(_, atlas)
            if atlas == PLAYER_ALT_ATLAS and not applying then Guarded("player art", SetPlayerArt) end
        end)
    end
    if container.FrameFlash then
        hooksecurefunc(container.FrameFlash, "SetAtlas", Glows)
    end
    if PlayerMain().StatusTexture then
        hooksecurefunc(PlayerMain().StatusTexture, "SetAtlas", Glows)
    end
    -- mUI's bar texture option can change the health texture at any time.
    local _, playerBar = PlayerHealth()
    local playerBarTexture = playerBar:GetStatusBarTexture()
    if playerBarTexture then
        local function Fills()
            if On() and not applying then
                Guarded("player bar fills", function() SetPlayerSegmentFills(true) end)
            end
        end
        hooksecurefunc(playerBarTexture, "SetTexture", Fills)
        hooksecurefunc(playerBarTexture, "SetAtlas", Fills)
    end

    for _, frame in ipairs({ TargetFrame, FocusFrame }) do
        if frame and frame.TargetFrameContainer then
            hooksecurefunc(frame, "CheckClassification", function(self)
                if On() then UpdateTarget(self) end
            end)
            local function Reapply()
                if On() then
                    Guarded("target art", function() SetTargetArt(frame) end)
                end
            end
            hooksecurefunc(frame.TargetFrameContainer.FrameTexture, "SetAtlas", Reapply)
            hooksecurefunc(frame.TargetFrameContainer.Flash, "SetAtlas", Reapply)
            if frame.UpdateHealthBarVisuals then
                hooksecurefunc(frame, "UpdateHealthBarVisuals", function(self)
                    local R = Retail()
                    if R then
                        Guarded("target mana", function() FitTargetMana(self, R) end)
                    end
                end)
            end
        end
    end
end

local logCleared = false

local function Refresh()
    -- The error log holds the current session only.
    if not logCleared and mUI.db and mUI.db.global then
        logCleared = true
        mUI.db.global.bigHealthbarErrors = nil
        mUI.db.global.bigHealthbarDebug = nil
    end
    if On() then
        Guarded("hooks", InstallHooks)
        ApplyPlayer()
    else
        RestorePlayer()
    end
    RefreshTargets()
end

-------------------------------------------------------------------------------
-- Module, and the switch Retail Textures uses
-------------------------------------------------------------------------------
mUI.UFLayout = {
    SetRetail = function(on)
        retailOn = on and true or false
        Refresh()
    end,
    SetSymmetric = function(on)
        symOn = on and true or false
        Refresh()
    end,
}

function BigHealthbar:OnEnable()
    bigOn = true
    Refresh()
end

function BigHealthbar:OnDisable()
    bigOn = false
    Refresh()
end
