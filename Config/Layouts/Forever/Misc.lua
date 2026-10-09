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
                order = 3
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
                order = 4
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
                order = 5
            },
            playerlinks = {
                name = "Player Links",
                desc = "Add WarcraftLogs, Raider.io and CheckPVP links to the player right-click menu",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.playerlinks = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.PlayerLinks:Enable()
                    else
                        Misc.Module.PlayerLinks:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.playerlinks
                end,
                order = 6
            },
            lfgdeclined = {
                name = "LFG Declined",
                desc = "Allows you to queue up for groups you've been declined before.",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.lfgdeclined = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.LFGDeclined:Enable()
                    else
                        Misc.Module.LFGDeclined:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.lfgdeclined
                end,
                order = 7
            },
            header2 = {
                name = "Hide Frames",
                type = "header",
                order = 8
            },
            statusbar = {
                name = "XP/Rep/Honor Bar",
                desc = "Hide the XP/Rep/Honor Bar",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.statusbar = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Statusbar:Enable()
                    else
                        Misc.Module.Statusbar:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.statusbar
                end,
                order = 9
            },
            header3 = {
                name = "PvP Options",
                type = "header",
                order = 11
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
                order = 12
            },
            dampening = {
                name = "Dampening",
                desc = "Display Dampening below Arena Timer",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.dampening = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Dampening:Enable()
                    else
                        Misc.Module.Dampening:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.dampening
                end,
                order = 13
            },
            surrender = {
                name = "Surrender",
                desc = "Surrender an Arena Match by typing '/gg' in the Chat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.surrender = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Surrender:Enable()
                    else
                        Misc.Module.Surrender:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.surrender
                end,
                order = 14
            },
            safequeue = {
                name = "Safe Queue",
                desc = "Displays a Timer and remove the Leave-Button on Queuepop Window",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.safequeue = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Safequeue:Enable()
                    else
                        Misc.Module.Safequeue:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.safequeue
                end,
                order = 15
            },
            losecontrol = {
                name = "LoseControl",
                desc = "Make the built-in Loss of Control Frame more transparent",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.losecontrol = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Losecontrol:Enable()
                    else
                        Misc.Module.Losecontrol:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.losecontrol
                end,
                order = 16
            },
            achievements = {
                name = "Track Achievements",
                desc = "Click to Track Achievements (Gladiator / Strategist / Legend) in the Conquest Frame",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.achievements = val

                    if not Misc.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Misc.Module.Achievements:Enable()
                    else
                        Misc.Module.Achievements:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.misc.achievements
                end,
                order = 17
            }
        }
    }

    function Misc:GetOptions()
        return Misc.layout
    end
end
