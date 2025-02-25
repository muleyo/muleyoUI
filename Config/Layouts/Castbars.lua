local Castbars = mUI:NewModule("mUI.Config.Layouts.Castbars")

function Castbars:OnInitialize()
    -- Get Modules
    Castbars.Module = mUI:GetModule("mUI.Modules.Castbars")

    -- Initialize Layout
    Castbars.layout = {
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
                        Castbars.Module:Enable()
                        mUI:Reload('Enable Castbars Module')
                    else
                        Castbars.Module:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val == "mUI" then
                        Castbars.Module.Style:Enable()
                    else
                        Castbars.Module.Style:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val then
                        Castbars.Module.Icon:Enable()
                    else
                        Castbars.Module.Icon:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val then
                        Castbars.Module.Casttime:Enable()
                    else
                        Castbars.Module.Casttime:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val ~= 100 then
                        if not Castbars.Module.Targetscale:IsEnabled() then
                            Castbars.Module.Targetscale:Enable()
                        else
                            Castbars.Module.Targetscale:Update()
                        end
                    else
                        Castbars.Module.Targetscale:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val ~= 100 then
                        if not Castbars.Module.Focusscale:IsEnabled() then
                            Castbars.Module.Focusscale:Enable()
                        else
                            Castbars.Module.Focusscale:Update()
                        end
                    else
                        Castbars.Module.Focusscale:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val then
                        Castbars.Module.Targetpos:Enable()
                    else
                        Castbars.Module.Targetpos:Disable()
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

                    if not Castbars.Module:IsEnabled() then return end

                    if val then
                        Castbars.Module.Focuspos:Enable()
                    else
                        Castbars.Module.Focuspos:Disable()
                    end
                end,
                get = function() return mUI.db.profile.castbars.focuspos end,
                order = 11
            }
        }
    }

    function Castbars:GetOptions()
        return Castbars.layout
    end
end
