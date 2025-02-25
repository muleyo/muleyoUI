local ProfilesImport = mUI:NewModule("mUI.Config.Layouts.ProfilesImport")

function ProfilesImport:OnInitialize()
    -- Load Libraries
    local ACD = LibStub("AceConfigDialog-3.0")

    -- Get Modules
    ProfilesImport.Modules = mUI:GetModule("mUI.Modules.Profiles")

    -- Initialize Layout
    ProfilesImport.layout = {
        type = "group",
        args = {
            header1 = {
                name = "Import Profile",
                type = "header",
                order = 1
            },
            back = {
                name = "Back to Profiles",
                desc = "Return to the previous menu",
                type = "execute",
                func = function()
                    mUI:SwitchSettings("mUIOptions_Profiles_Tab")
                end,
                order = 2
            },
            input = {
                name = "Paste Import String here",
                desc = "",
                type = "input",
                multiline = 12,
                get = function() end,
                set = function(_, value)
                    ProfilesImport.Modules.Import:ImportProfile(value)
                end,
                confirm = function()
                    return "Warning: Importing a profile will overwrite your current settings."
                end,
                width = "full",
                order = 3
            },
        }
    }

    function ProfilesImport:GetOptions()
        return ProfilesImport.layout
    end

    ProfilesImport:GetOptions()
end
