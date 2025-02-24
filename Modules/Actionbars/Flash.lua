local Flash = mUI:NewModule("mUI.Modules.Actionbars.Flash", "AceHook-3.0")

function Flash:OnInitialize()
    -- Variables
    Flash.count = 5
    Flash.animations = {}
    Flash.animationNum = 1

    -- Create Frames
    for i = 1, Flash.count do
        Flash.frame = CreateFrame("Frame")
        Flash.texture = Flash.frame:CreateTexture()
        Flash.texture:SetTexture('Interface\\Cooldown\\star4')
        Flash.texture:SetAlpha(0)
        Flash.texture:SetAllPoints()
        Flash.texture:SetBlendMode("ADD")
        Flash.animationGroup = Flash.texture:CreateAnimationGroup()
        Flash.alpha1 = Flash.animationGroup:CreateAnimation("Alpha")
        Flash.alpha1:SetFromAlpha(0)
        Flash.alpha1:SetToAlpha(1)
        Flash.alpha1:SetDuration(0)
        Flash.alpha1:SetOrder(1)
        Flash.scale1 = Flash.animationGroup:CreateAnimation("Scale")
        Flash.scale1:SetScale(1.0, 1.0)
        Flash.scale1:SetDuration(0)
        Flash.scale1:SetOrder(1)
        Flash.scale2 = Flash.animationGroup:CreateAnimation("Scale")
        Flash.scale2:SetScale(1.5, 1.5)
        Flash.scale2:SetDuration(0.3)
        Flash.scale2:SetOrder(2)
        Flash.rotation2 = Flash.animationGroup:CreateAnimation("Rotation")
        Flash.rotation2:SetDegrees(90)
        Flash.rotation2:SetDuration(0.3)
        Flash.rotation2:SetOrder(2)
        Flash.animations[i] = { frame = Flash.frame, animationGroup = Flash.animationGroup }
    end

    function Flash:AnimateButton(button)
        if not button:IsVisible() then return true end
        local animation = Flash.animations[Flash.animationNum]
        local frame = animation.frame
        local animationGroup = animation.animationGroup
        frame:SetFrameStrata("HIGH")
        frame:SetFrameLevel(20)
        frame:SetAllPoints(button)
        animationGroup:Stop()
        animationGroup:Play()
        Flash.animationNum = (Flash.animationNum % Flash.count) + 1
        return true
    end
end

function Flash:OnEnable()
    Flash:SecureHook("MultiActionButtonDown", function(bname, id)
        if _G[bname]:GetEffectiveAlpha() == 1 then
            Flash:AnimateButton(_G[bname .. 'Button' .. id])
        end
    end)

    Flash:SecureHook(PetActionBar, "PetActionButtonDown", function(_, id)
        local button
        if PetActionBar then
            if id > NUM_PET_ACTION_SLOTS then return end
            button = _G["PetActionButton" .. id]
            if not button then return end
        end
        return Flash:AnimateButton(button)
    end)

    Flash:SecureHook("ActionButtonDown", function(id)
        local button
        if C_PetBattles.IsInBattle() then
            if PetBattleFrame then
                if id > NUM_BATTLE_PET_HOTKEYS then return end
                button = PetBattleFrame.BottomFrame.abilityButtons[id]
                if id == BATTLE_PET_ABILITY_SWITCH then
                    button = PetBattleFrame.BottomFrame.SwitchPetButton;
                elseif id == BATTLE_PET_ABILITY_CATCH then
                    button = PetBattleFrame.BottomFrame.CatchButton;
                end
                if not button then return end
            end
            return
        end
        if OverrideActionBar and OverrideActionBar:IsShown() then
            if id > NUM_OVERRIDE_BUTTONS then return end
            button = _G["OverrideActionBarButton" .. id]
        else
            button = _G["ActionButton" .. id]
        end
        if not button then return end
        if button:GetEffectiveAlpha() == 1 then
            Flash:AnimateButton(button)
        end
    end)
end

function Flash:OnDisable()
    Flash:UnhookAll()
end
