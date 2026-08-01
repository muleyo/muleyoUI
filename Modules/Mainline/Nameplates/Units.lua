local Units = mUI:NewModule("mUI.Modules.Nameplates.Units", "AceEvent-3.0")

function Units:OnInitialize()
    Units.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")

    -- [guid] = specID, for units we have managed to identify
    Units.specs = {}

    -- [specID] = { name, icon, role }
    Units.specInfo = {}

    -- [mUIPlate] = arena index, resolved once per plate rather than per update
    Units.arenaIndex = setmetatable({}, {
        __mode = "k"
    })

    local Core = Units.Core

    function Units:GetSpecInfo(specID)
        if not specID or specID == 0 then
            return nil
        end

        local info = Units.specInfo[specID]
        if not info then
            local _, name, _, icon, role, classFile = GetSpecializationInfoByID(specID)
            if not name then
                return nil
            end

            info = {
                name = name,
                icon = icon,
                role = role,
                classFile = classFile
            }
            Units.specInfo[specID] = info
        end

        return info
    end

    function Units:ResolveArenaIndex(data)
        if not Core.inArena or not data.isPlayer or not data.isEnemy then
            return nil
        end

        for i = 1, 3 do
            if UnitName(data.unit) == UnitName("arena" .. i) then
                return i
            end
        end

        return nil
    end

    function Units:GetArenaIndex(data)
        local plate = data.plate

        if plate then
            local cached = Units.arenaIndex[plate]
            if cached then
                return cached
            end
        end

        local index = Units:ResolveArenaIndex(data)
        if index and plate then
            Units.arenaIndex[plate] = index
        end

        return index
    end

    function Units:ClearArenaIndex(plate)
        if plate then
            Units.arenaIndex[plate] = nil
        else
            wipe(Units.arenaIndex)
        end
    end

    function Units:GetSpecID(data)
        local index = Units:GetArenaIndex(data)
        if index then
            local specID = Core:Safe(GetArenaOpponentSpec(index), 0)
            if specID and specID > 0 then
                return specID
            end
        end

        if data.guid and Units.specs[data.guid] then
            return Units.specs[data.guid]
        end

        return nil
    end

    function Units:GetRole(data)
        local info = Units:GetSpecInfo(Units:GetSpecID(data))
        if info then
            return info.role
        end

        if data.isPlayer and IsInGroup() then
            local role = Core:Safe(UnitGroupRolesAssigned(data.unit), "NONE")
            if role ~= "NONE" then
                return role
            end
        end

        return nil
    end

    function Units:IsHealer(data)
        return Units:GetRole(data) == "HEALER"
    end

    function Units:GetClassFile(data)
        if data.classFile then
            return data.classFile
        end

        local info = Units:GetSpecInfo(Units:GetSpecID(data))
        if info then
            return info.classFile
        end

        return nil
    end

    Units.handler = {}

    function Units.handler.Remove(plate)
        Units:ClearArenaIndex(plate)
    end

    function Units:OnInspectReady(_, guid)
        guid = Core.Clean(guid)
        if not guid then
            return
        end

        local unit
        for i = 1, 40 do
            local candidate = "nameplate" .. i
            if UnitExists(candidate) and Core.Clean(UnitGUID(candidate)) == guid then
                unit = candidate
                break
            end
        end

        if unit then
            local specID = Core:Safe(C_SpecializationInfo.GetInspectSpecialization(unit), 0)
            if specID > 0 then
                Units.specs[guid] = specID
                if Core:IsEnabled() then
                    Core:UpdateAll()
                end
            end
        end
    end

    function Units:OnArenaUpdate()
        Units:ClearArenaIndex()
        if Core:IsEnabled() then
            Core:UpdateAll()
        end
    end

    function Units:OnZoneChanged()
        wipe(Units.specs)
        Units:ClearArenaIndex()
    end
end

function Units:OnEnable()
    Units:RegisterEvent("ARENA_OPPONENT_UPDATE", "OnArenaUpdate")
    Units:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", "OnArenaUpdate")
    Units:RegisterEvent("PLAYER_ENTERING_WORLD", "OnZoneChanged")
    Units:RegisterEvent("INSPECT_READY", "OnInspectReady")

    -- Registered before any feature module, so the arena slot is resolved by the
    -- time the icons and name replacements ask for it.
    Units.Core:Register("Units", Units.handler)
end

function Units:OnDisable()
    Units:UnregisterAllEvents()
    Units.Core:Unregister("Units")

    wipe(Units.specs)
    Units:ClearArenaIndex()
end
