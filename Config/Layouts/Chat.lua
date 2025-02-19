local Chat = mUI:NewModule("mUI.Config.Layouts.Chat")

function Chat:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.chat

    local layout = {
        type = "group",
        args = {
            enabled = {
                name = "Enable",
                desc = "Enable / Disable Module",
                type = "toggle",
                set = function(_, val) db.enabled = val end,
                get = function() return db.enabled end,
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
                set = function(_, val) db.style = val end,
                get = function() return db.style end,
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
                set = function(_, val) db.input = val end,
                get = function() return db.input end,
                order = 5
            },
            link = {
                name = "Link Copy",
                desc = "Make Links clickable to copy them",
                type = "toggle",
                set = function(_, val) db.link = val end,
                get = function() return db.link end,
                order = 6
            },
            copy = {
                name = "Copy Chat",
                desc = "Enable / Disable Copying of Chat History",
                type = "toggle",
                set = function(_, val) db.copy = val end,
                get = function() return db.copy end,
                order = 7
            },
            friendlist = {
                name = "Friendlist Button",
                desc = "Show/Hide Friendlist Button",
                type = "toggle",
                set = function(_, val) db.friendlist = val end,
                get = function() return db.friendlist end,
                order = 8
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
