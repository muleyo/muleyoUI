local Buffcollapse = mUI:NewModule("mUI.Modules.Misc.Buffcollapse", "AceHook-3.0")

function Buffcollapse:OnEnable()
    BuffFrame.CollapseAndExpandButton:SetAlpha(0)
    BuffFrame.CollapseAndExpandButton:EnableMouse(false)
    Buffcollapse:SecureHookScript(BuffFrame.CollapseAndExpandButton, "OnShow", function(self)
        self:SetAlpha(0)
        self:EnableMouse(false)
    end)
end

function Buffcollapse:OnDisable()
    Buffcollapse:UnhookAll()
    BuffFrame.CollapseAndExpandButton:SetAlpha(1)
    BuffFrame.CollapseAndExpandButton:EnableMouse(true)
end
