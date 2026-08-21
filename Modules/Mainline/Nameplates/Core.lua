local Core = mUI:NewModule("mUI.Modules.Nameplates.Core", "AceEvent-3.0", "AceHook-3.0")

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

    -- Tables
    Core.widgets = {}
    Core.order = {}
    Core.plates = {}
    Core.special = {}

    -- Function assignments
    Core.Clean = Clean

    -- Functions
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

    Core.built = setmetatable({}, {
        __mode = "k"
    })

    local function IsUsablePlate(namePlate)
        if not namePlate or namePlate:IsForbidden() then
            return false
        end

        local frame = namePlate.UnitFrame
        if not frame or frame:IsForbidden() or not frame.unit then
            return false
        end

        if UnitNameplateShowsWidgetsOnly(frame.unit) then
            return false
        end

        if UnitIsGameObject(frame.unit) then
            return false
        end

        return true
    end

    local function ForEachHiddenRegion(frame, func)
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

    local function HideRegion(region)
        if region then
            region:SetAlpha(0)
        end
    end

    local function ShowRegion(region)
        if region then
            region:SetAlpha(1)
        end
    end

    local function SuppressBlizzard(namePlate)
        local frame = namePlate.UnitFrame
        if not frame then
            return
        end

        ForEachHiddenRegion(frame, HideRegion)
    end

    function Core:RestoreBlizzard(namePlate)
        local frame = namePlate.UnitFrame
        if not frame then
            return
        end

        ForEachHiddenRegion(frame, ShowRegion)

        frame:SetAlpha(1)
        frame:Show()
    end

    function Core:GetHealthBar(plate)
        local namePlate = plate:GetParent()
        local frame = namePlate and namePlate.UnitFrame
        local container = frame and frame.HealthBarsContainer
        return container and container.healthBar, container, frame
    end

    function Core:ApplyHitTest(namePlate, plate, data)
        if not namePlate.CanChangeHitTestPoints or not namePlate:CanChangeHitTestPoints() then
            return
        end

        if Core.db.clickthrough and data and data.isFriend then
            namePlate:ClearAllHitTestPoints()
            return
        end

        if not plate then
            return
        end

        local health, _, frame = Core:GetHealthBar(plate)
        if not health then
            return
        end

        local padding = Core.db.hitbox or 0
        local name = frame and frame.name
        local topFrame, bottomFrame = health, health
        if name and name:IsShown() then
            if Core.db.name and Core.db.name.anchor == "BELOW" then
                bottomFrame = name
            else
                topFrame = name
            end
        end

        namePlate:SetHitTestPoints({{
            point = "TOPLEFT",
            relativeTo = topFrame,
            relativePoint = "TOPLEFT",
            offsetX = -padding,
            offsetY = padding
        }, {
            point = "BOTTOMRIGHT",
            relativeTo = bottomFrame,
            relativePoint = "BOTTOMRIGHT",
            offsetX = padding,
            offsetY = -padding
        }})
    end

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
            a = a or 1
            if self.appliedR == r and self.appliedG == g and self.appliedB == b and self.appliedA == a then
                return
            end

            self.appliedR, self.appliedG, self.appliedB, self.appliedA = r, g, b, a

            for i = 1, 4 do
                edges[i]:SetColorTexture(r, g, b, a)
            end
        end

        function border:Invalidate()
            self.appliedThickness = nil
        end

        function border:SetThickness(size)
            local px = math.max(1, size or 1)
            if self.appliedThickness == px then
                return
            end

            self.appliedThickness = px

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
            return namePlate.mUIPlate, Core:GetData(namePlate)
        end
    end

    local plateData = setmetatable({}, {
        __mode = "k"
    })

    function Core:InvalidateData(namePlate)
        if namePlate then
            local data = plateData[namePlate]
            if data then
                data.stamp = nil
            end
            return
        end

        for _, data in pairs(plateData) do
            data.stamp = nil
        end
    end

    function Core:GetUnitData(unit, namePlate)
        if not unit then
            return nil
        end

        namePlate = namePlate or C_NamePlate.GetNamePlateForUnit(unit, false)

        local data = namePlate and plateData[namePlate]
        if data and data.stamp == GetTime() and data.unit == unit then
            return data
        end

        if not data then
            data = {}
            if namePlate then
                plateData[namePlate] = data
            end
        end

        local reaction = UnitReaction(unit, "player")
        local isPlayer = UnitIsPlayer(unit)
        local displayName = UnitName(unit)

        data.stamp = GetTime()
        data.unit = unit
        data.namePlate = namePlate
        data.plate = namePlate and namePlate.mUIPlate
        data.guid = Clean(UnitGUID(unit))
        data.displayName = displayName
        data.name = Clean(displayName)
        data.isFriend = reaction ~= nil and reaction >= 5
        data.isNeutral = reaction ~= nil and reaction == 4
        data.isEnemy = reaction ~= nil and reaction < 4
        data.isPlayer = isPlayer
        data.canAttack = UnitCanAttack("player", unit)
        data.isTapDenied = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)
        data.isTarget = Core:Safe(UnitIsUnit(unit, "target"), false)
        data.isFocus = Core:Safe(UnitIsUnit(unit, "focus"), false)
        data.classFile = isPlayer and Clean(select(2, UnitClass(unit))) or nil

        return data
    end

    function Core:GetData(namePlate)
        local unit = namePlate and Core.plates[namePlate]
        if not unit then
            return nil
        end

        return Core:GetUnitData(unit, namePlate)
    end

    function Core:Register(name, handler)
        if Core.widgets[name] then
            return
        end

        Core.widgets[name] = handler
        Core.order[#Core.order + 1] = name

        Core:ForEach(function(plate, data)
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

    local function RefreshPlate(namePlate)
        Core:InvalidateData(namePlate)

        local data = Core:GetData(namePlate)
        if data and data.plate then
            Dispatch("Update", data.plate, data)
            Dispatch("Layout", data.plate, data)
        end
    end

    local function RefreshSpecial(key, unit)
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        local current
        if namePlate and not namePlate:IsForbidden() and Core.plates[namePlate] then
            current = namePlate
        end

        local previous = Core.special[key]
        if previous == current then
            return
        end

        Core.special[key] = current

        if previous then
            RefreshPlate(previous)
        end
        if current then
            RefreshPlate(current)
        end
    end

    local function AdoptSpecial(namePlate, data)
        if data.isTarget then
            Core.special.isTarget = namePlate
        elseif Core.special.isTarget == namePlate then
            Core.special.isTarget = nil
        end

        if data.isFocus then
            Core.special.isFocus = namePlate
        elseif Core.special.isFocus == namePlate then
            Core.special.isFocus = nil
        end
    end

    function Core:OnTargetChanged()
        RefreshSpecial("isTarget", "target")
    end

    function Core:OnFocusChanged()
        RefreshSpecial("isFocus", "focus")
    end

    function Core:ForEach(func)
        for namePlate, unit in pairs(Core.plates) do
            local data = Core:GetUnitData(unit, namePlate)
            if data and data.plate then
                func(data.plate, data)
            end
        end
    end

    function Core:UpdateAll()
        Core:InvalidateData()

        for namePlate, unit in pairs(Core.plates) do
            local data = Core:GetUnitData(unit, namePlate)
            if data and data.plate then
                SuppressBlizzard(namePlate)
                AdoptSpecial(namePlate, data)
                Dispatch("Update", data.plate, data)
                Dispatch("Layout", data.plate, data)
            end
        end
    end

    function Core:UpdateWidget(name)
        local handler = Core.widgets[name]
        if not handler then
            return
        end

        for namePlate, unit in pairs(Core.plates) do
            local data = Core:GetUnitData(unit, namePlate)
            if data and data.plate then
                if handler.Update then
                    pcall(handler.Update, data.plate, data)
                end
                if handler.Layout then
                    pcall(handler.Layout, data.plate, data)
                end
            end
        end
    end

    function Core:RefreshHitTest()
        for namePlate, unit in pairs(Core.plates) do
            local data = Core:GetUnitData(unit, namePlate)
            if data then
                Core:ApplyHitTest(namePlate, data.plate, data)
            end
        end
    end

    function Core:LayoutAll()
        Core:ForEach(function(plate, data)
            Dispatch("Layout", plate, data)
        end)
    end

    function Core:OnUnitAdded(unit)
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        if not IsUsablePlate(namePlate) then
            return
        end

        if Core:Safe(UnitIsUnit(unit, "player"), false) then
            return
        end

        local stale = Core.plates[namePlate]
        if stale and stale ~= unit then
            Core:OnUnitRemoved(stale)
        end

        local plate = Core:AcquirePlate(namePlate)
        SuppressBlizzard(namePlate)

        Core.plates[namePlate] = unit
        Core:InvalidateData(namePlate)
        local data = Core:GetUnitData(unit, namePlate)
        AdoptSpecial(namePlate, data)

        for i = 1, #Core.order do
            Core:Build(Core.order[i], plate)
        end

        plate:Show()

        Dispatch("Update", plate, data)
        Dispatch("Layout", plate, data)

        Core:ApplyHitTest(namePlate, plate, data)
    end

    function Core:OnUnitRemoved(unit)
        for namePlate, tracked in pairs(Core.plates) do
            if tracked == unit then
                Core:InvalidateData(namePlate)
                local data = Core:GetUnitData(unit, namePlate)
                if data and data.plate then
                    Dispatch("Remove", data.plate, data)
                    data.plate:Hide()
                end

                if Core.special.isTarget == namePlate then
                    Core.special.isTarget = nil
                end
                if Core.special.isFocus == namePlate then
                    Core.special.isFocus = nil
                end

                Core.plates[namePlate] = nil
            end
        end
    end

    function Core:RefreshInstanceType()
        local _, instanceType = IsInInstance()
        Core.inArena = instanceType == "arena"
    end

    function Core:OnNameplateEvent(event, unit)
        if event == "NAME_PLATE_UNIT_ADDED" then
            Core:OnUnitAdded(unit)
        elseif event == "NAME_PLATE_UNIT_REMOVED" then
            Core:OnUnitRemoved(unit)
        elseif event == "RAID_TARGET_UPDATE" then
            Core:UpdateWidget("RaidMarker")
        else
            if event == "PLAYER_ENTERING_WORLD" then
                Core:RefreshInstanceType()
            end
            Core:UpdateAll()
        end
    end

    function Core:OnUnitEvent(_, unit)
        C_Timer.After(0.1, function()
            local ok, namePlate = pcall(C_NamePlate.GetNamePlateForUnit, unit, false)
            if not ok or not namePlate or not Core.plates[namePlate] then
                return
            end

            SuppressBlizzard(namePlate)

            local stableUnit = namePlate.UnitFrame and namePlate.UnitFrame.unit
            if not stableUnit then
                return
            end

            Core.plates[namePlate] = stableUnit
            Core:InvalidateData(namePlate)

            local data = Core:GetUnitData(stableUnit, namePlate)
            if data and data.plate then
                Dispatch("Update", data.plate, data)
                Dispatch("Layout", data.plate, data)
            end
        end)
    end

    if not Core:IsHooked(NamePlateUnitFrameMixin, "OnUnitFactionChanged") then
        Core:SecureHook(NamePlateUnitFrameMixin, "OnUnitFactionChanged", function(unitFrame)
            if unitFrame:IsForbidden() or not unitFrame.unit then
                return
            end

            local namePlate = unitFrame:GetParent()
            if not namePlate or not Core.plates[namePlate] then
                return
            end

            Core.plates[namePlate] = unitFrame.unit
            Core:InvalidateData(namePlate)

            local data = Core:GetUnitData(unitFrame.unit, namePlate)
            if not data or not data.plate then
                return
            end

            Dispatch("Update", data.plate, data)
            Dispatch("Layout", data.plate, data)
        end)
    end

    if not Core:IsHooked(NamePlateUnitFrameMixin, "UpdateWidgetsOnlyMode") then
        Core:SecureHook(NamePlateUnitFrameMixin, "UpdateWidgetsOnlyMode", function(unitFrame)
            if unitFrame:IsForbidden() or not unitFrame.unit then
                return
            end

            local namePlate = unitFrame:GetParent()
            if not namePlate then
                return
            end

            local shouldSkip = unitFrame.widgetsOnlyMode or UnitIsGameObject(unitFrame.unit)

            if shouldSkip then
                if Core.plates[namePlate] then
                    Core:OnUnitRemoved(unitFrame.unit)
                    Core:RestoreBlizzard(namePlate)
                end
            elseif not Core.plates[namePlate] then
                Core:OnUnitAdded(unitFrame.unit)
            end
        end)
    end
end

function Core:OnEnable()
    Core.db = mUI.db.profile.nameplates

    Core:RegisterEvent("NAME_PLATE_UNIT_ADDED", "OnNameplateEvent")
    Core:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "OnNameplateEvent")
    Core:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
    Core:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnFocusChanged")
    Core:RegisterEvent("RAID_TARGET_UPDATE", "OnNameplateEvent")
    Core:RegisterEvent("GROUP_ROSTER_UPDATE", "OnNameplateEvent")
    Core:RegisterEvent("PLAYER_ENTERING_WORLD", "OnNameplateEvent")
    Core:RegisterEvent("UNIT_FACTION", "OnUnitEvent")
    Core:RegisterEvent("UNIT_NAME_UPDATE", "OnUnitEvent")

    Core:RefreshInstanceType()

    -- Adopt whatever is already on screen when the module is toggled on.
    for _, namePlate in pairs(C_NamePlate.GetNamePlates(false)) do
        if namePlate.UnitFrame and namePlate.UnitFrame.unit then
            Core:OnUnitAdded(namePlate.UnitFrame.unit)
        end
    end
end

function Core:OnDisable()
    Core:UnregisterAllEvents()

    for namePlate in pairs(Core.plates) do
        local data = Core:GetData(namePlate)
        if data and data.plate then
            for i = 1, #Core.order do
                local handler = Core.widgets[Core.order[i]]
                if handler and handler.Remove then
                    handler.Remove(data.plate, data)
                end
            end
            data.plate:Hide()
        end

        Core:RestoreBlizzard(namePlate)
    end

    wipe(Core.plates)
    wipe(Core.special)
end
