local Unitframes = mUI:NewModule("mUI.Config.Layouts.Unitframes")

-- Enable Layout
Unitframes:Enable()

function Unitframes:OnInitialize()
    -- Get LSM
    Unitframes.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Unitframes.Module = mUI:GetModule("mUI.Modules.Unitframes")

    -- Initialize Layout
    Unitframes.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.unitframes.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.enabled = val

                    if val then
                        Unitframes.Module:Enable()
                        mUI:Reload('Enable Unitframes Module')
                    else
                        Unitframes.Module:Disable()
                        mUI:Reload('Disable Unitframes Module')
                    end
                end,
                get = function() return mUI.db.profile.unitframes.enabled end,
                order = 1
            },
            header1 = {
                name = "Textures",
                type = "header",
                order = 2
            },
            textures_unitframes = {
                name = "Unitframes",
                desc = "Select a Texture for the Unitframes (Player, Target, Focus, etc.)",
                type = "select",
                values = Unitframes.LSM:HashTable("statusbar"),
                dialogControl = 'LSM30_Statusbar',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.unitframes = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val == "None" then
                        Unitframes.Module.Unitframes_Textures:Disable()
                        Unitframes.Module.Unitframes_Textures:Update()
                    else
                        Unitframes.Module.Unitframes_Textures:Enable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.textures.unitframes end,
                order = 3
            },
            textures_raidframes = {
                name = "Party / Raidframes",
                desc = "Select a Texture for the Party / Raidframes",
                type = "select",
                values = Unitframes.LSM:HashTable("statusbar"),
                dialogControl = 'LSM30_Statusbar',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.raidframes = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val == "None" then
                        Unitframes.Module.Raidframes_Textures:Disable()
                        Unitframes.Module.Raidframes_Textures:Update()
                    else
                        Unitframes.Module.Raidframes_Textures:Enable()
                        Unitframes.Module.Raidframes_Textures:Update()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.textures.raidframes end,
                order = 4
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 5
            },
            color = {
                name = "Class/Reaction Colors",
                desc = "Show Healthbars in Class/Reaction Colors (Neutral etc.)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.color = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Color:Enable()
                    else
                        Unitframes.Module.Color:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.color end,
                order = 6
            },
            playerrepcolor = {
                name = "Player Reputation Bar",
                desc = "Show Reputation Bar on Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.playerrepcolor = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        mUI.db.profile.unitframes.reputationcolor = false
                        if Unitframes.Module.Reputationcolor:IsEnabled() then
                            Unitframes.Module.Reputationcolor:Update("player", true)
                        else
                            Unitframes.Module.Reputationcolor:Enable()
                        end
                    else
                        Unitframes.Module.Reputationcolor:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.playerrepcolor end,
                order = 7
            },
            reputationcolor = {
                name = "Hide Reputation Bars",
                desc = "Hide Reputation Bars on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.reputationcolor = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        mUI.db.profile.unitframes.playerrepcolor = false
                        if Unitframes.Module.Reputationcolor:IsEnabled() then
                            Unitframes.Module.Reputationcolor:Update("hide", true)
                        else
                            Unitframes.Module.Reputationcolor:Enable()
                        end
                    else
                        Unitframes.Module.Reputationcolor:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.reputationcolor end,
                order = 8
            },
            combatindicator = {
                name = "Combat Indicator",
                desc = "Show a Combat Icon on Unitframes when Target/Focus in combat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.combatindicator = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Combatindicator:Enable()
                    else
                        Unitframes.Module.Combatindicator:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.combatindicator end,
                order = 9
            },
            pvpbadge = {
                name = "Hide PVP Badge",
                desc = "Hide PVP Badge on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.pvpbadge = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Pvpbadge:Enable()
                    else
                        Unitframes.Module.Pvpbadge:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.pvpbadge end,
                order = 10
            },
            hitindicator = {
                name = "Hide Hit Indicator",
                desc = "Hide Hit Indicator (damage/healing numbers on the Player Portrait)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.hitindicator = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Hitindicator:Enable()
                    else
                        Unitframes.Module.Hitindicator:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.hitindicator end,
                order = 11
            },
            totemicons = {
                name = "Hide TotemFrame",
                desc = "Hide Totem Icons (Consecration etc.) below the Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.totemicons = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Totemicons:Enable()
                    else
                        Unitframes.Module.Totemicons:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.totemicons end,
                order = 12
            },
            classbar = {
                name = "Hide ClassBar",
                desc = "Hide ClassBar (Combo Points, Holy Power, etc.)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.classbar = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Classbar:Enable()
                    else
                        Unitframes.Module.Classbar:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.classbar end,
                order = 13
            },
            cornericon = {
                name = "Hide Corner Icon",
                desc = "Hide the Corner Icon on the Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.cornericon = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Cornericon:Enable()
                    else
                        Unitframes.Module.Cornericon:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.cornericon end,
                order = 14
            },
            restingtextures = {
                name = "Hide Rest Textures",
                desc = "Hide Resting Textures on Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.restingtextures = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Restingtextures:Enable()
                    else
                        Unitframes.Module.Restingtextures:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.restingtextures end,
                order = 15
            },
            name = {
                name = "Hide Name",
                desc = "Hide Names on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.name = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Name:Enable()
                    else
                        Unitframes.Module.Name:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.name end,
                order = 16
            },
            level = {
                name = "Hide Level",
                desc = "Hide Level Text on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.level = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Level:Enable()
                    else
                        Unitframes.Module.Level:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.level end,
                order = 17
            },
            header3 = {
                name = "Buffs & Debuffs",
                type = "header",
                order = 18
            },
            enablebuffdebuff = {
                name = function()
                    if mUI.db.profile.unitframes.buffsdebuffs.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Buffs & Debuffs re-sizing on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.enabled = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.BuffsDebuffs:Enable()
                    else
                        Unitframes.Module.BuffsDebuffs:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.enabled end,
                order = 19
            },
            buffsize = {
                name = "Buff Size",
                desc = "Set the Size of Buffs on Unitframes",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                set = function(_, val) mUI.db.profile.unitframes.buffsdebuffs.buffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.buffsize end,
                order = 20
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes",
                type = "range",
                min = 10,
                max = 50,
                step = 1,
                set = function(_, val) mUI.db.profile.unitframes.buffsdebuffs.debuffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.debuffsize end,
                order = 21
            }
        }
    }
end

function Unitframes:OnEnable()
    function Unitframes:GetOptions()
        return Unitframes.layout
    end
end
