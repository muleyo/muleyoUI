local Name = mUI:NewModule("mUI.Modules.Unitframes.Name")

function Name:OnEnable()
    if mUI:IsClassic() then
        PlayerName:SetAlpha(0)
        TargetFrameTextureFrameName:SetAlpha(0)
        FocusFrameTextureFrameName:SetAlpha(0)
    else
        PlayerName:SetAlpha(0)
        TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(0)
        FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(0)
    end
end

function Name:OnDisable()
    if mUI:IsClassic() then
        PlayerName:SetAlpha(1)
        TargetFrameTextureFrameName:SetAlpha(1)
        FocusFrameTextureFrameName:SetAlpha(1)
    else
        PlayerName:SetAlpha(1)
        TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(1)
        FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetAlpha(1)
    end
end
