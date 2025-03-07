local Core = mUI:NewModule("mUI.Core")

-- Enable Module
Core:Enable()

function Core:OnInitialize()
    -- Load Database
    Core.db = mUI.db.profile

    -- Libraries
    local Config = LibStub("AceConfig-3.0")

    -- Get Modules
    Core.modules = {}
    Core.modules.general = mUI:GetModule("mUI.Modules.General")
    Core.modules.actionbars = mUI:GetModule("mUI.Modules.Actionbars")
    Core.modules.unitframes = mUI:GetModule("mUI.Modules.Unitframes")
    Core.modules.castbars = mUI:GetModule("mUI.Modules.Castbars")
    Core.modules.nameplates = mUI:GetModule("mUI.Modules.Nameplates")
    Core.modules.tooltips = mUI:GetModule("mUI.Modules.Tooltips")
    Core.modules.mapminimap = mUI:GetModule("mUI.MapMinimap.Modules")
    Core.modules.chat = mUI:GetModule("mUI.Modules.Chat")
    Core.modules.misc = mUI:GetModule("mUI.Modules.Misc")
    Core.modules.profiles = mUI:GetModule("mUI.Modules.Profiles")

    -- Get Layouts
    Core.layouts = {}
    Core.layouts.general = mUI:GetModule("mUI.Config.Layouts.General")
    Core.layouts.actionbars = mUI:GetModule("mUI.Config.Layouts.Actionbars")
    Core.layouts.unitframes = mUI:GetModule("mUI.Config.Layouts.Unitframes")
    Core.layouts.castbars = mUI:GetModule("mUI.Config.Layouts.Castbars")
    Core.layouts.nameplates = mUI:GetModule("mUI.Config.Layouts.Nameplates")
    Core.layouts.npccolors = mUI:GetModule("mUI.Config.Layouts.NPCColors")
    Core.layouts.tooltips = mUI:GetModule("mUI.Config.Layouts.Tooltips")
    Core.layouts.mapminimap = mUI:GetModule("mUI.Config.Layouts.MapMinimap")
    Core.layouts.chat = mUI:GetModule("mUI.Config.Layouts.Chat")
    Core.layouts.misc = mUI:GetModule("mUI.Config.Layouts.Misc")
    Core.layouts.profiles = mUI:GetModule("mUI.Config.Layouts.Profiles")
    Core.layouts.profilesImport = mUI:GetModule("mUI.Config.Layouts.ProfilesImport")
    Core.layouts.profilesExport = mUI:GetModule("mUI.Config.Layouts.ProfilesExport")
    Core.layouts.about = mUI:GetModule("mUI.Config.Layouts.About")

    -- Enable Modules
    if Core.db.general.enabled then
        Core.modules.general:Enable()
    end

    if Core.db.actionbars.enabled then
        Core.modules.actionbars:Enable()
    end

    if Core.db.unitframes.enabled then
        Core.modules.unitframes:Enable()
    end

    if Core.db.castbars.enabled then
        Core.modules.castbars:Enable()
    end

    if Core.db.nameplates.enabled then
        Core.modules.nameplates:Enable()
    end

    if Core.db.tooltips.enabled then
        Core.modules.tooltips:Enable()
    end

    if Core.db.map.enabled then
        Core.modules.mapminimap:Enable()
    end

    if Core.db.chat.enabled then
        Core.modules.chat:Enable()
    end

    if Core.db.misc.enabled then
        Core.modules.misc:Enable()
    end

    -- Register Options
    Config:RegisterOptionsTable("mUIOptions_General_Tab", Core.layouts.general:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Actionbars_Tab", Core.layouts.actionbars:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Unitframes_Tab", Core.layouts.unitframes:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Castbars_Tab", Core.layouts.castbars:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Nameplates_Tab", Core.layouts.nameplates:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_NPCColors_Tab", Core.layouts.npccolors:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Tooltips_Tab", Core.layouts.tooltips:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_MapMinimap_Tab", Core.layouts.mapminimap:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Chat_Tab", Core.layouts.chat:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Misc_Tab", Core.layouts.misc:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Profiles_Tab", Core.layouts.profiles:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_ProfilesExport_Tab", Core.layouts.profilesExport:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_ProfilesImport_Tab", Core.layouts.profilesImport:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_About_Tab", Core.layouts.about:GetOptions())
end

function Core:OnEnable()
    if C_AddOns.IsAddOnLoaded("Plater") or C_AddOns.IsAddOnLoaded("TidyPlates_ThreatPlates") or C_AddOns.IsAddOnLoaded("TidyPlates") or C_AddOns.IsAddOnLoaded("Kui_Nameplates") then
        Core.db.nameplates.enabled = false
        Core.modules.nameplates:Disable()
        mUI:Debug("Nameplates Module disabled because another Nameplates AddOn is active.")
    end

    if C_AddOns.IsAddOnLoaded("LS_Glass") then
        Core.db.chat.enabled = false
        Core.modules.chat:Disable()
        mUI:Debug("Chat Module disabled because another Chat AddOn is active.")
    end

    if C_AddOns.IsAddOnLoaded("BetterBlizzFrames") then
        mUI:Debug("BetterBlizzFrames AddOn detected. You might want to disable it, if you encounter any issues.")
    end
end
