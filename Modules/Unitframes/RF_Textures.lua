local RF_Textures = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Textures", "AceHook-3.0")

function RF_Textures:OnInitialize()
    -- Load LSM
    RF_Textures.LSM = LibStub("LibSharedMedia-3.0")

    -- Load Database
    RF_Textures.db = mUI.db.profile.unitframes.textures

    -- Hide Partyframe Title
    CompactPartyFrameTitle:Hide()

    -- Tables
    RF_Textures.frames = {
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

    RF_Textures.defaultTextures = {
        health = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
        power = [[Interface\RaidFrame\Raid-Bar-Resource-Fill]]
    }

    function RF_Textures:SetTextures(frame)
        if frame and frame:IsForbidden() then return end
        if frame and frame:GetName() then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local texture = RF_Textures.LSM:Fetch('statusbar', RF_Textures.db.raidframes)
                if RF_Textures.db.raidframes ~= "None" then
                    frame.healthBar:SetStatusBarTexture(texture)
                    frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.powerBar:SetStatusBarTexture(texture)
                    frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.myHealPrediction:SetTexture(texture)
                    frame.otherHealPrediction:SetTexture(texture)
                else
                    frame.healthBar:SetStatusBarTexture(RF_Textures.defaultTextures.health)
                    frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.powerBar:SetStatusBarTexture(RF_Textures.defaultTextures.power)
                    frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.myHealPrediction:SetTexture(RF_Textures.defaultTextures.health)
                    frame.otherHealPrediction:SetTexture(RF_Textures.defaultTextures.health)
                end

                frame.selectionHighlight:SetTexture([[Interface\AddOns\mUI\Media\Textures\Raidframes\border.png]])
                frame.aggroHighlight:SetTexture([[Interface\AddOns\mUI\Media\Textures\Raidframes\border.png]])

                frame.vertLeftBorder:Hide()
                frame.vertRightBorder:Hide()
                frame.horizTopBorder:Hide()
                frame.horizBottomBorder:Hide()
            end
        end
    end

    function RF_Textures:Update()
        for _, frame in pairs(RF_Textures.frames) do
            RF_Textures:SetTextures(_G["Compact" .. frame])
        end
    end
end

function RF_Textures:OnEnable()
    RF_Textures:SecureHook("CompactUnitFrame_UpdateHealthColor", function(frame)
        RF_Textures:SetTextures(frame)
    end)
end

function RF_Textures:OnDisable()
    RF_Textures:UnhookAll()
end
