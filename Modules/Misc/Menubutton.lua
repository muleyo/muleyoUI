local Menubutton = mUI:NewModule("mUI.Modules.Misc.Menubutton", "AceHook-3.0")

function Menubutton:OnInitialize()
    if mUI:IsClassic() then
        Menubutton.button = CreateFrame("Button", "mUI_MenuButton", GameMenuFrame, "UIPanelButtonTemplate")
        Menubutton.button:SetHeight(20)
        Menubutton.button:SetWidth(145)
        Menubutton.button:SetText("|cff009cffmuleyo|r|cffffd100UI|r")
        Menubutton.button:SetPoint("CENTER", GameMenuButtonContinue, "CENTER", 0, -52)

        -- Hide button by default
        Menubutton.button:Hide()
    else
        function Menubutton:Add()
            GameMenuFrame:AddSection()
            GameMenuFrame:AddButton("|cff009cffmuleyo|r|cffffd100UI|r", mUI:GUI(true))
        end
    end
end

function Menubutton:OnEnable()
    if mUI:IsClassic() then
        Menubutton.button:Show()
        Menubutton:SecureHookScript(Menubutton.button, "OnClick", mUI:GUI(true))
    else
        Menubutton:SecureHook(GameMenuFrame, "InitButtons", Menubutton.Add)
    end
end

function Menubutton:OnDisable()
    if mUI:IsClassic() then
        Menubutton:Unhook(Menubutton.button, "OnClick")
        Menubutton.button:Hide()
    else
        Menubutton:UnhookAll()
    end
end
