local Modules = mUI:NewModule("mUI.MapMinimap.Modules")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Clock = mUI:GetModule("mUI.MapMinimap.Clock")
    Modules.Tracking = mUI:GetModule("mUI.MapMinimap.Tracking")
    Modules.Mouseover = mUI:GetModule("mUI.MapMinimap.Mouseover")
    Modules.Calendar = mUI:GetModule("mUI.MapMinimap.Calendar")
    Modules.Coords = mUI:GetModule("mUI.MapMinimap.Coords")
    Modules.Minimap = mUI:GetModule("mUI.MapMinimap.Minimap")
end

function Modules:OnEnable()
    -- Load Database
    Modules.db = mUI.db.profile.map

    if Modules.db.clock then
        Modules.Clock:Enable()
    end
    if Modules.db.tracking then
        Modules.Tracking:Enable()
    end
    if Modules.db.buttons then
        Modules.Mouseover:Enable()
    end
    if Modules.db.date then
        Modules.Calendar:Enable()
    end
    if Modules.db.coordinates then
        Modules.Coords:Enable()
    end
    if Modules.db.minimap then
        Modules.Minimap:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Clock:Disable()
    Modules.Tracking:Disable()
    Modules.Mouseover:Disable()
    Modules.Calendar:Disable()
    Modules.Coords:Disable()
    Modules.Minimap:Disable()
end
