local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnInitialize()
    -- Load Database
    Icon.db = mUI.db.profile.general

    C_Timer.After(0, function()
        if PlayerCastingBarFrame.mUIBorder then
            PlayerCastingBarFrame.mUIBorder:Hide()
        end
    end)
end

function Icon:OnEnable()
    PlayerCastingBarFrame.Icon:Show()
    PlayerCastingBarFrame.Icon:SetSize(20, 20)

    if Icon.db.theme ~= "Disabled" then
        C_Timer.After(0.1, function()
            PlayerCastingBarFrame.mUIBorder:Show()
        end)
    end
end

function Icon:OnDisable()
    PlayerCastingBarFrame.Icon:Hide()
    PlayerCastingBarFrame.Icon:SetSize(16, 16)

    PlayerCastingBarFrame.mUIBorder:Hide()
end
