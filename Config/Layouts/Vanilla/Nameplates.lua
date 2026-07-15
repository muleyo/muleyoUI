local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

function Nameplates:OnInitialize()
    -- Load Libraries
    Nameplates.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Nameplates.Module = mUI:GetModule("mUI.Modules.Nameplates")

    -- Initialize Layout
    Nameplates.layout = {
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
                        Nameplates.Module:Enable()
                        mUI:Reload('Enable Nameplates Module')
                    else
                        Nameplates.Module:Disable()
                        mUI:Reload('Disable Nameplates Module')
                    end
                end,
                get = function()
                    return mUI.db.profile.nameplates.enabled
                end,
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
                values = Nameplates.LSM:HashTable("statusbar"),
                dialogControl = 'mUI_LSM30_Status',
                set = function(_, val)
                    mUI.db.profile.nameplates.texture = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    Nameplates.Module.Textures:RefreshNameplates(true)
                end,
                get = function()
                    return mUI.db.profile.nameplates.texture
                end,
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

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end
                    if not mUI.db.profile.nameplates.healthtext then
                        return
                    end

                    Nameplates.Module.Health:RefreshNameplates()
                end,
                get = function()
                    return mUI.db.profile.nameplates.decimals
                end,
                order = 4
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 5
            },
            healthtext = {
                name = "Health Text",
                desc = "Show Health Percentage on Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.healthtext = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Nameplates.Module.Health:RefreshNameplates()
                    else
                        Nameplates.Module.Health:RefreshNameplates()
                    end
                end,
                get = function()
                    return mUI.db.profile.nameplates.healthtext
                end,
                order = 6
            },
            classcolor = {
                name = "Names in Class Color",
                desc = "Show Player Names in Class Colors",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.classcolor = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Nameplates.Module.Names:RefreshNameplates()
                    else
                        Nameplates.Module.Names:RefreshNameplates()
                    end
                end,
                get = function()
                    return mUI.db.profile.nameplates.classcolor
                end,
                order = 7
            },
            servername = {
                name = "Hide Server Names",
                desc = "Hide Server Names on Nameplates",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.servername = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Nameplates.Module.Names:RefreshNameplates()
                    else
                        Nameplates.Module.Names:RefreshNameplates()
                    end
                end,
                get = function()
                    return mUI.db.profile.nameplates.servername
                end,
                order = 8
            },
            arena = {
                name = "Arena Numbers",
                desc = "Show arena1/2/3 instead of enemy Player Names in Arenas",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.arena = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    if val then
                        Nameplates.Module.Names:RefreshNameplates()
                    else
                        Nameplates.Module.Names:RefreshNameplates()
                    end
                end,
                get = function()
                    return mUI.db.profile.nameplates.arena
                end,
                order = 9
            },
            header3 = {
                name = "PVE Options",
                type = "header",
                order = 13
            },
            smartstacking = {
                name = "Smart Stacking",
                desc = "Makes it easier to target Nameplates and have an overall better visibility",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.nameplates.smartstacking = val

                    if not Nameplates.Module:IsEnabled() then
                        return
                    end

                    Nameplates.Module.Options:Update()
                end,
                get = function()
                    return mUI.db.profile.nameplates.smartstacking
                end,
                order = 14
            }
        }
    }

    function Nameplates:GetOptions()
        return Nameplates.layout
    end
end
