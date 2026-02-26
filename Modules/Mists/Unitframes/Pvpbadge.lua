local Pvpbadge = mUI:NewModule("mUI.Modules.Unitframes.Pvpbadge")

function Pvpbadge:OnEnable()
    PlayerPVPIcon:SetAlpha(0)
    TargetFrameTextureFramePVPIcon:SetAlpha(0)
    FocusFrameTextureFramePVPIcon:SetAlpha(0)
end

function Pvpbadge:OnDisable()
    PlayerPVPIcon:SetAlpha(1)
    TargetFrameTextureFramePVPIcon:SetAlpha(1)
    FocusFrameTextureFramePVPIcon:SetAlpha(1)
end
