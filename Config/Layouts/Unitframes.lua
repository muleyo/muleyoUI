local Unitframes = mUI:NewModule("mUI.Config.Layouts.Unitframes")

function Unitframes:OnInitialize()
    -- Get LSM
    Unitframes.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Unitframes.Module = mUI:GetModule("mUI.Modules.Unitframes")
    Unitframes.Theme = mUI:GetModule("mUI.Modules.General.Theme")

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
            elitecolor = {
                name = "Elitechain Color",
                desc = "Keep the default Elitechain Color",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.elitecolor = val

                    if not Unitframes.Module:IsEnabled() then return end
                    if not Unitframes.Theme:IsEnabled() then return end

                    if val then
                        Unitframes.Module.Elitecolor:Enable()
                    else
                        Unitframes.Module.Elitecolor:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.elitecolor end,
                order = 18
            },
            debuffcolors = {
                name = "Debuff Colors",
                desc = "Color borders of Debuffs by their type on Target/Focus Frames",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.debuffcolors = val
                end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.debuffcolors end,
                order = 19
            },
            header3 = {
                name = "Buffs & Debuffs",
                type = "header",
                order = 20
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
                order = 21
            },
            buffsize = {
                name = "Buff Size",
                desc = "Set the Size of Buffs on Unitframes",
                type = "range",
                min = 0,
                max = 36,
                step = 1,
                set = function(_, val) mUI.db.profile.unitframes.buffsdebuffs.buffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.buffsize end,
                order = 22
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes",
                type = "range",
                min = 0,
                max = 36,
                step = 1,
                set = function(_, val) mUI.db.profile.unitframes.buffsdebuffs.debuffsize = val end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.debuffsize end,
                order = 23
            },
            header4 = {
                name = "Party / Raidframes Resize",
                type = "header",
                order = 24
            },
            enablesizing = {
                name = function()
                    if mUI.db.profile.unitframes.raidframes.size.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Raidframes re-sizing",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.size.enabled = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.RF_Size:Enable()
                    else
                        Unitframes.Module.RF_Size:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.size.enabled end,
                order = 25
            },
            width = {
                name = "Width",
                desc = "Set the Width of Raidframes",
                type = "range",
                min = 0,
                max = 200,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.size.width = val

                    if not Unitframes.Module:IsEnabled() then return end
                    if not Unitframes.Module.RF_Size:IsEnabled() then return end

                    Unitframes.Module.RF_Size:Update(val, mUI.db.profile.unitframes.raidframes.size.height)
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.size.width end,
                order = 26
            },
            height = {
                name = "Height",
                desc = "Set the Height of Raidframes",
                type = "range",
                min = 0,
                max = 200,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.size.height = val

                    if not Unitframes.Module:IsEnabled() then return end
                    if not Unitframes.Module.RF_Size:IsEnabled() then return end

                    Unitframes.Module.RF_Size:Update(mUI.db.profile.unitframes.raidframes.size.width, val)
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.size.height end,
                order = 27
            },
            header5 = {
                name = "Raidframes",
                type = "header",
                order = 28
            },
            darkmode = {
                name = "Dark Mode",
                desc = "Make the Healthbars of Party/Raidframes dark",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.darkmode = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.RF_Colors:Enable()
                    else
                        Unitframes.Module.RF_Colors:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.darkmode end,
                order = 29
            },
            roleicons = {
                name = "Role Icons",
                desc = "Hide Role Icons on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.roleicons = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.RF_RoleIcons:Enable()
                    else
                        Unitframes.Module.RF_RoleIcons:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.roleicons end,
                order = 30
            },
            health = {
                name = "Accurate Health",
                desc = "Show accurate Health Percentage (counts in absorb shields and heal absorbs)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.health = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        if not Unitframes.Module.RF_Health:IsEnabled() then
                            Unitframes.Module.RF_Health:Enable()
                        else
                            Unitframes.Module.RF_Health:Update()
                        end
                    else
                        if (not val) and (not mUI.db.profile.unitframes.raidframes.healthcolor) then
                            Unitframes.Module.RF_Health:Disable()
                        else
                            Unitframes.Module.RF_Health:Update()
                        end
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.health end,
                order = 31
            },
            healthcolor = {
                name = "Classcolor Health",
                desc = "Show Health in Classcolor on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.healthcolor = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        if not Unitframes.Module.RF_Health:IsEnabled() then
                            Unitframes.Module.RF_Health:Enable()
                        else
                            Unitframes.Module.RF_Health:Update()
                        end
                    else
                        if (not val) and (not mUI.db.profile.unitframes.raidframes.health) then
                            Unitframes.Module.RF_Health:Disable()
                        else
                            Unitframes.Module.RF_Health:Update()
                        end
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.healthcolor end,
                order = 32
            },
            names = {
                name = "Classcolor Names",
                desc = "Show Names in Classcolor on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.names = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.RF_Name:Enable()
                    else
                        Unitframes.Module.RF_Name:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.names end,
                order = 33
            },
            solo = {
                name = "Solo Partyframes",
                desc = "Show Partyframes even when not in a group",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.solo = val

                    if not Unitframes.Module:IsEnabled() then return end

                    if val then
                        Unitframes.Module.RF_Solo:Enable()
                    else
                        Unitframes.Module.RF_Solo:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.raidframes.solo end,
                order = 34
            }
        }
    }

    function Unitframes:GetOptions()
        return Unitframes.layout
    end
end
