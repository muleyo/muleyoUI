local Debuffs = mUI:NewModule("mUI.Modules.Nameplates.Debuffs")

function Debuffs:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    -- Create Frame
    self.debuffs = CreateFrame("Frame")

    function self:HideDebuffs(nameplate)
        if not nameplate then return end

        if not self.db.debuffs then
            nameplate.BuffFrame.UpdateBuffs = self.updatebuffs
            nameplate.BuffFrame.Show = self.show
            nameplate.BuffFrame:Show()
            nameplate.BuffFrame:SetAlpha(1)
        else
            if not (self.updatebuffs and self.show) then
                self.updatebuffs = nameplate.BuffFrame.UpdateBuffs
                self.show = nameplate.BuffFrame.Show
            end
            nameplate.BuffFrame.UpdateBuffs = function() end
            nameplate.BuffFrame.Show = function() end
            nameplate.BuffFrame:Hide()
            nameplate.BuffFrame:SetAlpha(0)
        end
    end

    function self:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            self:HideDebuffs(nameplate.UnitFrame)
        end
    end
end

function Debuffs:OnEnable()
    self.debuffs:RegisterEvent("NAME_PLATE_CREATED")
    self.debuffs:RegisterEvent("NAME_PLATE_UNIT_ADDED")

    mUI:HookScript(self.debuffs, "OnEvent", function()
        self:RefreshNameplates()
    end)
end

function Debuffs:OnDisable()
end
