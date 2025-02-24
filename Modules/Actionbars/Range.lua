local Range = mUI:NewModule("mUI.Modules.Actionbars.Range", "AceHook-3.0")

function Range:OnInitialize()
    Range.range = CreateFrame("Frame")
    Range.updater = CreateFrame("Frame")
    Range.delay = 0.2
    Range.buttonColors = {}
    Range.buttonsToUpdate = {}
    Range.colors = {
        ["normal"] = { 1, 1, 1 },
        ["oor"] = { 0.8, 0.1, 0.1 },
        ["oom"] = { 0.5, 0.5, 1 },
        ["unusable"] = { 0.3, 0.3, 0.3 }
    }

    function Range:UpdateButtons()
        if next(Range.buttonsToUpdate) then
            for button in pairs(Range.buttonsToUpdate) do
                Range:UpdateButtonUsable(button)
            end
            return true
        end

        return false
    end

    function Range:OnUpdateRange(elapsed)
        Range.elapsed = (Range.elapsed or Range.delay) - elapsed
        if Range.elapsed <= 0 then
            Range.elapsed = UPDATE_DELAY

            if not Range:UpdateButtons() then
                Range:Hide()
            end
        end
    end

    function Range:UpdateButtonStatus(button)
        local action = button.action

        if action and button:IsVisible() and HasAction(action) then
            Range.buttonsToUpdate[button] = true
        else
            Range.buttonsToUpdate[button] = nil
        end

        if next(Range.buttonsToUpdate) then
            Range.updater:Show()
        end
    end

    function Range:UpdateButtonUsable(button, force)
        if force then
            Range.buttonColors[button] = nil
        end

        local action = button.action
        local isUsable, notEnoughMana = IsUsableAction(action)

        if isUsable then
            local inRange = IsActionInRange(action)
            if inRange == false then
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
        if button.Update then
            if not (Range:IsHooked(button, "Update") and Range:IsHooked(button, "UpdateUsable")) then
                Range:SecureHook(button, "Update", function(button)
                    Range:UpdateButtonStatus(button)
                end)
                Range:SecureHook(button, "UpdateUsable", function(button)
                    Range:UpdateButtonUsable(button, true)
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
        end
    end
end

function Range:OnEnable()
    Range:HookScript(Range.updater, "OnUpdate", function(_, elapsed)
        Range:OnUpdateRange(elapsed)
    end)

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
end

function Range:OnDisable()
    Range:UnhookAll()
end
