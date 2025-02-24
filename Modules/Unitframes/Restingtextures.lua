local Restingtextures = mUI:NewModule("mUI.Modules.Unitframes.Restingtextures", "AceHook-3.0")

function Restingtextures:OnEnable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(0)

    Restingtextures:SecureHook("PlayerFrame_UpdatePlayerRestLoop", function()
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
    end)
end

function Restingtextures:OnDisable()
    Restingtextures:Unhook("PlayerFrame_UpdatePlayerRestLoop")
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(1)
end
