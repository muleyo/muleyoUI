local Actionbars = mUI:NewModule("mUI.Config.Layouts.Actionbars")

function Actionbars:OnInitialize()
    -- Get Modules
    Actionbars.Module = mUI:GetModule("mUI.Modules.Actionbars")

    -- Initialize Layout
    Actionbars.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.actionbars.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.enabled = val

                    if val then
                        Actionbars.Module:Enable()
                        mUI:Reload('Enable Actionbars Module')
                    else
                        Actionbars.Module:Disable()
                        mUI:Reload('Disable Actionbars Module')
                    end
                end,
                get = function() return mUI.db.profile.actionbars.enabled end,
                order = 1
            },
            header1 = {
                name = "Actionbar Buttons",
                type = "header",
                order = 2
            },
            hotkey = {
                name = "Hide HotKey Text",
                desc = "Hide Hotkey Text on Actionbuttons",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.hotkey = val

                    if not Actionbars.Module:IsEnabled() then return end

                    if val then
                        Actionbars.Module.Hotkey:Enable()
                    else
                        Actionbars.Module.Hotkey:Disable()
                    end
                end,
                get = function() return mUI.db.profile.actionbars.hotkey end,
                order = 3
            },
            macro = {
                name = "Hide Macro Text",
                desc = "Hide Macro Text on Actionbuttons",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.macro = val

                    if not Actionbars.Module:IsEnabled() then return end

                    if val then
                        Actionbars.Module.Macro:Enable()
                    else
                        Actionbars.Module.Macro:Disable()
                    end
                end,
                get = function() return mUI.db.profile.actionbars.macro end,
                order = 4
            },
            flash = {
                name = "Flash Animation",
                desc = "Flash Actionbuttons on button press",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.flash = val

                    if not Actionbars.Module:IsEnabled() then return end

                    if val then
                        Actionbars.Module.Flash:Enable()
                    else
                        Actionbars.Module.Flash:Disable()
                    end
                end,
                get = function() return mUI.db.profile.actionbars.flash end,
                order = 5
            },
            range = {
                name = "Range Indicator",
                desc = "Change button-color to red when out of range",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.range = val

                    if not Actionbars.Module:IsEnabled() then return end

                    if val then
                        Actionbars.Module.Range:Enable()
                    else
                        Actionbars.Module.Range:Disable()
                    end
                end,
                get = function() return mUI.db.profile.actionbars.range end,
                order = 6
            },
            header2 = {
                name = "Mouseover",
                type = "header",
                order = 7
            },
            enablemouseover = {
                name = function()
                    if mUI.db.profile.actionbars.mouseover.enabled then
                        return "|cFF00FF00Mouseover Enabled|r"
                    else
                        return "|cFFFF0000Mouseover Disabled|r"
                    end
                end,
                desc = "Enable/Disable Mouseover Module",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.enabled = val

                    if not Actionbars.Module:IsEnabled() then return end

                    if val then
                        Actionbars.Module.Mouseover:Enable()
                    else
                        Actionbars.Module.Mouseover:Disable()
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.enabled end,
                order = 8
            },
            spacer = {
                name = "",
                type = "description",
                order = 9
            },
            bar1 = {
                name = "ActionBar 1",
                desc = "Show Actionbar 1 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar1 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar1", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar1", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar1 end,
                order = 10
            },
            bar2 = {
                name = "ActionBar 2",
                desc = "Show Actionbar 2 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar2 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar2", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar2", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar2 end,
                order = 11
            },
            bar3 = {
                name = "ActionBar 3",
                desc = "Show Actionbar 3 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar3 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar3", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar3", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar3 end,
                order = 12
            },
            bar4 = {
                name = "ActionBar 4",
                desc = "Show Actionbar 4 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar4 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar4", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar4", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar4 end,
                order = 13
            },
            bar5 = {
                name = "ActionBar 5",
                desc = "Show Actionbar 5 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar5 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar5", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar5", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar5 end,
                order = 14
            },
            bar6 = {
                name = "ActionBar 6",
                desc = "Show Actionbar 6 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar6 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar6", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar6", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar6 end,
                order = 15
            },
            bar7 = {
                name = "ActionBar 7",
                desc = "Show Actionbar 7 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar7 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar7", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar7", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar7 end,
                order = 16
            },
            bar8 = {
                name = "ActionBar 8",
                desc = "Show Actionbar 8 on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bar8 = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("bar8", true)
                    else
                        Actionbars.Module.Mouseover:Update("bar8", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bar8 end,
                order = 17
            },
            petbar = {
                name = "Pet Actionbar",
                desc = "Show Pet Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.petbar = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("petbar", true)
                    else
                        Actionbars.Module.Mouseover:Update("petbar", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.petbar end,
                order = 18
            },
            stancebar = {
                name = "Stance Actionbar",
                desc = "Show Stance Actionbar on Mouseover",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.stancebar = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val then
                        Actionbars.Module.Mouseover:Update("stancebar", true)
                    else
                        Actionbars.Module.Mouseover:Update("stancebar", false)
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.stancebar end,
                order = 19
            },
            micromenu = {
                name = "Micro Menu",
                desc = "Choose an option",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["Mouseover"] = "Mouseover",
                    ["Hidden"] = "Hidden"
                },
                sorting = {
                    "Default",
                    "Mouseover",
                    "Hidden"
                },
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.micromenu = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val == "Default" then
                        Actionbars.Module.Mouseover:Update("micromenu", "Default")
                    elseif val == "Hidden" then
                        Actionbars.Module.Mouseover:Update("micromenu", "Hidden")
                    else
                        Actionbars.Module.Mouseover:Update("micromenu", "Mouseover")
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.micromenu end,
                order = 20
            },
            bagbuttons = {
                name = "Bag Buttons",
                desc = "Choose an option",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["Mouseover"] = "Mouseover",
                    ["Hidden"] = "Hidden"
                },
                sorting = {
                    "Default",
                    "Mouseover",
                    "Hidden"
                },
                set = function(_, val)
                    mUI.db.profile.actionbars.mouseover.bagbuttons = val

                    if not Actionbars.Module:IsEnabled() then return end
                    if not mUI.db.profile.actionbars.mouseover.enabled then return end

                    if val == "Default" then
                        Actionbars.Module.Mouseover:Update("bagbuttons", "Default")
                    elseif val == "Hidden" then
                        Actionbars.Module.Mouseover:Update("bagbuttons", "Hidden")
                    else
                        Actionbars.Module.Mouseover:Update("bagbuttons", "Mouseover")
                    end
                end,
                get = function() return mUI.db.profile.actionbars.mouseover.bagbuttons end,
                order = 21
            }
        }
    }

    function Actionbars:GetOptions()
        return Actionbars.layout
    end
end
