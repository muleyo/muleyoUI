local Level = mUI:NewModule("mUI.Modules.Unitframes.Level")

function Level:OnInitialize()
    self.player = PlayerLevelText.Show
    self.target = TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show
    self.focus = FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show
end

function Level:OnEnable()
    PlayerLevelText:Hide()
    PlayerLevelText.Show = function() end

    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show = function() end

    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:Hide()
    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show = function() end
end

function Level:OnDisable()
    PlayerLevelText.Show = self.player
    PlayerLevelText:Show()

    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show = self.target
    TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:Show()

    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText.Show = self.focus
    FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:Show()
end
