local Actionbars = mUI:NewModule("mUI.Config.Layouts.Actionbars")

function Actionbars:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.actionbars

    local layout = {
        type = "group",
        args = {
            enabled = {
                name = "Enable",
                desc = "Enable / Disable Module",
                type = "toggle",
                set = function(_, val) db.enabled = val end,
                get = function() return db.enabled end,
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
                set = function(_, val) db.hotkey = val end,
                get = function() return db.hotkey end,
                order = 3
            },
            macro = {
                name = "Macro Text",
                desc = "Show Macro Text on Actionbuttons",
                type = "toggle",
                set = function(_, val) db.macro = val end,
                get = function() return db.macro end,
                order = 4
            },
            flash = {
                name = "Flash Animation",
                desc = "Flash Actionbutton on when pressing it",
                type = "toggle",
                set = function(_, val) db.flash = val end,
                get = function() return db.flash end,
                order = 5
            },
            range = {
                name = "Range Indicator",
                desc = "Change button-color to red when out of range",
                type = "toggle",
                set = function(_, val) db.range = val end,
                get = function() return db.range end,
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
                set = function(_, val) db.mouseover.bar1 = val end,
                get = function() return db.mouseover.bar1 end,
                order = 8
            },
            bar2 = {
                name = "ActionBar 2",
                desc = "Show Actionbar 2 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar2 = val end,
                get = function() return db.mouseover.bar2 end,
                order = 9
            },
            bar3 = {
                name = "ActionBar 3",
                desc = "Show Actionbar 3 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar3 = val end,
                get = function() return db.mouseover.bar3 end,
                order = 10
            },
            bar4 = {
                name = "ActionBar 4",
                desc = "Show Actionbar 4 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar4 = val end,
                get = function() return db.mouseover.bar4 end,
                order = 11
            },
            bar5 = {
                name = "ActionBar 5",
                desc = "Show Actionbar 5 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar5 = val end,
                get = function() return db.mouseover.bar5 end,
                order = 12
            },
            bar6 = {
                name = "ActionBar 6",
                desc = "Show Actionbar 6 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar6 = val end,
                get = function() return db.mouseover.bar6 end,
                order = 13
            },
            bar7 = {
                name = "ActionBar 7",
                desc = "Show Actionbar 7 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar7 = val end,
                get = function() return db.mouseover.bar7 end,
                order = 14
            },
            bar8 = {
                name = "ActionBar 8",
                desc = "Show Actionbar 8 on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.bar8 = val end,
                get = function() return db.mouseover.bar8 end,
                order = 15
            },
            petbar = {
                name = "Pet Actionbar",
                desc = "Show Pet Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.petbar = val end,
                get = function() return db.mouseover.petbar end,
                order = 16
            },
            stancebar = {
                name = "Stance Actionbar",
                desc = "Show Stance Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val) db.mouseover.stancebar = val end,
                get = function() return db.mouseover.stancebar end,
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
                set = function(_, val) db.mouseover.micromenu = val end,
                get = function() return db.mouseover.micromenu end,
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
                set = function(_, val) db.mouseover.bagbuttons = val end,
                get = function() return db.mouseover.bagbuttons end,
                order = 19
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
