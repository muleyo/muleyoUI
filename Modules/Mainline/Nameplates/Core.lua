local Core = mUI:NewModule("mUI.Modules.Nameplates.Core", "AceEvent-3.0")

local IsSecret = issecretvalue or function()
    return false
end

local function Clean(value)
    if value == nil or IsSecret(value) then
        return nil
    end
    return value
end

function Core:OnInitialize()
    -- Load Database
    Core.db = mUI.db.profile.nameplates

    Core.IsSecret = IsSecret
    Core.Clean = Clean

    function Core:Safe(value, fallback)
        local cleaned = Clean(value)
        if cleaned == nil then
            return fallback
        end
        return cleaned
    end

    function Core:Exists(value)
        if IsSecret(value) then
            return true
        end
        return value ~= nil
    end

    -- Registered feature handlers
    Core.widgets = {}
    Core.order = {}

    -- [base NamePlate frame] = unit snapshot, for every plate currently on screen
    Core.plates = {}

    -- [mUIPlate] = { [widget name] = true }
    Core.built = setmetatable({}, {
        __mode = "k"
    })

    local function IsUsablePlate(namePlate)
        if not namePlate or namePlate:IsForbidden() then
            return false
        end

        local frame = namePlate.UnitFrame
        return frame and not frame:IsForbidden() and frame.unit ~= nil
    end

    local function ForEachHiddenRegion(frame, func)
        func(frame.HealthBarsContainer)
        func(frame.name)
        func(frame.selectionHighlight)
        func(frame.ClassificationFrame)
        func(frame.LevelFrame)
        func(frame.RaidTargetFrame)
        func(frame.aggroHighlight)
        func(frame.aggroFlash)
        func(frame.AurasFrame)

        if frame.aggroHighlightTextures then
            for _, texture in ipairs(frame.aggroHighlightTextures) do
                func(texture)
            end
        end
    end

    local function SuppressBlizzard(namePlate)
        local frame = namePlate.UnitFrame
        if not frame then
            return
        end

        ForEachHiddenRegion(frame, function(region)
            if region then
                region:SetAlpha(0)
            end
        end)
    end

    local function RestoreBlizzard(namePlate)
        local frame = namePlate.UnitFrame
        if not frame then
            return
        end

        ForEachHiddenRegion(frame, function(region)
            if region then
                region:SetAlpha(1)
            end
        end)

        frame:SetAlpha(1)
        frame:Show()
    end

    function Core:ApplyHitTest(namePlate, plate, data)
        if not namePlate.CanChangeHitTestPoints or not namePlate:CanChangeHitTestPoints() then
            return
        end

        if Core.db.clickthrough and data and data.isFriend then
            namePlate:ClearAllHitTestPoints()
        elseif plate and plate.Health then
            namePlate:SetAllHitTestPoints(plate.Health)
        end
    end

    Core.SuppressBlizzard = SuppressBlizzard
    Core.RestoreBlizzard = RestoreBlizzard

    function Core:AcquirePlate(namePlate)
        local plate = namePlate.mUIPlate
        if plate then
            return plate
        end

        plate = CreateFrame("Frame", nil, namePlate)
        plate:SetAllPoints(namePlate)
        plate:EnableMouse(false)

        namePlate.mUIPlate = plate
        return plate
    end

    function Core:CreateBorder(parent, anchorTo, thickness)
        local border = CreateFrame("Frame", nil, parent)

        local edges = {}
        for i = 1, 4 do
            edges[i] = border:CreateTexture(nil, "BORDER")
        end

        edges[1]:SetPoint("TOPLEFT")
        edges[1]:SetPoint("TOPRIGHT")

        edges[2]:SetPoint("BOTTOMLEFT")
        edges[2]:SetPoint("BOTTOMRIGHT")

        edges[3]:SetPoint("TOPLEFT")
        edges[3]:SetPoint("BOTTOMLEFT")

        edges[4]:SetPoint("TOPRIGHT")
        edges[4]:SetPoint("BOTTOMRIGHT")

        function border:SetBorderColor(r, g, b, a)
            for i = 1, 4 do
                edges[i]:SetColorTexture(r, g, b, a or 1)
            end
        end

        function border:SetThickness(size)
            local px = math.max(1, size or 1)

            self:ClearAllPoints()
            PixelUtil.SetPoint(self, "TOPLEFT", anchorTo, "TOPLEFT", -px, px)
            PixelUtil.SetPoint(self, "BOTTOMRIGHT", anchorTo, "BOTTOMRIGHT", px, -px)

            PixelUtil.SetHeight(edges[1], px)
            PixelUtil.SetHeight(edges[2], px)
            PixelUtil.SetWidth(edges[3], px)
            PixelUtil.SetWidth(edges[4], px)
        end

        border:SetThickness(thickness or 1)
        border:SetBorderColor(0, 0, 0, 1)

        return border
    end

    function Core:GetPlateForUnit(unit)
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        if namePlate and not namePlate:IsForbidden() then
            return namePlate.mUIPlate, Core.plates[namePlate]
        end
    end

    function Core:GetData(namePlate)
        return Core.plates[namePlate]
    end

    -- Refresh the snapshot other modules read instead of re-querying the unit.
    function Core:BuildData(namePlate, unit)
        local data = Core.plates[namePlate]
        if not data then
            data = {}
            Core.plates[namePlate] = data
        end

        data.namePlate = namePlate
        data.plate = namePlate.mUIPlate
        data.unit = unit
        data.guid = Clean(UnitGUID(unit))

        data.displayName = UnitName(unit)
        data.name = Clean(data.displayName)

        -- Same as BetterBlizzPlates' GetNameplateUnitInfo: plain reads, a bare
        -- nil check, no issecretvalue guarding.
        local reaction = UnitReaction(unit, "player")
        data.isFriend = reaction ~= nil and reaction >= 5
        data.isNeutral = reaction ~= nil and reaction == 4
        data.isEnemy = reaction ~= nil and reaction < 4

        data.isPlayer = UnitIsPlayer(unit) == true
        data.isSelf = Core:Safe(UnitIsUnit(unit, "player"), false)
        data.isTarget = Core:Safe(UnitIsUnit(unit, "target"), false)
        data.isFocus = Core:Safe(UnitIsUnit(unit, "focus"), false)
        data.classFile = data.isPlayer and Clean(select(2, UnitClass(unit))) or nil

        return data
    end

    -- Feature registration -------------------------------------------------

    function Core:Register(name, handler)
        if Core.widgets[name] then
            return
        end

        Core.widgets[name] = handler
        Core.order[#Core.order + 1] = name

        -- Catch up the plates that are already on screen.
        Core:ForEach(function(plate, data)
            if not data.unit then
                return
            end

            Core:Build(name, plate)
            if handler.Update then
                handler.Update(plate, data)
            end
            if handler.Layout then
                handler.Layout(plate, data)
            end
        end)
    end

    function Core:Unregister(name)
        local handler = Core.widgets[name]
        if not handler then
            return
        end

        if handler.Remove then
            Core:ForEach(function(plate, data)
                handler.Remove(plate, data)
            end)
        end

        Core.widgets[name] = nil
        for i = #Core.order, 1, -1 do
            if Core.order[i] == name then
                table.remove(Core.order, i)
            end
        end
    end

    -- Run a feature's Create exactly once for a given plate.
    function Core:Build(name, plate)
        local handler = Core.widgets[name]
        if not handler or not handler.Create then
            return
        end

        local built = Core.built[plate]
        if not built then
            built = {}
            Core.built[plate] = built
        end

        if not built[name] then
            local ok, err = pcall(handler.Create, plate)
            if ok then
                built[name] = true
            else
                mUI:Debug("Nameplates: " .. name .. ".Create error: " .. tostring(err))
            end
        end
    end

    local reportedErrors = {}

    local function Dispatch(method, plate, data)
        for i = 1, #Core.order do
            local name = Core.order[i]
            local handler = Core.widgets[name]
            local func = handler and handler[method]
            if func then
                local ok, err = pcall(func, plate, data)
                if not ok and not reportedErrors[err] then
                    reportedErrors[err] = true
                    mUI:Debug("Nameplates: " .. name .. "." .. method .. " error: " .. tostring(err))
                end
            end
        end
    end

    -- Iteration ------------------------------------------------------------

    function Core:ForEach(func)
        for _, data in pairs(Core.plates) do
            if data.plate then
                func(data.plate, data)
            end
        end
    end

    function Core:UpdateAll()
        for namePlate, data in pairs(Core.plates) do
            if data.unit and data.plate then
                SuppressBlizzard(namePlate)
                Core:BuildData(namePlate, data.unit)
                Dispatch("Update", data.plate, data)
                Dispatch("Layout", data.plate, data)
            end
        end
    end

    function Core:RefreshHitTest()
        for namePlate, data in pairs(Core.plates) do
            Core:ApplyHitTest(namePlate, data.plate, data)
        end
    end

    function Core:LayoutAll()
        Core:ForEach(function(plate, data)
            if data.unit then
                Dispatch("Layout", plate, data)
            end
        end)
    end

    -- Lifecycle ------------------------------------------------------------

    function Core:OnUnitAdded(unit)
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        if not IsUsablePlate(namePlate) then
            return
        end

        if Core:Safe(UnitIsUnit(unit, "player"), false) then
            return
        end

        local stale = Core.plates[namePlate]
        if stale and stale.unit ~= unit then
            Core:OnUnitRemoved(stale.unit)
        end

        local plate = Core:AcquirePlate(namePlate)
        SuppressBlizzard(namePlate)

        local data = Core:BuildData(namePlate, unit)

        for i = 1, #Core.order do
            Core:Build(Core.order[i], plate)
        end

        plate:Show()

        Dispatch("Update", plate, data)
        Dispatch("Layout", plate, data)

        Core:ApplyHitTest(namePlate, plate, data)
    end

    function Core:OnUnitRemoved(unit)
        for namePlate, data in pairs(Core.plates) do
            if data.unit == unit then
                if data.plate then
                    Dispatch("Remove", data.plate, data)
                    data.plate:Hide()
                end
                Core.plates[namePlate] = nil
            end
        end
    end

    -- Event handling -------------------------------------------------------

    function Core:OnNameplateEvent(event, unit)
        if event == "NAME_PLATE_UNIT_ADDED" then
            Core:OnUnitAdded(unit)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            Core:OnUnitRemoved(unit)
        else
            Core:UpdateAll()
        end
    end

    local function Describe(region)
        if not region then
            return "|cffff0000nil|r"
        end

        local shown = region:IsShown() and "shown" or "|cffff0000hidden|r"
        local width, height = region:GetSize()
        local points = region:GetNumPoints()

        return string.format("%s %.0fx%.0f pts=%d", shown, Core:Safe(width, 0), Core:Safe(height, 0), points)
    end

    function Core:Diagnose()
        local unit
        if UnitExists("target") then
            unit = "target"
        elseif UnitExists("mouseover") then
            unit = "mouseover"
        else
            mUI:Debug("Nameplates: no target or mouseover. Target or mouseover a nameplate first.")
            return
        end

        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        if not namePlate then
            mUI:Debug("Nameplates: target has no nameplate.")
            return
        end

        local plate = namePlate.mUIPlate
        local data = Core.plates[namePlate]

        mUI:Debug("Nameplates: registered = " .. table.concat(Core.order, ", "))
        mUI:Debug("Nameplates: tracked = " .. tostring(data ~= nil) .. ", plate = " .. Describe(plate))

        if not plate then
            return
        end

        mUI:Debug("Nameplates: Health = " .. Describe(plate.Health))
        mUI:Debug("Nameplates: Cast = " .. Describe(plate.Cast))

        if plate.Health then
            local percent = plate.Health.percent
            mUI:Debug("Nameplates: percent = " .. Describe(percent) .. ", enabled = " .. tostring(Core.db.health and Core.db.health.percent))
            if percent then
                local text = percent:GetText()
                mUI:Debug("Nameplates: percent text = " .. text)
            end
        end

        local healthUnit = plate.Health and plate.Health:IsEventRegistered("UNIT_HEALTH")
        mUI:Debug("Nameplates: subscribed health = " .. tostring(healthUnit))

        local function Report(value)
            if IsSecret(value) then
                return "|cffffff00secret|r"
            elseif value == nil then
                return "nil"
            end
            return tostring(value)
        end

        mUI:Debug("Nameplates: UnitHealth = " .. Report(UnitHealth(unit)) .. ", UnitHealthMax = " .. Report(UnitHealthMax(unit)))
        mUI:Debug("Nameplates: casting = " .. Report(UnitCastingInfo(unit)) .. ", channeling = " .. Report(UnitChannelInfo(unit)))

        local castStart = select(4, UnitCastingInfo(unit))
        local channelStart = select(4, UnitChannelInfo(unit))
        mUI:Debug("Nameplates: cast timing = " .. Report(castStart) .. ", channel timing = " .. Report(channelStart))

        mUI:Debug("Nameplates: raidmark = " .. Report(GetRaidTargetIndex(unit)) .. ", marker = " .. Describe(plate.RaidMarker) .. ", classicon = " ..
                      Describe(plate.ClassIcon))

        local Units = mUI:GetModule("mUI.Modules.Nameplates.Units", true)
        local Health = mUI:GetModule("mUI.Modules.Nameplates.Health", true)
        if Units and data then
            local guid = UnitGUID(unit)
            local cleanGuid = Clean(guid)

            mUI:Debug("Nameplates: isPlayer = " .. tostring(data.isPlayer) .. ", isEnemy = " .. tostring(data.isEnemy) .. ", guid = " .. Report(guid))
            mUI:Debug("Nameplates: data.unit = " .. tostring(data.unit) .. " (diagnosed on " .. unit .. ")")
            mUI:Debug("Nameplates: live on diagnosed unit -- UnitIsPlayer = " .. Report(UnitIsPlayer(unit)) .. ", UnitReaction = " ..
                          Report(UnitReaction(unit, "player")))
            if data.unit then
                mUI:Debug("Nameplates: live on data.unit -- UnitIsPlayer = " .. Report(UnitIsPlayer(data.unit)) .. ", UnitReaction = " ..
                              Report(UnitReaction(data.unit, "player")))
            end
            mUI:Debug("Nameplates: names.spec option = " .. tostring(Health and Health.db and Health.db.names and Health.db.names.spec))
            mUI:Debug("Nameplates: CanInspect = " .. tostring(CanInspect(unit, false)) .. ", UnitIsVisible = " .. tostring(UnitIsVisible(unit)))
            mUI:Debug("Nameplates: specs[guid] = " .. tostring(cleanGuid and Units.specs[cleanGuid]) .. ", inspectPending = " ..
                          tostring(Units.inspectPending) .. ", queued = " .. tostring(cleanGuid and Units.inspectQueue[cleanGuid] ~= nil))
            mUI:Debug("Nameplates: GetSpecID = " .. tostring(Units:GetSpecID(data)) .. ", GetSpecName = " .. tostring(Units:GetSpecName(data)))
        end
    end

    function Core:OnUnitEvent(_, unit)
        C_Timer.After(0.1, function()
            -- UNIT_FACTION/UNIT_NAME_UPDATE can fire for a target-of-target-style
            -- compound token (e.g. "targettarget"), which GetNamePlateForUnit
            -- rejects outright rather than just returning nil -- pcall-guarded so
            -- that case is skipped instead of throwing every time one fires.
            local ok, namePlate = pcall(C_NamePlate.GetNamePlateForUnit, unit, false)
            if not ok or not namePlate or not Core.plates[namePlate] then
                return
            end

            SuppressBlizzard(namePlate)

            local stableUnit = namePlate.UnitFrame and namePlate.UnitFrame.unit
            if not stableUnit then
                return
            end

            local data = Core:BuildData(namePlate, stableUnit)
            if data.plate then
                Dispatch("Update", data.plate, data)
                Dispatch("Layout", data.plate, data)
            end
        end)
    end
end

function Core:OnEnable()
    Core.db = mUI.db.profile.nameplates

    mUI:RegisterChatCommand("muinp", function()
        Core:Diagnose()
    end)

    Core:RegisterEvent("NAME_PLATE_UNIT_ADDED", "OnNameplateEvent")
    Core:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "OnNameplateEvent")
    Core:RegisterEvent("PLAYER_TARGET_CHANGED", "OnNameplateEvent")
    Core:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnNameplateEvent")
    Core:RegisterEvent("RAID_TARGET_UPDATE", "OnNameplateEvent")
    Core:RegisterEvent("GROUP_ROSTER_UPDATE", "OnNameplateEvent")
    Core:RegisterEvent("PLAYER_ENTERING_WORLD", "OnNameplateEvent")
    Core:RegisterEvent("UNIT_FACTION", "OnUnitEvent")
    Core:RegisterEvent("UNIT_NAME_UPDATE", "OnUnitEvent")

    -- Adopt whatever is already on screen when the module is toggled on.
    for _, namePlate in pairs(C_NamePlate.GetNamePlates(false)) do
        if namePlate.UnitFrame and namePlate.UnitFrame.unit then
            Core:OnUnitAdded(namePlate.UnitFrame.unit)
        end
    end
end

function Core:OnDisable()
    Core:UnregisterAllEvents()

    for namePlate, data in pairs(Core.plates) do
        if data.plate then
            for i = 1, #Core.order do
                local handler = Core.widgets[Core.order[i]]
                if handler and handler.Remove then
                    handler.Remove(data.plate, data)
                end
            end
            data.plate:Hide()
        end

        Core.RestoreBlizzard(namePlate)
    end

    wipe(Core.plates)
end
