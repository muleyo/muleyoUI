local Icon = mUI:NewModule("mUI.Modules.Castbars.Icon")

function Icon:OnEnable()
    PlayerCastingBarFrame.Icon:Show()
    PlayerCastingBarFrame.Icon:SetSize(20, 20)
end

function Icon:OnDisable()
    PlayerCastingBarFrame.Icon:Hide()
    PlayerCastingBarFrame.Icon:SetSize(16, 16)
end
