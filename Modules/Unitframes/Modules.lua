local Modules = mUI:NewModule("mUI.Modules.Unitframes")

function Modules:OnInitialize()
    -- Modules
    self.BuffsDebuffs = mUI:GetModule("mUI.Modules.Unitframes.BuffsDebuffs")
    self.Classbar = mUI:GetModule("mUI.Modules.Unitframes.Classbar")
    self.Classcolor = mUI:GetModule("mUI.Modules.Unitframes.Classcolor")
    self.Combatindicator = mUI:GetModule("mUI.Modules.Unitframes.Combatindicator")
    self.Cornericon = mUI:GetModule("mUI.Modules.Unitframes.Cornericon")
    self.Hitindicator = mUI:GetModule("mUI.Modules.Unitframes.Hitindicator")
    self.Pvpbadge = mUI:GetModule("mUI.Modules.Unitframes.Pvpbadge")
    self.Textures = mUI:GetModule("mUI.Modules.Unitframes.Textures")
    self.Totemicons = mUI:GetModule("mUI.Modules.Unitframes.Totemicons")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.unitframes

    -- Enable Modules
    if self.db.buffsdebuffs.enabled then
        self.BuffsDebuffs:Enable()
    end
    if self.db.classbar then
        self.Classbar:Enable()
    end
    if self.db.classcolor then
        self.Classcolor:Enable()
    end
    if self.db.combatindicator then
        self.Combatindicator:Enable()
    end
    if self.db.cornericon then
        self.Cornericon:Enable()
    end
    if self.db.hitindicator then
        self.Hitindicator:Enable()
    end
    if self.db.pvpbadge then
        self.Pvpbadge:Enable()
    end
    if self.db.textures then
        self.Textures:Enable()
    end
    if self.db.totemicons then
        self.Totemicons:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    self.BuffsDebuffs:Disable()
    self.Classbar:Disable()
    self.Combatindicator:Disable()
    self.Cornericon:Disable()
    self.Hitindicator:Disable()
    self.Pvpbadge:Disable()
    self.Textures:Disable()
    self.Totemicons:Disable()
end
