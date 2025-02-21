local MapMinimap = mUI:NewModule("mUI.Config.Layouts.MapMinimap")

-- Enable Layout
MapMinimap:Enable()

function MapMinimap:OnInitialize()
    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.map.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.map.enabled = val end,
                get = function() return mUI.db.profile.map.enabled end,
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
                set = function(_, val) mUI.db.profile.map.coordinates = val end,
                get = function() return mUI.db.profile.map.coordinates end,
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
                set = function(_, val) mUI.db.profile.map.minimap = val end,
                get = function() return mUI.db.profile.map.minimap end,
                order = 5
            },
            clock = {
                name = "Show Clock",
                desc = "Show/Hide Clock on Minimap",
                type = "toggle",
                set = function(_, val) mUI.db.profile.map.clock = val end,
                get = function() return mUI.db.profile.map.clock end,
                order = 6
            },
            date = {
                name = "Show Date",
                desc = "Show/Hide Calendar Icon on Minimap",
                type = "toggle",
                set = function(_, val) mUI.db.profile.map.date = val end,
                get = function() return mUI.db.profile.map.date end,
                order = 7
            },
            tracking = {
                name = "Show Tracking",
                desc = "Show/Hide Tracking Icon on Minimap",
                type = "toggle",
                set = function(_, val) mUI.db.profile.map.tracking = val end,
                get = function() return mUI.db.profile.map.tracking end,
                order = 8
            },
            buttons = {
                name = "Buttons Mouseover",
                desc = "Show Minimap Buttons on Mouseover",
                type = "toggle",
                set = function(_, val) mUI.db.profile.map.buttons = val end,
                get = function() return mUI.db.profile.map.buttons end,
                order = 9
            }
        }
    }
end

function MapMinimap:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
