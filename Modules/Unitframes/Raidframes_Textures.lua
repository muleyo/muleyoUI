local Raidframes_Textures = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Textures")

function Raidframes_Textures:OnInitialize()
    -- Load LSM
    local LSM = LibStub("LibSharedMedia-3.0")

    -- Load Database
    self.db = mUI.db.profile.unitframes.textures

    -- Create Frame
    self.textures = CreateFrame("Frame", mUITextures)

    -- Tables
    self.healthbars = {
        player = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar,
        target = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        focus = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        targettarget = TargetFrameToT.HealthBar,
        focustarget = FocusFrameToT.HealthBar,
        boss1 = Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss2 = Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss3 = Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss4 = Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss5 = Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        party1 = PartyFrame.MemberFrame1.HealthBarContainer.HealthBar,
        party2 = PartyFrame.MemberFrame2.HealthBarContainer.HealthBar,
        party3 = PartyFrame.MemberFrame3.HealthBarContainer.HealthBar,
        party4 = PartyFrame.MemberFrame4.HealthBarContainer.HealthBar
    }

    self.defaultTextures = {
        health = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
        power = [[Interface\RaidFrame\Raid-Bar-Resource-Fill]]
    }

    function self:SetTextures(frame)
        if frame and frame:IsForbidden() then return end
        if frame:GetName() then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local texture = LSM:Fetch('statusbar', self.db.raidframes)
                if self.db.raidframes ~= "None" then
                    frame.healthBar:SetStatusBarTexture(texture)
                    frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.powerBar:SetStatusBarTexture(texture)
                    frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.myHealPrediction:SetTexture(texture)
                    frame.otherHealPrediction:SetTexture(texture)
                else
                    frame.healthBar:SetStatusBarTexture(self.defaultTextures.health)
                    frame.healthBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.powerBar:SetStatusBarTexture(self.defaultTextures.power)
                    frame.powerBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    frame.myHealPrediction:SetTexture(self.defaultTextures.health)
                    frame.otherHealPrediction:SetTexture(self.defaultTextures.health)
                end

                frame.vertLeftBorder:Hide()
                frame.vertRightBorder:Hide()
                frame.horizTopBorder:Hide()
                frame.horizBottomBorder:Hide()
            end
        end
    end

    function self:Update()
        for _, frame in pairs(self.frames) do
            self:SetTextures(frame)
        end
    end
end

function Raidframes_Textures:OnEnable()
    mUI:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        self:SetTextures(frame)
    end)

    -- Create table here as frames won't be available OnInitialize
    self.frames = {
        CompactPartyFrameMember1,
        CompactPartyFrameMember2,
        CompactPartyFrameMember3,
        CompactPartyFrameMember4,
        CompactPartyFrameMember5,
        CompactPartyFramePet1,
        CompactPartyFramePet2,
        CompactPartyFramePet3,
        CompactPartyFramePet4,
        CompactPartyFramePet5,
        CompactRaidFrame1,
        CompactRaidFrame2,
        CompactRaidFrame3,
        CompactRaidFrame4,
        CompactRaidFrame5,
        CompactRaidFrame6,
        CompactRaidFrame7,
        CompactRaidFrame8,
        CompactRaidFrame9,
        CompactRaidFrame10,
        CompactRaidFrame11,
        CompactRaidFrame12,
        CompactRaidFrame13,
        CompactRaidFrame14,
        CompactRaidFrame15,
        CompactRaidFrame16,
        CompactRaidFrame17,
        CompactRaidFrame18,
        CompactRaidFrame19,
        CompactRaidFrame20,
        CompactRaidFrame21,
        CompactRaidFrame22,
        CompactRaidFrame23,
        CompactRaidFrame24,
        CompactRaidFrame25,
        CompactRaidFrame26,
        CompactRaidFrame27,
        CompactRaidFrame28,
        CompactRaidFrame29,
        CompactRaidFrame30,
        CompactRaidFrame31,
        CompactRaidFrame32,
        CompactRaidFrame33,
        CompactRaidFrame34,
        CompactRaidFrame35,
        CompactRaidFrame36,
        CompactRaidFrame37,
        CompactRaidFrame38,
        CompactRaidFrame39,
        CompactRaidFrame40,
        CompactRaidGroup1Member1,
        CompactRaidGroup1Member2,
        CompactRaidGroup1Member3,
        CompactRaidGroup1Member4,
        CompactRaidGroup1Member5,
        CompactRaidGroup2Member1,
        CompactRaidGroup2Member2,
        CompactRaidGroup2Member3,
        CompactRaidGroup2Member4,
        CompactRaidGroup2Member5,
        CompactRaidGroup3Member1,
        CompactRaidGroup3Member2,
        CompactRaidGroup3Member3,
        CompactRaidGroup3Member4,
        CompactRaidGroup3Member5,
        CompactRaidGroup4Member1,
        CompactRaidGroup4Member2,
        CompactRaidGroup4Member3,
        CompactRaidGroup4Member4,
        CompactRaidGroup4Member5,
        CompactRaidGroup5Member1,
        CompactRaidGroup5Member2,
        CompactRaidGroup5Member3,
        CompactRaidGroup5Member4,
        CompactRaidGroup5Member5,
        CompactRaidGroup6Member1,
        CompactRaidGroup6Member2,
        CompactRaidGroup6Member3,
        CompactRaidGroup6Member4,
        CompactRaidGroup6Member5,
        CompactRaidGroup7Member1,
        CompactRaidGroup7Member2,
        CompactRaidGroup7Member3,
        CompactRaidGroup7Member4,
        CompactRaidGroup7Member5,
        CompactRaidGroup8Member1,
        CompactRaidGroup8Member2,
        CompactRaidGroup8Member3,
        CompactRaidGroup8Member4,
        CompactRaidGroup8Member5,
    }
end

function Raidframes_Textures:OnDisable()
    mUI:Unhook("CompactUnitFrame_UpdateAll", "OnUpdate")
end
