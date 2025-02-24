local Core = mUI:NewModule("mUI.Core")

-- Enable Module
Core:Enable()

function Core:OnEnable()
    -- Load Database
    self.db = mUI.db.profile

    -- Libraries
    local Config = LibStub("AceConfig-3.0")

    -- Get Modules
    self.modules = {}
    self.modules.general = mUI:GetModule("mUI.Modules.General")
    self.modules.actionbars = mUI:GetModule("mUI.Modules.Actionbars")
    self.modules.unitframes = mUI:GetModule("mUI.Modules.Unitframes")
    self.modules.castbars = mUI:GetModule("mUI.Modules.Castbars")
    self.modules.nameplates = mUI:GetModule("mUI.Modules.Nameplates")
    self.modules.tooltips = mUI:GetModule("mUI.Modules.Tooltips")
    self.modules.mapminimap = mUI:GetModule("mUI.MapMinimap.Modules")
    self.modules.chat = mUI:GetModule("mUI.Modules.Chat")

    -- Get Layouts
    self.layouts = {}
    self.layouts.general = mUI:GetModule("mUI.Config.Layouts.General")
    self.layouts.actionbars = mUI:GetModule("mUI.Config.Layouts.Actionbars")
    self.layouts.unitframes = mUI:GetModule("mUI.Config.Layouts.Unitframes")
    self.layouts.castbars = mUI:GetModule("mUI.Config.Layouts.Castbars")
    self.layouts.nameplates = mUI:GetModule("mUI.Config.Layouts.Nameplates")
    self.layouts.npccolors = mUI:GetModule("mUI.Config.Layouts.NPCColors")
    self.layouts.tooltips = mUI:GetModule("mUI.Config.Layouts.Tooltips")
    self.layouts.mapminimap = mUI:GetModule("mUI.Config.Layouts.MapMinimap")
    self.layouts.chat = mUI:GetModule("mUI.Config.Layouts.Chat")
    self.layouts.misc = mUI:GetModule("mUI.Config.Layouts.Misc")
    self.layouts.profiles = mUI:GetModule("mUI.Config.Layouts.Profiles")
    self.layouts.about = mUI:GetModule("mUI.Config.Layouts.About")

    -- Enable Modules
    if self.db.general.enabled then
        self.modules.general:Enable()
    end

    if self.db.actionbars.enabled then
        self.modules.actionbars:Enable()
    end

    if self.db.unitframes.enabled then
        self.modules.unitframes:Enable()
    end

    if self.db.castbars.enabled then
        self.modules.castbars:Enable()
    end

    if self.db.nameplates.enabled then
        self.modules.nameplates:Enable()
    end

    if self.db.tooltips.enabled then
        self.modules.tooltips:Enable()
    end

    if self.db.map.enabled then
        self.modules.mapminimap:Enable()
    end

    if self.db.chat.enabled then
        self.modules.chat:Enable()
    end

    -- Register Options
    Config:RegisterOptionsTable("mUIOptions_General_Tab", self.layouts.general:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Actionbars_Tab", self.layouts.actionbars:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Unitframes_Tab", self.layouts.unitframes:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Castbars_Tab", self.layouts.castbars:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Nameplates_Tab", self.layouts.nameplates:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_NPCColors_Tab", self.layouts.npccolors:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Tooltips_Tab", self.layouts.tooltips:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_MapMinimap_Tab", self.layouts.mapminimap:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Chat_Tab", self.layouts.chat:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Misc_Tab", self.layouts.misc:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_Profiles_Tab", self.layouts.profiles:GetOptions())
    Config:RegisterOptionsTable("mUIOptions_About_Tab", self.layouts.about:GetOptions())
end
