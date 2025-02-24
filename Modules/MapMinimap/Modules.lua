local Modules = mUI:NewModule("mUI.MapMinimap.Modules")

function Modules:OnInitialize()
    -- Get Modules
    self.Clock = mUI:GetModule("mUI.MapMinimap.Clock")
    self.Tracking = mUI:GetModule("mUI.MapMinimap.Tracking")
    self.Mouseover = mUI:GetModule("mUI.MapMinimap.Mouseover")
    self.Calendar = mUI:GetModule("mUI.MapMinimap.Calendar")
    self.Coords = mUI:GetModule("mUI.MapMinimap.Coords")
    self.Minimap = mUI:GetModule("mUI.MapMinimap.Minimap")
end

function Modules:OnEnable()
    -- Load Database
    self.db = mUI.db.profile.map

    if self.db.clock then
        self.Clock:Enable()
    end
    if self.db.tracking then
        self.Tracking:Enable()
    end
    if self.db.buttons then
        self.Mouseover:Enable()
    end
    if self.db.date then
        self.Calendar:Enable()
    end
    if self.db.coordinates then
        self.Coords:Enable()
    end
    if self.db.minimap then
        self.Minimap:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    self.Clock:Disable()
    self.Tracking:Disable()
    self.Mouseover:Disable()
    self.Calendar:Disable()
    self.Coords:Disable()
    self.Minimap:Disable()
end
