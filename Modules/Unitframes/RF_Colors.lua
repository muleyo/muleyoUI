local RF_Colors = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Colors", "AceHook-3.0")

function RF_Colors:OnInitialize()
    -- Tables
    RF_Colors.frames = {
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

    function RF_Colors:SetColors(frame)
        if (not frame) or frame:IsForbidden() then return end
        if frame:GetName() and frame.unit then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local connected = UnitIsConnected(frame.unit)

                if connected then
                    frame.healthBar:SetStatusBarColor(0.25, 0.25, 0.25)
                    frame.powerBar:SetStatusBarColor(0.25, 0.25, 0.25)
                else
                    frame.healthBar:SetStatusBarColor(0.8, 0.8, 0.8)
                    frame.powerBar:SetStatusBarColor(0.8, 0.8, 0.8)
                end
            end
        end
    end

    function RF_Colors:Update()
        for _, frame in pairs(RF_Colors.frames) do
            if _G["Compact" .. frame] then
                RF_Colors:SetColors(_G["Compact" .. frame])
            end
        end
    end
end

function RF_Colors:OnEnable()
    RF_Colors:SecureHook("CompactUnitFrame_UpdateHealthColor", function(frame)
        RF_Colors:SetColors(frame)
    end)

    RF_Colors:SecureHook("CompactUnitFrame_UpdatePowerColor", function(frame)
        RF_Colors:SetColors(frame)
    end)

    RF_Colors:Update()
end

function RF_Colors:OnDisable()
    RF_Colors:UnhookAll()
    EditModeManagerFrame:Show()
    EditModeManagerFrame:Hide()
end
