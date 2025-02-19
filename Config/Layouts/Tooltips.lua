local Tooltips = mUI:NewModule("mUI.Config.Layouts.Tooltips")

function Tooltips:OnEnable()
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
                name = "Tooltips",
                type = "header",
                order = 2
            },
            style = {
                name = "Style",
                desc = "Select a Style for the Tooltips",
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
            header2 = {
                name = "Options",
                type = "header",
                order = 4
            },
            combat = {
                name = "Hide in Combat",
                desc = "Hide Tooltips while in Combat",
                type = "toggle",
                set = function(_, val) db.combat = val end,
                get = function() return db.combat end,
                order = 5
            },
            lifeontop = {
                name = "Life on Top",
                desc = "Show the Healthbar on Top of the Tooltip",
                type = "toggle",
                set = function(_, val) db.lifeontop = val end,
                get = function() return db.lifeontop end,
                order = 6
            },
            mouseanchor = {
                name = "Mouse Anchor",
                desc = "Attach the Tooltip to the Mouse Cursor",
                type = "toggle",
                set = function(_, val) db.mouseanchor = val end,
                get = function() return db.mouseanchor end,
                order = 7
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
