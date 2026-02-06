local Menubutton = mUI:NewModule("mUI.Modules.Misc.Menubutton", "AceHook-3.0")

function Menubutton:OnInitialize()
    Menubutton.button = CreateFrame("Button", "mUI_MenuButton", GameMenuFrame, "UIPanelButtonTemplate")
    Menubutton.button:SetHeight(20)
    Menubutton.button:SetWidth(145)
    Menubutton.button:SetText("|cff009cffmuleyo|r|cffffd100UI|r")
    Menubutton.button:SetPoint("CENTER", GameMenuButtonContinue, "CENTER", 0, -52)

    -- Hide button by default
    Menubutton.button:Hide()
end

function Menubutton:OnEnable()
    Menubutton.button:Show()
    Menubutton:SecureHookScript(Menubutton.button, "OnClick", mUI:GUI(true))
end

function Menubutton:OnDisable()
    Menubutton:Unhook(Menubutton.button, "OnClick")
    Menubutton.button:Hide()
end
