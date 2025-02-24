local General = mUI:NewModule("mUI.Config.Layouts.General")

-- Enable Layout
General:Enable()

function General:OnInitialize()
    -- Load LSM
    self.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    self.Module = mUI:GetModule("mUI.Modules.General")

    -- Initialize Layout
    self.layout = {
        type = "group",
        args = {
            enable = {
                name = function()
                    if mUI.db.profile.general.enabled then
                        return "|cFF00FF00Enabled|r"
                    else
                        return "|cFFFF0000Disabled|r"
                    end
                end,
                desc = "Enable / Disable Module\n\n|cffffff00Info:|r Requires Reload",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.enabled = val

                    if val then
                        self.Module:Enable()
                        mUI:Reload('Enable General Module')
                    else
                        self.Module:Disable()
                        mUI:Reload('Disable General Module')
                    end
                end,
                get = function() return mUI.db.profile.general.enabled end,
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
                    if mUI.db.profile.general.theme == val then return end
                    mUI.db.profile.general.theme = val

                    if not self.Module:IsEnabled() then return end

                    if val == "Disabled" then
                        self.Module.Theme:Disable()
                    else
                        if not self.Module.Theme:IsEnabled() then
                            self.Module.Theme:Enable()
                        else
                            self.Module.Theme:Update()
                        end
                    end
                end,
                get = function() return mUI.db.profile.general.theme end,
                order = 3
            },
            color = {
                name = "Custom Color",
                desc = "Choose a color for the Custom Theme",
                type = "color",
                hasAlpha = true,
                set = function(_, r, g, b, a)
                    if mUI.db.profile.general.color == { r, g, b, a } then return end
                    mUI.db.profile.general.color = { r, g, b, a }

                    if not self.Module:IsEnabled() then return end

                    if mUI.db.profile.general.theme == "Custom" then
                        if not self.Module.Theme:IsEnabled() then
                            self.Module.Theme:Enable()
                        else
                            self.Module.Theme:Update()
                        end
                    end
                end,
                get = function()
                    return mUI.db.profile.general.color[1], mUI.db.profile.general.color[2],
                        mUI.db.profile.general.color[3], mUI.db.profile.general.color[4]
                end,
                order = 4
            },
            font = {
                name = "Font",
                desc = "Choose a Font you like\n\n|cffffff00Info:|r Requires Reload.",
                type = "select",
                values = self.LSM:HashTable("font"),
                dialogControl = 'LSM30_Font',
                set = function(_, val)
                    mUI.db.profile.general.font = val
                    self.Module.Font:Update()
                    mUI:Reload("Changed Font")
                end,
                get = function() return mUI.db.profile.general.font end,
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
                set = function(_, val)
                    if mUI.db.profile.general.automation.repair == val then return end
                    mUI.db.profile.general.automation.repair = val

                    if not self.Module:IsEnabled() then return end

                    if val == "Disabled" and self.Module.Repair:IsEnabled() then
                        self.Module.Repair:Disable()
                    else
                        if not self.Module.Repair:IsEnabled() then
                            self.Module.Repair:Enable()
                        else
                            self.Module.Repair:Update()
                        end
                    end
                end,
                get = function() return mUI.db.profile.general.automation.repair end,
                order = 7
            },
            sell = {
                name = "Auto Sell",
                desc = "Sell grey items automatically when visiting a vendor",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.sell = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Sell:Enable()
                    else
                        self.Module.Sell:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.sell end,
                order = 8
            },
            delete = {
                name = "Quick Delete",
                desc = "Inserts 'DELETE' when deleting Rare+ items",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.delete = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Delete:Enable()
                    else
                        self.Module.Delete:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.delete end,
                order = 9
            },
            duel = {
                name = "Duel",
                desc = "Decline duel requests automatically",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.duel = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Duel:Enable()
                    else
                        self.Module.Duel:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.duel end,
                order = 10
            },
            release = {
                name = "Release",
                desc = "Release spirit automatically when you died",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.release = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Release:Enable()
                    else
                        self.Module.Release:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.release end,
                order = 11
            },
            resurrect = {
                name = "Resurrection",
                desc = "Accept resurrections automatically",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.resurrect = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Resurrection:Enable()
                    else
                        self.Module.Resurrection:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.resurrect end,
                order = 12
            },
            invite = {
                name = "Invite",
                desc = "Accept group invites from friends and guild members automatically",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.invite = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Invite:Enable()
                    else
                        self.Module.Invite:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.invite end,
                order = 13
            },
            cinematic = {
                name = "Cinematic",
                desc = "Skip cinematics and movies automatically",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.cinematic = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Cinematic:Enable()
                    else
                        self.Module.Cinematic:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.cinematic end,
                order = 14
            },
            talkinghead = {
                name = "Talking Head",
                desc = "Hide the TalkingHead Frame automatically",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.automation.talkinghead = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.TalkingHead:Enable()
                    else
                        self.Module.TalkingHead:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.automation.talkinghead end,
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
                set = function(_, val)
                    mUI.db.profile.general.display.iteminfo = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.ItemInfo:Enable()
                    else
                        self.Module.ItemInfo:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.display.iteminfo end,
                order = 17
            },
            stats = {
                name = "Stats",
                desc = "Display current FPS/MS on the screen",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.display.stats = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Stats:Enable()
                    else
                        self.Module.Stats:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.display.stats end,
                order = 18
            },
            movementspeed = {
                name = "Speed",
                desc =
                "Display current movement speed on the screen\n\n|cffffff00Info:|r 'Stats' must be enabled for this feature",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.display.movementspeed = val
                end,
                get = function() return mUI.db.profile.general.display.movementspeed end,
                order = 19
            },
            errormessages = {
                name = "Error Messages",
                desc = "Hide Error Messages (Out of range etc.)",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.display.errormessages = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.ErrorMessages:Enable()
                    else
                        self.Module.ErrorMessages:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.display.errormessages end,
                order = 20
            },
            friendlist = {
                name = "Friends Class Colors",
                desc = "Display Character Names in Class Colors on the Friendlist",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.general.display.friendlist = val

                    if not self.Module:IsEnabled() then return end

                    if val then
                        self.Module.Friendlist:Enable()
                    else
                        self.Module.Friendlist:Disable()
                    end
                end,
                get = function() return mUI.db.profile.general.display.friendlist end,
                order = 21
            }
        }
    }
end

function General:OnEnable()
    function self:GetOptions()
        return self.layout
    end
end
