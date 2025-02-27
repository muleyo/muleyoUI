local Buffcollapse = mUI:NewModule("mUI.Modules.Misc.Buffcollapse", "AceHook-3.0")

function Buffcollapse:OnInitialize()
    Buffcollapse.func = BuffFrame.CollapseAndExpandButton.Show
end

function Buffcollapse:OnEnable()
    BuffFrame.CollapseAndExpandButton:Hide()
    Buffcollapse:HookScript(BuffFrame.CollapseAndExpandButton, "OnShow", BuffFrame.CollapseAndExpandButton.Hide)
end

function Buffcollapse:OnDisable()
    Buffcollapse:UnhookAll()
    BuffFrame.CollapseAndExpandButton:Show()
end
