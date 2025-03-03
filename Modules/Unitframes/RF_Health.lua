local RF_Health = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Health", "AceHook-3.0")

function RF_Health:OnInitialize()
    -- Load Database
    RF_Health.db = mUI.db.profile.unitframes.raidframes

    -- Create Fra,es
    RF_Health.frame = CreateFrame("Frame")

    -- Tables
    RF_Health.frames = {
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

    RF_Health.backup = {}


    function RF_Health:SetHealth(frame)
        if (not frame) or frame:IsForbidden() then return end
        if frame:GetName() and frame.unit then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local health = UnitHealth(frame.unit)
                local absorb = UnitGetTotalAbsorbs(frame.unit)
                local healAbsorb = UnitGetTotalHealAbsorbs(frame.unit)
                local maxHealth = UnitHealthMax(frame.unit)
                local color = RAID_CLASS_COLORS[select(2, UnitClass(frame.unit))]
                local value = math.floor((health + absorb - healAbsorb) / maxHealth * 100)
                local cvar = C_CVar.GetCVar("raidFramesHealthText")
                local connected = UnitIsConnected(frame.unit)

                if not RF_Health.backup[1] then
                    RF_Health.backup[1], RF_Health.backup[2], RF_Health.backup[3] = frame.statusText:GetFont()
                    RF_Health.backup[4], RF_Health.backup[5], RF_Health.backup[6] = frame.statusText:GetTextColor()
                end

                frame.statusText:ClearAllPoints()
                frame.statusText:SetPoint("CENTER", frame, "CENTER")

                if RF_Health.db.health then
                    if cvar == "perc" then
                        if connected then
                            if UnitIsDead(frame.unit) then
                                frame.statusText:SetText("Dead")
                            else
                                frame.statusText:SetText(value)
                            end
                        else
                            frame.statusText:SetText("Offline")
                        end
                    end
                end

                if RF_Health.db.healthcolor and color then
                    frame.statusText:SetTextColor(color.r, color.g, color.b)
                    frame.statusText:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
                else
                    frame.statusText:SetTextColor(1, 0.82, 0)
                    frame.statusText:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
                end
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
                _G["Compact" .. frame].statusText:SetTextColor(RF_Health.backup[4], RF_Health.backup[5],
                    RF_Health.backup[6])
            end
        end
    end
end

function RF_Health:OnEnable()
    RF_Health:SecureHook("CompactUnitFrame_OnUpdate", function(frame)
        RF_Health:SetHealth(frame)
    end)

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
