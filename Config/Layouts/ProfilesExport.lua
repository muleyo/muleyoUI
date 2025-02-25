local ProfilesExport = mUI:NewModule("mUI.Config.Layouts.ProfilesExport")

function ProfilesExport:OnInitialize()
    -- Load Libraries
    local ACD = LibStub("AceConfigDialog-3.0")

    -- Get Modules
    ProfilesExport.Modules = mUI:GetModule("mUI.Modules.Profiles")

    -- Initialize Layout
    ProfilesExport.layout = {
        type = "group",
        args = {
            header1 = {
                name = "Export Profile",
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
                name = "Export String",
                desc = "",
                type = "input",
                multiline = 12,
                get = function()
                    return ProfilesExport.Modules.Export:ExportProfile()
                end,
                set = function() end,
                width = "full",
                order = 3
            },
        }
    }

    function ProfilesExport:GetOptions()
        return ProfilesExport.layout
    end
end
