local General = mUI:NewModule("mUI.Config.Layouts.General")

function General:OnEnable()
    -- Initialize Database
    local db = mUI.db.profile.general

    -- Get Modules
    local Theme = mUI:GetModule("mUI.Modules.General.Theme")

    local layout = {
        type = "group",
        args = {
            enable = {
                name = "Enable",
                desc = "Enable / Disable Module",
                type = "toggle",
                set = function(_, val) db.enabled = val end,
                get = function() return db.enabled end,
                order = 1
            },
            header1 = {
                name = "General",
                type = "header",
                order = 2
            },
            theme = {
                name = "Theme",
                desc =
                "Disabled = No theme\nDark = Dark theme\nClass = Class colored theme\nCustom = Custom colored theme",
                type = "select",
                style = "radio",
                values = {
                    ["Disabled"] = "Disabled",
                    ["Dark"] = "Dark",
                    ["Class"] = "Class",
                    ["Custom"] = "Custom"
                },
                sorting = {
                    "Disabled",
                    "Dark",
                    "Class",
                    "Custom"
                },
                width = 0.5,
                set = function(_, val)
                    db.theme = val
                    if val == "Disabled" and Theme:IsEnabled() then
                        Theme:Disable()
                    else
                        if not Theme:IsEnabled() then
                            Theme:Enable()
                        else
                            Theme:Update()
                        end
                    end
                end,
                get = function() return db.theme end,
                order = 3
            },
            color = {
                name = "Custom Color",
                desc = "Choose a color for the Custom Theme",
                type = "color",
                hasAlpha = true,
                set = function(_, r, g, b, a)
                    db.color = { r, g, b, a }

                    if db.theme == "Custom" then
                        if not Theme:IsEnabled() then
                            Theme:Enable()
                        else
                            Theme:Update()
                        end
                    end
                end,
                get = function()
                    return db.color[1], db.color[2], db.color[3], db.color[4]
                end,
                order = 4
            },
            font = {
                name = "Font",
                desc = "Choose a Font you like\n\n|cffff0000WARNING:|r This Font will be used for any kind of Text",
                type = "select",
                values = {
                    ["Arial"] = "Arial",
                    ["Calibri"] = "Calibri",
                    ["Comic Sans MS"] = "Comic Sans MS",
                    ["Consolas"] = "Consolas",
                    ["Courier New"] = "Courier New",
                    ["DejaVu Sans"] = "DejaVu Sans",
                    ["Georgia"] = "Georgia",
                    ["Impact"] = "Impact",
                    ["Lucida Console"] = "Lucida Console",
                    ["Tahoma"] = "Tahoma",
                    ["Times New Roman"] = "Times New Roman",
                    ["Trebuchet MS"] = "Trebuchet MS",
                    ["Verdana"] = "Verdana"
                },
                set = function(_, val) db.font = val end,
                get = function() return db.font end,
                order = 5
            },
            header2 = {
                name = "Automation",
                type = "header",
                order = 6
            },
            repair = {
                name = "Repair Equipment",
                desc = "Repair your gear automatically when visiting a vendor",
                type = "select",
                style = "radio",
                values = {
                    ["Disabled"] = "Disabled",
                    ["Personal"] = "Personal",
                    ["Guild"] = "Guild"
                },
                sorting = {
                    "Disabled",
                    "Personal",
                    "Guild"
                },
                width = 0.5,
                set = function(_, val) db.automation.repair = val end,
                get = function() return db.automation.repair end,
                order = 7
            },
            sell = {
                name = "Auto Sell",
                desc = "Sell grey items automatically when visiting a vendor",
                type = "toggle",
                set = function(_, val) db.automation.sell = val end,
                get = function() return db.automation.sell end,
                order = 8
            },
            delete = {
                name = "Quick Delete",
                desc = "Inserts 'DELETE' when deleting Rare+ items",
                type = "toggle",
                set = function(_, val) db.automation.delete = val end,
                get = function() return db.automation.delete end,
                order = 9
            },
            duel = {
                name = "Duel",
                desc = "Decline duel requests automatically",
                type = "toggle",
                set = function(_, val) db.automation.duel = val end,
                get = function() return db.automation.duel end,
                order = 10
            },
            release = {
                name = "Release",
                desc = "Release spirit automatically when you died",
                type = "toggle",
                set = function(_, val) db.automation.release = val end,
                get = function() return db.automation.release end,
                order = 11
            },
            resurrect = {
                name = "Resurrection",
                desc = "Accept resurrections automatically",
                type = "toggle",
                set = function(_, val) db.automation.resurrect = val end,
                get = function() return db.automation.resurrect end,
                order = 12
            },
            invite = {
                name = "Invite",
                desc = "Accept group invites from friends and guild members automatically",
                type = "toggle",
                set = function(_, val) db.automation.invite = val end,
                get = function() return db.automation.invite end,
                order = 13
            },
            cinematic = {
                name = "Cinematic",
                desc = "Skip cinematics automatically",
                type = "toggle",
                set = function(_, val) db.automation.cinematic = val end,
                get = function() return db.automation.cinematic end,
                order = 14
            },
            talkinghead = {
                name = "Talking Head",
                desc = "Hide the TalkingHead Frame automatically",
                type = "toggle",
                set = function(_, val) db.automation.talkinghead = val end,
                get = function() return db.automation.talkinghead end,
                order = 15
            },
            header3 = {
                name = "Display",
                type = "header",
                order = 16
            },
            iteminfo = {
                name = "Item Info",
                desc = "Display item information on items and tooltips",
                type = "toggle",
                set = function(_, val) db.display.iteminfo = val end,
                get = function() return db.display.iteminfo end,
                order = 17
            },
            stats = {
                name = "Stats",
                desc = "Display current FPS/MS on the screen",
                type = "toggle",
                set = function(_, val) db.display.stats = val end,
                get = function() return db.display.stats end,
                order = 18
            },
            movementspeed = {
                name = "Movement Speed",
                desc = "Display current movement speed on the screen",
                type = "toggle",
                set = function(_, val) db.movementspeed = val end,
                get = function() return db.movementspeed end,
                order = 19
            },
            errormessages = {
                name = "Error Messages",
                desc = "Display error messages (Out of range etc.)",
                type = "toggle",
                set = function(_, val) db.display.errormessages = val end,
                get = function() return db.display.errormessages end,
                order = 20
            },
            friendlist = {
                name = "Friendlist Class Colors",
                desc = "Display Character Names in Class Colors on the Friendlist",
                type = "toggle",
                set = function(_, val) db.display.friendlist = val end,
                get = function() return db.display.friendlist end,
                order = 21
            }
        }
    }

    function self:GetOptions()
        return layout
    end
end
