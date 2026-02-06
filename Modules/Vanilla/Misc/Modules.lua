local Modules = mUI:NewModule("mUI.Modules.Misc")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Menubutton = mUI:GetModule("mUI.Modules.Misc.Menubutton")
    Modules.Tabbinder = mUI:GetModule("mUI.Modules.Misc.Tabbinder")
    Modules.Fastloot = mUI:GetModule("mUI.Modules.Misc.Fastloot")
    Modules.Gryphons = mUI:GetModule("mUI.Modules.Misc.Gryphons")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.misc

    if Modules.db.menubutton then
        Modules.Menubutton:Enable()
    end
    if Modules.db.tabbinder then
        Modules.Tabbinder:Enable()
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
    Modules.Menubutton:Disable()
    Modules.Tabbinder:Disable()
    Modules.Fastloot:Disable()
    Modules.Gryphons:Disable()
end
