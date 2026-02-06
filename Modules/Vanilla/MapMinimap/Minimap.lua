local Minimap = mUI:NewModule("mUI.MapMinimap.Minimap")

function Minimap:OnInitialize()
    MinimapBorderTop:Hide()
end

function Minimap:OnEnable()
    MinimapCluster:Hide()
end

function Minimap:OnDisable()
    MinimapCluster:Show()
end
