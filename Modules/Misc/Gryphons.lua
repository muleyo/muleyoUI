local Gryphons = mUI:NewModule("mUI.Modules.Misc.Gryphons")

function Gryphons:OnEnable()
    if not mUI:IsClassic() then return end
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

function Gryphons:OnDisable()
    if not mUI:IsClassic() then return end
    MainMenuBarLeftEndCap:Show()
    MainMenuBarRightEndCap:Show()
end
