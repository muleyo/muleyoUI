local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

-- Enable Layout
Nameplates:Enable()

function Nameplates:OnInitialize()
    -- Get LSM
    self.LSM = LibStub("LibSharedMedia-3.0")

    self.npc = mUI:GetModule("mUI.Config.Layouts.NPCColors")

    -- Load ACD
    local ACD = LibStub("AceConfigDialog-3.0")

    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.Nameplates")

    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.nameplates.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.enabled = val

                    if val then
                        self.Module:Enable()
                        mUI:Reload('Enable Nameplates Module')
                    else
                        self.Module:Disable()
                        mUI:Reload('Disable Nameplates Module')
                    end
                end,
                get = function() return mUI.db.profile.nameplates.enabled end,
                order = 1
            },
            header1 = {
                name = "Nameplates",
                type = "header",
                order = 2
            },
            texture = {
                name = "Texture",
                desc = "Select a Texture for the Nameplates",
                type = "select",
                values = self.LSM:HashTable("statusbar"),
                dialogControl = 'LSM30_Statusbar',
                set = function(_, val)
                    mUI.db.profile.nameplates.texture = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Textures:RefreshNameplates()
                end,
                get = function() return mUI.db.profile.nameplates.texture end,
                order = 3
            },
            decimals = {
                name = "Healthtext Decimals",
                desc = "Set the amount of Decimals for the Health Text\n\n0 = 100%\n1 = 100.0%\n2 = 100.00%",
                type = "range",
                min = 0,
                max = 2,
                step = 1,
                set = function(_, val)
                    mUI.db.profile.nameplates.decimals = val

                    if not self.Module:IsEnabled() then return end
                    if not mUI.db.profile.nameplates.healthtext then return end

                    self.Module.Health:RefreshNameplates()
                end,
                get = function() return mUI.db.profile.nameplates.decimals end,
                order = 4
            },
            height = {
                name = "Height",
                desc = "Set the Height of the Nameplates",
                type = "range",
                min = 1,
                max = 5,
                step = 0.1,
                set = function(_, val)
                    mUI.db.profile.nameplates.height = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Options:Update()
                end,
                get = function() return mUI.db.profile.nameplates.height end,
                order = 5
            },
            width = {
                name = "Width",
                desc = "Set the Width of the Nameplates",
                type = "range",
                min = 0.5,
                max = 2,
                step = 0.1,
                set = function(_, val)
                    mUI.db.profile.nameplates.width = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Options:Update()
                end,
                get = function() return mUI.db.profile.nameplates.width end,
                order = 6
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 7
            },
            healthtext = {
                name = "Health Text",
                desc = "Show Health Percentage on Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.healthtext = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Health:RefreshNameplates()
                    else
                        self.Module.Health:RefreshNameplates()
                    end
                end,
                get = function() return mUI.db.profile.nameplates.healthtext end,
                order = 8
            },
            classcolor = {
                name = "Names in Class Color",
                desc = "Show Player Names in Class Colors",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.classcolor = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Names:RefreshNameplates()
                    else
                        self.Module.Names:RefreshNameplates()
                    end
                end,
                get = function() return mUI.db.profile.nameplates.classcolor end,
                order = 9
            },
            servername = {
                name = "Hide Server Names",
                desc = "Hide Server Names on Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.servername = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Names:RefreshNameplates()
                    else
                        self.Module.Names:RefreshNameplates()
                    end
                end,
                get = function() return mUI.db.profile.nameplates.servername end,
                order = 10
            },
            arena = {
                name = "Arena Numbers",
                desc = "Show arena1/2/3 instead of enemy Player Names in Arenas",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.arena = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Names:RefreshNameplates()
                    else
                        self.Module.Names:RefreshNameplates()
                    end
                end,
                get = function() return mUI.db.profile.nameplates.arena end,
                order = 11
            },
            totem = {
                name = "Totem Icons",
                desc = "Show Totem Icons on Nameplates",
                type = "toggle",
                set = function(_, val) mUI.db.profile.nameplates.totem = val end,
                get = function() return mUI.db.profile.nameplates.totem end,
                order = 12
            },
            casttime = {
                name = "Cast Time",
                desc = "Show Cast Time below the Cast Icon on Nameplates",
                type = "toggle",
                set = function(_, val) mUI.db.profile.nameplates.casttime = val end,
                get = function() return mUI.db.profile.nameplates.casttime end,
                order = 13
            },
            focus = {
                name = "Focus Highlight",
                desc = "Highlight the Nameplate of your Focus Target with a different texture",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.focus = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Textures:RefreshNameplates()
                    else
                        self.Module.Textures:RefreshNameplates()
                    end
                end,
                get = function() return mUI.db.profile.nameplates.focus end,
                order = 14
            },
            debuffs = {
                name = "Hide Debuffs",
                desc = "Hide Debuffs on Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.debuffs = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Debuffs:RefreshNameplates()
                end,
                get = function() return mUI.db.profile.nameplates.debuffs end,
                order = 15
            },
            smallerfriends = {
                name = "Small Friendly Plates",
                desc = "Make Friendly Nameplates smaller than Enemy Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.smallerfriends = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Options:Update()
                end,
                get = function() return mUI.db.profile.nameplates.smallerfriends end,
                order = 16
            },
            header3 = {
                name = "PVE Options",
                type = "header",
                order = 17
            },
            smartstacking = {
                name = "Smart Stacking",
                desc = "Makes it easier to target Nameplates and have an overall better visibility",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.smartstacking = val

                    if not self.Module:IsEnabled() then return end

                    self.Module.Options:Update()
                end,
                get = function() return mUI.db.profile.nameplates.smartstacking end,
                order = 18
            },
            colors = {
                name = "NPC Colors",
                desc =
                "Enable/Disable custom colors.\n\n|cffffff00Info:|r Colors for NPCs can be edited by clicking on the 'Change NPC Colors' Button",
                type = "toggle",
                set = function(_, val) mUI.db.profile.nameplates.colors = val end,
                get = function() return mUI.db.profile.nameplates.colors end,
                order = 19
            },
            npccolors = {
                name = "Change NPC Colors",
                desc = "Change the Colors of NPCs",
                type = "execute",
                func = function()
                    mUIOptions.container:ReleaseChildren()
                    ACD:Open("mUIOptions_NPCColors_Tab", mUIOptions.container)
                end,
                order = 20
            }
        }
    }
end

function Nameplates:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
