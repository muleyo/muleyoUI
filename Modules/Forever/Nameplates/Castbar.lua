local Castbar = mUI:NewModule("mUI.Modules.Nameplates.Castbar", "AceHook-3.0")

local IsSecret = issecretvalue or function()
    return false
end

function Castbar:OnInitialize()
    -- Load Database
    Castbar.db = mUI.db.profile.nameplates

    Castbar.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Castbar.Theme = mUI:GetModule("mUI.Modules.General.Theme")

    local CAST_EVENTS = {"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_EMPOWER_START"}
    local UPDATE_SPELLS = {"PLAYER_LOGIN", "SPELLS_CHANGED"}
    local _, playerClass = UnitClass("player")
    local edgeR, edgeG, edgeB, edgeA = 0, 0, 0, 1
    local NORMAL_R, NORMAL_G, NORMAL_B = 1, 1, 1
    local NOKICK_R, NOKICK_G, NOKICK_B = 0.85, 0.15, 0.15
    local colorsEnabled = false
    local ICON_GAP = 2
    local TEXT_SIZE = 12
    local TEXT_PADDING = 2
    local interrupts = {}
    local interruptSpells = {
        ["PALADIN"] = {96231, 31935},
        ["WARRIOR"] = {6552},
        ["PRIEST"] = {15487},
        ["MAGE"] = {2139},
        ["WARLOCK"] = {89766, 119910, 132409},
        ["DRUID"] = {38675, 78675, 106839},
        ["ROGUE"] = {1766},
        ["HUNTER"] = {147362, 187707},
        ["SHAMAN"] = {57994},
        ["DEATHKNIGHT"] = {47528},
        ["MONK"] = {116705},
        ["DEMONHUNTER"] = {183752},
        ["EVOKER"] = {351338}
    }

    local function UpdateInterrupts()
        table.wipe(interrupts)

        local spells = interruptSpells[playerClass]
        if not spells then
            return
        end

        for _, spellID in ipairs(spells) do
            if C_SpellBook.IsSpellKnownOrInSpellBook(spellID) or C_SpellBook.IsSpellKnownOrInSpellBook(spellID, Enum.SpellBookSpellBank.Pet) then
                interrupts[#interrupts + 1] = spellID
            end
        end
    end

    local durations = {}
    local durationStamp

    local function InterruptDurations()
        if durationStamp == GetTime() then
            return durations
        end

        durationStamp = GetTime()
        wipe(durations)

        for i = 1, #interrupts do
            local duration = C_Spell.GetSpellCooldownDuration(interrupts[i], true)
            if not IsSecret(duration) and duration then
                durations[#durations + 1] = duration
            end
        end

        return durations
    end

    local function GetCastBar(plate)
        local namePlate = plate:GetParent()
        local frame = namePlate and namePlate.UnitFrame
        local container = frame and frame.CastBarsContainer
        return container and container.castBar, container, frame
    end

    local function RefreshCachedStyle()
        local color = mUI:Color(0.15)
        if color then
            edgeR, edgeG, edgeB, edgeA = color[1], color[2], color[3], color[4]
        end

        local config = Castbar.db.castbar
        colorsEnabled = config.colors

        local cooldown = config.cooldowncolor
        NOKICK_R, NOKICK_G, NOKICK_B = cooldown[1], cooldown[2], cooldown[3]
    end

    Castbar.RefreshCachedStyle = RefreshCachedStyle

    local function SkinBackground(castBar)
        local background = castBar.Background
        if not background then
            return
        end

        background:ClearAllPoints()
        background:SetAllPoints(castBar)
        background:SetVertexColor(edgeR, edgeG, edgeB, edgeA)
    end

    local function IconSize()
        return math.max((Castbar.db.size.castheight or 10), 16)
    end

    local function HookIcon(castBar, icon)
        if not Castbar:IsHooked(icon, "SetTexture") then
            Castbar:SecureHook(icon, "SetTexture", function(_, tex)
                castBar.iconFrame.texture:SetTexture(tex)
            end)
        end

        if not Castbar:IsHooked(icon, "SetShown") then
            Castbar:SecureHook(icon, "SetShown", function(_, shown)
                castBar.iconFrame:SetShown(shown)
            end)
        end

        if not Castbar:IsHooked(icon, "Hide") then
            Castbar:SecureHook(icon, "Hide", function()
                castBar.iconFrame:Hide()
            end)
        end

        if not Castbar:IsHooked(icon, "Show") then
            Castbar:SecureHook(icon, "Show", function()
                castBar.iconFrame:Show()
            end)
        end
    end

    local function SkinIcon(castBar)
        local icon = castBar.Icon
        if not icon then
            return
        end

        if not castBar.iconFrame then
            local iconFrame = CreateFrame("Frame", nil, castBar)
            iconFrame:SetFrameLevel(castBar:GetFrameLevel() + 1)

            local texture = iconFrame:CreateTexture(nil, "OVERLAY")
            texture:SetAllPoints(iconFrame)
            texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            iconFrame.texture = texture

            local mask = iconFrame:CreateMaskTexture()
            mask:SetAllPoints(texture)
            texture:AddMaskTexture(mask)

            -- No border texture on castbar icons, but the mask still needs to
            -- follow border-style swaps (Style1/Style2 use different masks).
            Castbar.Theme:RegisterBorder({
                mask = mask
            })

            icon:SetAlpha(0)
            icon:SetIgnoreParentAlpha(false)

            local currentTexture = icon:GetTexture()
            if currentTexture then
                texture:SetTexture(currentTexture)
            end
            iconFrame:SetShown(icon:IsShown())

            castBar.iconFrame = iconFrame
        end

        HookIcon(castBar, icon)

        local size = IconSize()
        local iconFrame = castBar.iconFrame
        if iconFrame.mUISize == size then
            return
        end

        iconFrame.mUISize = size
        iconFrame:ClearAllPoints()
        iconFrame:SetSize(size, size)
        iconFrame:SetPoint("RIGHT", castBar, "LEFT", -ICON_GAP, 0)
    end

    local SHIELD_ATLAS = "ui-castingbar-shield"

    local function IsUninterruptible(plate)
        local data = Castbar.Core:GetData(plate:GetParent())
        local unit = data and data.unit
        if not unit then
            return nil
        end

        local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
        if not Castbar.Core:Exists(name) then
            name, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit)
        end

        if not Castbar.Core:Exists(name) then
            return nil
        end

        if not Castbar.Core:Exists(notInterruptible) then
            return false
        end

        return notInterruptible
    end

    local EvaluateFromBoolean = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean

    local function Pick(value, ifTrue, ifFalse)
        if EvaluateFromBoolean then
            return EvaluateFromBoolean(value, ifTrue, ifFalse)
        end

        if IsSecret(value) then
            return ifFalse
        end

        return value and ifTrue or ifFalse
    end

    local function CastColor(uninterruptible)
        local r, g, b = NORMAL_R, NORMAL_G, NORMAL_B

        local ready = InterruptDurations()
        if #ready > 0 then
            r, g, b = NOKICK_R, NOKICK_G, NOKICK_B

            for i = 1, #ready do
                local zero = ready[i]:IsZero()
                r = Pick(zero, NORMAL_R, r)
                g = Pick(zero, NORMAL_G, g)
                b = Pick(zero, NORMAL_B, b)
            end
        end

        r = Pick(uninterruptible, NORMAL_R, r)
        g = Pick(uninterruptible, NORMAL_G, g)
        b = Pick(uninterruptible, NORMAL_B, b)

        return r, g, b
    end

    local function ApplyCastColor(castBar, uninterruptible)
        local texture = castBar:GetStatusBarTexture()
        if not texture then
            return
        end

        if not colorsEnabled then
            texture:SetVertexColor(NORMAL_R, NORMAL_G, NORMAL_B)
            return
        end

        if not IsSecret(uninterruptible) and uninterruptible == nil then
            texture:SetVertexColor(NORMAL_R, NORMAL_G, NORMAL_B)
            return
        end

        texture:SetVertexColor(CastColor(uninterruptible))
    end

    local function SkinShield(castBar, uninterruptible)
        local shield = castBar.BorderShield
        if not shield or not castBar.iconFrame then
            return
        end

        if not castBar.shieldFrame then
            local shieldFrame = CreateFrame("Frame", nil, castBar)
            shieldFrame:SetFrameLevel(castBar.iconFrame:GetFrameLevel() + 1)

            local texture = shieldFrame:CreateTexture(nil, "OVERLAY")
            texture:SetAllPoints(shieldFrame)
            texture:SetAtlas(SHIELD_ATLAS, false)
            shieldFrame.texture = texture

            -- Hide default shield border
            shield:SetAlpha(0)
            shield:SetIgnoreParentAlpha(false)

            castBar.shieldFrame = shieldFrame
        end

        local size = IconSize()
        local shieldFrame = castBar.shieldFrame
        if shieldFrame.mUISize ~= size then
            shieldFrame.mUISize = size
            shieldFrame:ClearAllPoints()
            shieldFrame:SetPoint("CENTER", castBar.iconFrame, "CENTER", 0, 0)
            shieldFrame:SetSize(size, size)
        end
        shieldFrame:Show()

        if Castbar.Core:Exists(uninterruptible) then
            shieldFrame:SetAlphaFromBoolean(uninterruptible, 1, 0)
        end
    end

    local function SkinText(castBar)
        local text = castBar.Text
        if not text then
            return
        end

        local path = mUI.db.profile.general.fontpath
        local currentPath, currentSize = text:GetFont()
        if currentPath ~= path or currentSize ~= TEXT_SIZE then
            text:SetFont(path, TEXT_SIZE, "OUTLINE, SLUG")
        end

        text:SetJustifyH("CENTER")

        text:ClearAllPoints()
        text:SetPoint("TOPLEFT", castBar, "TOPLEFT", -TEXT_PADDING, 0)
        text:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", TEXT_PADDING, 0)
    end

    local function SkinCastTargetText(castBar)
        local targetText = castBar.CastTargetNameText
        if not targetText then
            return
        end

        if not Castbar.db.castbar.showTarget then
            targetText:SetShown(false)
            return
        end

        local path = mUI.db.profile.general.fontpath
        local currentPath, currentSize = targetText:GetFont()
        if currentPath ~= path or currentSize ~= TEXT_SIZE then
            targetText:SetFont(path, TEXT_SIZE, "OUTLINE, SLUG")
        end

        targetText:SetJustifyH("CENTER")

        targetText:ClearAllPoints()
        targetText:SetWidth(0)
        targetText:SetPoint("TOP", castBar, "BOTTOM", 0, -TEXT_PADDING)
        targetText:SetShown(true)
    end

    local function SkinSpark(castBar)
        local spark = castBar.Spark
        local height = Castbar.db.size.castheight or 10
        if spark and spark.mUIHeight ~= height then
            spark.mUIHeight = height
            spark:SetSize(4, height)
        end
    end

    local function ReapplyStyle(unitFrame)
        if not Castbar:IsEnabled() or issecretvalue(unitFrame) then
            return
        end
        if not unitFrame.unit or unitFrame:IsForbidden() then
            return
        end

        if Castbar.Core:Safe(UnitIsUnit(unitFrame.unit, "player"), false) then
            return
        end

        local container = unitFrame.CastBarsContainer
        local castBar = container and container.castBar
        if not castBar then
            return
        end

        SkinBackground(castBar)
        SkinText(castBar)
        SkinCastTargetText(castBar)
        SkinSpark(castBar)
    end

    function Castbar:InstallHooks()
        if not Castbar:IsHooked(NamePlateUnitFrameMixin, "UpdateAnchors") then
            Castbar:SecureHook(NamePlateUnitFrameMixin, "UpdateAnchors", ReapplyStyle)
        end
    end

    local function ShouldHide(plate)
        local data = Castbar.Core:GetData(plate:GetParent())
        return data and data.isFriend and data.isPlayer and not data.canAttack and Castbar.db.friendly.hidehealthbar
    end

    local activeCastPlates = {}

    local function ApplyCastbar(plate)
        if not Castbar:IsEnabled() or not plate then
            return
        end

        local castBar, container, frame = GetCastBar(plate)
        if not castBar or not container or not frame then
            return
        end

        if ShouldHide(plate) then
            castBar:Hide()
            activeCastPlates[plate] = nil
            return
        end

        local uninterruptible = IsUninterruptible(plate)

        SkinBackground(castBar)
        SkinIcon(castBar)
        SkinShield(castBar, uninterruptible)
        SkinText(castBar)
        SkinCastTargetText(castBar)
        SkinSpark(castBar)
        ApplyCastColor(castBar, uninterruptible)

        activeCastPlates[plate] = castBar:IsShown() or nil
    end

    local function RefreshColors()
        if not Castbar:IsEnabled() then
            return
        end

        for plate in pairs(activeCastPlates) do
            local castBar = GetCastBar(plate)
            if castBar and castBar:IsShown() then
                ApplyCastColor(castBar, IsUninterruptible(plate))
            end
        end
    end

    local function HookCastBar(plate)
        local castBar = GetCastBar(plate)
        if not castBar then
            return
        end

        if not Castbar:IsHooked(castBar, "OnEvent") then
            Castbar:SecureHookScript(castBar, "OnEvent", function()
                ApplyCastbar(plate)
            end)
        end

        if not Castbar:IsHooked(castBar, "UpdateBarFillTexture") then
            Castbar:SecureHook(castBar, "UpdateBarFillTexture", function()
                ApplyCastColor(castBar, IsUninterruptible(plate))
            end)
        end
    end

    local spellWatcher = CreateFrame("Frame")
    spellWatcher:SetScript("OnEvent", function(_, event)
        if event == "SPELL_UPDATE_COOLDOWN" then
            if colorsEnabled and #interrupts > 0 then
                RefreshColors()
            end
            return
        end

        UpdateInterrupts()
        RefreshColors()
    end)

    function Castbar:RegisterSpellEvents()
        for i = 1, #UPDATE_SPELLS do
            spellWatcher:RegisterEvent(UPDATE_SPELLS[i])
        end
        spellWatcher:RegisterEvent("SPELL_UPDATE_COOLDOWN")

        UpdateInterrupts()
    end

    function Castbar:UnregisterSpellEvents()
        spellWatcher:UnregisterAllEvents()
    end

    Castbar.handler = {}

    function Castbar.handler.Create(plate)
        -- Built once per plate rather than two closures per cast event.
        local function refresh()
            ApplyCastbar(plate)
        end

        local watcher = CreateFrame("Frame", nil, plate)
        watcher:SetScript("OnEvent", function()
            RunNextFrame(refresh)
        end)

        plate.CastWatcher = watcher
    end

    function Castbar.handler.Update(plate, data)
        if not plate.CastWatcher then
            Castbar.handler.Create(plate)
        end

        HookCastBar(plate)

        local watcher = plate.CastWatcher
        if watcher then
            watcher:UnregisterAllEvents()
            for i = 1, #CAST_EVENTS do
                watcher:RegisterUnitEvent(CAST_EVENTS[i], data.unit)
            end
        end

        ApplyCastbar(plate)
    end

    function Castbar.handler.Layout(plate)
        ApplyCastbar(plate)
    end

    function Castbar.handler.Remove(plate)
        if plate.CastWatcher then
            plate.CastWatcher:UnregisterAllEvents()
        end
        activeCastPlates[plate] = nil
    end

    function Castbar:Update()
        RefreshCachedStyle()
        Castbar.Core:ForEach(ApplyCastbar)

        local Health = mUI:GetModule("mUI.Modules.Nameplates.Health", true)
        if Health and Health:IsEnabled() then
            Health:Update()
        end
    end
end

function Castbar:OnEnable()
    Castbar.db = mUI.db.profile.nameplates
    Castbar:RefreshCachedStyle()
    Castbar:InstallHooks()
    Castbar:RegisterSpellEvents()
    Castbar.Core:Register("Castbar", Castbar.handler)
end

function Castbar:OnDisable()
    Castbar.Core:Unregister("Castbar")
    Castbar:UnregisterSpellEvents()
    Castbar:UnhookAll()
end
