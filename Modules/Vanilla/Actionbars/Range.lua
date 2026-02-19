local Range = mUI:NewModule("mUI.Modules.Actionbars.Range", "AceHook-3.0")

function Range:OnInitialize()
    Range.updater = CreateFrame("Frame", "mUIRangeUpdater")
    Range.elapsed = 0
    Range.delay = 0.15
    Range.buttonColors = {}
    Range.actionToButtons = {}
    Range.colors = {
        ["normal"] = {1, 1, 1},
        ["oor"] = {0.8, 0.1, 0.1},
        ["oom"] = {0.5, 0.5, 1},
        ["unusable"] = {0.3, 0.3, 0.3}
    }

    function Range:UpdateAllButtons(force)
        for action, buttons in pairs(Range.actionToButtons) do
            for button in pairs(buttons) do
                if button:IsVisible() then
                    Range:UpdateButtonUsable(button, force)
                end
            end
        end
    end

    function Range:OnRangeUpdate(elapsed)
        Range.elapsed = Range.elapsed + elapsed
        if Range.elapsed < Range.delay then
            return
        end
        Range.elapsed = 0
        Range:UpdateAllButtons()
    end

    function Range:OnRangeEvent()
        Range:UpdateAllButtons(true)
    end

    function Range:UpdateButtonStatus(button)
        local action = button.action
        if not action then
            return
        end

        if button:IsVisible() and HasAction(action) then
            if not Range.actionToButtons[action] then
                Range.actionToButtons[action] = {}
            end
            Range.actionToButtons[action][button] = true
        else
            if Range.actionToButtons[action] then
                Range.actionToButtons[action][button] = nil
                if not next(Range.actionToButtons[action]) then
                    Range.actionToButtons[action] = nil
                end
            end
        end
    end

    function Range:UpdateButtonUsable(button, force)
        if force then
            Range.buttonColors[button] = nil
        end

        local action = button.action
        local isUsable, notEnoughMana = IsUsableAction(action)

        if isUsable then
            if IsActionInRange(action) == false then
                Range:SetButtonColor(button, "oor")
            else
                Range:SetButtonColor(button, "normal")
            end
        elseif notEnoughMana then
            Range:SetButtonColor(button, "oom")
        else
            Range:SetButtonColor(button, "unusable")
        end
    end

    function Range:SetButtonColor(button, colorIndex)
        if Range.buttonColors[button] == colorIndex then
            return
        end
        Range.buttonColors[button] = colorIndex

        local r, g, b = unpack(Range.colors[colorIndex])
        button.icon:SetVertexColor(r, g, b)
    end

    function Range:HookButtons(button)
        if not button or not button.UpdateAction then
            return
        end

        if not Range:IsHooked("ActionButton_UpdateAction") then
            Range:SecureHook("ActionButton_UpdateAction", function(button)
                Range:UpdateButtonStatus(button)
            end)
        end

        if not Range:IsHooked(button, "OnShow") then
            Range:SecureHookScript(button, "OnShow", function(button)
                Range:UpdateButtonStatus(button)
            end)
        end

        if not Range:IsHooked(button, "OnHide") then
            Range:SecureHookScript(button, "OnHide", function(button)
                Range:UpdateButtonStatus(button)
            end)
        end

        Range:UpdateButtonStatus(button)
    end
end

function Range:OnEnable()
    Range.updater:RegisterEvent("PLAYER_TARGET_CHANGED")
    Range.updater:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    Range.updater:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
    Range.updater:RegisterEvent("ACTIONBAR_UPDATE_STATE")

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        Range:HookButtons(_G["ActionButton" .. i])
        Range:HookButtons(_G["MultiBarBottomLeftButton" .. i])
        Range:HookButtons(_G["MultiBarBottomRightButton" .. i])
        Range:HookButtons(_G["MultiBarRightButton" .. i])
        Range:HookButtons(_G["MultiBarLeftButton" .. i])
    end

    Range.updater:SetScript("OnUpdate", function(_, elapsed)
        Range:OnRangeUpdate(elapsed)
    end)
    Range.updater:SetScript("OnEvent", function()
        Range:OnRangeEvent()
    end)
end

function Range:OnDisable()
    Range.updater:SetScript("OnUpdate", nil)
    Range.updater:UnregisterAllEvents()
    Range:UnhookAll()
end
