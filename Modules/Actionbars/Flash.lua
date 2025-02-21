local Flash = mUI:NewModule("mUI.Modules.Actionbars.Flash")

function Flash:OnInitialize()
    -- Variables
    self.count = 5
    self.animations = {}
    self.animationNum = 1

    -- Create Frames
    for i = 1, self.count do
        self.frame = CreateFrame("Frame")
        self.texture = self.frame:CreateTexture()
        self.texture:SetTexture('Interface\\Cooldown\\star4')
        self.texture:SetAlpha(0)
        self.texture:SetAllPoints()
        self.texture:SetBlendMode("ADD")
        self.animationGroup = self.texture:CreateAnimationGroup()
        self.alpha1 = self.animationGroup:CreateAnimation("Alpha")
        self.alpha1:SetFromAlpha(0)
        self.alpha1:SetToAlpha(1)
        self.alpha1:SetDuration(0)
        self.alpha1:SetOrder(1)
        self.scale1 = self.animationGroup:CreateAnimation("Scale")
        self.scale1:SetScale(1.0, 1.0)
        self.scale1:SetDuration(0)
        self.scale1:SetOrder(1)
        self.scale2 = self.animationGroup:CreateAnimation("Scale")
        self.scale2:SetScale(1.5, 1.5)
        self.scale2:SetDuration(0.3)
        self.scale2:SetOrder(2)
        self.rotation2 = self.animationGroup:CreateAnimation("Rotation")
        self.rotation2:SetDegrees(90)
        self.rotation2:SetDuration(0.3)
        self.rotation2:SetOrder(2)
        self.animations[i] = { frame = self.frame, animationGroup = self.animationGroup }
    end

    function self:AnimateButton(button)
        if not button:IsVisible() then return true end
        local animation = self.animations[self.animationNum]
        local frame = animation.frame
        local animationGroup = animation.animationGroup
        frame:SetFrameStrata("HIGH")
        frame:SetFrameLevel(20)
        frame:SetAllPoints(button)
        animationGroup:Stop()
        animationGroup:Play()
        self.animationNum = (self.animationNum % self.count) + 1
        return true
    end
end

function Flash:OnEnable()
    mUI:SecureHook("MultiActionButtonDown", function(bname, id)
        if _G[bname]:GetEffectiveAlpha() == 1 then
            self:AnimateButton(_G[bname .. 'Button' .. id])
        end
    end)

    mUI:SecureHook(PetActionBar, "PetActionButtonDown", function(_, id)
        local button
        if PetActionBar then
            if id > NUM_PET_ACTION_SLOTS then return end
            button = _G["PetActionButton" .. id]
            if not button then return end
        end
        return self:AnimateButton(button)
    end)

    mUI:SecureHook("ActionButtonDown", function(id)
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
            self:AnimateButton(button)
        end
    end)
end

function Flash:OnDisable()
    mUI:Unhook("MultiActionButtonDown")
    mUI:Unhook(PetActionBar, "PetActionButtonDown")
    mUI:Unhook("ActionButtonDown")
end
