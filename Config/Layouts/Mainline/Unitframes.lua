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
            preview = {
                name = "Preview",
                desc = "Preview your Unitframes changes in a side panel",
                type = "execute",
                func = function()
                    mUI.mGUI.Preview:Toggle()
                end,
                order = 1.5
            },
            enable = {
                name = function()
                    if mUI.db.profile.unitframes.enabled then
                        return "|cff00ff00Enabled|r"
                    else
                        return "|cffff0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable the Unitframes (Player, Target, Focus, etc.).\n\n|cffffff00Info:|r Requires Reload\n\n|cffffff00Note:|r Raidframes toggle separately on their own tab.",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.enabled = val
                    mUI:Reload(val and 'Enable Unitframes Module' or 'Disable Unitframes Module')
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
                name = "Healthbar / Powerbar",
                desc = "Select a Texture for the Health-/Powerbars of Unitframes (Player, Target, Focus, etc.)",
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
                        Unitframes.Module.UF_Textures:Update()
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.textures.unitframes
                end,
                order = 3
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
                order = 14
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
                order = 15
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
                order = 16
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
                order = 17
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
                order = 18
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
                order = 20
            },
            header3 = {
                name = "Auras",
                type = "header",
                order = 21
            },
            auraenabled = {
                name = "Enable Auras",
                desc = "Show Buffs/Debuffs on Unitframes (Target / Focus)\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.enabled = val
                    mUI:Reload(val and 'Enable Unitframe Auras' or 'Disable Unitframe Auras')
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                order = 21.5
            },
            dispellableOnly = {
                name = "Important Buffs only",
                desc = "Only show important and dispellable buffs on unitframes",
                type = "toggle",
                hidden = function()
                    return not mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.dispellableOnly = val
                    Unitframes.Theme:UpdateAllUnitframeBuffFilters()
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.dispellableOnly
                end,
                order = 21.6
            },
            debuffcolors = {
                name = "Debuff Colors",
                desc = "Color borders of Debuffs by their type on Target/Focus Frames\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.debuffcolors = val
                    if select(4, GetBuildInfo()) >= 120100 then
                        mUI:Reload("Debuff Colors")
                    end
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.debuffcolors
                end,
                order = 21.7
            },
            buffsize = {
                name = "Buff Size",
                desc = "Set the Size of Buffs on Unitframes (Target / Focus)",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                hidden = function()
                    return not mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.buffsize = val
                    Unitframes.Theme:UpdateAllUnitframeAuraSizes()
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.buffsize
                end,
                order = 22
            },
            debuffsize = {
                name = "Debuff Size",
                desc = "Set the Size of Debuffs on Unitframes (Target / Focus)",
                type = "range",
                min = 0,
                max = 30,
                step = 1,
                hidden = function()
                    return not mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.debuffsize = val
                    Unitframes.Theme:UpdateAllUnitframeAuraSizes()
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.debuffsize
                end,
                order = 23
            },
            durationTextSize = {
                name = "Cooldown Text Size",
                desc = "Scale the aura cooldown/duration text on Unitframes (Target / Focus), as a percent of the default size.",
                type = "range",
                min = 50,
                max = 200,
                step = 5,
                hidden = function()
                    return not mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.durationTextSize = val
                    Unitframes.Theme:UpdateAuraTextSizesForCategory("unitframe")
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.durationTextSize
                end,
                order = 24
            },
            countTextSize = {
                name = "Stack Count Text Size",
                desc = "Scale the aura stack count text on Unitframes (Target / Focus), as a percent of the default size.",
                type = "range",
                min = 50,
                max = 200,
                step = 5,
                hidden = function()
                    return not mUI.db.profile.unitframes.buffsdebuffs.enabled
                end,
                set = function(_, val)
                    mUI.db.profile.unitframes.buffsdebuffs.countTextSize = val
                    Unitframes.Theme:UpdateAuraTextSizesForCategory("unitframe")
                end,
                get = function()
                    return mUI.db.profile.unitframes.buffsdebuffs.countTextSize
                end,
                order = 25
            }

        }
    }

    function Unitframes:GetOptions()
        return Unitframes.layout
    end
end
