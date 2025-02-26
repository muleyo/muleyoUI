local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnEnable()
    PlayerCastingBarFrame.Icon:Show()
    PlayerCastingBarFrame.Icon:SetSize(20, 20)

    if PlayerCastingBarFrame.mUIBorder then
        PlayerCastingBarFrame.mUIBorder:Show()
    end
end

function Icon:OnDisable()
    PlayerCastingBarFrame.Icon:Hide()
    PlayerCastingBarFrame.Icon:SetSize(16, 16)

    PlayerCastingBarFrame.mUIBorder:Hide()
end
