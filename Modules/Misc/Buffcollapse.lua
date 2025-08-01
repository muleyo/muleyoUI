local Buffcollapse = mUI:NewModule("mUI.Modules.Misc.Buffcollapse", "AceHook-3.0")

function Buffcollapse:OnInitialize()
    if not mUI:IsClassic() then
        Buffcollapse.func = BuffFrame.CollapseAndExpandButton.Show
    end
end

function Buffcollapse:OnEnable()
    if not mUI:IsClassic() then
        BuffFrame.CollapseAndExpandButton:Hide()
        Buffcollapse:SecureHookScript(BuffFrame.CollapseAndExpandButton, "OnShow", BuffFrame.CollapseAndExpandButton
        .Hide)
    end
end

function Buffcollapse:OnDisable()
    if not mUI:IsClassic() then
        Buffcollapse:UnhookAll()
        BuffFrame.CollapseAndExpandButton:Show()
    end
end
