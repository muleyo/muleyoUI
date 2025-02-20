local Mouseover = mUI:NewModule("mUI.Modules.Actionbars.Mouseover")

function Mouseover:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.actionbars.mouseover

    -- Variables
    self.hookedBars = {}
    self.func = {}
    self.MICRO_BUTTONS = {
        "CharacterMicroButton",
        "ProfessionMicroButton",
        "PlayerSpellsMicroButton",
        "AchievementMicroButton",
        "QuestLogMicroButton",
        "GuildMicroButton",
        "LFDMicroButton",
        "CollectionsMicroButton",
        "EJMicroButton",
        "StoreMicroButton",
        "MainMenuMicroButton",
    }

    self.BAG_BUTTONS = {
        "MainMenuBarBackpackButton",
        "BagBarExpandToggle",
        "CharacterBag0Slot",
        "CharacterBag1Slot",
        "CharacterBag2Slot",
        "CharacterBag3Slot",
        "CharacterReagentBag0Slot"
    }

    self.ACTION_BARS = {
        bar2 = MultiBarBottomLeft,
        bar3 = MultiBarBottomRight,
        bar4 = MultiBarRight,
        bar5 = MultiBarLeft,
        bar6 = MultiBar5,
        bar7 = MultiBar6,
        bar8 = MultiBar7,
        petbar = PetActionBar,
        stancebar = StanceBar,
        micromenu = MicroMenu,
        bagbuttons = BagsBar
    }

    self.ACTION_BUTTONS = {
        bar1 = "ActionButton",
        bar2 = "MultiBarBottomLeftButton",
        bar3 = "MultiBarBottomRightButton",
        bar4 = "MultiBarRightButton",
        bar5 = "MultiBarLeftButton",
        bar6 = "MultiBar5Button",
        bar7 = "MultiBar6Button",
        bar8 = "MultiBar7Button",
        petbar = "PetActionButton",
        stancebar = "StanceButton"
    }

    -- Frames
    self.mouseover = CreateFrame("Frame")

    function self:GCD(button, showGCD)
        for i = 1, 12 do
            local b = _G[button .. i .. "Cooldown"]
            if b then
                if showGCD then
                    _G[button .. i .. "Cooldown"]:SetDrawBling(true)
                else
                    _G[button .. i .. "Cooldown"]:SetDrawBling(false)
                end
            end
        end
    end

    function self:GetAlpha()
        if self.db.bar1 then
            if ActionButton1:GetEffectiveAlpha() and ActionButton1:GetEffectiveAlpha() > 0.001 then
                self:GCD("ActionButton", true)
            else
                self:GCD("ActionButton", false)
            end
        end

        if self.db.bar2 then
            if MultiBarBottomLeft:GetEffectiveAlpha() and MultiBarBottomLeft:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBarBottomLeftButton", true)
            else
                self:GCD("MultiBarBottomLeftButton", false)
            end
        end

        if self.db.bar3 then
            if MultiBarBottomRight:GetEffectiveAlpha() and MultiBarBottomRight:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBarBottomRightButton", true)
            else
                self:GCD("MultiBarBottomRightButton", false)
            end
        end

        if self.db.bar4 then
            if MultiBarRight:GetEffectiveAlpha() and MultiBarRight:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBarRightButton", true)
            else
                self:GCD("MultiBarRightButton", false)
            end
        end

        if self.db.bar5 then
            if MultiBarLeft:GetEffectiveAlpha() and MultiBarLeft:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBarLeftButton", true)
            else
                self:GCD("MultiBarLeftButton", false)
            end
        end

        if self.db.bar6 then
            if MultiBar5:GetEffectiveAlpha() and MultiBar5:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBar5Button", true)
            else
                self:GCD("MultiBar5Button", false)
            end
        end

        if self.db.bar7 then
            if MultiBar6:GetEffectiveAlpha() and MultiBar6:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBar6Button", true)
            else
                self:GCD("MultiBar6Button", false)
            end
        end

        if self.db.bar8 then
            if MultiBar7:GetEffectiveAlpha() and MultiBar7:GetEffectiveAlpha() > 0.001 then
                self:GCD("MultiBar7Button", true)
            else
                self:GCD("MultiBar7Button", false)
            end
        end

        if self.db.petbar then
            if PetActionBar:GetEffectiveAlpha() and PetActionBar:GetEffectiveAlpha() > 0.001 then
                self:GCD("PetActionButton", true)
            else
                self:GCD("PetActionButton", false)
            end
        end

        if self.db.stancebar then
            if StanceBar:GetEffectiveAlpha() and StanceBar:GetEffectiveAlpha() > 0.001 then
                self:GCD("StanceButton")
            else
                self:GCD("StanceButton")
            end
        end
    end

    function self:SetAlpha(bar, alpha)
        if bar == "bar1" then
            for i = 1, 12 do
                _G[self.ACTION_BUTTONS[bar] .. i]:SetAlpha(alpha)
            end
        else
            self.ACTION_BARS[bar]:SetAlpha(alpha)
        end
    end

    function self:Mouseover(bar)
        if bar == "micromenu" then
            for i = 1, #self.MICRO_BUTTONS do
                if not (mUI:IsHooked(_G[self.MICRO_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[self.MICRO_BUTTONS[i]], "OnLeave")) then
                    mUI:SecureHookScript(_G[self.MICRO_BUTTONS[i]], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[self.MICRO_BUTTONS[i]], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[self.MICRO_BUTTONS[i]] = true
                end
            end
        elseif bar == "bagbuttons" then
            for i = 1, #self.BAG_BUTTONS do
                if not (mUI:IsHooked(_G[self.BAG_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[self.BAG_BUTTONS[i]], "OnLeave")) then
                    mUI:SecureHookScript(_G[self.BAG_BUTTONS[i]], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[self.BAG_BUTTONS[i]], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[self.BAG_BUTTONS[i]] = true
                end
            end
        elseif bar == "petbar" or bar == "stancebar" then
            for i = 1, 10 do
                if not (mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter") and mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave")) then
                    mUI:SecureHookScript(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[self.ACTION_BUTTONS[bar] .. i] = true
                end
            end
        else
            for i = 1, 12 do
                if not (mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter") and mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave")) then
                    mUI:SecureHookScript(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[self.ACTION_BUTTONS[bar] .. i] = true
                end
            end
        end
    end

    function self:UnhookBars(bar)
        if bar == "micromenu" then
            for i = 1, #MICRO_BUTTONS do
                if mUI:IsHooked(_G[self.MICRO_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[self.MICRO_BUTTONS[i]], "OnLeave") then
                    mUI:Unhook(_G[self.MICRO_BUTTONS[i]], "OnEnter")
                    mUI:Unhook(_G[self.MICRO_BUTTONS[i]], "OnLeave")
                end
            end
        elseif bar == "bagbuttons" then
            for i = 1, #self.BAG_BUTTONS do
                if mUI:IsHooked(_G[self.BAG_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[self.BAG_BUTTONS[i]], "OnLeave") then
                    mUI:Unhook(_G[self.BAG_BUTTONS[i]], "OnEnter")
                    mUI:Unhook(_G[self.BAG_BUTTONS[i]], "OnLeave")
                end
            end
        elseif bar == "petbar" or bar == "stancebar" then
            for i = 1, 10 do
                if mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter") and mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave") then
                    mUI:Unhook(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter")
                    mUI:Unhook(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave")
                end
            end
        else
            for i = 1, 12 do
                if mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter") and mUI:IsHooked(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave") then
                    mUI:Unhook(_G[self.ACTION_BUTTONS[bar] .. i], "OnEnter")
                    mUI:Unhook(_G[self.ACTION_BUTTONS[bar] .. i], "OnLeave")
                end
            end
        end
    end

    function self:Update(bar, state)
        if (not state) or state == "Default" then
            self:UnhookBars(bar)
            self:SetAlpha(bar, 1)

            if bar == "micromenu" then
                MicroMenu:Show()
            elseif bar == "bagbuttons" then
                BagsBar:Show()
            end
        elseif state == "Hidden" then
            self:UnhookBars(bar)

            if bar == "micromenu" then
                MicroMenu:Hide()
            elseif bar == "bagbuttons" then
                BagsBar:Hide()
            end
        else
            self:Mouseover(bar)
            self:SetAlpha(bar, 0)

            if bar == "micromenu" then
                MicroMenu:Show()
            elseif bar == "bagbuttons" then
                BagsBar:Show()
            end
        end
    end

    function self:ShowGrid()
        mUI:CancelAllTimers()
        for bar in pairs(self.hookedBars) do
            mUI:Unhook(bar, "OnEnter")
            mUI:Unhook(bar, "OnLeave")
        end
        for i = 1, 8 do
            self:SetAlpha("bar" .. i, 1)
        end

        self:SetAlpha("petbar", 1)
        self:SetAlpha("stancebar", 1)
        self:SetAlpha("micromenu", 1)
        self:SetAlpha("bagbuttons", 1)
    end

    function self:HideGrid()
        if not KeybindFrames_InQuickKeybindMode() then
            for bar, state in pairs(self.bars) do
                self:Update(bar, state)
            end
        end
    end
end

function Mouseover:OnEnable()
    self.bars = {
        bar1 = mUI.db.profile.actionbars.mouseover.bar1,
        bar2 = mUI.db.profile.actionbars.mouseover.bar2,
        bar3 = mUI.db.profile.actionbars.mouseover.bar3,
        bar4 = mUI.db.profile.actionbars.mouseover.bar4,
        bar5 = mUI.db.profile.actionbars.mouseover.bar5,
        bar6 = mUI.db.profile.actionbars.mouseover.bar6,
        bar7 = mUI.db.profile.actionbars.mouseover.bar7,
        bar8 = mUI.db.profile.actionbars.mouseover.bar8,
        petbar = mUI.db.profile.actionbars.mouseover.petbar,
        stancebar = mUI.db.profile.actionbars.mouseover.stancebar,
        micromenu = mUI.db.profile.actionbars.mouseover.micromenu,
        bagbuttons = mUI.db.profile.actionbars.mouseover.bagbuttons
    }

    for bar, state in pairs(self.bars) do
        self:Update(bar, state)
    end

    self.mouseover:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    self.mouseover:RegisterEvent("ACTIONBAR_SHOWGRID")
    self.mouseover:RegisterEvent("ACTIONBAR_HIDEGRID")
    mUI:HookScript(self.mouseover, "OnEvent", function(_, event)
        if event == "ACTIONBAR_SHOWGRID" then
            self:ShowGrid()
        elseif event == "ACTIONBAR_HIDEGRID" then
            self:HideGrid()
        elseif event == "SPELL_UPDATE_COOLDOWN" then
            self:GetAlpha()
        end
    end)
end

function Mouseover:OnDisable()
    -- Unhook all bars
    for bar in pairs(self.bars) do
        self:Update(bar, false)
    end
    mUI:Unhook(self.mouseover, "OnEvent")
    self.mouseover:UnregisterAllEvents()
end
