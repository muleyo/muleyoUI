local Castbars = mUI:NewModule("mUI.Config.Layouts.Castbars")

-- Enable Layout
Castbars:Enable()

function Castbars:OnInitialize()
    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.Castbars")

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
                desc = "Enable / Disable Module|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.castbars.enabled = val

                    if val then
                        self.Module:Enable()
                        mUI:Reload('Enable Castbars Module')
                    else
                        self.Module:Disable()
                        mUI:Reload('Disable Castbars Module')
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.castbars.style = val

                    if not self.Module:IsEnabled() then return end

                    if val == "mUI" then
                        self.Module.Style:Enable()
                    else
                        self.Module.Style:Disable()
                    end
                end,
                get = function() return mUI.db.profile.castbars.style end,
                order = 3
            },
            icons = {
                name = "Spell Icon",
                desc = "Show / Hide Spell Icon next to the Player Castbar",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.castbars.icon = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Icon:Enable()
                    else
                        self.Module.Icon:Disable()
                    end
                end,
                get = function() return mUI.db.profile.castbars.icon end,
                order = 4
            },
            casttime = {
                name = "Cast Time",
                desc = "Show / Hide Cast Time next to Castbars",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.castbars.casttime = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Casttime:Enable()
                    else
                        self.Module.Casttime:Disable()
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.castbars.targetscale = val

                    if not self.Module:IsEnabled() then return end

                    if val ~= 100 then
                        if not self.Module.Targetscale:IsEnabled() then
                            self.Module.Targetscale:Enable()
                        else
                            self.Module.Targetscale:Update()
                        end
                    else
                        self.Module.Targetscale:Disable()
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.castbars.focusscale = val

                    if not self.Module:IsEnabled() then return end

                    if val ~= 100 then
                        if not self.Module.Focusscale:IsEnabled() then
                            self.Module.Focusscale:Enable()
                        else
                            self.Module.Focusscale:Update()
                        end
                    else
                        self.Module.Focusscale:Disable()
                    end
                end,
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
                set = function(_, val)
                    mUI.db.profile.castbars.targetpos = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Targetpos:Enable()
                    else
                        self.Module.Targetpos:Disable()
                    end
                end,
                get = function() return mUI.db.profile.castbars.targetpos end,
                order = 10
            },
            focuspos = {
                name = "Focus Castbar on top",
                desc = "Display the Focus Castbar above the Focusframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.castbars.focuspos = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Focuspos:Enable()
                    else
                        self.Module.Focuspos:Disable()
                    end
                end,
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
