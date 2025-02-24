local Mouseover = mUI:NewModule("mUI.MapMinimap.Mouseover")

function Mouseover:OnInitialize()
    self.LibDBIcon = LibStub("LibDBIcon-1.0")
end

function Mouseover:OnEnable()
    self.buttons = self.LibDBIcon:GetButtonList()
    for i = 1, #self.buttons do
        self.LibDBIcon:ShowOnEnter(self.buttons[i], true)
    end

    ExpansionLandingPageMinimapButton:SetAlpha(0)
    mUI:HookScript(ExpansionLandingPageMinimapButton, "OnEnter", function()
        ExpansionLandingPageMinimapButton:SetAlpha(1)
    end)

    mUI:HookScript(ExpansionLandingPageMinimapButton, "OnLeave", function(self)
        ExpansionLandingPageMinimapButton:SetAlpha(0)
    end)
end

function Mouseover:OnDisable()
    for i = 1, #self.buttons do
        self.LibDBIcon:ShowOnEnter(self.buttons[i], false)
    end

    mUI:Unhook(ExpansionLandingPageMinimapButton, "OnEnter")
    mUI:Unhook(ExpansionLandingPageMinimapButton, "OnLeave")
end
