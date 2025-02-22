local Cornericon = mUI:NewModule("mUI.Modules.Unitframes.Cornericon")

function Cornericon:OnEnable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(0)
end

function Cornericon:OnDisable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(1)
end
