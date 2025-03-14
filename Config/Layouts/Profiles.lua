local Profiles = mUI:NewModule("mUI.Config.Layouts.Profiles")

function Profiles:OnInitialize()
    -- Load Libraries
    local ACD = LibStub("AceConfigDialog-3.0")

    -- Get Modules
    Profiles.Module = mUI:GetModule("mUI.Modules.Profiles")

    Profiles.profiles = {}

    -- Get Profiles Function
    local function GetProfiles(info)
        local no_current = info.arg == "no_current"
        local current_profile = mUI.db:GetCurrentProfile()
        local profile_list = {}
        for k, v in pairs(mUI.db:GetProfiles(Profiles.profiles)) do
            if no_current and v == current_profile then
                -- skip
            else
                profile_list[k] = v
            end
        end
        return profile_list
    end

    -- Initialize Layout
    Profiles.layout = {
        type = "group",
        args = {
            header1 = {
                name = function()
                    local currentProfile = mUI.db:GetCurrentProfile()
                    return "Profiles (active Profile: |cff00ff00" .. currentProfile .. "|r)"
                end,
                type = "header",
                order = 1
            },
            reset = {
                name = "Reset Profile",
                desc = "Reset the current Profile back to default values\n\n|cffffff00Info:|r Requires Reload",
                type = "execute",
                confirm = true,
                func = function()
                    mUI.db:ResetProfile()
                    mUI:Reload("Reset Profile")
                    mUI:GUI()
                end,
                order = 2
            },
            newprofile_desc = {
                name = "Create a new Profile",
                type = "description",
                fontSize = "medium",
                order = 3
            },
            newprofile = {
                name = "New Profile",
                desc = "Create a new Profile\n\n|cffffff00Info:|r Requires Reload",
                type = "input",
                confirm = true,
                get = function() return "" end,
                set = function(_, value)
                    mUI.db:SetProfile(value)
                    mUI.db.profile.install = true
                    mUI:Reload("New Profile")
                end,
                order = 4
            },
            changeprofile_desc = {
                name = "Change your active Profile",
                type = "description",
                fontSize = "medium",
                order = 5
            },
            changeprofile = {
                disabled = function()
                    local profile_list = GetProfiles({ arg = "no_current" })
                    return not next(profile_list)
                end,
                name = "Change Profile",
                desc = "Change your active Profile\n\n|cffffff00Info:|r Requires Reload",
                type = "select",
                confirm = true,
                values = GetProfiles,
                set = function(_, value)
                    mUI.db:SetProfile(Profiles.profiles[value])
                    mUI:Reload("Change Profile")
                end,
                arg = "no_current",
                order = 6
            },
            copyprofile_desc = {
                name = "Copy settings from an existing profile into your current profile",
                type = "description",
                fontSize = "medium",
                order = 7
            },
            copyprofile = {
                disabled = function()
                    local profile_list = GetProfiles({ arg = "no_current" })
                    return not next(profile_list)
                end,
                name = "Copy From",
                desc = "Copy a Profile into your current Profile\n\n|cffffff00Info:|r Requires Reload",
                type = "select",
                confirm = true,
                values = GetProfiles,
                set = function(_, value)
                    mUI.db:CopyProfile(Profiles.profiles[value])
                    mUI:Reload("Copy Profile")
                end,
                arg = "no_current",
                order = 8
            },
            deleteprofile_desc = {
                name = "Delete an existing Profile",
                type = "description",
                fontSize = "medium",
                order = 9
            },
            deleteprofile = {
                disabled = function()
                    local profile_list = GetProfiles({ arg = "no_current" })
                    return not next(profile_list)
                end,
                name = "Delete a Profile",
                desc = "Deletes a Profile from the Database",
                type = "select",
                values = GetProfiles,
                set = function(_, value)
                    mUI.db:DeleteProfile(Profiles.profiles[value])
                end,
                arg = "no_current",
                confirm = true,
                confirmText = "Are you sure you want to delete the selected Profile?",
                order = 10
            },
            header2 = {
                name = "Import / Export",
                type = "header",
                order = 11
            },
            export = {
                name = "Export",
                desc = "Export your current Profile",
                type = "execute",
                func = function()
                    mUI:SwitchSettings("mUIOptions_ProfilesExport_Tab")
                end,
                order = 12
            },
            import = {
                name = "Import",
                desc = "Import a Profile",
                type = "execute",
                func = function()
                    mUI:SwitchSettings("mUIOptions_ProfilesImport_Tab")
                end,
                order = 13
            }
        }
    }

    function Profiles:GetOptions()
        return Profiles.layout
    end
end
