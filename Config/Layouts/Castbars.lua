local Castbars = mUI:NewModule("mUI.Config.Layouts.Castbars")

function Castbars:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.castbars

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
                name = "Castbars",
                type = "header",
                order = 2
            },
            style = {
                name = "Style",
                desc = "Select a Style for the Castbars",
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
            icons = {
                name = "Icons",
                desc = "Show / Hide Spell Icons next to Castbars",
                type = "toggle",
                set = function(_, val) db.icons = val end,
                get = function() return db.icons end,
                order = 4
            },
            casttime = {
                name = "Cast Time",
                desc = "Show / Hide Cast Time next to Castbars",
                type = "toggle",
                set = function(_, val) db.casttime = val end,
                get = function() return db.casttime end,
                order = 5
            },
            header2 = {
                name = "Target / Focus Castbar Size",
                type = "header",
                order = 6
            },
            targetscale = {
                name = "Target Castbar Size",
                desc = "Set the Size of the Target Castbar",
                type = "range",
                min = 50,
                max = 200,
                step = 10,
                set = function(_, val) db.targetscale = val end,
                get = function() return db.targetscale end,
                order = 7
            },
            focusscale = {
                name = "Focus Castbar Size",
                desc = "Set the Size of the Focus Castbar",
                type = "range",
                min = 50,
                max = 200,
                step = 10,
                set = function(_, val) db.focusscale = val end,
                get = function() return db.focusscale end,
                order = 8
            },
            header3 = {
                name = "Target / Focus Castbar Position",
                type = "header",
                order = 9
            },
            targetpos = {
                name = "Target Castbar on top",
                desc = "Display the Target Castbar above the Targetframe",
                type = "toggle",
                set = function(_, val) db.targetpos = val end,
                get = function() return db.targetpos end,
                order = 10
            },
            focuspos = {
                name = "Focus Castbar on top",
                desc = "Display the Focus Castbar above the Focusframe",
                type = "toggle",
                set = function(_, val) db.focuspos = val end,
                get = function() return db.focuspos end,
                order = 11
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
