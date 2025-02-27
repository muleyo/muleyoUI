local Mouseover = mUI:NewModule("mUI.Modules.Actionbars.Mouseover", "AceHook-3.0", "AceTimer-3.0")

function Mouseover:OnInitialize()
    -- Load Database
    Mouseover.db = mUI.db.profile.actionbars.mouseover

    Mouseover.bars = {
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

    -- Variables
    Mouseover.hookedBars = {}
    Mouseover.func = {}
    Mouseover.MICRO_BUTTONS = {
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

    Mouseover.BAG_BUTTONS = {
        "MainMenuBarBackpackButton",
        "BagBarExpandToggle",
        "CharacterBag0Slot",
        "CharacterBag1Slot",
        "CharacterBag2Slot",
        "CharacterBag3Slot",
        "CharacterReagentBag0Slot"
    }

    Mouseover.ACTION_BARS = {
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

    Mouseover.ACTION_BUTTONS = {
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
    Mouseover.mouseover = CreateFrame("Frame")

    function Mouseover:GCD(button, showGCD)
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

    function Mouseover:GetAlpha()
        if Mouseover.db.bar1 then
            if ActionButton1:GetEffectiveAlpha() and ActionButton1:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("ActionButton", true)
            else
                Mouseover:GCD("ActionButton", false)
            end
        end

        if Mouseover.db.bar2 then
            if MultiBarBottomLeft:GetEffectiveAlpha() and MultiBarBottomLeft:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBarBottomLeftButton", true)
            else
                Mouseover:GCD("MultiBarBottomLeftButton", false)
            end
        end

        if Mouseover.db.bar3 then
            if MultiBarBottomRight:GetEffectiveAlpha() and MultiBarBottomRight:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBarBottomRightButton", true)
            else
                Mouseover:GCD("MultiBarBottomRightButton", false)
            end
        end

        if Mouseover.db.bar4 then
            if MultiBarRight:GetEffectiveAlpha() and MultiBarRight:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBarRightButton", true)
            else
                Mouseover:GCD("MultiBarRightButton", false)
            end
        end

        if Mouseover.db.bar5 then
            if MultiBarLeft:GetEffectiveAlpha() and MultiBarLeft:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBarLeftButton", true)
            else
                Mouseover:GCD("MultiBarLeftButton", false)
            end
        end

        if Mouseover.db.bar6 then
            if MultiBar5:GetEffectiveAlpha() and MultiBar5:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBar5Button", true)
            else
                Mouseover:GCD("MultiBar5Button", false)
            end
        end

        if Mouseover.db.bar7 then
            if MultiBar6:GetEffectiveAlpha() and MultiBar6:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBar6Button", true)
            else
                Mouseover:GCD("MultiBar6Button", false)
            end
        end

        if Mouseover.db.bar8 then
            if MultiBar7:GetEffectiveAlpha() and MultiBar7:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("MultiBar7Button", true)
            else
                Mouseover:GCD("MultiBar7Button", false)
            end
        end

        if Mouseover.db.petbar then
            if PetActionBar:GetEffectiveAlpha() and PetActionBar:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("PetActionButton", true)
            else
                Mouseover:GCD("PetActionButton", false)
            end
        end

        if Mouseover.db.stancebar then
            if StanceBar:GetEffectiveAlpha() and StanceBar:GetEffectiveAlpha() > 0.001 then
                Mouseover:GCD("StanceButton")
            else
                Mouseover:GCD("StanceButton")
            end
        end
    end

    function Mouseover:SetAlpha(bar, alpha)
        if bar == "bar1" then
            for i = 1, 12 do
                _G[Mouseover.ACTION_BUTTONS[bar] .. i]:SetAlpha(alpha)
            end
        else
            Mouseover.ACTION_BARS[bar]:SetAlpha(alpha)
        end
    end

    function Mouseover:Mouseover(bar)
        if bar == "micromenu" then
            for i = 1, #Mouseover.MICRO_BUTTONS do
                if not (Mouseover:IsHooked(_G[Mouseover.MICRO_BUTTONS[i]], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.MICRO_BUTTONS[i]], "OnLeave")) then
                    Mouseover:SecureHookScript(_G[Mouseover.MICRO_BUTTONS[i]], "OnEnter", function()
                        Mouseover:CancelTimer(Mouseover.func[bar])
                        Mouseover:SetAlpha(bar, 1)
                    end)
                    Mouseover:SecureHookScript(_G[Mouseover.MICRO_BUTTONS[i]], "OnLeave", function()
                        Mouseover.func[bar] = Mouseover:ScheduleTimer(function()
                            Mouseover:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    Mouseover.hookedBars[Mouseover.MICRO_BUTTONS[i]] = true
                end
            end
        elseif bar == "bagbuttons" then
            for i = 1, #Mouseover.BAG_BUTTONS do
                if not (Mouseover:IsHooked(_G[Mouseover.BAG_BUTTONS[i]], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.BAG_BUTTONS[i]], "OnLeave")) then
                    Mouseover:SecureHookScript(_G[Mouseover.BAG_BUTTONS[i]], "OnEnter", function()
                        Mouseover:CancelTimer(Mouseover.func[bar])
                        Mouseover:SetAlpha(bar, 1)
                    end)
                    Mouseover:SecureHookScript(_G[Mouseover.BAG_BUTTONS[i]], "OnLeave", function()
                        Mouseover.func[bar] = Mouseover:ScheduleTimer(function()
                            Mouseover:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    Mouseover.hookedBars[Mouseover.BAG_BUTTONS[i]] = true
                end
            end
        elseif bar == "petbar" or bar == "stancebar" then
            for i = 1, 10 do
                if not (Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave")) then
                    Mouseover:SecureHookScript(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter", function()
                        Mouseover:CancelTimer(Mouseover.func[bar])
                        Mouseover:SetAlpha(bar, 1)
                    end)
                    Mouseover:SecureHookScript(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave", function()
                        Mouseover.func[bar] = Mouseover:ScheduleTimer(function()
                            Mouseover:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    Mouseover.hookedBars[Mouseover.ACTION_BUTTONS[bar] .. i] = true
                end
            end
        else
            for i = 1, 12 do
                if not (Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave")) then
                    Mouseover:SecureHookScript(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter", function()
                        Mouseover:CancelTimer(Mouseover.func[bar])
                        Mouseover:SetAlpha(bar, 1)
                    end)
                    Mouseover:SecureHookScript(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave", function()
                        Mouseover.func[bar] = Mouseover:ScheduleTimer(function()
                            Mouseover:SetAlpha(bar, 0)
                        end, 0.1)
                    end)
                    Mouseover.hookedBars[Mouseover.ACTION_BUTTONS[bar] .. i] = true
                end
            end
        end
    end

    function Mouseover:UnhookBars(bar)
        if bar == "micromenu" then
            for i = 1, #MICRO_BUTTONS do
                if Mouseover:IsHooked(_G[Mouseover.MICRO_BUTTONS[i]], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.MICRO_BUTTONS[i]], "OnLeave") then
                    Mouseover:Unhook(_G[Mouseover.MICRO_BUTTONS[i]], "OnEnter")
                    Mouseover:Unhook(_G[Mouseover.MICRO_BUTTONS[i]], "OnLeave")
                end
            end
        elseif bar == "bagbuttons" then
            for i = 1, #Mouseover.BAG_BUTTONS do
                if Mouseover:IsHooked(_G[Mouseover.BAG_BUTTONS[i]], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.BAG_BUTTONS[i]], "OnLeave") then
                    Mouseover:Unhook(_G[Mouseover.BAG_BUTTONS[i]], "OnEnter")
                    Mouseover:Unhook(_G[Mouseover.BAG_BUTTONS[i]], "OnLeave")
                end
            end
        elseif bar == "petbar" or bar == "stancebar" then
            for i = 1, 10 do
                if Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave") then
                    Mouseover:Unhook(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter")
                    Mouseover:Unhook(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave")
                end
            end
        else
            for i = 1, 12 do
                if Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter") and Mouseover:IsHooked(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave") then
                    Mouseover:Unhook(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnEnter")
                    Mouseover:Unhook(_G[Mouseover.ACTION_BUTTONS[bar] .. i], "OnLeave")
                end
            end
        end
    end

    function Mouseover:Update(bar, state)
        if bar == "bar1" then
            print(state)
        end
        if (not state) or state == "Default" then
            Mouseover:UnhookBars(bar)
            Mouseover:SetAlpha(bar, 1)

            if bar == "micromenu" then
                MicroMenu:Show()
            elseif bar == "bagbuttons" then
                BagsBar:Show()
            end
        elseif state == "Hidden" then
            Mouseover:UnhookBars(bar)

            if bar == "micromenu" then
                MicroMenu:Hide()
            elseif bar == "bagbuttons" then
                BagsBar:Hide()
            end
        else
            Mouseover:Mouseover(bar)
            Mouseover:SetAlpha(bar, 0)

            if bar == "micromenu" then
                MicroMenu:Show()
            elseif bar == "bagbuttons" then
                BagsBar:Show()
            end
        end
    end

    function Mouseover:ShowGrid()
        Mouseover:CancelAllTimers()
        for bar in pairs(Mouseover.hookedBars) do
            Mouseover:Unhook(bar, "OnEnter")
            Mouseover:Unhook(bar, "OnLeave")
        end
        for i = 1, 8 do
            Mouseover:SetAlpha("bar" .. i, 1)
        end

        Mouseover:SetAlpha("petbar", 1)
        Mouseover:SetAlpha("stancebar", 1)
        Mouseover:SetAlpha("micromenu", 1)
        Mouseover:SetAlpha("bagbuttons", 1)
    end

    function Mouseover:HideGrid()
        if not KeybindFrames_InQuickKeybindMode() then
            for bar, state in pairs(Mouseover.bars) do
                Mouseover:Update(bar, state)
            end
        end
    end
end

function Mouseover:OnEnable()
    for bar, state in pairs(Mouseover.bars) do
        if bar == "bar1" then
            print(state)
        end
        Mouseover:Update(bar, state)
    end

    Mouseover.mouseover:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    Mouseover.mouseover:RegisterEvent("ACTIONBAR_SHOWGRID")
    Mouseover.mouseover:RegisterEvent("ACTIONBAR_HIDEGRID")
    Mouseover:HookScript(Mouseover.mouseover, "OnEvent", function(_, event)
        if event == "ACTIONBAR_SHOWGRID" then
            Mouseover:ShowGrid()
        elseif event == "ACTIONBAR_HIDEGRID" then
            Mouseover:HideGrid()
        elseif event == "SPELL_UPDATE_COOLDOWN" then
            Mouseover:GetAlpha()
        end
    end)
end

function Mouseover:OnDisable()
    -- Unhook all bars
    for bar in pairs(Mouseover.bars) do
        Mouseover:Update(bar, false)
    end
    Mouseover:UnhookAll()
    Mouseover.mouseover:UnregisterAllEvents()
end
