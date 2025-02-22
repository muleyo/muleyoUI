local Restingtextures = mUI:NewModule("mUI.Modules.Unitframes.Restingtextures")

function Restingtextures:OnEnable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(0)

    mUI:SecureHook("PlayerFrame_UpdatePlayerRestLoop", function()
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
    end)
end

function Restingtextures:OnDisable()
    mUI:Unhook("PlayerFrame_UpdatePlayerRestLoop")
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(1)
end
