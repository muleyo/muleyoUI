local Mouseover = mUI:NewModule("mUI.MapMinimap.Mouseover", "AceHook-3.0")

function Mouseover:OnInitialize()
    -- Create Frame
    Mouseover.frame = CreateFrame("Frame")

    -- Load Libraries
    Mouseover.LibDBIcon = LibStub("LibDBIcon-1.0")

    function Mouseover:RegisterButtons()
        Mouseover.buttons = Mouseover.LibDBIcon:GetButtonList()
        for i = 1, #Mouseover.buttons do
            Mouseover.LibDBIcon:ShowOnEnter(Mouseover.buttons[i], true)
        end
    end
end

function Mouseover:OnEnable()
    Mouseover.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    Mouseover:HookScript(Mouseover.frame, "OnEvent", Mouseover.RegisterButtons)

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

    Mouseover.frame:UnregisterAllEvents()

    ExpansionLandingPageMinimapButton:SetAlpha(1)
    Mouseover:UnhookAll()
end
