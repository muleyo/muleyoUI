local Modules = mUI:NewModule("mUI.Modules.Nameplates")

function Modules:OnInitialize()
    -- Modules
    self.Textures = mUI:GetModule("mUI.Modules.Nameplates.Textures")
    self.Names = mUI:GetModule("mUI.Modules.Nameplates.Names")
    self.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")
    self.Options = mUI:GetModule("mUI.Modules.Nameplates.Options")
    self.Casttime = mUI:GetModule("mUI.Modules.Nameplates.Casttime")
    self.Debuffs = mUI:GetModule("mUI.Modules.Nameplates.Debuffs")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.nameplates

    -- Enable Modules
    if self.db.texture ~= "None" then
        self.Textures:Enable()
    end
    if self.db.classcolor or self.db.servername then
        self.Names:Enable()
    end
    if self.db.healthtext or self.db.colors then
        self.Health:Enable()
    end
    if self.db.casttime then
        self.Casttime:Enable()
    end
    if self.db.debuffs then
        self.Debuffs:Enable()
    end
    self.Options:Enable()
end

function Modules:OnDisable()
    -- Disable Modules
    self.Textures:Disable()
    self.Names:Disable()
    self.Health:Disable()
    self.Casttime:Disable()
    self.Options:Disable()
    self.Debuffs:Disable()
end
