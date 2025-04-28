local EditMode = mUI:NewModule("mUI.EditMode", "AceHook-3.0")

function EditMode:OnInitialize()
    -- Load Database
    EditMode.db = mUI.db.profile.edit

    -- Load Libraries
    EditMode.LEM = LibStub('LibEditMode')

    -- Create Holder Frame
    EditMode.QueueStatus = CreateFrame("Frame", "mUI QueueStatusButton", UIParent)
    EditMode.QueueStatus:SetSize(QueueStatusButton:GetWidth(), QueueStatusButton:GetHeight())
    EditMode.QueueStatus:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

    -- Set QueueStatusButton to Holder Frame
    QueueStatusButton:SetParent(EditMode.QueueStatus)
    QueueStatusButton:ClearAllPoints()
    QueueStatusButton:SetPoint("CENTER", EditMode.QueueStatus)
    EditMode:SecureHook(QueueStatusButton, "SetPoint", function()
        QueueStatusButton:SetAllPoints(EditMode.QueueStatus)
    end)

    -- Stats Frame
    function EditMode:StatsFrame(layout, point, x, y)
        EditMode.db[layout].statsframe.point = point
        EditMode.db[layout].statsframe.x = x
        EditMode.db[layout].statsframe.y = y
    end

    -- QueueStatusButton
    function EditMode:QueueIcon(layout, point, x, y)
        EditMode.db[layout].queueicon.point = point
        EditMode.db[layout].queueicon.x = x
        EditMode.db[layout].queueicon.y = y
    end

    EditMode.LEM:AddFrame(mUI.statsFrame, EditMode.StatsFrame)
    EditMode.LEM:AddFrame(EditMode.QueueStatus, EditMode.QueueIcon)

    EditMode.LEM:RegisterCallback('layout', function(layout)
        if not EditMode.db[layout] then
            EditMode.db[layout] = {
                ["statsframe"] = {
                    ["point"] = "BOTTOMLEFT",
                    ["x"] = 0,
                    ["y"] = 0
                },
                ["queueicon"] = {
                    ["point"] = "TOPRIGHT",
                    ["x"] = -166.668701171875,
                    ["y"] = -164.1666259765625
                }
            }
        end

        mUI.statsFrame:ClearAllPoints()
        mUI.statsFrame:SetPoint(
            EditMode.db[layout].statsframe.point,
            EditMode.db[layout].statsframe.x,
            EditMode.db[layout].statsframe.y)

        EditMode.QueueStatus:ClearAllPoints()
        EditMode.QueueStatus:SetPoint(
            EditMode.db[layout].queueicon.point,
            EditMode.db[layout].queueicon.x,
            EditMode.db[layout].queueicon.y)

        QueueStatusButton:SetScale(EditMode.db[layout].queueicon.scale or 0.8)
    end)

    EditMode.LEM:AddFrameSettings(EditMode.QueueStatus, {
        {
            name = 'Button Size',
            kind = EditMode.LEM.SettingType.Slider,
            default = 1,
            get = function(layout)
                return EditMode.db[layout].queueicon.scale
            end,
            set = function(layout, value)
                EditMode.db[layout].queueicon.scale = value
                QueueStatusButton:SetScale(value)
            end,
            minValue = 0.1,
            maxValue = 5,
            valueStep = 0.1,
            formatter = function(value)
                return FormatPercentage(value, true)
            end,
        }
    })
end
