local Range = mUI:NewModule("mUI.Modules.Actionbars.Range")

function Range:OnInitialize()
    self.range = CreateFrame("Frame")
    self.updater = CreateFrame("Frame")
    self.delay = 0.2
    self.buttonColors = {}
    self.buttonsToUpdate = {}
    self.colors = {
        ["normal"] = { 1, 1, 1 },
        ["oor"] = { 0.8, 0.1, 0.1 },
        ["oom"] = { 0.5, 0.5, 1 },
        ["unusable"] = { 0.3, 0.3, 0.3 }
    }

    function self:UpdateButtons()
        if next(self.buttonsToUpdate) then
            for button in pairs(self.buttonsToUpdate) do
                self:UpdateButtonUsable(button)
            end
            return true
        end

        return false
    end

    function self:OnUpdateRange(elapsed)
        self.elapsed = (self.elapsed or self.delay) - elapsed
        if self.elapsed <= 0 then
            self.elapsed = UPDATE_DELAY

            if not self:UpdateButtons() then
                self:Hide()
            end
        end
    end

    function self:UpdateButtonStatus(button)
        local action = button.action

        if action and button:IsVisible() and HasAction(action) then
            self.buttonsToUpdate[button] = true
        else
            self.buttonsToUpdate[button] = nil
        end

        if next(self.buttonsToUpdate) then
            self.updater:Show()
        end
    end

    function self:UpdateButtonUsable(button, force)
        if force then
            self.buttonColors[button] = nil
        end

        local action = button.action
        local isUsable, notEnoughMana = IsUsableAction(action)

        if isUsable then
            local inRange = IsActionInRange(action)
            if inRange == false then
                self:SetButtonColor(button, "oor")
            else
                self:SetButtonColor(button, "normal")
            end
        elseif notEnoughMana then
            self:SetButtonColor(button, "oom")
        else
            self:SetButtonColor(button, "unusable")
        end
    end

    function self:SetButtonColor(button, colorIndex)
        if self.buttonColors[button] == colorIndex then
            return
        end
        self.buttonColors[button] = colorIndex

        local r, g, b = unpack(self.colors[colorIndex])
        button.icon:SetVertexColor(r, g, b)
    end

    function self:HookButtons(button)
        if button.Update then
            if not (mUI:IsHooked(button, "Update") and mUI:IsHooked(button, "UpdateUsable")) then
                mUI:SecureHook(button, "Update", function(button)
                    self:UpdateButtonStatus(button)
                end)
                mUI:SecureHook(button, "UpdateUsable", function(button)
                    self:UpdateButtonUsable(button, true)
                end)
            end

            if not (mUI:IsHooked(button, "OnShow") and mUI:IsHooked(button, "OnHide")) then
                mUI:SecureHookScript(button, "OnShow", function(button)
                    self:UpdateButtonStatus(button)
                end)
                mUI:SecureHookScript(button, "OnHide", function(button)
                    self:UpdateButtonStatus(button)
                end)
            end
        end
    end

    function self:UnhookButtons(button)
        if (mUI:IsHooked(button, "Update") and mUI:IsHooked(button, "UpdateUsable")) then
            mUI:Unhook(button, "Update")
            mUI:Unhook(button, "UpdateUsable")
        end

        if (mUI:IsHooked(button, "OnShow") and mUI:IsHooked(button, "OnHide")) then
            mUI:Unhook(button, "OnShow")
            mUI:Unhook(button, "OnHide")
        end
    end
end

function Range:OnEnable()
    mUI:HookScript(self.updater, "OnUpdate", function(_, elapsed)
        self:OnUpdateRange(elapsed)
    end)

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        self:HookButtons(_G["ActionButton" .. i])
        self:HookButtons(_G["MultiBarBottomLeftButton" .. i])
        self:HookButtons(_G["MultiBarBottomRightButton" .. i])
        self:HookButtons(_G["MultiBarRightButton" .. i])
        self:HookButtons(_G["MultiBarLeftButton" .. i])
        self:HookButtons(_G["MultiBar5Button" .. i])
        self:HookButtons(_G["MultiBar6Button" .. i])
        self:HookButtons(_G["MultiBar7Button" .. i])
    end
end

function Range:OnDisable()
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        self:UnhookButtons(_G["ActionButton" .. i])
        self:UnhookButtons(_G["MultiBarBottomLeftButton" .. i])
        self:UnhookButtons(_G["MultiBarBottomRightButton" .. i])
        self:UnhookButtons(_G["MultiBarRightButton" .. i])
        self:UnhookButtons(_G["MultiBarLeftButton" .. i])
        self:UnhookButtons(_G["MultiBar5Button" .. i])
        self:UnhookButtons(_G["MultiBar6Button" .. i])
        self:UnhookButtons(_G["MultiBar7Button" .. i])
    end

    mUI:Unhook(self.updater, "OnUpdate")
end
