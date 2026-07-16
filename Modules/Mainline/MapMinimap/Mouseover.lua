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
    Mouseover:SecureHookScript(Mouseover.frame, "OnEvent", Mouseover.RegisterButtons)
end

function Mouseover:OnDisable()
    for i = 1, #Mouseover.buttons do
        Mouseover.LibDBIcon:ShowOnEnter(Mouseover.buttons[i], false)
    end

    Mouseover.frame:UnregisterAllEvents()
    Mouseover:UnhookAll()
end
