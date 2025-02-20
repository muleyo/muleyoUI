local Modules = mUI:NewModule("mUI.Modules.Actionbars")

function Modules:OnInitialize()
    -- Modules
    self.Flash = mUI:GetModule("mUI.Modules.Actionbars.Flash")
    self.Hotkey = mUI:GetModule("mUI.Modules.Actionbars.Hotkey")
    self.Macro = mUI:GetModule("mUI.Modules.Actionbars.Macro")
    self.Mouseover = mUI:GetModule("mUI.Modules.Actionbars.Mouseover")
    self.Range = mUI:GetModule("mUI.Modules.Actionbars.Range")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.actionbars

    -- Enable Modules
    if self.db.flash then
        self.Flash:Enable()
    end
    if self.db.hotkey then
        self.Hotkey:Enable()
    end
    if self.db.macro then
        self.Macro:Enable()
    end
    if self.db.mouseover.bar1
        or self.db.mouseover.bar2
        or self.db.mouseover.bar3
        or self.db.mouseover.bar4
        or self.db.mouseover.bar5
        or self.db.mouseover.bar6
        or self.db.mouseover.bar7
        or self.db.mouseover.bar8
        or self.db.mouseover.petbar
        or self.db.mouseover.stancebar
        or self.db.mouseover.micromenu ~= "Default"
        or self.db.mouseover.bagbar ~= "Default"
    then
        self.Mouseover:Enable()
    end
    if self.db.range then
        self.Range:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    self.Flash:Disable()
    self.Hotkey:Disable()
    self.Macro:Disable()
    self.Mouseover:Disable()
    self.Range:Disable()
end
