local Modules = mUI:NewModule("mUI.Modules.Misc")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Losecontrol = mUI:GetModule("mUI.Modules.Misc.Losecontrol")
    Modules.Menubutton = mUI:GetModule("mUI.Modules.Misc.Menubutton")
    Modules.Safequeue = mUI:GetModule("mUI.Modules.Misc.Safequeue")
    Modules.Statusbar = mUI:GetModule("mUI.Modules.Misc.Statusbar")
    Modules.Tabbinder = mUI:GetModule("mUI.Modules.Misc.Tabbinder")
    Modules.Fastloot = mUI:GetModule("mUI.Modules.Misc.Fastloot")
    Modules.PlayerLinks = mUI:GetModule("mUI.Modules.Misc.PlayerLinks")
    Modules.QuestAnnounce = mUI:GetModule("mUI.Modules.Misc.QuestAnnounce")
    Modules.WowheadLinks = mUI:GetModule("mUI.Modules.Misc.WowheadLinks")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.misc

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
    if Modules.db.tabbinder then
        Modules.Tabbinder:Enable()
    end
    if Modules.db.fastloot then
        Modules.Fastloot:Enable()
    end
    if Modules.db.playerlinks then
        Modules.PlayerLinks:Enable()
    end
    if Modules.db.questannounce then
        Modules.QuestAnnounce:Enable()
    end
    if Modules.db.wowheadlinks then
        Modules.WowheadLinks:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Losecontrol:Disable()
    Modules.Menubutton:Disable()
    Modules.Safequeue:Disable()
    Modules.Statusbar:Disable()
    Modules.Tabbinder:Disable()
    Modules.Fastloot:Disable()
    Modules.PlayerLinks:Disable()
    Modules.QuestAnnounce:Disable()
    Modules.WowheadLinks:Disable()
end
