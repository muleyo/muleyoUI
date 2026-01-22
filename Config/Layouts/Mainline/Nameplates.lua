local Nameplates = mUI:NewModule("mUI.Config.Layouts.Nameplates")

function Nameplates:OnInitialize()
    -- Load Libraries
    Nameplates.LSM = LibStub("LibSharedMedia-3.0")
    local ACD = LibStub("AceConfigDialog-3.0-mUI")

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
            }
        }
    }

    function Nameplates:GetOptions()
        return Nameplates.layout
    end
end
