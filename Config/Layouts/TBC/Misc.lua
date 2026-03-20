local Misc = mUI:NewModule("mUI.Config.Layouts.Misc")

function Misc:OnInitialize()
    -- Get Modules
    Misc.Module = mUI:GetModule("mUI.Modules.Misc")

    -- Initialize Layout
    Misc.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.misc.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.enabled = val

                    if val then
                        Misc.Module:Enable()
                        mUI:Reload('Enable Misc Module')
                    else
                        Misc.Module:Disable()
                        mUI:Reload('Disable Misc Module')
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.enabled
                end,
                order = 1
            },
            header1 = {
                name = "Miscellaneous",
                type = "header",
                order = 2
            },
            skinmenu = {
                name = "Skin Menu Buttons",
                desc = "Skin ESC-Menu Buttons to match mUI theme",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.skinmenu = val
                end,
                get = function()
                    return mUI.db.profile.misc.skinmenu
                end,
                order = 4
            },
            menubutton = {
                name = "Menu Button",
                desc = "Show mUI Button on the ESC-Menu to open the Menu",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.menubutton = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Menubutton:Enable()
                    else
                        Misc.Module.Menubutton:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.menubutton
                end,
                order = 5
            },
            fastloot = {
                name = "Fast Loot",
                desc = "Removes the delay when looting\n\n|cffffff00Info:|r Requires AutoLoot to be enabled",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.fastloot = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Fastloot:Enable()
                    else
                        Misc.Module.Fastloot:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.fastloot
                end,
                order = 6
            },
            header2 = {
                name = "PvP Options",
                type = "header",
                order = 9
            },
            tabbinder = {
                name = "Tab Binder",
                desc = "Bind Tab to target only enemy players in PVP Combat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.tabbinder = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Tabbinder:Enable()
                    else
                        Misc.Module.Tabbinder:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.tabbinder
                end,
                order = 10
            }
        }
    }

    function Misc:GetOptions()
        return Misc.layout
    end
end
