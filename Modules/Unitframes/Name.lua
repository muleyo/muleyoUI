local Name = mUI:NewModule("mUI.Modules.Unitframes.Name")

function Name:OnEnable()
    PlayerName:SetAlpha(0)
    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(0)
    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(0)
end

function Name:OnDisable()
    PlayerName:SetAlpha(1)
    TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(1)
    FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(1)
end
