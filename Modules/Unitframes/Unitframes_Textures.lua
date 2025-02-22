local Unitframes_Textures = mUI:NewModule("mUI.Modules.Unitframes.Unitframes_Textures")

function Unitframes_Textures:OnInitialize()
    -- Load LSM
    local LSM = LibStub("LibSharedMedia-3.0")

    -- Load Database
    self.db = mUI.db.profile.unitframes

    -- Create Frame
    self.textures = CreateFrame("Frame")
    self.lastUpdate = 0

    -- Tables
    self.healthbars = {
        player = PlayerFrame.healthbar,
        pet = PetFrame.healthbar,
        target = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        focus = FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        targettarget = TargetFrameToT.HealthBar,
        focustarget = FocusFrameToT.HealthBar,
        boss1 = Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss2 = Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss3 = Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss4 = Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        boss5 = Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
        party1 = PartyFrame.MemberFrame1.healthbar,
        party2 = PartyFrame.MemberFrame2.healthbar,
        party3 = PartyFrame.MemberFrame3.healthbar,
        party4 = PartyFrame.MemberFrame4.healthbar
    }

    self.powerbars = {
        player = PlayerFrame.manabar,
        pet = PetFrame.manabar,
        target = TargetFrame.manabar,
        focus = FocusFrame.manabar,
        targettarget = TargetFrameToT.manabar,
        focustarget = FocusFrameToT.manabar,
        boss1 = Boss1TargetFrame.manabar,
        boss2 = Boss2TargetFrame.manabar,
        boss3 = Boss3TargetFrame.manabar,
        boss4 = Boss4TargetFrame.manabar,
        boss5 = Boss5TargetFrame.manabar,
        party1 = PartyFrame.MemberFrame1.manabar,
        party2 = PartyFrame.MemberFrame2.manabar,
        party3 = PartyFrame.MemberFrame3.manabar,
        party4 = PartyFrame.MemberFrame4.manabar
    }

    self.defaultHealthTextures = {
        player = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Health",
        pet = "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health",
        target = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health",
        focus = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health",
        targettarget = "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health",
        focustarget = "UI-HUD-UnitFrame-TargetofTarget-PortraitOn-Bar-Health",
        boss1 = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health",
        boss2 = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health",
        boss3 = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health",
        boss4 = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health",
        boss5 = "UI-HUD-UnitFrame-Target-Boss-Small-PortraitOff-Bar-Health",
        party1 = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health",
        party2 = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health",
        party3 = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health",
        party4 = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Health"
    }

    self.defaultPowerTextures = {
        player = {
            [0] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-RunicPower"
        },
        pet = {
            [0] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Energy",
        },
        target = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        focus = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        targettarget = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        focustarget = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        boss1 = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        boss2 = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        boss3 = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        boss4 = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        boss5 = {
            [0] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Target-PortraitOn-Bar-RunicPower"
        },
        party1 = {
            [0] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower"
        },
        party2 = {
            [0] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower"
        },
        party3 = {
            [0] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower"
        },
        party4 = {
            [0] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Mana",
            [1] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Rage",
            [2] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Focus",
            [3] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-Energy",
            [6] = "UI-HUD-UnitFrame-Party-PortraitOn-Bar-RunicPower"
        },
        classresource = {
            [0] = "UI-HUD-UnitFrame-Player-PortraitOn-ClassResource-Bar-Mana",
            [3] = "UI-HUD-UnitFrame-Player-PortraitOn-ClassResource-Bar-Energy",
        }
    }

    function self:Update()
        local texture = LSM:Fetch('statusbar', self.db.textures.unitframes)
        local powerColor

        for name, healthbar in pairs(self.healthbars) do
            if self.db.textures.unitframes == "None" then
                if not self.db.color then
                    healthbar:SetStatusBarDesaturated(false)
                    healthbar:SetStatusBarColor(1, 1, 1)
                end
                healthbar:GetStatusBarTexture():SetAtlas(self.defaultHealthTextures[name])
            else
                if healthbar.HealthBarTexture then
                    healthbar.HealthBarTexture:SetTexture(texture)
                    if not self.db.color then
                        healthbar.HealthBarTexture:SetVertexColor(0, 1, 0)
                    end
                elseif healthbar.unit == "pet" then
                    select(7, healthbar:GetRegions()):SetTexture(texture)
                    if not self.db.color then
                        select(7, healthbar:GetRegions()):SetVertexColor(0, 1, 0)
                    end
                else
                    healthbar:SetStatusBarTexture(texture)
                    healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    if not self.db.color then
                        healthbar:SetStatusBarColor(0, 1, 0)
                    end
                end
            end
        end

        for name, powerbar in pairs(self.powerbars) do
            if powerbar and powerbar.powerType then
                powerColor = PowerBarColor[powerbar.powerType]
                if self.db.textures.unitframes == "None" then
                    powerbar:GetStatusBarTexture():SetAtlas(self.defaultPowerTextures[name][powerbar.powerType])
                    powerbar:SetStatusBarColor(1, 1, 1)
                else
                    if not (powerbar.powerType == 8 or powerbar.powerType == 11 or powerbar.powerType == 13 or powerbar.powerType == 17 or powerbar.powerType == 18) then
                        powerbar.texture:SetTexture(texture)

                        if powerbar.powerType == 0 then
                            powerbar:SetStatusBarColor(0, 0.5, 1)
                        else
                            powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                        end
                    end
                end
            end
        end

        if AlternatePowerBar and AlternatePowerBar.powerType then
            powerColor = PowerBarColor[AlternatePowerBar.powerType]
            if self.db.textures.unitframes == "None" then
                AlternatePowerBar:GetStatusBarTexture():SetAtlas(self.defaultPowerTextures["classresource"]
                    [AlternatePowerBar.powerType])
                AlternatePowerBar:SetStatusBarColor(1, 1, 1)
            else
                select(6, AlternatePowerBar:GetRegions()):SetTexture(texture)

                if AlternatePowerBar.powerType == 0 then
                    AlternatePowerBar:SetStatusBarColor(0, 0.5, 1)
                else
                    AlternatePowerBar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                end
            end
        end
    end
end

function Unitframes_Textures:OnEnable()
    mUI:HookScript(self.textures, "OnUpdate", function(_, _)
        self:Update()
    end)
end

function Unitframes_Textures:OnDisable()
    mUI:Unhook(self.textures, "OnUpdate")
end
