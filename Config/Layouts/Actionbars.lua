local Actionbars = mUI:NewModule("mUI.Config.Layouts.Actionbars")

-- Enable Layout
Actionbars:Enable()

function Actionbars:OnInitialize()
    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.Actionbars")
    self.Mouseover = mUI:GetModule("mUI.Modules.Actionbars.Mouseover")

    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enabled = {
                name = function()
                    if mUI.db.profile.actionbars.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "|cffffff00Info|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.enabled = val end,
                get = function() return mUI.db.profile.actionbars.enabled end,
                order = 1
            },
            header1 = {
                name = "Actionbar Buttons",
                type = "header",
                order = 2
            },
            hotkey = {
                name = "Hotkey Text",
                desc = "Show Hotkey Text on Actionbuttons",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.hotkey = val end,
                get = function() return mUI.db.profile.actionbars.hotkey end,
                order = 3
            },
            macro = {
                name = "Macro Text",
                desc = "Show Macro Text on Actionbuttons",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.macro = val end,
                get = function() return mUI.db.profile.actionbars.macro end,
                order = 4
            },
            flash = {
                name = "Flash Animation",
                desc = "Flash Actionbutton on when pressing it",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.flash = val end,
                get = function() return mUI.db.profile.actionbars.flash end,
                order = 5
            },
            range = {
                name = "Range Indicator",
                desc = "Change button-color to red when out of range",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.range = val end,
                get = function() return mUI.db.profile.actionbars.range end,
                order = 6
            },
            header2 = {
                name = "Mouseover",
                type = "header",
                order = 7
            },
            bar1 = {
                name = "ActionBar 1",
                desc = "Show Actionbar 1 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar1 = val
                    if val then
                        self.Mouseover:Update("bar1", true)
                    else
                        self.Mouseover:Update("bar1", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar1 end,
                order = 8
            },
            bar2 = {
                name = "ActionBar 2",
                desc = "Show Actionbar 2 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar2 = val

                    if val then
                        self.Mouseover:Update("bar2", true)
                    else
                        self.Mouseover:Update("bar2", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar2 end,
                order = 9
            },
            bar3 = {
                name = "ActionBar 3",
                desc = "Show Actionbar 3 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar3 = val

                    if val then
                        self.Mouseover:Update("bar3", true)
                    else
                        self.Mouseover:Update("bar3", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar3 end,
                order = 10
            },
            bar4 = {
                name = "ActionBar 4",
                desc = "Show Actionbar 4 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar4 = val

                    if val then
                        self.Mouseover:Update("bar4", true)
                    else
                        self.Mouseover:Update("bar4", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar4 end,
                order = 11
            },
            bar5 = {
                name = "ActionBar 5",
                desc = "Show Actionbar 5 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar5 = val

                    if val then
                        self.Mouseover:Update("bar5", true)
                    else
                        self.Mouseover:Update("bar5", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar5 end,
                order = 12
            },
            bar6 = {
                name = "ActionBar 6",
                desc = "Show Actionbar 6 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar6 = val

                    if val then
                        self.Mouseover:Update("bar6", true)
                    else
                        self.Mouseover:Update("bar6", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar6 end,
                order = 13
            },
            bar7 = {
                name = "ActionBar 7",
                desc = "Show Actionbar 7 on Mouseover",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.mouseover.bar7 = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar7 end,
                order = 14
            },
            bar8 = {
                name = "ActionBar 8",
                desc = "Show Actionbar 8 on Mouseover",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.mouseover.bar8 = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar8 end,
                order = 15
            },
            petbar = {
                name = "Pet Actionbar",
                desc = "Show Pet Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.mouseover.petbar = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.petbar end,
                order = 16
            },
            stancebar = {
                name = "Stance Actionbar",
                desc = "Show Stance Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val) mUI.db.profile.actionbars.mouseover.stancebar = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.stancebar end,
                order = 17
            },
            micromenu = {
                name = "Micro Menu",
                desc = "Choose an option",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["Mouseover"] = "Mouseover",
                    ["Hidden"] = "Hidden"
                },
                sorting = {
                    "Default",
                    "Mouseover",
                    "Hidden"
                },
                --width = 0.5,
                set = function(_, val) mUI.db.profile.actionbars.mouseover.micromenu = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.micromenu end,
                order = 18
            },
            bagbuttons = {
                name = "Bag Buttons",
                desc = "Choose an option",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["Mouseover"] = "Mouseover",
                    ["Hidden"] = "Hidden"
                },
                sorting = {
                    "Default",
                    "Mouseover",
                    "Hidden"
                },
                --width = 0.5,
                set = function(_, val) mUI.db.profile.actionbars.mouseover.bagbuttons = val end,
                get = function() return mUI.db.profile.actionbars.mouseover.bagbuttons end,
                order = 19
            }
        }
    }
end

function Actionbars:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
