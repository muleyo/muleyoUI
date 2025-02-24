local Names = mUI:NewModule("mUI.Modules.Nameplates.Names", "AceHook-3.0")

function Names:OnInitialize()
    -- Load Database
    Names.db = mUI.db.profile.nameplates

    function Names:SetNames(nameplate)
        if not nameplate or nameplate:IsForbidden() then return end
        if nameplate.unit:find('nameplate%d') then
            if ShouldShowName(nameplate) and nameplate.optionTable.colorNameBySelection then
                -- Classcolor Player Names
                if Names.db.classcolor then
                    if UnitIsPlayer(nameplate.unit) then
                        local _, class = UnitClass(nameplate.unit)
                        local color = RAID_CLASS_COLORS[class]
                        if not Names.color then Names.color = nameplate.name:GetVertexColor() end
                        nameplate.name:SetVertexColor(color.r, color.g, color.b)
                    end
                end

                -- Hide Servername
                if Names.db.servername then
                    if UnitIsPlayer(nameplate.unit) then
                        local name = UnitName(nameplate.unit)
                        nameplate.name:SetText(name)
                    end
                end

                if Names.db.arena and IsActiveBattlefieldArena() then
                    for i = 1, 3 do
                        if UnitIsUnit(nameplate.unit, "arena" .. i) then
                            nameplate.name:SetText("arena" .. i)
                            break
                        end
                    end
                end
            end
        end
    end

    function Names:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Name for Nameplate
            Names:SetNames(nameplate.UnitFrame)
        end
    end
end

function Names:OnEnable()
    Names:SecureHook("CompactUnitFrame_UpdateName", function(nameplate)
        Names:SetNames(nameplate)
    end)
end

function Names:OnDisable()
    Names:UnhookAll()
end
