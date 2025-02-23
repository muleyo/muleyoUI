local Chat = mUI:NewModule("mUI.Config.Layouts.Chat")

-- Enable Layout
Chat:Enable()

function Chat:OnInitialize()
    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enabled = {
                name = function()
                    if mUI.db.profile.chat.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.enabled = val end,
                get = function() return mUI.db.profile.chat.enabled end,
                order = 1
            },
            header1 = {
                name = "Chat",
                type = "header",
                order = 2
            },
            style = {
                name = "Style",
                desc = "Select a Style for the Chat",
                type = "select",
                style = "radio",
                values = {
                    ["Default"] = "Default",
                    ["mUI"] = "mUI Style"
                },
                sorting = {
                    "Default",
                    "mUI"
                },
                width = 0.5,
                set = function(_, val) mUI.db.profile.chat.style = val end,
                get = function() return mUI.db.profile.chat.style end,
                order = 3
            },
            header2 = {
                name = "Options",
                type = "header",
                order = 4
            },
            input = {
                name = "Input on Top",
                desc = "Display the Input Box on Top of the Chat",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.input = val end,
                get = function() return mUI.db.profile.chat.input end,
                order = 5
            },
            link = {
                name = "Link Copy",
                desc = "Make Links clickable to copy them",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.link = val end,
                get = function() return mUI.db.profile.chat.link end,
                order = 6
            },
            copy = {
                name = "Copy Chat",
                desc = "Enable / Disable Copying of Chat History",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.copy = val end,
                get = function() return mUI.db.profile.chat.copy end,
                order = 7
            },
            friendlist = {
                name = "Friendlist Button",
                desc = "Show/Hide Friendlist Button",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.friendlist = val end,
                get = function() return mUI.db.profile.chat.friendlist end,
                order = 8
            }
        }
    }
end

function Chat:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
