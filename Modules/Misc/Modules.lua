local Modules = mUI:NewModule("mUI.Modules.Misc")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Dampening = mUI:GetModule("mUI.Modules.Misc.Dampening")
    Modules.Dragonflying = mUI:GetModule("mUI.Modules.Misc.Dragonflying")
    Modules.Interrupt = mUI:GetModule("mUI.Modules.Misc.Interrupt")
    Modules.Losecontrol = mUI:GetModule("mUI.Modules.Misc.Losecontrol")
    Modules.Menubutton = mUI:GetModule("mUI.Modules.Misc.Menubutton")
    Modules.Safequeue = mUI:GetModule("mUI.Modules.Misc.Safequeue")
    Modules.Statusbar = mUI:GetModule("mUI.Modules.Misc.Statusbar")
    Modules.Surrender = mUI:GetModule("mUI.Modules.Misc.Surrender")
    Modules.Tabbinder = mUI:GetModule("mUI.Modules.Misc.Tabbinder")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.misc

    if Modules.db.dampening then
        Modules.Dampening:Enable()
    end
    if Modules.db.dragonflying then
        Modules.Dragonflying:Enable()
    end
    if Modules.db.interrupt then
        Modules.Interrupt:Enable()
    end
    if Modules.db.losecontrol then
        Modules.Losecontrol:Enable()
    end
    if Modules.db.menubutton then
        Modules.Menubutton:Enable()
    end
    if Modules.db.safequeue then
        Modules.Safequeue:Enable()
    end
    if Modules.db.statusbar then
        Modules.Statusbar:Enable()
    end
    if Modules.db.surrender then
        Modules.Surrender:Enable()
    end
    if Modules.db.tabbinder then
        Modules.Tabbinder:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Dampening:Disable()
    Modules.Dragonflying:Disable()
    Modules.Interrupt:Disable()
    Modules.Losecontrol:Disable()
    Modules.Menubutton:Disable()
    Modules.Safequeue:Disable()
    Modules.Statusbar:Disable()
    Modules.Surrender:Disable()
    Modules.Tabbinder:Disable()
end
