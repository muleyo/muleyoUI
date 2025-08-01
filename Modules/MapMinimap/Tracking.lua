local Tracking = mUI:NewModule("mUI.MapMinimap.Tracking")

function Tracking:OnEnable()
    if mUI:IsClassic() then
        MiniMapTracking:Hide()
    else
        MinimapCluster.Tracking.Button:SetAlpha(0)
        MinimapCluster.Tracking.Background:SetAlpha(0)
    end
end

function Tracking:OnDisable()
    if mUI:IsClassic() then
        MiniMapTracking:Show()
    else
        MinimapCluster.Tracking.Background:SetAlpha(1)
        MinimapCluster.Tracking.Button:SetAlpha(1)
    end
end
