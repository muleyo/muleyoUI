local Unitframes = mUI:NewModule("mUI.Config.Layouts.Unitframes")

function Unitframes:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.unitframes

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
                name = "Textures",
                type = "header",
                order = 2
            },
            textures_unitframes = {
                name = "Unitframes",
                desc = "Select a Texture for the Unitframes (Player, Target, Focus, etc.)",
                type = "select",
                values = {
                    ["Default"] = "Default",
                    ["Dark"] = "Dark",
                    ["Class"] = "Class",
                    ["Custom"] = "Custom"
                },
                sorting = {
                    "Default",
                    "Dark",
                    "Class",
                    "Custom"
                },
                set = function(_, val) db.textures.unitframes = val end,
                get = function() return db.textures.unitframes end,
                order = 3
            },
            textures_raidframes = {
                name = "Party / Raidframes",
                desc = "Select a Texture for the Party / Raidframes",
                type = "select",
                values = {
                    ["Default"] = "Default",
                    ["Dark"] = "Dark",
                    ["Class"] = "Class",
                    ["Custom"] = "Custom"
                },
                sorting = {
                    "Default",
                    "Dark",
                    "Class",
                    "Custom"
                },
                set = function(_, val) db.textures.raidframes = val end,
                get = function() return db.textures.raidframes end,
                order = 4
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 5
            },
            classcolor = {
                name = "Class Colors",
                desc = "Show Healthbars in Class Colors",
                type = "toggle",
                set = function(_, val) db.classcolor = val end,
                get = function() return db.classcolor end,
                order = 6
            },
            pvpbadge = {
                name = "PvP Badge",
                desc = "Show PvP Badge on Unitframes",
                type = "toggle",
                set = function(_, val) db.pvpbadge = val end,
                get = function() return db.pvpbadge end,
                order = 7
            },
            hitindicator = {
                name = "Hit Indicator",
                desc = "Show Hit Indicator on Player Portrait",
                type = "toggle",
                set = function(_, val) db.hitindicator = val end,
                get = function() return db.hitindicator end,
                order = 8
            },
            combatindicator = {
                name = "Combat Indicator",
                desc = "Show a Combat Icon on Unitframes when Unit in combat",
                type = "toggle",
                set = function(_, val) db.combatindicator = val end,
                get = function() return db.combatindicator end,
                order = 9
            },
            totemicons = {
                name = "Totem Icons",
                desc = "Show Totem Icons (Consecration etc.) below the Player Unitframe",
                type = "toggle",
                set = function(_, val) db.totemicons = val end,
                get = function() return db.totemicons end,
                order = 10
            },
            classbar = {
                name = "Classbar",
                desc = "Show Class Bar (Combo Points, Holy Power, etc.)",
                type = "toggle",
                set = function(_, val) db.classbar = val end,
                get = function() return db.classbar end,
                order = 11
            },
            cornericon = {
                name = "Corner Icon",
                desc = "Display the Corner Icon on the Player Unitframe",
                type = "toggle",
                set = function(_, val) db.cornericon = val end,
                get = function() return db.cornericon end,
                order = 12
            },
            header3 = {
                name = "Buffs & Debuffs",
                type = "header",
                order = 13
            },
            buffsize = {
                name = "Buff Size",
                desc = "Set the Size of Buffs on Unitframes",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                set = function(_, val) db.buffsize = val end,
                get = function() return db.buffsize end,
                order = 14
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                set = function(_, val) db.debuffsize = val end,
                get = function() return db.buffsize end,
                order = 15
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
