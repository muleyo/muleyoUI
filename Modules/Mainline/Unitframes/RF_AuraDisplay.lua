local RF_AuraDisplay = mUI:NewModule("mUI.Modules.Unitframes.RF_AuraDisplay", "AceHook-3.0")

local MAX_BUFFS = 6
local MAX_DEBUFFS = 3
local MAX_PRIVATE = 2
local BUFFS_PER_ROW = 3
local ICON_GAP = 1

local function GetDispelScale()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.dispelScale) or 1.5
end

local function GetCCScale()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.ccScale) or 1.3
end

local function TooltipsEnabled()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return raid and raid.auraTooltips ~= false
end

local function OnAuraSlotEnter(slot)
    if not TooltipsEnabled() then
        return
    end
    local unit = slot.mUI_unit
    local id = slot.mUI_auraID
    if not unit or not id or id <= 0 or not UnitExists(unit) then
        return
    end
    GameTooltip:SetOwner(slot, "ANCHOR_BOTTOMRIGHT")
    if slot.mUI_isDebuff then
        if GameTooltip.SetUnitDebuffByAuraInstanceID then
            GameTooltip:SetUnitDebuffByAuraInstanceID(unit, id)
        end
    else
        if GameTooltip.SetUnitBuffByAuraInstanceID then
            GameTooltip:SetUnitBuffByAuraInstanceID(unit, id)
        end
    end
end

local function OnAuraSlotLeave()
    GameTooltip:Hide()
end

-- Spell IDs to never display
local HIDDEN_SPELL_IDS = {
    [57723] = true, -- Exhaustion (Heroism)
    [57724] = true, -- Sated (Bloodlust)
    [80354] = true, -- Temporal Displacement (Time Warp)
    [95809] = true, -- Insanity (Hunter pet Ancient Hysteria)
    [264689] = true, -- Fatigued (Drums of Fury / Primal Rage)
    [390435] = true, -- Exhaustion (Evoker Fury of the Aspects)
    [308312] = true -- Time Trial Practice (Time Trial)
}

local BORDER_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\border.png]]
local MASK_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]]

-- Filter sets mirror RaidFrameAuras' defaults
local BUFF_FILTERS, DEBUFF_FILTERS = {}, {}
local BUFF_SCALE_FILTERS, DEBUFF_SCALE_FILTERS = {}, {}

local function buildFilter(...)
    if AuraUtil and AuraUtil.CreateFilterString then
        return AuraUtil.CreateFilterString(...)
    end
    local parts, n = {}, select("#", ...)
    for i = 1, n do
        local p = select(i, ...)
        if p and p ~= "" then
            parts[#parts + 1] = p
        end
    end
    return table.concat(parts, "|")
end

local function BuildFilterTables()
    local AF = (AuraUtil and AuraUtil.AuraFilters) or {}
    local IMPORTANT = AF.Important or "IMPORTANT"
    local CC = AF.CrowdControl
    local BIGDEF = AF.BigDefensive
    local EXTDEF = AF.ExternalDefensive
    local RAIDIC = AF.RaidInCombat

    -- Buff inclusion filters (HELPFUL|PLAYER + category)
    BUFF_FILTERS = {}
    if RAIDIC then
        BUFF_FILTERS[#BUFF_FILTERS + 1] = buildFilter("HELPFUL", "PLAYER", RAIDIC)
    end
    BUFF_FILTERS[#BUFF_FILTERS + 1] = buildFilter("HELPFUL", "PLAYER", IMPORTANT)
    if BIGDEF then
        BUFF_FILTERS[#BUFF_FILTERS + 1] = buildFilter("HELPFUL", "PLAYER", BIGDEF)
    end
    if EXTDEF then
        BUFF_FILTERS[#BUFF_FILTERS + 1] = buildFilter("HELPFUL", "PLAYER", EXTDEF)
    end

    -- All buffs render at the same size — no per-category scaling.
    BUFF_SCALE_FILTERS = {}

    -- Debuff inclusion filters
    DEBUFF_FILTERS = {buildFilter("HARMFUL", "RAID"), buildFilter("HARMFUL", IMPORTANT)}
    if CC then
        DEBUFF_FILTERS[#DEBUFF_FILTERS + 1] = buildFilter("HARMFUL", CC)
    end

    -- Debuff category scales (CC scale is user-configurable)
    DEBUFF_SCALE_FILTERS = {{
        scale = 1.00,
        filter = buildFilter("HARMFUL", IMPORTANT)
    }}
    if CC then
        DEBUFF_SCALE_FILTERS[#DEBUFF_SCALE_FILTERS + 1] = {
            scale = GetCCScale(),
            filter = buildFilter("HARMFUL", CC)
        }
    end
end

local function GetCategoryScale(unit, auraInstanceID, scaleFilters)
    if not C_UnitAuras.IsAuraFilteredOutByInstanceID then
        return 1
    end
    local best, bestDelta = 1, -1
    for i = 1, #scaleFilters do
        local entry = scaleFilters[i]
        local ok, filteredOut = pcall(C_UnitAuras.IsAuraFilteredOutByInstanceID, unit, auraInstanceID, entry.filter)
        if ok and not filteredOut then
            local delta = math.abs(entry.scale - 1)
            if delta > bestDelta then
                best, bestDelta = entry.scale, delta
            end
        end
    end
    return best
end

function RF_AuraDisplay:OnInitialize()
    local LSM = LibStub("LibSharedMedia-3.0")

    local function GetFont()
        local fontName = mUI.db and mUI.db.profile.general and mUI.db.profile.general.font
        return (fontName and LSM:Fetch("font", fontName)) or STANDARD_TEXT_FONT
    end

    local function GetSizes(frame)
        local h = frame:GetHeight()
        if not h or h < 1 then
            h = 36
        end
        local raid = mUI.db and mUI.db.profile.unitframes.raidframes
        local buffPct = (raid and raid.buffsize or 33) / 100
        local debuffPct = (raid and raid.debuffsize or 55) / 100
        return math.floor(h * buffPct + 0.5), math.floor(h * debuffPct + 0.5)
    end

    function RF_AuraDisplay:CreateIcon(parent)
        local f = CreateFrame("Frame", nil, parent)
        f:SetScript("OnEnter", OnAuraSlotEnter)
        f:SetScript("OnLeave", OnAuraSlotLeave)

        local icon = f:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        f.icon = icon

        local cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
        cd:SetAllPoints(icon)
        cd:SetDrawBling(false)
        cd:SetDrawEdge(false)
        cd:SetSwipeTexture(MASK_TEX)
        cd:SetSwipeColor(0.2, 0.2, 0.2, 0.75)
        cd:SetHideCountdownNumbers(false)
        cd.noCooldownCount = true
        cd:SetReverse(true)
        f.cooldown = cd

        local border = f:CreateTexture(nil, "OVERLAY", nil, 7)
        border:SetTexture(BORDER_TEX)
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        f.border = border

        local mask = f:CreateMaskTexture()
        mask:SetTexture(MASK_TEX, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        mask:SetAllPoints(icon)
        icon:AddMaskTexture(mask)

        local textOverlay = CreateFrame("Frame", nil, f)
        textOverlay:SetAllPoints(icon)
        textOverlay:SetFrameLevel(cd:GetFrameLevel() + 1)
        local count = textOverlay:CreateFontString(nil, "OVERLAY")
        count:SetFont(GetFont(), 14, "OUTLINE")
        count:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, 0)
        f.count = count

        f:Hide()
        return f
    end

    function RF_AuraDisplay:EnsureContainers(frame)
        if frame.mUI_AD then
            return frame.mUI_AD
        end
        local data = {
            buffs = {},
            debuffs = {}
        }

        local buffAnchor = CreateFrame("Frame", nil, frame)
        buffAnchor:SetSize(1, 1)
        data.buffAnchor = buffAnchor

        local debuffAnchor = CreateFrame("Frame", nil, frame)
        debuffAnchor:SetSize(1, 1)
        data.debuffAnchor = debuffAnchor

        for i = 1, MAX_BUFFS do
            data.buffs[i] = RF_AuraDisplay:CreateIcon(frame)
        end
        for i = 1, MAX_DEBUFFS do
            data.debuffs[i] = RF_AuraDisplay:CreateIcon(frame)
        end

        frame.mUI_AD = data
        return data
    end

    -- Test mode: render placeholder icons where each aura category would
    -- appear so users can preview size/position without an actual mechanic.
    local TEST_TEXTURE_PRIVATE = 132288 -- Spell_Holy_BorrowedTime
    local TEST_TEXTURE_BUFF = 136224 -- Spell_Nature_Rejuvenation
    local TEST_TEXTURE_DEBUFF = 136139 -- Spell_Shadow_AbominationExplosion
    function RF_AuraDisplay:UpdateTestPrivateAuras(frame, data, size)
        local active = RF_AuraDisplay.testPrivateAuras
        data.testIcons = data.testIcons or {}
        for i = 1, MAX_PRIVATE do
            local icon = data.testIcons[i]
            if active then
                if not icon then
                    icon = frame:CreateTexture(nil, "OVERLAY")
                    data.testIcons[i] = icon
                end
                icon:SetTexture(TEST_TEXTURE_PRIVATE)
                icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                icon:SetSize(size, size)
                icon:ClearAllPoints()
                icon:SetPoint("RIGHT", frame, "LEFT", -2 - (i - 1) * (size + ICON_GAP), 0)
                icon:Show()
            elseif icon then
                icon:Hide()
            end
        end
    end

    local function MakeTestAura(texture, instanceID)
        return {
            icon = texture,
            auraInstanceID = instanceID,
            spellId = 0,
            mUI_scale = 1
        }
    end

    function RF_AuraDisplay:GetTestBuffs()
        if not RF_AuraDisplay.testBuffs then return nil end
        local list = {}
        for i = 1, MAX_BUFFS do
            list[i] = MakeTestAura(TEST_TEXTURE_BUFF, -i)
        end
        return list
    end

    function RF_AuraDisplay:GetTestDebuffs()
        if not RF_AuraDisplay.testDebuffs then return nil end
        local list = {}
        for i = 1, MAX_DEBUFFS do
            list[i] = MakeTestAura(TEST_TEXTURE_DEBUFF, -100 - i)
        end
        return list
    end

    -- frame.buffFrames/debuffFrames were removed in 12.0.5; auras now flow
    -- through the PrivateAura container system attached to the frame itself.
    -- We register our own non-container PrivateAuraAnchors (auraIndex 1..N)
    -- so private auras still render at our positions, while our custom
    -- GetAuraSlots scan keeps showing regular buffs/debuffs.
    local function ClearPrivateAuraAnchors(data)
        if not C_UnitAuras or not C_UnitAuras.RemovePrivateAuraAnchor or not data.privateAnchorIDs then
            return
        end
        for i = 1, #data.privateAnchorIDs do
            C_UnitAuras.RemovePrivateAuraAnchor(data.privateAnchorIDs[i])
        end
        wipe(data.privateAnchorIDs)
    end

    local function RefreshPrivateAuraAnchors(frame, data, unit, size)
        if not C_UnitAuras or not C_UnitAuras.AddPrivateAuraAnchor then
            return
        end
        if data.privateUnit == unit and data.privateSize == size then
            return
        end
        ClearPrivateAuraAnchors(data)
        data.privateAnchorIDs = data.privateAnchorIDs or {}
        data.privateUnit = unit
        data.privateSize = size
        for i = 1, MAX_PRIVATE do
            local anchorID = C_UnitAuras.AddPrivateAuraAnchor({
                unitToken = unit,
                auraIndex = i,
                parent = frame,
                showCountdownFrame = true,
                showCountdownNumbers = true,
                isContainer = false,
                iconInfo = {
                    iconAnchor = {
                        point = "RIGHT",
                        relativeTo = frame,
                        relativePoint = "LEFT",
                        offsetX = -2 - (i - 1) * (size + ICON_GAP),
                        offsetY = 0
                    },
                    iconWidth = size,
                    iconHeight = size
                }
            })
            if anchorID then
                data.privateAnchorIDs[#data.privateAnchorIDs + 1] = anchorID
            end
        end
    end

    -- Anchor the buff/debuff containers above the powerBar when one is shown
    local function PositionAnchors(frame, data)
        local powerBar = frame.powerBar
        local hasPower = powerBar and powerBar:IsShown()
        local refFrame = hasPower and powerBar or frame
        local rightRef = hasPower and "TOPRIGHT" or "BOTTOMRIGHT"
        local leftRef = hasPower and "TOPLEFT" or "BOTTOMLEFT"
        local yOffset = hasPower and 1 or 2

        data.buffAnchor:ClearAllPoints()
        data.buffAnchor:SetPoint("BOTTOMRIGHT", refFrame, rightRef, -2, yOffset)

        data.debuffAnchor:ClearAllPoints()
        data.debuffAnchor:SetPoint("BOTTOMLEFT", refFrame, leftRef, 2, yOffset)
    end

    local function ApplyCountdownText(cd)
        for _, region in ipairs({cd:GetRegions()}) do
            if region.SetTextColor and region:GetObjectType() == "FontString" then
                region:SetTextColor(1, 1, 1, 1)
                local fontPath, _, fontFlags = region:GetFont()
                if fontPath then
                    region:SetFont(fontPath, 11, fontFlags or "OUTLINE")
                end
            end
        end
    end

    -- Skip auras whose spellId is in the hide list
    local function IsHidden(aura)
        if not aura then
            return false
        end
        local id = aura.spellId
        if not id then
            return false
        end
        if type(issecretvalue) == "function" and issecretvalue(id) then
            return false
        end
        return HIDDEN_SPELL_IDS[id] == true
    end

    function RF_AuraDisplay:ApplyAura(slot, unit, aura, size, isDebuff)
        slot:SetSize(size, size)
        slot:SetScale(1)
        slot:SetAlpha(1)
        slot.icon:SetTexture(aura.icon)
        slot.mUI_unit = unit
        slot.mUI_auraID = aura.auraInstanceID
        slot.mUI_isDebuff = isDebuff
        slot:EnableMouse(TooltipsEnabled())

        local stackText
        if C_UnitAuras.GetAuraApplicationDisplayCount and aura.auraInstanceID then
            local ok, result = pcall(C_UnitAuras.GetAuraApplicationDisplayCount, unit, aura.auraInstanceID, 2, 99)
            if ok then
                stackText = result
            end
        end
        if stackText ~= nil then
            slot.count:SetText(stackText)
            slot.count:Show()
        else
            slot.count:SetText("")
            slot.count:Hide()
        end

        local durObj
        if aura.auraInstanceID and aura.auraInstanceID > 0 then
            local ok, result = pcall(C_UnitAuras.GetAuraDuration, unit, aura.auraInstanceID)
            if ok then durObj = result end
        end
        if durObj then
            slot.cooldown:SetCooldownFromDurationObject(durObj:Copy())
        else
            slot.cooldown:Clear()
        end
        ApplyCountdownText(slot.cooldown)

        if isDebuff then
            local color
            local curve = RF_AuraDisplay.Theme and RF_AuraDisplay.Theme.colorCurve
            if curve and aura.auraInstanceID and aura.auraInstanceID > 0 then
                local ok, result = pcall(C_UnitAuras.GetAuraDispelTypeColor, unit, aura.auraInstanceID, curve)
                if ok then color = result end
            end
            if color then
                slot.border:SetVertexColor(color.r, color.g, color.b, 1)
            else
                slot.border:SetVertexColor(unpack(mUI:Color(0.15)))
            end
        else
            slot.border:SetVertexColor(unpack(mUI:Color(0.15)))
        end

        slot:Show()
    end

    local function LayoutGrid(anchor, icons, count, perRow, growLeft)
        local rowCorner = growLeft and "BOTTOMRIGHT" or "BOTTOMLEFT"
        local rowOppCorner = growLeft and "TOPRIGHT" or "TOPLEFT"
        for i = 1, count do
            local f = icons[i]
            f:ClearAllPoints()
            local col = (i - 1) % perRow
            local row = math.floor((i - 1) / perRow)
            if col == 0 then
                if row == 0 then
                    f:SetPoint(rowCorner, anchor, rowCorner)
                else
                    local rowStart = icons[(row - 1) * perRow + 1]
                    f:SetPoint(rowCorner, rowStart, rowOppCorner, 0, ICON_GAP)
                end
            else
                local prev = icons[i - 1]
                if growLeft then
                    f:SetPoint("BOTTOMRIGHT", prev, "BOTTOMLEFT", -ICON_GAP, 0)
                else
                    f:SetPoint("BOTTOMLEFT", prev, "BOTTOMRIGHT", ICON_GAP, 0)
                end
            end
        end
    end

    local function ScanByFilters(unit, filters, scaleFilters, into, seen)
        for _, filterStr in ipairs(filters) do
            local slots = {C_UnitAuras.GetAuraSlots(unit, filterStr)}
            for i = 2, #slots do
                local data = C_UnitAuras.GetAuraDataBySlot(unit, slots[i])
                local id = data and data.auraInstanceID
                if id and not seen[id] and not IsHidden(data) then
                    seen[id] = true
                    data.mUI_scale = GetCategoryScale(unit, id, scaleFilters)
                    into[#into + 1] = data
                end
            end
        end
    end

    local function ScanUnit(unit)
        local buffs, debuffs = {}, {}
        if not C_UnitAuras.GetAuraSlots then
            return buffs, debuffs
        end

        local seenBuff, seenDebuff = {}, {}
        ScanByFilters(unit, BUFF_FILTERS, BUFF_SCALE_FILTERS, buffs, seenBuff)

        -- Include all HARMFUL debuffs
        local harmful = {C_UnitAuras.GetAuraSlots(unit, "HARMFUL")}
        for i = 2, #harmful do
            local data = C_UnitAuras.GetAuraDataBySlot(unit, harmful[i])
            local id = data and data.auraInstanceID
            if id and not seenDebuff[id] and not IsHidden(data) then
                seenDebuff[id] = true
                data.mUI_scale = GetCategoryScale(unit, id, DEBUFF_SCALE_FILTERS)
                debuffs[#debuffs + 1] = data
            end
        end

        -- Mark debuffs the player can personally dispel (respects class/spec)
        local AF = (AuraUtil and AuraUtil.AuraFilters) or {}
        local playerDispelToken = AF.RaidPlayerDispellable or "RAID_PLAYER_DISPELLABLE"
        local playerDispelFilter = buildFilter("HARMFUL", playerDispelToken)
        local pdSlots = {C_UnitAuras.GetAuraSlots(unit, playerDispelFilter)}
        local playerDispelIDs = {}
        for i = 2, #pdSlots do
            local data = C_UnitAuras.GetAuraDataBySlot(unit, pdSlots[i])
            if data and data.auraInstanceID then
                playerDispelIDs[data.auraInstanceID] = true
            end
        end
        local dispelScale = GetDispelScale()
        for _, data in ipairs(debuffs) do
            if playerDispelIDs[data.auraInstanceID] and (data.mUI_scale or 1) < dispelScale then
                data.mUI_scale = dispelScale
            end
        end

        local function sortByScaleThenID(a, b)
            if a.mUI_scale ~= b.mUI_scale then
                return a.mUI_scale > b.mUI_scale
            end
            return (a.auraInstanceID or 0) < (b.auraInstanceID or 0)
        end
        table.sort(buffs, sortByScaleThenID)
        table.sort(debuffs, sortByScaleThenID)

        return buffs, debuffs
    end

    function RF_AuraDisplay:UpdateFrame(frame)
        if not frame or frame:IsForbidden() or not frame.unit then
            return
        end
        local data = RF_AuraDisplay:EnsureContainers(frame)
        PositionAnchors(frame, data)

        local unit = frame.displayedUnit or frame.unit
        -- GetAuraSlots rejects compound tokens (e.g. boss1targetpet). Only
        -- compound tokens reaching raid/party frames contain "target"; pet
        -- tokens like "raidpet1" are fine. UnitTokenFromGUID would normally
        -- resolve them but returns secret values under taint.
        if not unit or unit:match("target") then
            return
        end

        -- Hide auras for units we can't observe: in a different phase/shard
        -- or out of visible range. Their aura data is stale because UNIT_AURA
        -- no longer fires for them. Disconnected players still in-world stay
        -- visible since they can still be healed/dispelled.
        local unreachable = (UnitPhaseReason and UnitPhaseReason(unit) ~= nil) or (UnitIsVisible and not UnitIsVisible(unit))
        if unreachable then
            for i = 1, MAX_BUFFS do
                data.buffs[i]:Hide()
            end
            for i = 1, MAX_DEBUFFS do
                data.debuffs[i]:Hide()
            end
            ClearPrivateAuraAnchors(data)
            data.privateUnit, data.privateSize = nil, nil
            return
        end

        local buffSize, debuffSize = GetSizes(frame)
        local buffs, debuffs = ScanUnit(unit)
        local testBuffs = RF_AuraDisplay:GetTestBuffs()
        local testDebuffs = RF_AuraDisplay:GetTestDebuffs()
        if testBuffs then buffs = testBuffs end
        if testDebuffs then debuffs = testDebuffs end
        local frameH = frame:GetHeight()
        if not frameH or frameH < 1 then frameH = 36 end
        local raid = mUI.db and mUI.db.profile.unitframes.raidframes
        local privatePct = (raid and raid.privateaurasize or 90) / 100
        local privateSize = math.floor(frameH * privatePct + 0.5)
        RefreshPrivateAuraAnchors(frame, data, unit, privateSize)
        RF_AuraDisplay:UpdateTestPrivateAuras(frame, data, privateSize)

        for i = 1, MAX_BUFFS do
            local slot = data.buffs[i]
            local aura = buffs[i]
            if aura then
                RF_AuraDisplay:ApplyAura(slot, unit, aura, math.floor(buffSize * (aura.mUI_scale or 1) + 0.5), false)
            else
                slot:Hide()
            end
        end
        for i = 1, MAX_DEBUFFS do
            local slot = data.debuffs[i]
            local aura = debuffs[i]
            if aura then
                RF_AuraDisplay:ApplyAura(slot, unit, aura, math.floor(debuffSize * (aura.mUI_scale or 1) + 0.5), true)
            else
                slot:Hide()
            end
        end

        LayoutGrid(data.buffAnchor, data.buffs, math.min(#buffs, MAX_BUFFS), BUFFS_PER_ROW, true)
        LayoutGrid(data.debuffAnchor, data.debuffs, math.min(#debuffs, MAX_DEBUFFS), MAX_DEBUFFS, false)
    end

    RF_AuraDisplay.trackedFrames = RF_AuraDisplay.trackedFrames or {}

    function RF_AuraDisplay:Track(frame)
        if frame and not frame:IsForbidden() then
            RF_AuraDisplay.trackedFrames[frame] = true
        end
    end

    function RF_AuraDisplay:ForEachTrackedFrame(func)
        for frame in pairs(RF_AuraDisplay.trackedFrames) do
            if frame and not frame:IsForbidden() and frame.unit then
                func(frame)
            end
        end
    end

    function RF_AuraDisplay:UpdateAll()
        RF_AuraDisplay:ForEachTrackedFrame(function(f)
            RF_AuraDisplay:UpdateFrame(f)
        end)
    end

    local function FormatValue(v)
        if type(issecretvalue) == "function" and issecretvalue(v) then
            return "[SECRET " .. type(v) .. "]"
        end
        if type(v) == "string" then
            return string.format("%q", v)
        end
        return tostring(v)
    end

    function RF_AuraDisplay:DumpAuras()
        if not C_UnitAuras or not C_UnitAuras.GetAuraSlots then
            print("|cffff5555[RF_AuraDisplay]|r C_UnitAuras unavailable")
            return
        end
        print("|cff00ff88[RF_AuraDisplay]|r === player HARMFUL ===")
        local slots = {C_UnitAuras.GetAuraSlots("player", "HARMFUL")}
        for i = 2, #slots do
            local data = C_UnitAuras.GetAuraDataBySlot("player", slots[i])
            if data then
                local parts = {}
                for k, v in pairs(data) do
                    parts[#parts + 1] = tostring(k) .. "=" .. FormatValue(v)
                end
                table.sort(parts)
                print("  " .. table.concat(parts, "  "))
            end
        end
    end
end

function RF_AuraDisplay:RefreshFilters()
    BuildFilterTables()
end

function RF_AuraDisplay:SetTestPrivateAuras(enabled)
    self.testPrivateAuras = enabled and true or false
    self:UpdateAll()
end

function RF_AuraDisplay:SetTestBuffs(enabled)
    self.testBuffs = enabled and true or false
    self:UpdateAll()
end

function RF_AuraDisplay:SetTestDebuffs(enabled)
    self.testDebuffs = enabled and true or false
    self:UpdateAll()
end

function RF_AuraDisplay:OnEnable()
    BuildFilterTables()
    self.Theme = mUI:GetModule("mUI.Modules.General.Theme", true)

    _G.SLASH_RFADEBUG1 = "/rfadebug"
    _G.SlashCmdList = _G.SlashCmdList or {}
    _G.SlashCmdList.RFADEBUG = function()
        self:DumpAuras()
    end

    local function isCompactFrame(frame)
        local name = frame and frame:GetName()
        if not name then
            return false
        end
        return name:match("^CompactPartyFrameMember") or name:match("^CompactRaidFrame%d") or name:match("^CompactRaidGroup%d+Member%d") ~= nil
    end

    self:SecureHook("DefaultCompactUnitFrameSetup", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            self:Track(frame)
            self:UpdateFrame(frame)
        end
    end)

    self:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            self:Track(frame)
            self:UpdateFrame(frame)
        end
    end)

    -- Visibility (UnitIsVisible) doesn't fire a dedicated event, so poll on
     -- our own (insecure) frame to avoid tainting Blizzard's range-update path.
    if not self.visibilityTicker then
        self.visibilityTicker = C_Timer.NewTicker(0.5, function()
            self:ForEachTrackedFrame(function(f)
                local unit = f.displayedUnit or f.unit
                if not unit then
                    return
                end
                local visible = UnitIsVisible and UnitIsVisible(unit)
                if f.mUI_AD_lastVisible ~= visible then
                    f.mUI_AD_lastVisible = visible
                    self:UpdateFrame(f)
                end
            end)
        end)
    end

    if not self.eventFrame then
        self.eventFrame = CreateFrame("Frame")
        self.eventFrame:SetScript("OnEvent", function(_, event, unit)
            if (event == "UNIT_AURA" or event == "UNIT_PHASE" or event == "UNIT_FLAGS" or event == "UNIT_CONNECTION") and unit then
                self:ForEachTrackedFrame(function(f)
                    if f.unit == unit or f.displayedUnit == unit then
                        self:UpdateFrame(f)
                    end
                end)
            else
                C_Timer.After(0, function()
                    self:UpdateAll()
                end)
            end
        end)
    end
    self.eventFrame:RegisterEvent("UNIT_AURA")
    self.eventFrame:RegisterEvent("UNIT_PHASE")
    self.eventFrame:RegisterEvent("UNIT_FLAGS")
    self.eventFrame:RegisterEvent("UNIT_CONNECTION")
    self.eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    C_Timer.After(0, function()
        self:UpdateAll()
    end)
end

function RF_AuraDisplay:OnDisable()
    self:UnhookAll()
    if self.eventFrame then
        self.eventFrame:UnregisterAllEvents()
    end
    if self.visibilityTicker then
        self.visibilityTicker:Cancel()
        self.visibilityTicker = nil
    end
    if C_UnitAuras and C_UnitAuras.RemovePrivateAuraAnchor then
        for frame in pairs(RF_AuraDisplay.trackedFrames or {}) do
            local data = frame and frame.mUI_AD
            if data and data.privateAnchorIDs then
                for i = 1, #data.privateAnchorIDs do
                    C_UnitAuras.RemovePrivateAuraAnchor(data.privateAnchorIDs[i])
                end
                wipe(data.privateAnchorIDs)
                data.privateUnit, data.privateSize = nil, nil
            end
        end
    end
end
