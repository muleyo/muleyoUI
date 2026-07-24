local UF_Textures = mUI:NewModule("mUI.Modules.Unitframes.Unitframes_Textures", "AceHook-3.0")

function UF_Textures:OnInitialize()
    -- Load LSM
    UF_Textures.LSM = LibStub("LibSharedMedia-3.0")

    -- Load Database
    UF_Textures.db = mUI.db.profile.unitframes

    -- Create Frame
    UF_Textures.textures = CreateFrame("Frame")
    UF_Textures.textures:RegisterEvent("PLAYER_LOGIN")
    UF_Textures.textures:RegisterEvent("PLAYER_ENTERING_WORLD")
    UF_Textures.textures:RegisterEvent("UNIT_HEALTH")
    UF_Textures.textures:RegisterEvent("UNIT_TARGET")
    UF_Textures.textures:RegisterEvent("PLAYER_TARGET_CHANGED")
    UF_Textures.textures:RegisterEvent("PLAYER_FOCUS_CHANGED")

    -- Tables
    UF_Textures.healthbars = {
        player = PlayerFrame.healthbar,
        pet = PetFrame.healthbar,
        target = TargetFrame.healthbar,
        focus = FocusFrame.healthbar,
        targettarget = TargetFrameToT.healthbar,
        focustarget = FocusFrameToT.healthbar,
        boss1 = Boss1TargetFrame.healthbar,
        boss2 = Boss2TargetFrame.healthbar,
        boss3 = Boss3TargetFrame.healthbar,
        boss4 = Boss4TargetFrame.healthbar,
        boss5 = Boss5TargetFrame.healthbar,
        party1 = PartyFrame.MemberFrame1.healthbar,
        party2 = PartyFrame.MemberFrame2.healthbar,
        party3 = PartyFrame.MemberFrame3.healthbar,
        party4 = PartyFrame.MemberFrame4.healthbar
    }

    UF_Textures.powerbars = {
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

    function UF_Textures:Update()
        local texture = UF_Textures.LSM:Fetch('statusbar', UF_Textures.db.textures.unitframes)
        local powerColor

        -- Healthbar Texture
        for name, healthbar in pairs(UF_Textures.healthbars) do
            if UF_Textures.db.textures.unitframes == "None" then
                if not UF_Textures.db.color then
                    healthbar:SetStatusBarColor(0, 1, 0, 1)
                end

                if healthbar.currentTexture ~= UF_Textures.db.textures.unitframes then
                    healthbar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
                    healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")

                    healthbar.currentTexture = UF_Textures.db.textures.unitframes
                end

                healthbar.currentTexture = UF_Textures.db.textures.unitframes
            else
                if healthbar.currentTexture ~= UF_Textures.db.textures.unitframes then
                    healthbar:SetStatusBarTexture(texture)
                    healthbar:GetStatusBarTexture():SetDrawLayer("BORDER")

                    healthbar.currentTexture = UF_Textures.db.textures.unitframes
                end
            end
        end

        -- Powerbar Texture
        for name, powerbar in pairs(UF_Textures.powerbars) do
            if powerbar and powerbar.powerType then
                powerColor = PowerBarColor[powerbar.powerType]
                if UF_Textures.db.textures.unitframes == "None" then
                    powerbar.texture:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
                    powerbar.texture:SetDrawLayer("BORDER")
                else
                    powerbar.texture:SetTexture(texture)
                    powerbar.texture:SetDrawLayer("BORDER")

                    if powerbar.powerType == 0 then
                        powerbar:SetStatusBarColor(0, 0.5, 1)
                    else
                        powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                    end
                end
            end
        end

        if PlayerFrameAlternateManaBar then
            if UF_Textures.db.textures.unitframes == "None" then
                if PlayerFrameAlternateManaBar.texture ~= "None" then
                    PlayerFrameAlternateManaBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
                    PlayerFrameAlternateManaBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    PlayerFrameAlternateManaBar:SetStatusBarColor(0, 0, 1)

                    PlayerFrameAlternateManaBar.texture = "None"
                end
            else
                if PlayerFrameAlternateManaBar.texture ~= texture then
                    PlayerFrameAlternateManaBar:SetStatusBarTexture(texture)
                    PlayerFrameAlternateManaBar:GetStatusBarTexture():SetDrawLayer("BORDER")
                    PlayerFrameAlternateManaBar:SetStatusBarColor(0, 0.5, 1)

                    PlayerFrameAlternateManaBar.texture = texture
                end
            end
        end
    end
end

function UF_Textures:OnEnable()
    UF_Textures:SecureHookScript(UF_Textures.textures, "OnEvent", UF_Textures.Update)
end

function UF_Textures:OnDisable()
    UF_Textures:UnhookAll()
end
