local Castbars = mUI:NewModule("mUI.Config.Layouts.Castbars")

-- Enable Layout
Castbars:Enable()

function Castbars:OnInitialize()
    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enabled = {
                name = function()
                    if mUI.db.profile.castbars.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "|cffffff00INFO:|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.castbars.enabled = val end,
                get = function() return mUI.db.profile.castbars.enabled end,
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
                set = function(_, val) mUI.db.profile.castbars.style = val end,
                get = function() return mUI.db.profile.castbars.style end,
                order = 3
            },
            icons = {
                name = "Icons",
                desc = "Show / Hide Spell Icons next to Castbars",
                type = "toggle",
                set = function(_, val) mUI.db.profile.castbars.icons = val end,
                get = function() return mUI.db.profile.castbars.icons end,
                order = 4
            },
            casttime = {
                name = "Cast Time",
                desc = "Show / Hide Cast Time next to Castbars",
                type = "toggle",
                set = function(_, val) mUI.db.profile.castbars.casttime = val end,
                get = function() return mUI.db.profile.castbars.casttime end,
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
                set = function(_, val) mUI.db.profile.castbars.targetscale = val end,
                get = function() return mUI.db.profile.castbars.targetscale end,
                order = 7
            },
            focusscale = {
                name = "Focus Castbar Size",
                desc = "Set the Size of the Focus Castbar",
                type = "range",
                min = 50,
                max = 200,
                step = 10,
                set = function(_, val) mUI.db.profile.castbars.focusscale = val end,
                get = function() return mUI.db.profile.castbars.focusscale end,
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
                set = function(_, val) mUI.db.profile.castbars.targetpos = val end,
                get = function() return mUI.db.profile.castbars.targetpos end,
                order = 10
            },
            focuspos = {
                name = "Focus Castbar on top",
                desc = "Display the Focus Castbar above the Focusframe",
                type = "toggle",
                set = function(_, val) mUI.db.profile.castbars.focuspos = val end,
                get = function() return mUI.db.profile.castbars.focuspos end,
                order = 11
            }
        }
    }
end

function Castbars:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
