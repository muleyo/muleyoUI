local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

function Nameplates:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.nameplates

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
                name = "Nameplates",
                type = "header",
                order = 2
            },
            style = {
                name = "Style",
                desc = "Select a Style for the Nameplates",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["mUI"] = "mUI Style"
                },
                sorting = {
                    "Default",
                    "mUI"
                },
                width = 0.5,
                set = function(_, val) db.style = val end,
                get = function() return db.style end,
                order = 3
            },
            texture = {
                name = "Texture",
                desc = "Select a Texture for the Nameplates",
                type = "select",
                values = {
                    ["Blizzard"] = "Blizzard",
                    ["mUI"] = "mUI Texture"
                },
                set = function(_, val) db.texture = val end,
                get = function() return db.texture end,
                order = 4
            },
            decimals = {
                name = "Healthtext Decimals",
                desc = "Set the amount of Decimals for the Health Text\n\n0 = 100%\n1 = 100.0%\n2 = 100.00%",
                type = "range",
                min = 0,
                max = 2,
                step = 1,
                set = function(_, val) db.decimals = val end,
                get = function() return db.decimals end,
                order = 5
            },
            height = {
                name = "Height",
                desc = "Set the Height of the Nameplates",
                type = "range",
                min = 1,
                max = 5,
                step = 1,
                set = function(_, val) db.height = val end,
                get = function() return db.height end,
                order = 6
            },
            width = {
                name = "Width",
                desc = "Set the Width of the Nameplates",
                type = "range",
                min = 1,
                max = 5,
                step = 1,
                set = function(_, val) db.width = val end,
                get = function() return db.width end,
                order = 7
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 8
            },
            healthtext = {
                name = "Health Text",
                desc = "Show Health Percentage on Nameplates",
                type = "toggle",
                set = function(_, val) db.healthtext = val end,
                get = function() return db.healthtext end,
                order = 9
            },
            classcolor = {
                name = "Names in Class Color",
                desc = "Show Player Names in Class Colors",
                type = "toggle",
                set = function(_, val) db.classcolor = val end,
                get = function() return db.classcolor end,
                order = 10
            },
            servername = {
                name = "Hide Server Names",
                desc = "Hide Server Names on Nameplates",
                type = "toggle",
                set = function(_, val) db.servername = val end,
                get = function() return db.servername end,
                order = 11
            },
            arena = {
                name = "Arena Numbers",
                desc = "Show arena1/2/3 instead of enemy Player Names in Arenas",
                type = "toggle",
                set = function(_, val) db.arena = val end,
                get = function() return db.arena end,
                order = 12
            },
            totem = {
                name = "Totem Icons",
                desc = "Show Totem Icons on Nameplates",
                type = "toggle",
                set = function(_, val) db.totem = val end,
                get = function() return db.totem end,
                order = 13
            },
            casttime = {
                name = "Cast Time",
                desc = "Show Cast Time below the Cast Icon on Nameplates",
                type = "toggle",
                set = function(_, val) db.casttime = val end,
                get = function() return db.casttime end,
                order = 14
            },
            focus = {
                name = "Focus Highlight",
                desc = "Highlight the Nameplate of your Focus Target with a different texture",
                type = "toggle",
                set = function(_, val) db.focus = val end,
                get = function() return db.focus end,
                order = 15
            },
            debuffs = {
                name = "Hide Debuffs",
                desc = "Hide Debuffs on Nameplates",
                type = "toggle",
                set = function(_, val) db.debuffs = val end,
                get = function() return db.debuffs end,
                order = 16
            },
            header3 = {
                name = "PVE Options",
                type = "header",
                order = 17
            },
            colors = {
                name = "NPC Colors",
                desc =
                "Enable/Disable custom colors.\n\n|cffffff00INFO:|r Colors for NPCs can be edited by clicking on the 'Change NPC Colors' Button",
                type = "toggle",
                set = function(_, val) db.colors = val end,
                get = function() return end,
                order = 18
            },
            npccolors = {
                name = "Change NPC Colors",
                desc = "Change the Colors of NPCs",
                type = "execute",
                func = function() end,
                order = 19
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
