local RF_Defensive = mUI:NewModule("mUI.Modules.Unitframes.RF_Defensive", "AceHook-3.0")

function RF_Defensive:OnInitialize()
    -- Load Database
    RF_Defensive.db = mUI.db.profile.unitframes.raidframes.defensive

    RF_Defensive.frames = {"PartyFrameMember1", "PartyFrameMember2", "PartyFrameMember3", "PartyFrameMember4", "PartyFrameMember5", "RaidFrame1",
                           "RaidFrame2", "RaidFrame3", "RaidFrame4", "RaidFrame5", "RaidFrame6", "RaidFrame7", "RaidFrame8", "RaidFrame9",
                           "RaidFrame10", "RaidFrame11", "RaidFrame12", "RaidFrame13", "RaidFrame14", "RaidFrame15", "RaidFrame16", "RaidFrame17",
                           "RaidFrame18", "RaidFrame19", "RaidFrame20", "RaidFrame21", "RaidFrame22", "RaidFrame23", "RaidFrame24", "RaidFrame25",
                           "RaidFrame26", "RaidFrame27", "RaidFrame28", "RaidFrame29", "RaidFrame30", "RaidFrame31", "RaidFrame32", "RaidFrame33",
                           "RaidFrame34", "RaidFrame35", "RaidFrame36", "RaidFrame37", "RaidFrame38", "RaidFrame39", "RaidFrame40",
                           "RaidGroup1Member1", "RaidGroup1Member2", "RaidGroup1Member3", "RaidGroup1Member4", "RaidGroup1Member5",
                           "RaidGroup2Member1", "RaidGroup2Member2", "RaidGroup2Member3", "RaidGroup2Member4", "RaidGroup2Member5",
                           "RaidGroup3Member1", "RaidGroup3Member2", "RaidGroup3Member3", "RaidGroup3Member4", "RaidGroup3Member5",
                           "RaidGroup4Member1", "RaidGroup4Member2", "RaidGroup4Member3", "RaidGroup4Member4", "RaidGroup4Member5",
                           "RaidGroup5Member1", "RaidGroup5Member2", "RaidGroup5Member3", "RaidGroup5Member4", "RaidGroup5Member5",
                           "RaidGroup6Member1", "RaidGroup6Member2", "RaidGroup6Member3", "RaidGroup6Member4", "RaidGroup6Member5",
                           "RaidGroup7Member1", "RaidGroup7Member2", "RaidGroup7Member3", "RaidGroup7Member4", "RaidGroup7Member5",
                           "RaidGroup8Member1", "RaidGroup8Member2", "RaidGroup8Member3", "RaidGroup8Member4", "RaidGroup8Member5"}

    function RF_Defensive:Update(frame)
        if (not frame) or frame:IsForbidden() then
            return
        end

        if frame and frame:GetName() then
            local name = frame:GetName()
            if name:match("^Compact") then
                if not frame.CenterDefensiveBuff then
                    return
                end

                frame.CenterDefensiveBuff:SetSize(RF_Defensive.db.size, RF_Defensive.db.size)
                frame.CenterDefensiveBuff:ClearAllPoints()

                if RF_Defensive.db.position == "TOP" then
                    frame.CenterDefensiveBuff:SetPoint("TOP", frame, "TOP", 0, 0)
                elseif RF_Defensive.db.position == "TOPLEFT" then
                    frame.CenterDefensiveBuff:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
                elseif RF_Defensive.db.position == "TOPRIGHT" then
                    frame.CenterDefensiveBuff:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
                elseif RF_Defensive.db.position == "CENTER" then
                    frame.CenterDefensiveBuff:SetPoint("CENTER", frame, "CENTER", 0, 0)
                elseif RF_Defensive.db.position == "LEFT" then
                    frame.CenterDefensiveBuff:SetPoint("LEFT", frame, "LEFT", 0, 0)
                elseif RF_Defensive.db.position == "RIGHT" then
                    frame.CenterDefensiveBuff:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
                elseif RF_Defensive.db.position == "BOTTOM" then
                    frame.CenterDefensiveBuff:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
                elseif RF_Defensive.db.position == "BOTTOMLEFT" then
                    frame.CenterDefensiveBuff:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
                elseif RF_Defensive.db.position == "BOTTOMRIGHT" then
                    frame.CenterDefensiveBuff:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
                end
            end
        end
    end

    function RF_Defensive:UpdateSizePos()
        for _, name in pairs(RF_Defensive.frames) do
            local frame = _G["Compact" .. name]

            if (not frame) or frame:IsForbidden() then
                return
            end

            RF_Defensive:Update(frame)
        end
    end
end

function RF_Defensive:OnEnable()
    RF_Defensive:SecureHook("CompactUnitFrame_UpdateAuras", function(frame)
        RF_Defensive:Update(frame)
    end)
end
