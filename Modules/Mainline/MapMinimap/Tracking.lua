local Tracking = mUI:NewModule("mUI.MapMinimap.Tracking")

function Tracking:OnEnable()
    MinimapCluster.Tracking.Button:SetAlpha(0)
    MinimapCluster.Tracking.Background:SetAlpha(0)
end

function Tracking:OnDisable()
    MinimapCluster.Tracking.Background:SetAlpha(1)
    MinimapCluster.Tracking.Button:SetAlpha(1)
end
