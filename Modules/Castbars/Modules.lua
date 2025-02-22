local Modules = mUI:NewModule("mUI.Modules.Castbars")

function Modules:OnInitialize()
    -- Modules
    self.Module = mUI:GetModule("mUI.Modules.Castbars")
    self.Style = mUI:GetModule("mUI.Modules.Castbars.Style")
    self.Icon = mUI:GetModule("mUI.Modules.Castbars.Icon")
    self.Casttime = mUI:GetModule("mUI.Modules.Castbars.Casttime")
    self.Targetscale = mUI:GetModule("mUI.Modules.Castbars.Targetscale")
    self.Focusscale = mUI:GetModule("mUI.Modules.Castbars.Focusscale")
    self.Targetpos = mUI:GetModule("mUI.Modules.Castbars.Targetpos")
    self.Focuspos = mUI:GetModule("mUI.Modules.Castbars.Focuspos")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.castbars

    -- Enable Modules
    if self.db.style == "mUI" then
        self.Style:Enable()
    end
    if self.db.icon then
        self.Icon:Enable()
    end
    if self.db.casttime then
        self.Casttime:Enable()
    end
    if self.db.targetscale ~= 100 then
        self.Targetscale:Enable()
    end
    if self.db.focusscale ~= 100 then
        self.Focusscale:Enable()
    end
    if self.db.targetpos then
        self.Targetpos:Enable()
    end
    if self.db.focuspos then
        self.Focuspos:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    self.Style:Disable()
    self.Icon:Disable()
end
