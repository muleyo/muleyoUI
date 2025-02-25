local MapMinimap = mUI:NewModule("mUI.Config.Layouts.MapMinimap")

function MapMinimap:OnInitialize()
    -- Get Modules
    MapMinimap.Module = mUI:GetModule("mUI.MapMinimap.Modules")

    -- Initialize Layout
    MapMinimap.layout = {
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
                set = function(_, val)
                    mUI.db.profile.map.enabled = val

                    if val then
                        MapMinimap.Module:Enable()
                        mUI:Reload('Enable Map & Minimap Module')
                    else
                        MapMinimap.Module:Disable()
                        mUI:Reload('Disable Map & Minimap Module')
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.map.coordinates = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Coords:Enable()
                    else
                        MapMinimap.Module.Coords:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.coordinates end,
                order = 3
            },
            header2 = {
                name = "Minimap",
                type = "header",
                order = 4
            },
            minimap = {
                name = "Hide Minimap",
                desc = "Show/Hide Minimap",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.map.minimap = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Minimap:Enable()
                    else
                        MapMinimap.Module.Minimap:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.minimap end,
                order = 5
            },
            clock = {
                name = "Hide Clock",
                desc = "Show/Hide Clock on Minimap",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.map.clock = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Clock:Enable()
                    else
                        MapMinimap.Module.Clock:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.clock end,
                order = 6
            },
            date = {
                name = "Hide Calendar Icon",
                desc = "Show/Hide Calendar Icon on Minimap",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.map.date = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Calendar:Enable()
                    else
                        MapMinimap.Module.Calendar:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.date end,
                order = 7
            },
            tracking = {
                name = "Hide Tracking Icon",
                desc = "Show/Hide Tracking Icon on Minimap",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.map.tracking = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Tracking:Enable()
                    else
                        MapMinimap.Module.Tracking:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.tracking end,
                order = 8
            },
            buttons = {
                name = "Buttons Mouseover",
                desc = "Show Minimap Buttons on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.map.buttons = val

                    if not MapMinimap.Module:IsEnabled() then return end

                    if val then
                        MapMinimap.Module.Mouseover:Enable()
                    else
                        MapMinimap.Module.Mouseover:Disable()
                    end
                end,
                get = function() return mUI.db.profile.map.buttons end,
                order = 9
            }
        }
    }

    function MapMinimap:GetOptions()
        return MapMinimap.layout
    end
end
