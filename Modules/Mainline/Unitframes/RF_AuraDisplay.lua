local RF_AuraDisplay = mUI:NewModule("mUI.Modules.Unitframes.RF_AuraDisplay", "AceHook-3.0")

local MAX_BUFFS = 6
local MAX_DEBUFFS = 3
local MAX_PRIVATE = 2
local MAX_DEFENSIVE = 2
local BUFFS_PER_ROW = 3
local ICON_GAP = 1

local function GetDefensiveSize()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.centerDefensiveSize) or 60
end

local DEFENSIVE_POINTS = {
    CENTER = true,
    LEFT = true,
    RIGHT = true
}

local function GetDefensivePosition()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    local point = raid and raid.centerDefensivePoint or "CENTER"
    if not DEFENSIVE_POINTS[point] then
        point = "CENTER"
    end
    local x = (raid and raid.centerDefensiveX) or 0
    local y = (raid and raid.centerDefensiveY) or 0
    return point, x, y
end

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
    [308312] = true, -- Time Trial Practice (Time Trial)
    [1254550] = true, -- Arcane Empowerment
    [26013] = true, -- Deserter
    [71041] = true -- Deserter
}

local BORDER_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\border.png]]
local MASK_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]]

-- Filter sets mirror RaidFrameAuras' defaults
local BUFF_FILTERS, DEBUFF_FILTERS, DEFENSIVE_FILTERS = {}, {}, {}
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

local function IsPriorityAura(aura)
    if not aura then
        return false
    end
    local isSecret = type(issecretvalue) == "function"
    local boss = aura.isBossAura
    if not (isSecret and issecretvalue(boss)) and boss then
        return true
    end
    local id = aura.spellId
    if not id then
        return false
    end
    if isSecret and issecretvalue(id) then
        return false
    end
    if AuraUtil and AuraUtil.CheckIsPriorityAura then
        local ok, result = pcall(AuraUtil.CheckIsPriorityAura, id)
        if ok then
            return result == true
        end
    end
    return false
end

local function BuildFilterTables()
    local AF = (AuraUtil and AuraUtil.AuraFilters) or {}
    local CC = AF.CrowdControl
    local BIGDEF = AF.BigDefensive
    local EXTDEF = AF.ExternalDefensive
    local RAIDIC = AF.RaidInCombat

    -- AuraUtil.AuraFilters no longer exposes an "Important" token, so the
    -- old HELPFUL|PLAYER|IMPORTANT filter returned no slots. We now scan
    -- HELPFUL|PLAYER and keep auras that AuraUtil.CheckIsPriorityAura (or
    -- isBossAura) flags as priority — entries marked priorityOnly=true are
    -- post-filtered in ScanByFilters.
    BUFF_FILTERS = {}
    if RAIDIC then
        BUFF_FILTERS[#BUFF_FILTERS + 1] = {
            filter = buildFilter("HELPFUL", "PLAYER", RAIDIC)
        }
    end
    BUFF_FILTERS[#BUFF_FILTERS + 1] = {
        filter = buildFilter("HELPFUL", "PLAYER"),
        priorityOnly = true
    }

    -- No PLAYER flag: BigDefensive includes self-cast cooldowns on other
    -- party members (e.g. Shield Wall on the tank), and ExternalDefensive
    -- can be cast by any teammate, not just the local player.
    DEFENSIVE_FILTERS = {}
    if BIGDEF then
        DEFENSIVE_FILTERS[#DEFENSIVE_FILTERS + 1] = {
            filter = buildFilter("HELPFUL", BIGDEF)
        }
    end
    if EXTDEF then
        DEFENSIVE_FILTERS[#DEFENSIVE_FILTERS + 1] = {
            filter = buildFilter("HELPFUL", EXTDEF)
        }
    end

    -- All buffs render at the same size — no per-category scaling.
    BUFF_SCALE_FILTERS = {}

    -- Debuff inclusion filters. Priority/boss debuffs flow through the broad
    -- HARMFUL scan in ScanUnit, so no separate "important" filter is needed.
    DEBUFF_FILTERS = {{
        filter = buildFilter("HARMFUL", "RAID")
    }}
    if CC then
        DEBUFF_FILTERS[#DEBUFF_FILTERS + 1] = {
            filter = buildFilter("HARMFUL", CC)
        }
    end

    -- Debuff category scales (CC scale is user-configurable). The previous
    -- IMPORTANT entry was a no-op (scale 1) and used a token that no longer
    -- exists, so we drop it.
    DEBUFF_SCALE_FILTERS = {}
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
        count:SetFont(GetFont(), 9, "OUTLINE")
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
            debuffs = {},
            defensives = {}
        }

        local buffAnchor = CreateFrame("Frame", nil, frame)
        buffAnchor:SetSize(1, 1)
        data.buffAnchor = buffAnchor

        local debuffAnchor = CreateFrame("Frame", nil, frame)
        debuffAnchor:SetSize(1, 1)
        data.debuffAnchor = debuffAnchor

        local defensiveAnchor = CreateFrame("Frame", nil, frame)
        defensiveAnchor:SetSize(1, 1)
        data.defensiveAnchor = defensiveAnchor

        for i = 1, MAX_BUFFS do
            data.buffs[i] = RF_AuraDisplay:CreateIcon(frame)
        end
        for i = 1, MAX_DEBUFFS do
            data.debuffs[i] = RF_AuraDisplay:CreateIcon(frame)
        end
        for i = 1, MAX_DEFENSIVE do
            local slot = RF_AuraDisplay:CreateIcon(frame)
            slot:SetFrameLevel(frame:GetFrameLevel() + 10)
            data.defensives[i] = slot
        end

        frame.mUI_AD = data
        return data
    end

    -- Test mode: render placeholder icons where each aura category would
    -- appear so users can preview size/position without an actual mechanic.
    local TEST_TEXTURE_PRIVATE = 132288 -- Spell_Holy_BorrowedTime
    local TEST_TEXTURE_BUFF = 136224 -- Spell_Nature_Rejuvenation
    local TEST_TEXTURE_DEBUFF = 136139 -- Spell_Shadow_AbominationExplosion
    local TEST_TEXTURE_DEFENSIVE = 135936 -- Spell_Holy_PainSuppression
    function RF_AuraDisplay:UpdateTestPrivateAuras(frame, data, size, debuffSize)
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
                icon:SetPoint("BOTTOMLEFT", data.debuffAnchor, "BOTTOMLEFT", (i - 1) * (size + ICON_GAP), (debuffSize or 0) + ICON_GAP)
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
        if not RF_AuraDisplay.testBuffs then
            return nil
        end
        local list = {}
        for i = 1, MAX_BUFFS do
            list[i] = MakeTestAura(TEST_TEXTURE_BUFF, -i)
        end
        return list
    end

    function RF_AuraDisplay:GetTestDebuffs()
        if not RF_AuraDisplay.testDebuffs then
            return nil
        end
        local list = {}
        for i = 1, MAX_DEBUFFS do
            list[i] = MakeTestAura(TEST_TEXTURE_DEBUFF, -100 - i)
        end
        return list
    end

    function RF_AuraDisplay:GetTestDefensives()
        if not RF_AuraDisplay.testDefensives then
            return nil
        end
        local list = {}
        for i = 1, MAX_DEFENSIVE do
            list[i] = MakeTestAura(TEST_TEXTURE_DEFENSIVE, -200 - i)
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

    -- AddPrivateAuraAnchor caches the parent's frame level on the FIRST
    -- registration and ignores it on every subsequent re-register against
    -- the same parent. After a remove+re-add cycle the new icons render at
    -- the OLD cached level and can end up painted behind the unit frame.
    -- Toggling the level to 0 and back forces the renderer to re-read on
    -- the next paint. (Workaround sourced from the Grid2 dev.)
    local function ForceFrameLevelRefresh(parent)
        if not parent then
            return
        end
        local level = parent:GetFrameLevel()
        parent:SetFrameLevel(0)
        parent:SetFrameLevel(level)
    end

    local function EnsurePrivateSlots(frame, data)
        if data.privateSlots then
            return
        end
        data.privateSlots = {}
        for i = 1, MAX_PRIVATE do
            local slot = CreateFrame("Frame", nil, frame)
            slot:SetFrameLevel(frame:GetFrameLevel() + 10)
            slot:Hide()
            data.privateSlots[i] = slot
        end
    end

    local function PositionPrivateSlots(data, size, debuffSize)
        for i = 1, MAX_PRIVATE do
            local slot = data.privateSlots[i]
            slot:SetSize(size, size)
            slot:ClearAllPoints()
            slot:SetPoint("BOTTOMLEFT", data.debuffAnchor, "BOTTOMLEFT", (i - 1) * (size + ICON_GAP), debuffSize + ICON_GAP)
            slot:Show()
        end
    end

    local function RefreshPrivateAuraAnchors(frame, data, unit, size, debuffSize)
        if not C_UnitAuras or not C_UnitAuras.AddPrivateAuraAnchor then
            return
        end
        EnsurePrivateSlots(frame, data)
        PositionPrivateSlots(data, size, debuffSize)

        data.privateAnchorIDs = data.privateAnchorIDs or {}
        local fullyRegistered = #data.privateAnchorIDs == MAX_PRIVATE
        if fullyRegistered and data.privateUnit == unit and data.privateSize == size then
            return
        end
        ClearPrivateAuraAnchors(data)
        local registered = 0
        for i = 1, MAX_PRIVATE do
            local slot = data.privateSlots[i]
            slot:SetFrameLevel(frame:GetFrameLevel() + 10)
            local anchorID = C_UnitAuras.AddPrivateAuraAnchor({
                unitToken = unit,
                auraIndex = i,
                parent = slot,
                showCountdownFrame = true,
                showCountdownNumbers = true,
                isContainer = false,
                iconInfo = {
                    borderScale = 1,
                    iconAnchor = {
                        point = "CENTER",
                        relativeTo = slot,
                        relativePoint = "CENTER",
                        offsetX = 0,
                        offsetY = 0
                    },
                    iconWidth = size,
                    iconHeight = size
                }
            })
            if anchorID then
                data.privateAnchorIDs[#data.privateAnchorIDs + 1] = anchorID
                ForceFrameLevelRefresh(slot)
                registered = registered + 1
            end
        end
        if registered == MAX_PRIVATE then
            data.privateUnit = unit
            data.privateSize = size
            data.privateRowOffset = debuffSize
        else
            data.privateUnit, data.privateSize, data.privateRowOffset = nil, nil, nil
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
            if ok then
                durObj = result
            end
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
                if ok then
                    color = result
                end
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

    -- Horizontal layout of defensive slots. CENTER keeps the pair balanced
    -- around the anchor; LEFT pins the first icon's left edge and grows
    -- rightward; RIGHT pins the first icon's right edge and grows leftward.
    local function LayoutCentered(anchor, icons, count, size, point)
        if count <= 0 then
            return
        end
        icons[1]:ClearAllPoints()
        if point == "LEFT" then
            icons[1]:SetPoint("LEFT", anchor, "LEFT", 0, 0)
            for i = 2, count do
                icons[i]:ClearAllPoints()
                icons[i]:SetPoint("LEFT", icons[i - 1], "RIGHT", ICON_GAP, 0)
            end
        elseif point == "RIGHT" then
            icons[1]:SetPoint("RIGHT", anchor, "RIGHT", 0, 0)
            for i = 2, count do
                icons[i]:ClearAllPoints()
                icons[i]:SetPoint("RIGHT", icons[i - 1], "LEFT", -ICON_GAP, 0)
            end
        else
            if count == 1 then
                icons[1]:SetPoint("CENTER", anchor, "CENTER", 0, 0)
            else
                local pairOffset = (size + ICON_GAP) / 2
                icons[1]:SetPoint("CENTER", anchor, "CENTER", -pairOffset, 0)
                for i = 2, count do
                    icons[i]:ClearAllPoints()
                    icons[i]:SetPoint("LEFT", icons[i - 1], "RIGHT", ICON_GAP, 0)
                end
            end
        end
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
        for _, entry in ipairs(filters) do
            local filterStr = entry.filter
            local priorityOnly = entry.priorityOnly
            local slots = {C_UnitAuras.GetAuraSlots(unit, filterStr)}
            for i = 2, #slots do
                local data = C_UnitAuras.GetAuraDataBySlot(unit, slots[i])
                local id = data and data.auraInstanceID
                if id and not seen[id] and not IsHidden(data) and (not priorityOnly or IsPriorityAura(data)) then
                    seen[id] = true
                    data.mUI_scale = GetCategoryScale(unit, id, scaleFilters)
                    into[#into + 1] = data
                end
            end
        end
    end

    local function ScanUnit(unit)
        local buffs, debuffs, defensives = {}, {}, {}
        if not C_UnitAuras.GetAuraSlots then
            return buffs, debuffs, defensives
        end

        local seenBuff, seenDebuff, seenDef = {}, {}, {}
        ScanByFilters(unit, BUFF_FILTERS, BUFF_SCALE_FILTERS, buffs, seenBuff)
        ScanByFilters(unit, DEFENSIVE_FILTERS, BUFF_SCALE_FILTERS, defensives, seenDef)

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
        table.sort(defensives, sortByScaleThenID)

        return buffs, debuffs, defensives
    end

    function RF_AuraDisplay:UpdateFrame(frame)
        if not frame or frame:IsForbidden() or not frame.unit then
            return
        end
        local data = RF_AuraDisplay:EnsureContainers(frame)
        PositionAnchors(frame, data)

        local unit = frame.displayedUnit or frame.unit
        if not unit or unit:match("target") then
            return
        end

        local unreachable = (UnitPhaseReason and UnitPhaseReason(unit) ~= nil) or (UnitIsVisible and not UnitIsVisible(unit))

        local buffSize, debuffSize = GetSizes(frame)
        local buffs, debuffs, defensives
        if unreachable then
            buffs, debuffs, defensives = {}, {}, {}
        else
            buffs, debuffs, defensives = ScanUnit(unit)
            local testBuffs = RF_AuraDisplay:GetTestBuffs()
            local testDebuffs = RF_AuraDisplay:GetTestDebuffs()
            local testDefensives = RF_AuraDisplay:GetTestDefensives()
            if testBuffs then
                buffs = testBuffs
            end
            if testDebuffs then
                debuffs = testDebuffs
            end
            if testDefensives then
                defensives = testDefensives
            end
        end
        local frameH = frame:GetHeight()
        if not frameH or frameH < 1 then
            frameH = 36
        end
        local raid = mUI.db and mUI.db.profile.unitframes.raidframes
        local privatePct = (raid and raid.privateaurasize or 90) / 100
        local privateSize = math.floor(frameH * privatePct + 0.5)
        RefreshPrivateAuraAnchors(frame, data, unit, privateSize, debuffSize)
        RF_AuraDisplay:UpdateTestPrivateAuras(frame, data, privateSize, debuffSize)

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

        local defensiveSize = math.floor(frameH * (GetDefensiveSize() / 100) + 0.5)
        local defensiveCount = math.min(#defensives, MAX_DEFENSIVE)
        local defPoint, defX, defY = GetDefensivePosition()
        data.defensiveAnchor:ClearAllPoints()
        data.defensiveAnchor:SetPoint(defPoint, frame, defPoint, defX, defY)
        for i = 1, MAX_DEFENSIVE do
            local slot = data.defensives[i]
            local aura = defensives[i]
            if aura then
                RF_AuraDisplay:ApplyAura(slot, unit, aura, defensiveSize, false)
            else
                slot:Hide()
            end
        end

        LayoutGrid(data.buffAnchor, data.buffs, math.min(#buffs, MAX_BUFFS), BUFFS_PER_ROW, true)
        LayoutGrid(data.debuffAnchor, data.debuffs, math.min(#debuffs, MAX_DEBUFFS), MAX_DEBUFFS, false)
        LayoutCentered(data.defensiveAnchor, data.defensives, defensiveCount, defensiveSize, defPoint)
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

function RF_AuraDisplay:SetTestDefensives(enabled)
    self.testDefensives = enabled and true or false
    self:UpdateAll()
end

local BLIZZARD_AURA_CVARS = {"raidFramesDisplayBuffs", "raidFramesDisplayDebuffs", "raidFramesCenterBigDefensive"}

function RF_AuraDisplay:OnEnable()
    BuildFilterTables()
    self.Theme = mUI:GetModule("mUI.Modules.General.Theme", true)

    for _, cv in ipairs(BLIZZARD_AURA_CVARS) do
        pcall(SetCVar, cv, "0")
    end

    local function isCompactFrame(frame)
        local name = frame and frame:GetName()
        if not name then
            return false
        end
        return name:match("^CompactPartyFrameMember") or name:match("^CompactRaidFrame%d") or name:match("^CompactRaidGroup%d+Member%d") ~= nil
    end

    -- Blizzard reuses frames across units/group changes. When it re-sets up
    -- a frame, the private aura anchors we registered against it can be
    -- silently invalidated. Drop our cache so RefreshPrivateAuraAnchors
    -- forces a re-register on the next update.
    local function InvalidatePrivateCache(frame)
        local d = frame and frame.mUI_AD
        if d then
            d.privateUnit, d.privateSize, d.privateRowOffset = nil, nil, nil
        end
    end

    self:SecureHook("DefaultCompactUnitFrameSetup", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            InvalidatePrivateCache(frame)
            self:Track(frame)
            self:UpdateFrame(frame)
        end
    end)

    -- CompactUnitFrame_SetUnit rebinds an existing frame to a (possibly new)
    -- unit without going through DefaultCompactUnitFrameSetup. Blizzard tears
    -- down the frame's private aura state on rebind, so our cache must be
    -- dropped here too — otherwise dungeons/roster shuffles leave us thinking
    -- the anchors are still live when they aren't.
    self:SecureHook("CompactUnitFrame_SetUnit", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            InvalidatePrivateCache(frame)
        end
    end)

    -- Blizzard's own CompactUnitFrame_UpdatePrivateAuras manages a separate
    -- set of anchors on the same parent frame. When it runs (frame setup,
    -- roster changes, layout swaps in dungeons), it can quietly invalidate
    -- anchors we registered earlier. Re-register right after it runs so our
    -- anchors are always the last word on the frame's private aura state.
    if _G.CompactUnitFrame_UpdatePrivateAuras then
        self:SecureHook("CompactUnitFrame_UpdatePrivateAuras", function(frame)
            if not frame or frame:IsForbidden() then
                return
            end
            if isCompactFrame(frame) then
                InvalidatePrivateCache(frame)
                self:UpdateFrame(frame)
            end
        end)
    end

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
                -- Roster/world transitions can invalidate private aura anchors
                -- registered earlier. Wipe the cache so the next UpdateAll
                -- forces a re-register for every tracked frame.
                self:ForEachTrackedFrame(InvalidatePrivateCache)
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
    for _, cv in ipairs(BLIZZARD_AURA_CVARS) do
        pcall(SetCVar, cv, "1")
    end
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
