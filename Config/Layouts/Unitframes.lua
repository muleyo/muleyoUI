local Unitframes = mUI:NewModule("mUI.Config.Layouts.Unitframes")

-- Enable Layout
Unitframes:Enable()

function Unitframes:OnInitialize()
    -- Get LSM
    local LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.Unitframes")
    self.Unitframes_Textures = mUI:GetModule("mUI.Modules.Unitframes.Unitframes_Textures")
    self.Raidframes_Textures = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Textures")
    self.Color = mUI:GetModule("mUI.Modules.Unitframes.Color")
    self.Reputationcolor = mUI:GetModule("mUI.Modules.Unitframes.Reputationcolor")
    self.Combatindicator = mUI:GetModule("mUI.Modules.Unitframes.Combatindicator")
    self.Hitindicator = mUI:GetModule("mUI.Modules.Unitframes.Hitindicator")
    self.Totemicons = mUI:GetModule("mUI.Modules.Unitframes.Totemicons")
    self.Pvpbadge = mUI:GetModule("mUI.Modules.Unitframes.Pvpbadge")
    self.Cornericon = mUI:GetModule("mUI.Modules.Unitframes.Cornericon")
    self.Name = mUI:GetModule("mUI.Modules.Unitframes.Name")
    self.Level = mUI:GetModule("mUI.Modules.Unitframes.Level")
    self.Classbar = mUI:GetModule("mUI.Modules.Unitframes.Classbar")
    self.BuffsDebuffs = mUI:GetModule("mUI.Modules.Unitframes.BuffsDebuffs")

    -- Initialize Layout
    self.layout = {
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
                desc = "|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.enabled = val

                    if val then
                        mUI:Reload('Enable Unitframes Module')
                    else
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
                values = LSM:HashTable("statusbar"),
                dialogControl = 'LSM30_Statusbar',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.unitframes = val

                    if not self.Module:IsEnabled() then return end

                    if val == "None" then
                        self.Unitframes_Textures:Disable()
                        self.Unitframes_Textures:Update()
                    else
                        self.Unitframes_Textures:Enable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.textures.unitframes end,
                order = 3
            },
            textures_raidframes = {
                name = "Party / Raidframes",
                desc = "Select a Texture for the Party / Raidframes",
                type = "select",
                values = LSM:HashTable("statusbar"),
                dialogControl = 'LSM30_Statusbar',
                set = function(_, val)
                    mUI.db.profile.unitframes.textures.raidframes = val

                    if not self.Module:IsEnabled() then return end

                    if val == "None" then
                        self.Raidframes_Textures:Disable()
                        self.Raidframes_Textures:Update()
                    else
                        self.Raidframes_Textures:Enable()
                        self.Raidframes_Textures:Update()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Color:Enable()
                    else
                        self.Color:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        mUI.db.profile.unitframes.reputationcolor = false
                        if self.Reputationcolor:IsEnabled() then
                            self.Reputationcolor:Update("player", true)
                        else
                            self.Reputationcolor:Enable()
                        end
                    else
                        self.Reputationcolor:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        mUI.db.profile.unitframes.playerrepcolor = false
                        if self.Reputationcolor:IsEnabled() then
                            self.Reputationcolor:Update("hide", true)
                        else
                            self.Reputationcolor:Enable()
                        end
                    else
                        self.Reputationcolor:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Combatindicator:Enable()
                    else
                        self.Combatindicator:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Pvpbadge:Enable()
                    else
                        self.Pvpbadge:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Hitindicator:Enable()
                    else
                        self.Hitindicator:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Totemicons:Enable()
                    else
                        self.Totemicons:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Classbar:Enable()
                    else
                        self.Classbar:Disable()
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Cornericon:Enable()
                    else
                        self.Cornericon:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.cornericon end,
                order = 14
            },
            name = {
                name = "Hide Name",
                desc = "Hide Names on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.name = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Name:Enable()
                    else
                        self.Name:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.name end,
                order = 15
            },
            level = {
                name = "Hide Level",
                desc = "Hide Level Text on Unitframes",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.unitframes.level = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Level:Enable()
                    else
                        self.Level:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.level end,
                order = 16
            },
            header3 = {
                name = "Buffs & Debuffs",
                type = "header",
                order = 17
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

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.BuffsDebuffs:Enable()
                    else
                        self.BuffsDebuffs:Disable()
                    end
                end,
                get = function() return mUI.db.profile.unitframes.buffsdebuffs.enabled end,
                order = 18
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
                order = 19
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
                order = 20
            }
        }
    }
end

function Unitframes:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
