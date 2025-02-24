local Debuffs = mUI:NewModule("mUI.Modules.Nameplates.Debuffs", "AceHook-3.0")

function Debuffs:OnInitialize()
    -- Load Database
    Debuffs.db = mUI.db.profile.nameplates

    -- Create Frame
    Debuffs.debuffs = CreateFrame("Frame")

    function Debuffs:HideDebuffs(nameplate)
        if not nameplate then return end

        if not Debuffs.db.debuffs then
            nameplate.BuffFrame.UpdateBuffs = Debuffs.updatebuffs
            nameplate.BuffFrame.Show = Debuffs.show
            nameplate.BuffFrame:Show()
            nameplate.BuffFrame:SetAlpha(1)
        else
            if not (Debuffs.updatebuffs and Debuffs.show) then
                Debuffs.updatebuffs = nameplate.BuffFrame.UpdateBuffs
                Debuffs.show = nameplate.BuffFrame.Show
            end
            nameplate.BuffFrame.UpdateBuffs = function() end
            nameplate.BuffFrame.Show = function() end
            nameplate.BuffFrame:Hide()
            nameplate.BuffFrame:SetAlpha(0)
        end
    end

    function Debuffs:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            Debuffs:HideDebuffs(nameplate.UnitFrame)
        end
    end
end

function Debuffs:OnEnable()
    Debuffs.debuffs:RegisterEvent("NAME_PLATE_CREATED")
    Debuffs.debuffs:RegisterEvent("NAME_PLATE_UNIT_ADDED")

    Debuffs:HookScript(Debuffs.debuffs, "OnEvent", function()
        Debuffs:RefreshNameplates()
    end)
end

function Debuffs:OnDisable()
    Debuffs:RefreshNameplates()
    Debuffs:UnhookAll()
end
