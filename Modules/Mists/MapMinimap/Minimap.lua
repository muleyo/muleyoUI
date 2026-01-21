local Minimap = mUI:NewModule("mUI.MapMinimap.Minimap")

function Minimap:OnInitialize()
    MinimapBorderTop:Hide()
    C_Timer.After(0, function()
        MiniMapWorldMapButton.Show = function()
        end
        MiniMapWorldMapButton:Hide()
    end)
end

function Minimap:OnEnable()
    MinimapCluster:Hide()
end

function Minimap:OnDisable()
    MinimapCluster:Show()
end
