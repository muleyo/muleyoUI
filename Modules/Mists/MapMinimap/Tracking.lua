local Tracking = mUI:NewModule("mUI.MapMinimap.Tracking")

function Tracking:OnEnable()
    MiniMapTracking:Hide()
end

function Tracking:OnDisable()
    MiniMapTracking:Show()
end
