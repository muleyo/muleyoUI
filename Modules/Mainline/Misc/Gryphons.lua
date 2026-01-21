local Gryphons = mUI:NewModule("mUI.Modules.Misc.Gryphons")

function Gryphons:OnEnable()
    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
end

function Gryphons:OnDisable()
    MainMenuBarLeftEndCap:Show()
    MainMenuBarRightEndCap:Show()
end
