local RF_Health = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Health", "AceHook-3.0")

function RF_Health:OnInitialize()
    -- Load Database
    RF_Health.db = mUI.db.profile.unitframes.raidframes

    -- Create Fra,es
    RF_Health.frame = CreateFrame("Frame")

    -- Tables
    RF_Health.frames = {"PartyFrameMember1", "PartyFrameMember2", "PartyFrameMember3", "PartyFrameMember4", "PartyFrameMember5", "PartyFramePet1",
                        "PartyFramePet2", "PartyFramePet3", "PartyFramePet4", "PartyFramePet5", "RaidFrame1", "RaidFrame2", "RaidFrame3",
                        "RaidFrame4", "RaidFrame5", "RaidFrame6", "RaidFrame7", "RaidFrame8", "RaidFrame9", "RaidFrame10", "RaidFrame11",
                        "RaidFrame12", "RaidFrame13", "RaidFrame14", "RaidFrame15", "RaidFrame16", "RaidFrame17", "RaidFrame18", "RaidFrame19",
                        "RaidFrame20", "RaidFrame21", "RaidFrame22", "RaidFrame23", "RaidFrame24", "RaidFrame25", "RaidFrame26", "RaidFrame27",
                        "RaidFrame28", "RaidFrame29", "RaidFrame30", "RaidFrame31", "RaidFrame32", "RaidFrame33", "RaidFrame34", "RaidFrame35",
                        "RaidFrame36", "RaidFrame37", "RaidFrame38", "RaidFrame39", "RaidFrame40", "RaidGroup1Member1", "RaidGroup1Member2",
                        "RaidGroup1Member3", "RaidGroup1Member4", "RaidGroup1Member5", "RaidGroup2Member1", "RaidGroup2Member2", "RaidGroup2Member3",
                        "RaidGroup2Member4", "RaidGroup2Member5", "RaidGroup3Member1", "RaidGroup3Member2", "RaidGroup3Member3", "RaidGroup3Member4",
                        "RaidGroup3Member5", "RaidGroup4Member1", "RaidGroup4Member2", "RaidGroup4Member3", "RaidGroup4Member4", "RaidGroup4Member5",
                        "RaidGroup5Member1", "RaidGroup5Member2", "RaidGroup5Member3", "RaidGroup5Member4", "RaidGroup5Member5", "RaidGroup6Member1",
                        "RaidGroup6Member2", "RaidGroup6Member3", "RaidGroup6Member4", "RaidGroup6Member5", "RaidGroup7Member1", "RaidGroup7Member2",
                        "RaidGroup7Member3", "RaidGroup7Member4", "RaidGroup7Member5", "RaidGroup8Member1", "RaidGroup8Member2", "RaidGroup8Member3",
                        "RaidGroup8Member4", "RaidGroup8Member5"}

    RF_Health.backup = {}
    RF_Health.frameBackup = {}

    function RF_Health:SnapshotFrame(frame)
        if RF_Health.frameBackup[frame] or not frame.statusText then
            return
        end
        local font, size, flags = frame.statusText:GetFont()
        local r, g, b, a = frame.statusText:GetTextColor()
        local point, relTo, relPoint, x, y = frame.statusText:GetPoint(1)
        RF_Health.frameBackup[frame] = {
            font = font,
            size = size,
            flags = flags,
            r = r,
            g = g,
            b = b,
            a = a,
            point = point,
            relTo = relTo,
            relPoint = relPoint,
            x = x,
            y = y
        }
    end

    function RF_Health:RestoreFrame(frame)
        local bk = RF_Health.frameBackup[frame]
        if not bk or not frame.statusText then
            return
        end
        if bk.font then
            frame.statusText:SetFont(bk.font, bk.size, bk.flags)
        end
        frame.statusText:SetTextColor(bk.r or 1, bk.g or 0.82, bk.b or 0, bk.a or 1)
        if bk.point then
            frame.statusText:ClearAllPoints()
            frame.statusText:SetPoint(bk.point, bk.relTo or frame, bk.relPoint or bk.point, bk.x or 0, bk.y or 0)
        end
    end

    function RF_Health:SetHealth(frame)
        if (not frame) or frame:IsForbidden() then
            return
        end
        if frame:GetName() and frame.unit then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local _, class = UnitClass(frame.unit)

                if not class then
                    return
                end

                local color = C_ClassColor.GetClassColor(class)
                local isParty = name:match("^CompactPartyFrameMember") and true or false
                local partyMode = RF_Health.db.partyStatusColorMode or "default"

                RF_Health:SnapshotFrame(frame)

                if isParty and partyMode == "default" then
                    RF_Health:RestoreFrame(frame)
                    return
                end

                if not RF_Health.backup[1] then
                    RF_Health.backup[1], RF_Health.backup[2], RF_Health.backup[3] = frame.statusText:GetFont()
                    RF_Health.backup[4], RF_Health.backup[5], RF_Health.backup[6] = frame.statusText:GetTextColor()
                end

                frame.statusText:ClearAllPoints()
                frame.statusText:SetPoint("CENTER", frame, "CENTER", 0, -2.5)

                -- Use EditMode API to get frame dimensions (GetWidth/GetHeight are protected)
                local fontSize = 13
                local defaultWidth, defaultHeight = 72, 36

                -- Try to get dimensions from EditMode, fallback to defaults if not available
                local frameWidth = defaultWidth
                local frameHeight = defaultHeight

                if IsInRaid() then
                    frameWidth = EditModeManagerFrame:GetRaidFrameWidth(Enum.EditModeUnitFrameSystemIndices.Raid, defaultWidth)
                    frameHeight = EditModeManagerFrame:GetRaidFrameHeight(Enum.EditModeUnitFrameSystemIndices.Raid, defaultHeight)
                else
                    frameWidth = EditModeManagerFrame:GetRaidFrameWidth(Enum.EditModeUnitFrameSystemIndices.Party, defaultWidth)
                    frameHeight = EditModeManagerFrame:GetRaidFrameHeight(Enum.EditModeUnitFrameSystemIndices.Party, defaultHeight)
                end

                local scaleFactor = math.min(frameWidth / 100, frameHeight / 40)
                fontSize = math.max(12, math.min(16, 13 * scaleFactor))

                if isParty and partyMode == "class" and color then
                    frame.statusText:SetTextColor(color.r, color.g, color.b)
                elseif isParty and partyMode == "custom" then
                    local c = RF_Health.db.partyStatusCustomColor or {1, 0.82, 0, 1}
                    frame.statusText:SetTextColor(c[1] or 1, c[2] or 0.82, c[3] or 0)
                else
                    frame.statusText:SetTextColor(1, 0.82, 0)
                end
                frame.statusText:SetFont(STANDARD_TEXT_FONT, fontSize, "OUTLINE")
            end
        end
    end

    function RF_Health:Update()
        for _, frame in pairs(RF_Health.frames) do
            if _G["Compact" .. frame] then
                RF_Health:SetHealth(_G["Compact" .. frame])
            end
        end
    end

    function RF_Health:Restore()
        for _, frame in pairs(RF_Health.frames) do
            if _G["Compact" .. frame] then
                _G["Compact" .. frame].statusText:SetFont(RF_Health.backup[1], RF_Health.backup[2], RF_Health.backup[3])
                _G["Compact" .. frame].statusText:SetTextColor(RF_Health.backup[4], RF_Health.backup[5], RF_Health.backup[6])
            end
        end
    end
end

function RF_Health:OnEnable()
    -- CompactUnitFrame_OnUpdate fires every frame for every raid frame; restyling the
    -- statusText only needs to happen when the text itself updates.
    RF_Health:SecureHook("CompactUnitFrame_UpdateStatusText", function(frame)
        RF_Health:SetHealth(frame)
    end)

    RF_Health:Update()
end

function RF_Health:OnDisable()
    RF_Health:UnhookAll()
    RF_Health:Restore()

    EditModeManagerFrame:Show()
    EditModeManagerFrame:Hide()
end
