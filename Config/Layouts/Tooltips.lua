local Tooltips = mUI:NewModule("mUI.Config.Layouts.Tooltips")

-- Enable Layout
Tooltips:Enable()

function Tooltips:OnInitialize()
    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.Tooltips")

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
                desc = "|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.tooltips.enabled = val

                    if val then
                        self.Module:Enable()
                        mUI:Reload('Enable Tooltips Module')
                    else
                        self.Module:Disable()
                        mUI:Reload('Disable Tooltips Module')
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.tooltips.style = val

                    if not self.Module:IsEnabled() then return end

                    if val == "mUI" then
                        self.Module.Style:Enable()
                    else
                        self.Module.Style:Disable()
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.tooltips.combat = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Combat:Enable()
                    else
                        self.Module.Combat:Disable()
                    end
                end,
                get = function() return mUI.db.profile.tooltips.combat end,
                order = 5
            },
            mouseanchor = {
                name = "Mouse Anchor",
                desc = "Attach the Tooltip to the Mouse Cursor",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.tooltips.mouseanchor = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Anchor:Enable()
                    else
                        self.Module.Anchor:Disable()
                    end
                end,
                get = function() return mUI.db.profile.tooltips.mouseanchor end,
                order = 6
            }
        }
    }
end

function Tooltips:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
