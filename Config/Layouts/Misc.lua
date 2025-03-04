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
                desc = "|cffffff00Info:|r Requires Reload",
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
                get = function() return mUI.db.profile.misc.enabled end,
                order = 1
            },
            header1 = {
                name = "Miscellaneous",
                type = "header",
                order = 2
            },
            interrupt = {
                name = "Interrupt Announce",
                desc = "Announce successful Interrupts in Party/Raid/Instance Chat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.interrupt = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Interrupt:Enable()
                    else
                        Misc.Module.Interrupt:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.interrupt end,
                order = 3
            },
            menubutton = {
                name = "Menu Button",
                desc = "Show mUI Button on the ESC-Menu to open the Menu",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.menubutton = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Menubutton:Enable()
                    else
                        Misc.Module.Menubutton:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.menubutton end,
                order = 4
            },
            header2 = {
                name = "Hide Frames",
                type = "header",
                order = 5
            },
            statusbar = {
                name = "XP/Rep/Honor Bar",
                desc = "Hide the XP/Rep/Honor Bar",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.statusbar = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Statusbar:Enable()
                    else
                        Misc.Module.Statusbar:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.statusbar end,
                order = 6
            },
            dragonflying = {
                name = "Dragonflying Wings",
                desc = "Hide the Dragonflying Bar Wings",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.dragonflying = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Dragonflying:Enable()
                    else
                        Misc.Module.Dragonflying:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.dragonflying end,
                order = 7
            },
            buffcollapse = {
                name = "Collapse Button",
                desc = "Hide the BuffFrame Collapse Button",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.buffcollapse = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Buffcollapse:Enable()
                    else
                        Misc.Module.Buffcollapse:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.buffcollapse end,
                order = 8
            },
            fastloot = {
                name = "Fast Loot",
                desc = "Removes the delay when looting\n\n|cffffff00Info:|r Requires AutoLoot to be enabled",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.fastloot = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Fastloot:Enable()
                    else
                        Misc.Module.Fastloot:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.fastloot end,
                order = 9
            },
            header3 = {
                name = "PvP Options",
                type = "header",
                order = 10
            },
            tabbinder = {
                name = "Tab Binder",
                desc = "Bind Tab to target only enemy players in PVP Combat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.tabbinder = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Tabbinder:Enable()
                    else
                        Misc.Module.Tabbinder:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.tabbinder end,
                order = 11
            },
            dampening = {
                name = "Dampening",
                desc = "Display Dampening below Arena Timer",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.dampening = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Dampening:Enable()
                    else
                        Misc.Module.Dampening:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.dampening end,
                order = 12
            },
            surrender = {
                name = "Surrender",
                desc = "Surrender an Arena Match by typing '/gg' in the Chat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.surrender = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Surrender:Enable()
                    else
                        Misc.Module.Surrender:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.surrender end,
                order = 13
            },
            safequeue = {
                name = "Safe Queue",
                desc = "Displays a Timer and remove the Leave-Button on Queuepop Window",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.safequeue = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Safequeue:Enable()
                    else
                        Misc.Module.Safequeue:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.safequeue end,
                order = 14
            },
            losecontrol = {
                name = "LoseControl",
                desc = "Make the built-in Loss of Control Frame more transparent",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.losecontrol = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Losecontrol:Enable()
                    else
                        Misc.Module.Losecontrol:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.losecontrol end,
                order = 15
            },
            achievements = {
                name = "Track Achievements",
                desc = "Click to Track Achievements (Gladiator / Strategist / Legend) in the Conquest Frame",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.misc.achievements = val

                    if not Misc.Module:IsEnabled() then return end

                    if val then
                        Misc.Module.Achievements:Enable()
                    else
                        Misc.Module.Achievements:Disable()
                    end
                end,
                get = function() return mUI.db.profile.misc.achievements end,
                order = 16
            }
        }
    }

    function Misc:GetOptions()
        return Misc.layout
    end
end
