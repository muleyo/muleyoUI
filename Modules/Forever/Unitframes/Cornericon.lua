local Cornericon = mUI:NewModule("mUI.Modules.Unitframes.Cornericon")

function Cornericon:OnEnable()
    C_Timer.After(0, function()
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(0)
    end)
end

function Cornericon:OnDisable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(1)
end
