local Cornericon = mUI:NewModule("mUI.Modules.Unitframes.Cornericon")

function Cornericon:OnInitialize()
    self.cornericon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon.Show
end

function Cornericon:OnEnable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Hide()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon.Show = function() end
end

function Cornericon:OnDisable()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon.Show = self.cornericon
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Show()
end
