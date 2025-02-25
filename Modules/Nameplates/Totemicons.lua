local Totemicons = mUI:NewModule("mUI.Modules.Nameplates.Totemicons", "AceHook-3.0")

function Totemicons:OnInitialize()
    -- Load Libraries
    Totemicons.glow = LibStub("LibCustomGlow-1.0")

    -- Create Frame
    Totemicons.frame = CreateFrame("Frame")

    -- Variables
    Totemicons.startTimes = setmetatable({ __mode = "v" }, {})

    -- Tables
    Totemicons.active = {}
    Totemicons.toglow = {
        [105427] = true,
        [5925] = true,
        [5913] = true
    }
    Totemicons.totems = {
        [2630] = { 2484, 20 },     -- Earthbind
        [60561] = { 51485, 20 },   -- Earthgrab
        [3527] = { 5394, 15 },     -- Healing Stream
        [6112] = { 8512, 120 },    -- Windfury
        [97369] = { 192222, 15 },  -- Liquid Magma
        [5913] = { 8143, 10 },     -- Tremor
        [5925] = { 204336, 3 },    -- Grounding
        [78001] = { 157153, 15 },  -- Cloudburst
        [53006] = { 98008, 6 },    -- Spirit Link
        [59764] = { 108280, 12 },  -- Healing Tide
        [61245] = { 192058, 2 },   -- Static Charge
        [100943] = { 198838, 15 }, -- Earthen Wall
        [97285] = { 192077, 15 },  -- Wind Rush
        [105451] = { 204331, 15 }, -- Counterstrike
        [104818] = { 207399, 30 }, -- Ancestral
        [105427] = { 204330, 15 }, -- Skyfury
        [179867] = { 355580, 6 },  -- Static Field
        [166523] = { 324386, 30 }, -- Vesper Totem (Kyrian)

        -- Warrior
        [119052] = { 236320, 15 }, -- War Banner

        --Priest
        [101398] = { 211522, 12 }, -- Psyfiend
    }

    function Totemicons:GetNPCIDByGUID(guid)
        local _, _, _, _, _, npcID = strsplit("-", guid);
        return tonumber(npcID)
    end

    function Totemicons:CreateIcon(nameplate)
        local frame = CreateFrame("Frame", nil, nameplate)
        frame:SetSize(25, 25)
        frame:SetPoint("BOTTOM", nameplate, "TOP", 0, 5)

        local icon = frame:CreateTexture(nil, "ARTWORK")
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetAllPoints()

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
        bg:SetVertexColor(0, 0, 0, 0.5)
        bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
        bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)

        local cd = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
        cd.noCooldownCount = true
        cd:SetHideCountdownNumbers(true)
        cd:SetReverse(true)
        cd:SetDrawEdge(false)
        cd:SetAllPoints(frame)

        frame.cooldown = cd
        frame.icon = icon
        frame.bg = bg

        return frame
    end

    function Totemicons:NAME_PLATE_UNIT_ADDED(event, unit)
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        local guid = UnitGUID(unit)
        local npcID = Totemicons:GetNPCIDByGUID(guid)

        if npcID and Totemicons.totems[npcID] then
            local isFriendly = UnitReaction(unit, "player") >= 4
            if isFriendly then return end

            if not nameplate.mUITotemIcon then
                nameplate.mUITotemIcon = Totemicons:CreateIcon(nameplate)
            end

            local iconFrame = nameplate.mUITotemIcon
            iconFrame:Show()

            local totemData = Totemicons.totems[npcID]
            local spellID, duration = unpack(totemData)

            local tex = C_Spell.GetSpellTexture(spellID)

            iconFrame.icon:SetTexture(tex)
            local startTime = Totemicons.startTimes[guid]
            if startTime then
                iconFrame.cooldown:SetCooldown(startTime, duration)
                iconFrame.cooldown:Show()
            end

            if Totemicons.toglow[npcID] then
                iconFrame:SetSize(35, 35)
                Totemicons.glow.ButtonGlow_Start(iconFrame, { 1, 0, 0.3, 1 })
            end

            Totemicons.active[guid] = nameplate
        end
    end

    function Totemicons:NAME_PLATE_UNIT_REMOVED(event, unit)
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        if nameplate.mUITotemIcon then
            local guid = UnitGUID(unit)
            local npcID = Totemicons:GetNPCIDByGUID(guid)

            nameplate.mUITotemIcon:Hide()

            if Totemicons.toglow[npcID] then
                nameplate.mUITotemIcon:SetSize(25, 25)
                Totemicons.glow.ButtonGlow_Stop(nameplate.mUITotemIcon)
            end

            Totemicons.active[guid] = nil
        end
    end

    function Totemicons:COMBAT_LOG_EVENT_UNFILTERED(event, unit)
        local timestamp, eventType, hideCaster,
        srcGUID, srcName, srcFlags, srcFlags2,
        dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo()

        if eventType == "SPELL_SUMMON" then
            local npcID = Totemicons:GetNPCIDByGUID(dstGUID)
            if npcID and Totemicons.totems[npcID] then
                Totemicons.startTimes[dstGUID] = GetTime()
            end
        end
    end
end

function Totemicons:OnEnable()
    Totemicons.frame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    Totemicons.frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    Totemicons.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Totemicons:HookScript(Totemicons.frame, "OnEvent", function(_, event, ...)
        return Totemicons[event](self, event, ...)
    end)
end

function Totemicons:OnDisable()
    Totemicons.frame:UnregisterAllEvents()
    Totemicons:UnhookAll()
end
