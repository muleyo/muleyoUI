local Menubutton = mUI:NewModule("mUI.Modules.Misc.Menubutton", "AceHook-3.0")

function Menubutton:OnInitialize()
    function Menubutton:Add()
        GameMenuFrame:AddSection()
        GameMenuFrame:AddButton("|cff009cffmuleyo|r|cffffd100UI|r", mUI:GUI(true))
    end
end

function Menubutton:OnEnable()
    Menubutton:SecureHook(GameMenuFrame, "InitButtons", Menubutton.Add)
end

function Menubutton:OnDisable()
    Menubutton:UnhookAll()
end
