local Unitframes = mUI:NewModule("mUI.Config.Layouts.Unitframes")

-- Enable Layout
Unitframes:Enable()

function Unitframes:OnInitialize()
    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.unitframes.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "|cffffff00INFO:|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.enabled = val end,
                get = function() return mUI.db.profile.unitframes.enabled end,
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
                set = function(_, val) mUI.db.profile.unitframes.textures.unitframes = val end,
                get = function() return mUI.db.profile.unitframes.textures.unitframes end,
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
                set = function(_, val) mUI.db.profile.unitframes.textures.raidframes = val end,
                get = function() return mUI.db.profile.unitframes.textures.raidframes end,
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
                set = function(_, val) mUI.db.profile.unitframes.classcolor = val end,
                get = function() return mUI.db.profile.unitframes.classcolor end,
                order = 6
            },
            pvpbadge = {
                name = "PvP Badge",
                desc = "Show PvP Badge on Unitframes",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.pvpbadge = val end,
                get = function() return mUI.db.profile.unitframes.pvpbadge end,
                order = 7
            },
            hitindicator = {
                name = "Hit Indicator",
                desc = "Show Hit Indicator on Player Portrait",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.hitindicator = val end,
                get = function() return mUI.db.profile.unitframes.hitindicator end,
                order = 8
            },
            combatindicator = {
                name = "Combat Indicator",
                desc = "Show a Combat Icon on Unitframes when Unit in combat",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.combatindicator = val end,
                get = function() return mUI.db.profile.unitframes.combatindicator end,
                order = 9
            },
            totemicons = {
                name = "Totem Icons",
                desc = "Show Totem Icons (Consecration etc.) below the Player Unitframe",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.totemicons = val end,
                get = function() return mUI.db.profile.unitframes.totemicons end,
                order = 10
            },
            classbar = {
                name = "Classbar",
                desc = "Show Class Bar (Combo Points, Holy Power, etc.)",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.classbar = val end,
                get = function() return mUI.db.profile.unitframes.classbar end,
                order = 11
            },
            cornericon = {
                name = "Corner Icon",
                desc = "Display the Corner Icon on the Player Unitframe",
                type = "toggle",
                set = function(_, val) mUI.db.profile.unitframes.cornericon = val end,
                get = function() return mUI.db.profile.unitframes.cornericon end,
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
                set = function(_, val) mUI.db.profile.unitframes.buffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsize end,
                order = 14
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                set = function(_, val) mUI.db.profile.unitframes.debuffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsize end,
                order = 15
            }
        }
    }
end

function Unitframes:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
