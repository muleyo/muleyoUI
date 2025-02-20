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
        stancebar = StanceBar
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
            if _G[button .. i .. "Cooldown"] then
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
                _G["ActionButton" .. i]:SetAlpha(alpha)
            end
        else
            self.ACTION_BARS[bar]:SetAlpha(alpha)
        end
    end

    function self:Mouseover(bar)
        if bar == "petbar" then
            for i = 1, 10 do
                if not (mUI:IsHooked(_G["PetActionButton" .. i], "OnEnter") and mUI:IsHooked(_G["PetActionButton" .. i], "OnLeave")) then
                    mUI:SecureHookScript(_G["PetActionButton" .. i], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G["PetActionButton" .. i], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[bar] = true
                end
            end
        elseif bar == "stancebar" then
            for i = 1, 10 do
                if not (mUI:IsHooked(_G["StanceButton" .. i], "OnEnter") and mUI:IsHooked(_G["StanceButton" .. i], "OnLeave")) then
                    mUI:SecureHookScript(_G["StanceButton" .. i], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G["StanceButton" .. i], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[bar] = true
                end
            end
        elseif bar == "micromenu" then
            for i = 1, #MICRO_BUTTONS do
                if not (mUI:IsHooked(_G[MICRO_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[MICRO_BUTTONS[i]], "OnLeave")) then
                    mUI:SecureHookScript(_G[MICRO_BUTTONS[i]], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[MICRO_BUTTONS[i]], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[bar] = true
                end
            end
        elseif bar == "bagbar" then
            for i = 1, #BAG_BUTTONS do
                if not (mUI:IsHooked(_G[BAG_BUTTONS[i]], "OnEnter") and mUI:IsHooked(_G[BAG_BUTTONS[i]], "OnLeave")) then
                    mUI:SecureHookScript(_G[BAG_BUTTONS[i]], "OnEnter", function()
                        mUI:CancelTimer(self.func[bar])
                        self:SetAlpha(bar, 1)
                    end)
                    mUI:SecureHookScript(_G[BAG_BUTTONS[i]], "OnLeave", function()
                        self.func[bar] = mUI:ScheduleTimer(function()
                            self:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    self.hookedBars[bar] = true
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
                    self.hookedBars[bar] = true
                end
            end
        end
    end

    function self:Update(bar, enabled)
        --[[if enabled then
            self:Mouseover(bar)
            self:SetAlpha(bar, 0)
        else
            self:SetAlpha(bar, 1)
        end]]
        if self.db.bar1 then
            self:Mouseover("bar1")
            self:SetAlpha("bar1", 0)
        elseif not self.db.bar1 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["ActionButton" .. i], "OnEnter") and mUI:IsHooked(_G["ActionButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["ActionButton" .. i], "OnEnter")
                    mUI:Unhook(_G["ActionButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar1", 1)
        end
        if self.db.bar2 then
            self:onMouseover("bar2")
            self:SetAlpha("bar2", 0)
        elseif not self.db.bar2 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBarBottomLeftButton" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBarBottomLeftButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBarBottomLeftButton" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBarBottomLeftButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar2", 1)
        end
        if self.db.bar3 then
            self:onMouseover("bar3")
            self:SetAlpha("bar3", 0)
        elseif not self.db.bar3 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBarBottomRightButton" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBarBottomRightButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBarBottomRightButton" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBarBottomRightButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar3", 1)
        end
        if self.db.bar4 then
            self:onMouseover("bar4")
            self:SetAlpha("bar4", 0)
        elseif not self.db.bar4 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBarRightButton" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBarRightButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBarRightButton" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBarRightButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar4", 1)
        end
        if self.db.bar5 then
            self:onMouseover("bar5")
            self:SetAlpha("bar5", 0)
        elseif not self.db.bar5 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBarLeftButton" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBarLeftButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBarLeftButton" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBarLeftButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar5", 1)
        end
        if self.db.bar6 then
            self:onMouseover("bar6")
            self:SetAlpha("bar6", 0)
        elseif not self.db.bar6 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBar5Button" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBar5Button" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBar5Button" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBar5Button" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar6", 1)
        end
        if self.db.bar7 then
            self:onMouseover("bar7")
            self:SetAlpha("bar7", 0)
        elseif not self.db.bar7 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBar6Button" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBar6Button" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBar6Button" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBar6Button" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar7", 1)
        end
        if self.db.bar8 then
            self:onMouseover("bar8")
            self:SetAlpha("bar8", 0)
        elseif not self.db.bar8 then
            for i = 1, 12 do
                if mUI:IsHooked(_G["MultiBar7Button" .. i], "OnEnter") and mUI:IsHooked(_G["MultiBar7Button" .. i], "OnLeave") then
                    mUI:Unhook(_G["MultiBar7Button" .. i], "OnEnter")
                    mUI:Unhook(_G["MultiBar7Button" .. i], "OnLeave")
                end
            end
            self:SetAlpha("bar8", 1)
        end
        if self.db.petbar then
            self:onMouseover("petbar")
            self:SetAlpha("petbar", 0)
        elseif not self.db.petbar then
            for i = 1, 10 do
                if mUI:IsHooked(_G["PetActionButton" .. i], "OnEnter") and mUI:IsHooked(_G["PetActionButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["PetActionButton" .. i], "OnEnter")
                    mUI:Unhook(_G["PetActionButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("petbar", 1)
        end
        if self.db.stancebar then
            self:onMouseover("stancebar")
            self:SetAlpha("stancebar", 0)
        elseif not self.db.stancebar then
            for i = 1, 10 do
                if mUI:IsHooked(_G["StanceButton" .. i], "OnEnter") and mUI:IsHooked(_G["StanceButton" .. i], "OnLeave") then
                    mUI:Unhook(_G["StanceButton" .. i], "OnEnter")
                    mUI:Unhook(_G["StanceButton" .. i], "OnLeave")
                end
            end
            self:SetAlpha("stancebar", 1)
        end
        --[[
        if db.micromenu == "mouse_over" then
            self:onMouseover("micromenu")
            self:SetAlpha("micromenu", 0)
        elseif db.micromenu == "show" then
            self:SetAlpha("micromenu", 1)
        elseif db.micromenu == "hide" then
            MicroMenu:Hide()
        end
        if db.bagbar == "mouse_over" then
            self:onMouseover("bagbar")
            self:SetAlpha("bagbar", 0)
        elseif db.bagbar == "show" then
            self:SetAlpha("bagbar", 1)
        elseif db.bagbar == "hide" then
            BagsBar:Hide()
        end]]
    end

    function self:ShowGrid()
        mUI:CancelAllTimers()
        for bar in pairs(self.hookedBars) do
            mUI:Unhook(bar, "OnEnter")
            mUI:Unhook(bar, "OnLeave")
        end
        for i = 1, 10 do
            self:SetAlpha("bar" .. i, 1)
        end
    end

    function self:HideGrid()
        if not KeybindFrames_InQuickKeybindMode() then
            self:Update()
        end
    end
end

function Mouseover:OnEnable()
    self:Update()

    self.mouseover:RegisterEvent("ACTIONBAR_SHOWGRID", self:ShowGrid())
    self.mouseover:RegisterEvent("ACTIONBAR_HIDEGRID", self:ShowGrid())
    mUI:HookScript(self.mouseover, "OnEvent", function()
        if event == "ACTIONBAR_SHOWGRID" then
            self:ShowGrid()
        elseif event == "ACTIONBAR_HIDEGRID" then
            self:HideGrid()
        end
    end)
end

function Mouseover:OnDisable()
    -- Unhook all bars
    for bar in pairs(self.hookedBars) do
        mUI:Unhook(bar, "OnEnter")
        mUI:Unhook(bar, "OnLeave")
    end
    mUI:Unhook(self.mouseover, "OnEvent")
    self.mouseover:UnregisterAllEvents()
end
