local Profiles = mUI:NewModule("mUI.Config.Layouts.Profiles")

function Profiles:OnInitialize()
    -- Load Libraries

    -- Get Modules
    Profiles.Module = mUI:GetModule("mUI.Modules.Profiles")

    Profiles.profiles = {}
    Profiles.importText = ""

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
            active_profile = {
                name = function()
                    local currentProfile = mUI.db:GetCurrentProfile()
                    return "Active Profile: |cff00ff00" .. currentProfile .. "|r"
                end,
                type = "description",
                fontSize = "medium",
                order = 1
            },
            header1 = {
                name = "Profile",
                type = "header",
                order = 2
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
                order = 3
            },
            newprofile_desc = {
                name = "Create a new Profile",
                type = "description",
                fontSize = "medium",
                order = 4
            },
            newprofile = {
                name = "New Profile",
                desc = "Create a new Profile\n\n|cffffff00Info:|r Requires Reload",
                type = "input",
                confirm = true,
                get = function()
                    return ""
                end,
                set = function(_, value)
                    mUI.db:SetProfile(value)
                    mUI.db.profile.install = true
                    mUI:Reload("New Profile")
                end,
                order = 5
            },
            changeprofile_desc = {
                name = "Change your active Profile",
                type = "description",
                fontSize = "medium",
                order = 6
            },
            changeprofile = {
                disabled = function()
                    local profile_list = GetProfiles({
                        arg = "no_current"
                    })
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
                order = 7
            },
            copyprofile_desc = {
                name = "Copy settings from an existing profile into your current profile",
                type = "description",
                fontSize = "medium",
                order = 8
            },
            copyprofile = {
                disabled = function()
                    local profile_list = GetProfiles({
                        arg = "no_current"
                    })
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
                order = 9
            },
            deleteprofile_desc = {
                name = "Delete an existing Profile",
                type = "description",
                fontSize = "medium",
                order = 10
            },
            deleteprofile = {
                disabled = function()
                    local profile_list = GetProfiles({
                        arg = "no_current"
                    })
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
                order = 11
            },
            header2 = {
                name = "Import",
                type = "header",
                order = 12
            },
            import_desc = {
                name = "Paste an Import String below, then click Okay to import a Profile",
                type = "description",
                fontSize = "medium",
                order = 13
            },
            import = {
                name = "Import String",
                desc = "",
                type = "input",
                multiline = 12,
                get = function()
                end,
                set = function(_, value)
                    Profiles.importText = value
                end,
                width = "full",
                order = 14
            },
            import_confirm = {
                name = "Import",
                desc = "Import the pasted Profile string\n\n|cffffff00Info:|r Overwrites your current Profile",
                type = "execute",
                disabled = function()
                    return not Profiles.importText or Profiles.importText == ""
                end,
                confirm = true,
                confirmText = "Warning: Importing a profile will overwrite your current settings. Continue?",
                func = function()
                    Profiles.Module.Import:ImportProfile(Profiles.importText)
                    Profiles.importText = ""
                end,
                order = 15
            },
            header3 = {
                name = "Export",
                type = "header",
                order = 16
            },
            export = {
                name = "Export String",
                desc = "",
                type = "input",
                multiline = 12,
                get = function()
                    return Profiles.Module.Export:ExportProfile()
                end,
                set = function()
                end,
                selectAllOnFocus = true,
                width = "full",
                order = 17
            }
        }
    }

    function Profiles:GetOptions()
        return Profiles.layout
    end
end
