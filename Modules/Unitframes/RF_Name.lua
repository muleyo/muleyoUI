local RF_Name = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Name", "AceHook-3.0")

function RF_Name:OnInitialize()
    -- Load Database
    RF_Name.db = mUI.db.profile.unitframes.raidframes

    -- Tables
    RF_Name.frames = {
        "PartyFrameMember1", "PartyFrameMember2", "PartyFrameMember3", "PartyFrameMember4", "PartyFrameMember5",
        "PartyFramePet1", "PartyFramePet2", "PartyFramePet3", "PartyFramePet4", "PartyFramePet5",
        "RaidFrame1", "RaidFrame2", "RaidFrame3", "RaidFrame4", "RaidFrame5",
        "RaidFrame6", "RaidFrame7", "RaidFrame8", "RaidFrame9", "RaidFrame10",
        "RaidFrame11", "RaidFrame12", "RaidFrame13", "RaidFrame14", "RaidFrame15",
        "RaidFrame16", "RaidFrame17", "RaidFrame18", "RaidFrame19", "RaidFrame20",
        "RaidFrame21", "RaidFrame22", "RaidFrame23", "RaidFrame24", "RaidFrame25",
        "RaidFrame26", "RaidFrame27", "RaidFrame28", "RaidFrame29", "RaidFrame30",
        "RaidFrame31", "RaidFrame32", "RaidFrame33", "RaidFrame34", "RaidFrame35",
        "RaidFrame36", "RaidFrame37", "RaidFrame38", "RaidFrame39", "RaidFrame40",
        "RaidGroup1Member1", "RaidGroup1Member2", "RaidGroup1Member3", "RaidGroup1Member4", "RaidGroup1Member5",
        "RaidGroup2Member1", "RaidGroup2Member2", "RaidGroup2Member3", "RaidGroup2Member4", "RaidGroup2Member5",
        "RaidGroup3Member1", "RaidGroup3Member2", "RaidGroup3Member3", "RaidGroup3Member4", "RaidGroup3Member5",
        "RaidGroup4Member1", "RaidGroup4Member2", "RaidGroup4Member3", "RaidGroup4Member4", "RaidGroup4Member5",
        "RaidGroup5Member1", "RaidGroup5Member2", "RaidGroup5Member3", "RaidGroup5Member4", "RaidGroup5Member5",
        "RaidGroup6Member1", "RaidGroup6Member2", "RaidGroup6Member3", "RaidGroup6Member4", "RaidGroup6Member5",
        "RaidGroup7Member1", "RaidGroup7Member2", "RaidGroup7Member3", "RaidGroup7Member4", "RaidGroup7Member5",
        "RaidGroup8Member1", "RaidGroup8Member2", "RaidGroup8Member3", "RaidGroup8Member4", "RaidGroup8Member5",
    }

    RF_Name.backup = {}

    function RF_Name:SetName(frame)
        if (not frame) or frame:IsForbidden() then return end
        if frame:GetName() and frame.unit then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local color = RAID_CLASS_COLORS[select(2, UnitClass(frame.unit))]
                local unitName = UnitName(frame.unit)

                if not RF_Name.backup[1] then
                    RF_Name.backup[1], RF_Name.backup[2], RF_Name.backup[3] = frame.name:GetFont()
                    RF_Name.backup[4], RF_Name.backup[5], RF_Name.backup[6] = frame.name:GetTextColor()
                end

                if color then
                    frame.name:SetText(unitName)
                    frame.name:SetTextColor(color.r, color.g, color.b)
                    frame.name:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")

                    if RF_Name.db.roleicons then
                        frame.name:ClearAllPoints()
                        frame.name:SetPoint("TOPLEFT", frame, 2, -5)
                    else
                        frame.name:ClearAllPoints()
                        frame.name:SetPoint("TOPLEFT", frame, 15, -5)
                    end
                end
            end
        end
    end

    function RF_Name:Update()
        for _, frame in pairs(RF_Name.frames) do
            if _G["Compact" .. frame] then
                RF_Name:SetName(_G["Compact" .. frame])
            end
        end
    end

    function RF_Name:Restore()
        for _, frame in pairs(RF_Name.frames) do
            if _G["Compact" .. frame] then
                _G["Compact" .. frame].name:SetFont(RF_Name.backup[1], RF_Name.backup[2], RF_Name.backup[3])
                _G["Compact" .. frame].name:SetTextColor(RF_Name.backup[4], RF_Name.backup[5], RF_Name.backup[6])
            end
        end
    end
end

function RF_Name:OnEnable()
    RF_Name:SecureHook("CompactUnitFrame_UpdateName", function(frame)
        RF_Name:SetName(frame)
    end)

    RF_Name:Update()
end

function RF_Name:OnDisable()
    RF_Name:UnhookAll()
    RF_Name:Restore()
    EditModeManagerFrame:Show()
    EditModeManagerFrame:Hide()
end
