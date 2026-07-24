local _, ns = ...
local EditMode = mUI:NewModule("mUI.EditMode", "AceHook-3.0")

function EditMode:OnInitialize()
    -- Load Database
    EditMode.db = mUI.db.profile.edit

    if mUI:GameVersion()["Mists"] or mUI:GameVersion()["TBC"] or mUI:GameVersion()["Vanilla"] then
        -- Load Libraries
        EditMode.LEM = ns.LibEditMode

        -- Stats Frame
        function EditMode:StatsFrame(layout, point, x, y)
            EditMode.db[layout].statsframe.point = point
            EditMode.db[layout].statsframe.x = x
            EditMode.db[layout].statsframe.y = y
        end

        -- GameTooltip
        local mUIGameTooltip = CreateFrame("Frame", "mUIGameTooltip", UIParent)
        mUIGameTooltip:SetSize(160, 90)
        mUIGameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

        EditMode:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("CENTER", mUIGameTooltip, "CENTER")
        end)

        function EditMode:GameTooltip(layout, point, x, y)
            EditMode.db[layout].gametooltip.point = point
            EditMode.db[layout].gametooltip.x = x
            EditMode.db[layout].gametooltip.y = y
        end

        EditMode.LEM:AddFrame(mUI.statsFrame, EditMode.StatsFrame)
        EditMode.LEM:AddFrame(mUIGameTooltip, EditMode.GameTooltip)

        EditMode.LEM:RegisterCallback('layout', function(layout)
            if not EditMode.db[layout] then
                EditMode.db[layout] = {
                    ["statsframe"] = {
                        ["point"] = "BOTTOMLEFT",
                        ["x"] = 0,
                        ["y"] = 0
                    },
                    ["gametooltip"] = {
                        ["point"] = "BOTTOMRIGHT",
                        ["x"] = 0,
                        ["y"] = 0
                    }
                }
            else
                if not EditMode.db[layout]["gametooltip"] then
                    EditMode.db[layout]["gametooltip"] = {
                        ["point"] = "BOTTOMRIGHT",
                        ["x"] = 0,
                        ["y"] = 0
                    }
                end
            end

            mUI.statsFrame:ClearAllPoints()
            mUI.statsFrame:SetPoint(EditMode.db[layout].statsframe.point, EditMode.db[layout].statsframe.x, EditMode.db[layout].statsframe.y)

            mUIGameTooltip:ClearAllPoints()
            mUIGameTooltip:SetPoint(EditMode.db[layout].gametooltip.point, EditMode.db[layout].gametooltip.x, EditMode.db[layout].gametooltip.y)
        end)
    elseif mUI:GameVersion()["Mainline"] then
        -- Load Libraries
        EditMode.LEM = ns.LibEditMode

        -- Create Holder Frame
        EditMode.QueueStatus = CreateFrame("Frame", "mUIQueueStatusButton", UIParent)
        EditMode.QueueStatus:SetSize(QueueStatusButton:GetWidth(), QueueStatusButton:GetHeight())
        EditMode.QueueStatus:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

        -- Set QueueStatusButton to Holder Frame
        QueueStatusButton:SetParent(EditMode.QueueStatus)
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetPoint("CENTER", EditMode.QueueStatus)
        -- Keep button centered when Blizzard tries to reposition it
        local ignoringPointHook = false
        EditMode:SecureHook(QueueStatusButton, "SetPoint", function()
            if ignoringPointHook then
                return
            end
            ignoringPointHook = true
            QueueStatusButton:ClearAllPoints()
            QueueStatusButton:SetPoint("CENTER", EditMode.QueueStatus)
            ignoringPointHook = false
        end)

        -- Desired scale for QueueStatusButton; updated by layout callback and slider.
        -- The SetScale hook below ensures Blizzard can never override this.
        local queueDesiredScale = 0.8
        EditMode:SecureHook(QueueStatusButton, "SetScale", function(self, scale)
            if scale ~= queueDesiredScale then
                self:SetScale(queueDesiredScale)
            end
        end)

        -- Stats Frame
        function EditMode:StatsFrame(layout, point, x, y)
            if not EditMode.db[layout].statsframe then
                EditMode.db[layout].statsframe = {}
            end
            EditMode.db[layout].statsframe.point = point
            EditMode.db[layout].statsframe.x = x
            EditMode.db[layout].statsframe.y = y
        end

        -- QueueStatusButton
        function EditMode:QueueIcon(layout, point, x, y)
            if not EditMode.db[layout].queueicon then
                EditMode.db[layout].queueicon = {}
            end
            EditMode.db[layout].queueicon.point = point
            EditMode.db[layout].queueicon.x = x
            EditMode.db[layout].queueicon.y = y
        end

        EditMode.LEM:AddFrame(mUI.statsFrame, EditMode.StatsFrame)
        EditMode.LEM:AddFrame(EditMode.QueueStatus, EditMode.QueueIcon)

        EditMode.LEM:RegisterCallback('layout', function(layout)
            if not EditMode.db[layout] then
                EditMode.db[layout] = {}
            end
            if not EditMode.db[layout].statsframe then
                EditMode.db[layout].statsframe = {
                    point = "BOTTOMLEFT",
                    x = 0,
                    y = 0
                }
            end
            if not EditMode.db[layout].queueicon then
                EditMode.db[layout].queueicon = {
                    point = "TOPRIGHT",
                    x = -166.668701171875,
                    y = -164.1666259765625
                }
            end

            mUI.statsFrame:ClearAllPoints()
            mUI.statsFrame:SetPoint(EditMode.db[layout].statsframe.point, EditMode.db[layout].statsframe.x, EditMode.db[layout].statsframe.y)

            -- Apply stats frame text size
            local textSize = EditMode.db[layout].statsframe.textsize or 13
            local Stats = mUI:GetModule("mUI.Modules.General.Stats")
            local fontPath = Stats and Stats.db and Stats.db.general.font ~= "None" and Stats.db.general.fontpath or STANDARD_TEXT_FONT
            mUI.statsFrame.text:SetFont(fontPath, textSize, "OUTLINE")

            EditMode.QueueStatus:ClearAllPoints()
            EditMode.QueueStatus:SetPoint(EditMode.db[layout].queueicon.point, EditMode.db[layout].queueicon.x, EditMode.db[layout].queueicon.y)

            -- Apply QueueStatusButton scale
            queueDesiredScale = EditMode.db[layout].queueicon.scale or 0.8
            QueueStatusButton:SetScale(queueDesiredScale)
        end)

        EditMode.LEM:AddFrameSettings(mUI.statsFrame, {{
            name = 'Text Size',
            kind = EditMode.LEM.SettingType.Slider,
            default = 13,
            get = function(layout)
                return EditMode.db[layout].statsframe and EditMode.db[layout].statsframe.textsize or 13
            end,
            set = function(layout, value)
                if not EditMode.db[layout].statsframe then
                    EditMode.db[layout].statsframe = {}
                end
                EditMode.db[layout].statsframe.textsize = value
                local Stats = mUI:GetModule("mUI.Modules.General.Stats")
                local fontPath = Stats and Stats.db and Stats.db.general.font ~= "None" and Stats.db.general.fontpath or STANDARD_TEXT_FONT
                mUI.statsFrame.text:SetFont(fontPath, value, "OUTLINE")
            end,
            minValue = 6,
            maxValue = 32,
            valueStep = 1,
            formatter = function(value)
                return tostring(value)
            end
        }})

        EditMode.LEM:AddFrameSettings(EditMode.QueueStatus, {{
            name = 'Button Size',
            kind = EditMode.LEM.SettingType.Slider,
            default = 0.8,
            get = function(layout)
                return EditMode.db[layout].queueicon and EditMode.db[layout].queueicon.scale or 0.8
            end,
            set = function(layout, value)
                if not EditMode.db[layout].queueicon then
                    EditMode.db[layout].queueicon = {}
                end
                EditMode.db[layout].queueicon.scale = value
                queueDesiredScale = value
                QueueStatusButton:SetScale(value)
            end,
            minValue = 0.1,
            maxValue = 5,
            valueStep = 0.1,
            formatter = function(value)
                return FormatPercentage(value, true)
            end
        }})
    end
end
