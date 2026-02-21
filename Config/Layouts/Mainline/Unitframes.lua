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
                get = function()
                    return mUI.db.profile.unitframes.enabled
                end,
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
                dialogControl = 'mUI_LSM30_Status',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.unitframes = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val == "None" then
                        Unitframes.Module.UF_Textures:Disable()
                        Unitframes.Module.UF_Textures:Update()
                    else
                        Unitframes.Module.UF_Textures:Enable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.textures.unitframes
                end,
                order = 3
            },
            textures_raidframes = {
                name = "Party / Raidframes",
                desc = "Select a Texture for the Party / Raidframes",
                type = "select",
                values = Unitframes.LSM:HashTable("statusbar"),
                dialogControl = 'mUI_LSM30_Status',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.raidframes = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val == "None" then
                        Unitframes.Module.RF_Textures:Disable()
                        Unitframes.Module.RF_Textures:Update()
                    else
                        Unitframes.Module.RF_Textures:Enable()
                        Unitframes.Module.RF_Textures:Update()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.textures.raidframes
                end,
                order = 5
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 6
            },
            color = {
                name = "Class/Reaction Colors",
                desc = "Show Healthbars in Class/Reaction Colors (Neutral etc.)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.color = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Color:Enable()
                    else
                        Unitframes.Module.Color:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.color
                end,
                order = 7
            },
            playerrepcolor = {
                name = "Player Reputation Bar",
                desc = "Show Reputation Bar on Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.playerrepcolor = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

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
                get = function()
                    return mUI.db.profile.unitframes.playerrepcolor
                end,
                order = 8
            },
            reputationcolor = {
                name = "Hide Reputation Bars",
                desc = "Hide Reputation Bars on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.reputationcolor = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

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
                get = function()
                    return mUI.db.profile.unitframes.reputationcolor
                end,
                order = 9
            },
            combatindicator = {
                name = "Combat Indicator",
                desc = "Show a Combat Icon on Unitframes when Target/Focus in combat",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.combatindicator = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Combatindicator:Enable()
                    else
                        Unitframes.Module.Combatindicator:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.combatindicator
                end,
                order = 10
            },
            pvpbadge = {
                name = "Hide PVP Badge",
                desc = "Hide PVP Badge on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.pvpbadge = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Pvpbadge:Enable()
                    else
                        Unitframes.Module.Pvpbadge:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.pvpbadge
                end,
                order = 11
            },
            hitindicator = {
                name = "Hide Hit Indicator",
                desc = "Hide Hit Indicator (damage/healing numbers on the Player Portrait)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.hitindicator = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Hitindicator:Enable()
                    else
                        Unitframes.Module.Hitindicator:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.hitindicator
                end,
                order = 12
            },
            totemicons = {
                name = "Hide TotemFrame",
                desc = "Hide Totem Icons (Consecration etc.) below the Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.totemicons = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Totemicons:Enable()
                    else
                        Unitframes.Module.Totemicons:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.totemicons
                end,
                order = 13
            },
            classbar = {
                name = "Hide ClassBar",
                desc = "Hide ClassBar (Combo Points, Holy Power, etc.)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.classbar = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Classbar:Enable()
                    else
                        Unitframes.Module.Classbar:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.classbar
                end,
                order = 14
            },
            cornericon = {
                name = "Hide Corner Icon",
                desc = "Hide the Corner Icon on the Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.cornericon = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Cornericon:Enable()
                    else
                        Unitframes.Module.Cornericon:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.cornericon
                end,
                order = 15
            },
            restingtextures = {
                name = "Hide Rest Textures",
                desc = "Hide Resting Textures on Player Unitframe",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.restingtextures = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Restingtextures:Enable()
                    else
                        Unitframes.Module.Restingtextures:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.restingtextures
                end,
                order = 16
            },
            name = {
                name = "Hide Name",
                desc = "Hide Names on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.name = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Name:Enable()
                    else
                        Unitframes.Module.Name:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.name
                end,
                order = 17
            },
            level = {
                name = "Hide Level",
                desc = "Hide Level Text on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.level = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Level:Enable()
                    else
                        Unitframes.Module.Level:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.level
                end,
                order = 18
            },
            elitecolor = {
                name = "Elitechain Color",
                desc = "Keep the default Elitechain Color",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.elitecolor = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end
                    if not Unitframes.Theme:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Elitecolor:Enable()
                    else
                        Unitframes.Module.Elitecolor:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.elitecolor
                end,
                order = 19
            },
            debuffcolors = {
                name = "Debuff Colors",
                desc = "Color borders of Debuffs by their type on Target/Focus Frames",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.debuffcolors = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.debuffcolors
                end,
                order = 20
            },
            smooth = {
                name = "Smooth Healthbars",
                desc = "Enable Smooth Healthbar Animation\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.smooth = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Smooth:Enable()
                    else
                        Unitframes.Module.Smooth:Disable()
                        mUI:Reload("Disable Smooth Healthbars")
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.smooth
                end,
                order = 22
            },
            overshields = {
                name = "Overshields",
                desc = "Show Absorbshields on Unitframes\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.overshields = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.Overshields:Enable()
                    else
                        Unitframes.Module.Overshields:Disable()
                        mUI:Reload("Disable Overshields")
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.overshields
                end,
                order = 23
            },
            header3 = {
                name = "Buffs & Debuffs",
                type = "header",
                order = 24
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

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.BuffsDebuffs:Enable()
                    else
                        Unitframes.Module.BuffsDebuffs:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                order = 25
            },
            buffsize = {
                name = "Buff Size",
                desc = "Set the Size of Buffs on Unitframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.buffsize = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.buffsize
                end,
                order = 26
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.debuffsize = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.debuffsize
                end,
                order = 27
            },
            header4 = {
                name = "Raidframes",
                type = "header",
                order = 28
            },
            roleicons = {
                name = "Role Icons",
                desc = "Hide Role Icons on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.roleicons = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.RF_RoleIcons:Enable()
                    else
                        Unitframes.Module.RF_RoleIcons:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.roleicons
                end,
                order = 29
            },
            healthcolor = {
                name = "Classcolor Health",
                desc = "Show Health in Classcolor on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.healthcolor = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

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
                get = function()
                    return mUI.db.profile.unitframes.raidframes.healthcolor
                end,
                order = 30
            },
            names = {
                name = "Classcolor Names",
                desc = "Show Names in Classcolor on Party/Raidframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.names = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.RF_Name:Enable()
                    else
                        Unitframes.Module.RF_Name:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.names
                end,
                order = 31
            },
            solo = {
                name = "Solo Partyframes",
                desc = "Show Partyframes even when not in a group",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.solo = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Unitframes.Module.RF_Solo:Enable()
                    else
                        Unitframes.Module.RF_Solo:Disable()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.solo
                end,
                order = 32
            },
            skinicons = {
                name = "Skin Aura Icons",
                desc = "Apply mUI Skin to Aura Icons on Party/Raidframes\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.skinicons = val

                    if val then
                        mUI:Reload("Enable Skin Aura Icons")
                    else
                        mUI:Reload("Disable Skin Aura Icons")
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.skinicons
                end,
                order = 33
            },
            aurasizeParty = {
                name = "Buff Size (Party)",
                desc = "Set the Size of Buffs on Raidframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.aurasizeParty = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.aurasizeParty
                end,
                order = 34
            },
            aurasizeRaid = {
                name = "Buff Size (Raid)",
                desc = "Set the Size of Buffs on Raidframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.aurasizeRaid = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.aurasizeRaid
                end,
                order = 35
            },
            debuffsizeParty = {
                name = "Debuff Size (Party)",
                desc = "Set the Size of Debuffs on Raidframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.debuffsizeParty = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.debuffsizeParty
                end,
                order = 36
            },
            debuffsizeRaid = {
                name = "Debuff Size (Raid)",
                desc = "Set the Size of Debuffs on Raidframes",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.debuffsizeRaid = val
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.debuffsizeRaid
                end,
                order = 37
            },
            defensiveSize = {
                name = "Defensive Buff Size",
                desc = "Set the Size of Defensive Buffs on Raidframes\n\n|cffffff00Info:|r Requires Reload",
                type = "range",
                min = 0,
                max = 50,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.defensive.size = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    Unitframes.Module.RF_Defensive:Update(nil, nil, val)
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.defensive.size
                end,
                order = 38
            },
            defensivePosition = {
                name = "Defensive Buff Position",
                desc = "Set the Position of Defensive Buffs on Raidframes\n\n|cffffff00Info:|r Requires Reload",
                type = "select",
                values = {
                    ["TOP"] = "Top Center",
                    ["TOPLEFT"] = "Top Left",
                    ["TOPRIGHT"] = "Top Right",
                    ["CENTER"] = "Center",
                    ["LEFT"] = "Left",
                    ["RIGHT"] = "Right",
                    ["BOTTOM"] = "Bottom Center",
                    ["BOTTOMLEFT"] = "Bottom Left",
                    ["BOTTOMRIGHT"] = "Bottom Right"
                },
                set = function(_, val)
                    mUI.db.profile.unitframes.raidframes.defensive.position = val

                    if not Unitframes.Module:IsEnabled() then
                        return
                    end

                    Unitframes.Module.RF_Defensive:Update(nil, val)
                end,
                get = function()
                    return mUI.db.profile.unitframes.raidframes.defensive.position
                end,
                order = 39
            }
        }
    }

    function Unitframes:GetOptions()
        return Unitframes.layout
    end
end
