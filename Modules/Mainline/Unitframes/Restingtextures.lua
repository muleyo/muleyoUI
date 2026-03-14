local Restingtextures = mUI:NewModule("mUI.Modules.Unitframes.Restingtextures", "AceHook-3.0")

function Restingtextures:OnEnable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(0)
    local statusTexture = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture

    C_Timer.After(0, function()
        statusTexture:Hide()
    end)

    Restingtextures:SecureHookScript(statusTexture, "OnShow", function(self)
        statusTexture:Hide()
    end)
end

function Restingtextures:OnDisable()
    Restingtextures:UnhookAll()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(1)
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Show()
end
