local Raidframes_Textures = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Textures")

function Raidframes_Textures:OnInitialize()
    -- Load LSM
    self.LSM = LibStub("LibSharedMedia-3.0")

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

    self.frames = {
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

    self.defaultTextures = {
        health = [[Interface\RaidFrame\Raid-Bar-Hp-Fill]],
        power = [[Interface\RaidFrame\Raid-Bar-Resource-Fill]]
    }

    function self:SetTextures(frame)
        if frame and frame:IsForbidden() then return end
        if frame and frame:GetName() then
            local name = frame:GetName()
            if name and name:match("^Compact") then
                local texture = self.LSM:Fetch('statusbar', self.db.raidframes)
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
            self:SetTextures(_G["Compact" .. frame])
        end
    end
end

function Raidframes_Textures:OnEnable()
    mUI:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        self:SetTextures(frame)
    end)
end

function Raidframes_Textures:OnDisable()
    mUI:Unhook("CompactUnitFrame_UpdateAll", "OnUpdate")
end
