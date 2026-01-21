local Name = mUI:NewModule("mUI.Modules.Unitframes.Name")

function Name:OnEnable()
    PlayerName:SetAlpha(0)
    TargetFrameTextureFrameName:SetAlpha(0)
    FocusFrameTextureFrameName:SetAlpha(0)
end

function Name:OnDisable()
    PlayerName:SetAlpha(1)
    TargetFrameTextureFrameName:SetAlpha(1)
    FocusFrameTextureFrameName:SetAlpha(1)
end
