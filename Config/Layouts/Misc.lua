local Misc = mUI:NewModule("mUI.Config.Layouts.Misc")

function Misc:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.misc

    local layout = {
        type = "group",
        args = {
            enable = {
                name = "Enable",
                desc = "Enable / Disable Module",
                type = "toggle",
                set = function(_, val) db.enabled = val end,
                get = function() return db.enabled end,
                order = 1
            },
            header1 = {
                name = "Miscellaneous",
                type = "header",
                order = 2
            },
            interrupt = {
                name = "Interrupt Announce",
                desc = "Announce successful Interrupts in Party/Raid/Instance Chat",
                type = "toggle",
                set = function(_, val) db.interrupt = val end,
                get = function() return db.interrupt end,
                order = 3
            },
            menubutton = {
                name = "Menu Button",
                desc = "Show mUI Button on the ESC-Menu to open the Menu",
                type = "toggle",
                set = function(_, val) db.menubutton = val end,
                get = function() return db.menubutton end,
                order = 4
            },
            header2 = {
                name = "Hide Frames",
                type = "header",
                order = 5
            },
            statusbar = {
                name = "XP/Rep/Honor Bar",
                desc = "Hide the XP/Rep/Honor Bar",
                type = "toggle",
                set = function(_, val) db.statusbar = val end,
                get = function() return db.statusbar end,
                order = 6
            },
            dragonflying = {
                name = "Dragonflying Wings",
                desc = "Hide the Dragonflying Bar Wings",
                type = "toggle",
                set = function(_, val) db.dragonflying = val end,
                get = function() return db.dragonflying end,
                order = 7
            },
            header3 = {
                name = "PvP Options",
                type = "header",
                order = 8
            },
            tabbinder = {
                name = "Tab Binder",
                desc = "Bind Tab to target only enemy players in PVP Combat",
                type = "toggle",
                set = function(_, val) db.tabbinder = val end,
                get = function() return db.tabbinder end,
                order = 9
            },
            dampening = {
                name = "Dampening",
                desc = "Display Dampening below Arena Timer",
                type = "toggle",
                set = function(_, val) db.dampening = val end,
                get = function() return db.dampening end,
                order = 10
            },
            surrender = {
                name = "Surrender",
                desc = "Surrender an Arena Match by typing '/gg' in the Chat",
                type = "toggle",
                set = function(_, val) db.surrender = val end,
                get = function() return db.surrender end,
                order = 11
            },
            safequeue = {
                name = "Safe Queue",
                desc = "Displays a Timer and remove the Leave-Button on Queuepop Window",
                type = "toggle",
                set = function(_, val) db.safequeue = val end,
                get = function() return db.safequeue end,
                order = 12
            },
            losecontrol = {
                name = "LoseControl",
                desc = "Make the built-in Loss of Control Frame more transparent",
                type = "toggle",
                set = function(_, val) db.losecontrol = val end,
                get = function() return db.losecontrol end,
                order = 13
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
