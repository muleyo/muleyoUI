local Tooltips = mUI:NewModule("mUI.Config.Layouts.Tooltips")

-- Enable Layout
Tooltips:Enable()

function Tooltips:OnInitialize()
    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.tooltips.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "|cffffff00INFO:|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.tooltips.enabled = val end,
                get = function() return mUI.db.profile.tooltips.enabled end,
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
                set = function(_, val) mUI.db.profile.tooltips.style = val end,
                get = function() return mUI.db.profile.tooltips.style end,
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
                set = function(_, val) mUI.db.profile.tooltips.combat = val end,
                get = function() return mUI.db.profile.tooltips.combat end,
                order = 5
            },
            lifeontop = {
                name = "Life on Top",
                desc = "Show the Healthbar on Top of the Tooltip",
                type = "toggle",
                set = function(_, val) mUI.db.profile.tooltips.lifeontop = val end,
                get = function() return mUI.db.profile.tooltips.lifeontop end,
                order = 6
            },
            mouseanchor = {
                name = "Mouse Anchor",
                desc = "Attach the Tooltip to the Mouse Cursor",
                type = "toggle",
                set = function(_, val) mUI.db.profile.tooltips.mouseanchor = val end,
                get = function() return mUI.db.profile.tooltips.mouseanchor end,
                order = 7
            }
        }
    }
end

function Tooltips:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
