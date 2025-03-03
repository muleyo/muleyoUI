local Chat = mUI:NewModule("mUI.Config.Layouts.Chat")

function Chat:OnInitialize()
    -- Load LSM
    Chat.LSM = LibStub("LibSharedMedia-3.0")

    -- Get Modules
    Chat.Module = mUI:GetModule("mUI.Modules.Chat")

    -- Initialize Layout
    Chat.layout = {
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
                set = function(_, val)
                    mUI.db.profile.chat.enabled = val
                    if val then
                        Chat.Module:Enable()
                        mUI:Reload('Enable Chat Module')
                    else
                        Chat.Module:Disable()
                        mUI:Reload("Disable Chat Module")
                    end
                end,
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
                desc = "Select a Style for the Chat\n\n|cffffff00Info:|r Requires Reload",
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
                set = function(_, val)
                    if mUI.db.profile.chat.style == val then return end

                    mUI.db.profile.chat.style = val

                    if not mUI.db.profile.chat.enabled then return end

                    if val == "mUI" then
                        mUI:Reload("Change Chat Style")
                    else
                        mUI:Reload("Change Chat Style")
                    end
                end,
                get = function() return mUI.db.profile.chat.style end,
                order = 3
            },
            header2 = {
                name = "EditBox",
                type = "header",
                order = 4
            },
            position = {
                name = "Position",
                desc = "Set the Position of the Chat EditBox\n\n|cffffff00Info:|r Requires mUI Style",
                type = "select",
                values = {
                    ["top"] = "Top",
                    ["bottom"] = "Bottom"
                },
                sorting = {
                    "top",
                    "bottom"
                },
                width = 0.5,
                set = function(_, val)
                    mUI.db.profile.chat.settings.edit.position = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxPosition()
                end,
                get = function() return mUI.db.profile.chat.settings.edit.position end,
                order = 5
            },
            offset = {
                name = "Offset",
                desc = "Set the Offset for the Chat EditBox\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 0,
                max = 64,
                step = 1,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.edit.offset == val then return end
                    mUI.db.profile.chat.settings.edit.offset = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxPosition()
                end,
                get = function() return mUI.db.profile.chat.settings.edit.offset end,
                order = 6
            },
            editalpha = {
                name = "Background Alpha",
                desc = "Set the Background Alpha for the Chat EditBox\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 0,
                max = 1,
                step = 0.1,
                set = function(_, val)
                    mUI.db.profile.chat.settings.edit.alpha = val
                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxAlpha()
                end,
                get = function() return mUI.db.profile.chat.settings.edit.alpha end,
                order = 7
            },
            editfontsize = {
                name = "Font Size",
                desc = "Set the Font Size for the Chat EditBox\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 10,
                max = 20,
                step = 1,
                get = function(info) return mUI.db.profile.chat.settings.edit.font.size end,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.edit.font.size == val then return end
                    mUI.db.profile.chat.settings.edit.font.size = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxFont()
                end,
                order = 8
            },
            editfontoutline = {
                name = "Font Outline",
                desc = "Enable/Disable EditBox Font Outline\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                width = 0.7,
                set = function(_, val)
                    mUI.db.profile.chat.settings.edit.font.outline = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxFont()
                end,
                get = function() return mUI.db.profile.chat.settings.edit.font.outline end,
                order = 9
            },
            editfontshadow = {
                name = "Font Shadow",
                desc = "Enable/Disable EditBox Font Shadow\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                width = 0.7,
                set = function(_, val)
                    mUI.db.profile.chat.settings.edit.font.shadow = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxFont()
                end,
                get = function() return mUI.db.profile.chat.settings.edit.font.shadow end,
                order = 10
            },
            header3 = {
                name = "Chat Frame",
                type = "header",
                order = 11
            },
            chatalpha = {
                name = "Chat Background Alpha",
                desc = "Set the Background Alpha for the Chat\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 0,
                max = 1,
                step = 0.1,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.chat.alpha == val then return end
                    mUI.db.profile.chat.settings.chat.alpha = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdateGradientBackgroundAlpha")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.alpha end,
                order = 12
            },
            hpadding = {
                name = "Horizontal Padding",
                desc = "Set the Horizontal Padding for the Chat\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 0,
                max = 10,
                step = 1,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.chat.x_padding == val then return end
                    mUI.db.profile.chat.settings.chat.x_padding = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdatePadding")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.x_padding end,
                order = 13
            },
            vpadding = {
                name = "Vertical Padding",
                desc = "Set the Vertical Padding for the Chat\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 0,
                max = 10,
                step = 1,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.chat.y_padding == val then return end
                    mUI.db.profile.chat.settings.chat.y_padding = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdatePadding")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.y_padding end,
                order = 14
            },
            chatfontsize = {
                name = "Chat Font Size",
                desc = "Set the Font Size for the Chat\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 10,
                max = 20,
                step = 1,
                set = function(_, val)
                    if mUI.db.profile.chat.settings.chat.font.size == val then return end
                    mUI.db.profile.chat.settings.chat.font.size = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateMessageFonts()

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdateHeight")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.font.size end,
                order = 15
            },
            spacer = {
                name = " ",
                type = "description",
                order = 16
            },
            chatfontoutline = {
                name = "Font Outline",
                desc = "Enable/Disable Chat Font Outline\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.settings.chat.font.outline = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxFont()
                    Chat.Module.Style:UpdateMessageFonts()

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdateHeight")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.font.outline end,
                order = 17
            },
            chatfontshadow = {
                name = "Font Shadow",
                desc = "Enable/Disable Chat Font Shadow\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.settings.chat.font.shadow = val


                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    Chat.Module.Style:UpdateEditBoxFont()
                    Chat.Module.Style:UpdateMessageFonts()

                    for i = 1, 10 do
                        Chat.Module.Style:ForMessageLinePool(i, "UpdateHeight")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.chat.font.shadow end,
                order = 18
            },
            smooth = {
                name = "Smooth Scrolling",
                desc = "Enable/Disable Smooth Scrolling\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.settings.smooth = val end,
                get = function() return mUI.db.profile.chat.settings.smooth end,
                order = 19
            },
            tooltips = {
                name = "Mouseover Tooltips",
                desc = "Enable/Disable Mouseover for Chat Tooltips\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val) mUI.db.profile.chat.settings.tooltips = val end,
                get = function() return mUI.db.profile.chat.settings.tooltips end,
                order = 20
            },
            scroll = {
                name = "Scroll Buttons",
                desc = "Enable/Disable Chat Scroll Buttons\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.settings.buttons.up_and_down = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    for i = 1, 10 do
                        Chat.Module.Style:ForChatFrame(i, "ToggleScrollButtons")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.buttons.up_and_down end,
                order = 21
            },
            header4 = {
                name = "Fading",
                type = "header",
                order = 22
            },
            fading = {
                name = "Enable Fading",
                desc = "Enable/Disable fading Chat Messages\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.settings.fade.enabled = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    if value then
                        for i = 1, 10 do
                            Chat.Module.Style:ForChatFrame(i, "ResetFadingTimer")
                            Chat.Module.Style:ForChatFrame(i, "UpdateFading")
                        end
                    else
                        for i = 1, 10 do
                            Chat.Module.Style:ForChatFrame(i, "FadeInMessages")
                        end
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.fade.enabled end,
                order = 23
            },
            fadetabs = {
                name = "Tabs & Buttons Fading",
                desc = "Enable/Disable Chat Fading\n\n|cffffff00Info:|r Requires mUI Style",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.settings.dock.fade.enabled = val

                    if not (mUI.db.profile.chat.style == "mUI" or Chat.Module:IsEnabled()) then return end

                    for i = 1, 10 do
                        Chat.Module.Style:ForChatFrame(i, "FadeInChatWidgets")
                    end
                end,
                get = function() return mUI.db.profile.chat.settings.dock.fade.enabled end,
                order = 23
            },
            fadingtime = {
                name = "Fade Out Delay",
                desc = "Set the Fade Out Delay for the Chat Messages\n\n|cffffff00Info:|r Requires mUI Style",
                type = "range",
                min = 10,
                max = 240,
                step = 1,
                set = function(_, val) mUI.db.profile.chat.settings.fade.out_delay = val end,
                get = function() return mUI.db.profile.chat.settings.fade.out_delay end,
                order = 24
            },
            header5 = {
                name = "Options",
                type = "header",
                order = 25
            },
            link = {
                name = "Link Copy",
                desc = "Make Links clickable to copy them",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.link = val


                    if not Chat.Module:IsEnabled() then return end

                    if val then
                        Chat.Module.Link:Enable()
                    else
                        Chat.Module.Link:Disable()
                    end
                end,
                get = function() return mUI.db.profile.chat.link end,
                order = 26
            },
            copy = {
                name = "Copy Chat",
                desc = "Enable / Disable Copying of Chat History",
                type = "toggle",
                set = function(_, val)
                    mUI.db.profile.chat.copy = val

                    if not Chat.Module:IsEnabled() then return end

                    if val then
                        Chat.Module.Copy:Enable()
                    else
                        Chat.Module.Copy:Disable()
                    end
                end,
                get = function() return mUI.db.profile.chat.copy end,
                order = 27
            }
        }
    }

    function Chat:GetOptions()
        return Chat.layout
    end
end
