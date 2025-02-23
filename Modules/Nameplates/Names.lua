local Names = mUI:NewModule("mUI.Modules.Nameplates.Names")

function Names:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    function self:SetNames(nameplate)
        if not nameplate or nameplate:IsForbidden() then return end
        if nameplate.unit:find('nameplate%d') then
            if ShouldShowName(nameplate) and nameplate.optionTable.colorNameBySelection then
                -- Classcolor Player Names
                if self.db.classcolor then
                    if UnitIsPlayer(nameplate.unit) then
                        local _, class = UnitClass(nameplate.unit)
                        local color = RAID_CLASS_COLORS[class]
                        if not self.color then self.color = nameplate.name:GetVertexColor() end
                        nameplate.name:SetVertexColor(color.r, color.g, color.b)
                    end
                end

                -- Hide Servername
                if self.db.servername then
                    if UnitIsPlayer(nameplate.unit) then
                        local name = UnitName(nameplate.unit)
                        nameplate.name:SetText(name)
                    end
                end

                if self.db.arena and IsActiveBattlefieldArena() then
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

    function self:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Name for Nameplate
            self:SetNames(nameplate.UnitFrame)
        end
    end
end

function Names:OnEnable()
    mUI:SecureHook("CompactUnitFrame_UpdateName", function(nameplate)
        self:SetNames(nameplate)
    end)
end

function Names:OnDisable()
    mUI:Unhook("CompactUnitFrame_UpdateName")
end
