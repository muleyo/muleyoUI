local Core = mUI:NewModule("mUI.Core")

-- Enable Module
Core:Enable()

function Core:OnInitialize()
    -- Load Database
    Core.db = mUI.db.profile

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
    if mUI:GameVersion()["Mainline"] then
        Core.layouts.raidframes = mUI:GetModule("mUI.Config.Layouts.Raidframes")
    end
    Core.layouts.castbars = mUI:GetModule("mUI.Config.Layouts.Castbars")
    Core.layouts.nameplates = mUI:GetModule("mUI.Config.Layouts.Nameplates")
    Core.layouts.tooltips = mUI:GetModule("mUI.Config.Layouts.Tooltips")
    Core.layouts.mapminimap = mUI:GetModule("mUI.Config.Layouts.MapMinimap")
    Core.layouts.chat = mUI:GetModule("mUI.Config.Layouts.Chat")
    Core.layouts.misc = mUI:GetModule("mUI.Config.Layouts.Misc")
    Core.layouts.profiles = mUI:GetModule("mUI.Config.Layouts.Profiles")
    Core.layouts.about = mUI:GetModule("mUI.Config.Layouts.About")

    -- Enable Modules
    if Core.db.general.enabled then
        Core.modules.general:Enable()
    end

    if Core.db.actionbars.enabled then
        Core.modules.actionbars:Enable()
    end

    if Core.db.unitframes.enabled or (mUI:GameVersion()["Mainline"] and Core.db.unitframes.raidframes.enabled) then
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

    -- Register Options (keys keep the former AceConfig app names, see Config/GUI/Registry.lua)
    mUI.mGUI:RegisterCategory("mUIOptions_General_Tab", Core.layouts.general:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Actionbars_Tab", Core.layouts.actionbars:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Unitframes_Tab", Core.layouts.unitframes:GetOptions())
    if Core.layouts.raidframes then
        mUI.mGUI:RegisterCategory("mUIOptions_Raidframes_Tab", Core.layouts.raidframes:GetOptions())
    end
    mUI.mGUI:RegisterCategory("mUIOptions_Castbars_Tab", Core.layouts.castbars:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Nameplates_Tab", Core.layouts.nameplates:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Tooltips_Tab", Core.layouts.tooltips:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_MapMinimap_Tab", Core.layouts.mapminimap:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Chat_Tab", Core.layouts.chat:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Misc_Tab", Core.layouts.misc:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_Profiles_Tab", Core.layouts.profiles:GetOptions())
    mUI.mGUI:RegisterCategory("mUIOptions_About_Tab", Core.layouts.about:GetOptions())
end
