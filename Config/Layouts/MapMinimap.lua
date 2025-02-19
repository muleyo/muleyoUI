local MapMinimap = mUI:NewModule("mUI.Config.Layouts.MapMinimap")

function MapMinimap:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.map

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
                name = "Map",
                type = "header",
                order = 2
            },
            coordinates = {
                name = "Coordinates",
                desc = "Display Coordinates on the Worldmap",
                type = "toggle",
                set = function(_, val) db.coordinates = val end,
                get = function() return db.coordinates end,
                order = 3
            },
            header2 = {
                name = "Minimap",
                type = "header",
                order = 4
            },
            minimap = {
                name = "Show Minimap",
                desc = "Show/Hide Minimap",
                type = "toggle",
                set = function(_, val) db.minimap = val end,
                get = function() return db.minimap end,
                order = 5
            },
            clock = {
                name = "Show Clock",
                desc = "Show/Hide Clock on Minimap",
                type = "toggle",
                set = function(_, val) db.clock = val end,
                get = function() return db.clock end,
                order = 6
            },
            date = {
                name = "Show Date",
                desc = "Show/Hide Calendar Icon on Minimap",
                type = "toggle",
                set = function(_, val) db.date = val end,
                get = function() return db.date end,
                order = 7
            },
            tracking = {
                name = "Show Tracking",
                desc = "Show/Hide Tracking Icon on Minimap",
                type = "toggle",
                set = function(_, val) db.tracking = val end,
                get = function() return db.tracking end,
                order = 8
            },
            buttons = {
                name = "Buttons Mouseover",
                desc = "Show Minimap Buttons on Mouseover",
                type = "toggle",
                set = function(_, val) db.buttons = val end,
                get = function() return db.buttons end,
                order = 9
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
