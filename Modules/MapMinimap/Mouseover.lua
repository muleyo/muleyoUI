local Mouseover = mUI:NewModule("mUI.MapMinimap.Mouseover", "AceHook-3.0")

function Mouseover:OnInitialize()
    Mouseover.LibDBIcon = LibStub("LibDBIcon-1.0")
end

function Mouseover:OnEnable()
    Mouseover.buttons = Mouseover.LibDBIcon:GetButtonList()
    for i = 1, #Mouseover.buttons do
        Mouseover.LibDBIcon:ShowOnEnter(Mouseover.buttons[i], true)
    end

    ExpansionLandingPageMinimapButton:SetAlpha(0)
    Mouseover:HookScript(ExpansionLandingPageMinimapButton, "OnEnter", function()
        ExpansionLandingPageMinimapButton:SetAlpha(1)
    end)

    Mouseover:HookScript(ExpansionLandingPageMinimapButton, "OnLeave", function(Mouseover)
        ExpansionLandingPageMinimapButton:SetAlpha(0)
    end)
end

function Mouseover:OnDisable()
    for i = 1, #Mouseover.buttons do
        Mouseover.LibDBIcon:ShowOnEnter(Mouseover.buttons[i], false)
    end

    ExpansionLandingPageMinimapButton:SetAlpha(1)
    Mouseover:UnhookAll()
end
