local Range = mUI:NewModule("mUI.Modules.Actionbars.Range", "AceHook-3.0")

function Range:OnInitialize()
    Range.updater = CreateFrame("Frame", "mUIRangeUpdater")
    Range.buttonColors = {}
    Range.actionToButtons = {}
    Range.colors = {
        ["normal"] = {1, 1, 1},
        ["oor"] = {0.8, 0.1, 0.1},
        ["oom"] = {0.5, 0.5, 1},
        ["unusable"] = {0.3, 0.3, 0.3}
    }

    function Range:UpdateAllButtons()
        for action, buttons in pairs(Range.actionToButtons) do
            for button in pairs(buttons) do
                if button:IsVisible() then
                    Range:UpdateButtonUsable(button, nil, true)
                end
            end
        end
    end

    function Range:OnRangeEvent(event, ...)
        if event == "ACTION_RANGE_CHECK_UPDATE" then
            local actionSlot = ...
            local buttons = Range.actionToButtons[actionSlot]
            if buttons then
                for button in pairs(buttons) do
                    if button:IsVisible() then
                        Range:UpdateButtonUsable(button, nil, true)
                    end
                end
            end
        else
            Range:UpdateAllButtons()
        end
    end

    function Range:UpdateButtonStatus(button)
        local action = button.action
        if not action then
            return
        end

        if button:IsVisible() and HasAction(action) then
            if not Range.actionToButtons[action] then
                Range.actionToButtons[action] = {}
                C_ActionBar.EnableActionRangeCheck(action, true)
            end
            Range.actionToButtons[action][button] = true
        else
            if Range.actionToButtons[action] then
                Range.actionToButtons[action][button] = nil
                if not next(Range.actionToButtons[action]) then
                    C_ActionBar.EnableActionRangeCheck(action, false)
                    Range.actionToButtons[action] = nil
                end
            end
        end
    end

    function Range:UpdateButtonUsable(button, isInRange, force)
        if force then
            Range.buttonColors[button] = nil
        end

        local action = button.action
        local isUsable, notEnoughMana = C_ActionBar.IsUsableAction(action)

        if isUsable then
            if isInRange == nil then
                isInRange = C_ActionBar.IsActionInRange(action)
            end

            if isInRange == false and UnitExists("target") then
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
        if button and button.Update then
            if not (Range:IsHooked(button, "Update") and Range:IsHooked(button, "UpdateUsable")) then
                Range:SecureHook(button, "Update", function(button)
                    Range:UpdateButtonStatus(button)
                end)
                Range:SecureHook(button, "UpdateUsable", function(button)
                    Range:UpdateButtonUsable(button, nil, true)
                end)
            end

            if not (Range:IsHooked(button, "OnShow") and Range:IsHooked(button, "OnHide")) then
                Range:SecureHookScript(button, "OnShow", function(button)
                    Range:UpdateButtonStatus(button)
                end)
                Range:SecureHookScript(button, "OnHide", function(button)
                    Range:UpdateButtonStatus(button)
                end)
            end

            Range:UpdateButtonStatus(button)
        end
    end
end

function Range:OnEnable()
    Range.updater:RegisterEvent("ACTION_RANGE_CHECK_UPDATE")
    Range.updater:RegisterEvent("SPELL_RANGE_CHECK_UPDATE")
    Range.updater:RegisterEvent("PLAYER_TARGET_CHANGED")
    Range.updater:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        Range:HookButtons(_G["ActionButton" .. i])
        Range:HookButtons(_G["MultiBarBottomLeftButton" .. i])
        Range:HookButtons(_G["MultiBarBottomRightButton" .. i])
        Range:HookButtons(_G["MultiBarRightButton" .. i])
        Range:HookButtons(_G["MultiBarLeftButton" .. i])
        Range:HookButtons(_G["MultiBar5Button" .. i])
        Range:HookButtons(_G["MultiBar6Button" .. i])
        Range:HookButtons(_G["MultiBar7Button" .. i])
    end

    Range:RawHookScript(Range.updater, "OnEvent", function(_, event, ...)
        Range:OnRangeEvent(event, ...)
    end, true)
end

function Range:OnDisable()
    Range.updater:UnregisterAllEvents()
    Range:UnhookAll()
end
