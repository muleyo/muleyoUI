local Name = mUI:NewModule("mUI.Modules.Unitframes.Name")

function Name:OnInitialize()
    self.player = PlayerName.Show
    self.target = TargetFrame.TargetFrameContent.TargetFrameContentMain.Name.Show
    self.focus = FocusFrame.TargetFrameContent.TargetFrameContentMain.Name.Show
end

function Name:OnEnable()
    PlayerName:Hide()
    PlayerName.Show = function() end

    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:Hide()
    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name.Show = function() end

    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:Hide()
    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name.Show = function() end
end

function Name:OnDisable()
    PlayerName.Show = self.player
    PlayerName:Show()

    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name.Show = self.target
    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:Show()

    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name.Show = self.focus
    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:Show()
end
