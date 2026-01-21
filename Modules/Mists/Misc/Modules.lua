local Modules = mUI:NewModule("mUI.Modules.Misc")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Dampening = mUI:GetModule("mUI.Modules.Misc.Dampening")
    Modules.Interrupt = mUI:GetModule("mUI.Modules.Misc.Interrupt")
    Modules.Losecontrol = mUI:GetModule("mUI.Modules.Misc.Losecontrol")
    Modules.Menubutton = mUI:GetModule("mUI.Modules.Misc.Menubutton")
    Modules.Safequeue = mUI:GetModule("mUI.Modules.Misc.Safequeue")
    Modules.Surrender = mUI:GetModule("mUI.Modules.Misc.Surrender")
    Modules.Tabbinder = mUI:GetModule("mUI.Modules.Misc.Tabbinder")
    Modules.Achievements = mUI:GetModule("mUI.Modules.Misc.Achievements")
    Modules.Fastloot = mUI:GetModule("mUI.Modules.Misc.Fastloot")
    Modules.Gryphons = mUI:GetModule("mUI.Modules.Misc.Gryphons")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.misc

    if Modules.db.dampening then
        Modules.Dampening:Enable()
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
    if Modules.db.surrender then
        Modules.Surrender:Enable()
    end
    if Modules.db.tabbinder then
        Modules.Tabbinder:Enable()
    end
    if Modules.db.achievements then
        Modules.Achievements:Enable()
    end
    if Modules.db.fastloot then
        Modules.Fastloot:Enable()
    end
    if Modules.db.gryphons then
        Modules.Gryphons:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Dampening:Disable()
    Modules.Interrupt:Disable()
    Modules.Losecontrol:Disable()
    Modules.Menubutton:Disable()
    Modules.Safequeue:Disable()
    Modules.Surrender:Disable()
    Modules.Tabbinder:Disable()
    Modules.Achievements:Disable()
    Modules.Fastloot:Disable()
    Modules.Gryphons:Disable()
end
