local Style = mUI:NewModule("mUI.Modules.Actionbars.Style", "AceHook-3.0")

if WOW_PROJECT_ID ~= WOW_PROJECT_MISTS_CLASSIC then return end

-- LSM
Style.LSM = LibStub("LibSharedMedia-3.0")

-- Frames
Style.frame = CreateFrame("Frame")
Style.hide = CreateFrame("Frame")
Style.hide:Hide()

-- Register Events
Style.frame:RegisterEvent("PLAYER_LOGIN")
Style.frame:RegisterEvent("ADDON_LOADED")
Style.frame:RegisterEvent("CVAR_UPDATE")
Style.frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
Style.frame:RegisterEvent("UNIT_EXITED_VEHICLE")

-- Tables
Style.stanceButtons = {}
Style.defaultActionButtons = {
    "ActionButton",
    "MultiBarBottomLeftButton",
    "MultiBarBottomRightButton",
    "MultiBarRightButton",
    "MultiBarLeftButton",
    "StanceButton",
    "PetActionButton"
}
Style.microButtons = {
    "CharacterMicroButton",
    "SpellbookMicroButton",
    "TalentMicroButton",
    "AchievementMicroButton",
    "QuestLogMicroButton",
    "GuildMicroButton",
    "PVPMicroButton",
    "LFGMicroButton",
    "CollectionsMicroButton",
    "EJMicroButton",
    "StoreMicroButton",
    "MainMenuMicroButton"
}
Style.bagButtons = {
    "CharacterBag3Slot",
    "CharacterBag2Slot",
    "CharacterBag1Slot",
    "CharacterBag0Slot",
    "MainMenuBarBackpackButton"
}

function Style:FetchActiveBar()
    if (HasBonusActionBar() or HasOverrideActionBar() or HasVehicleActionBar() or HasTempShapeshiftActionBar()) then
        if (HasVehicleActionBar()) then
            return GetVehicleBarIndex()
        elseif (HasOverrideActionBar()) then
            return GetOverrideBarIndex()
        elseif (HasTempShapeshiftActionBar()) then
            return GetTempShapeshiftBarIndex()
        elseif (HasBonusActionBar() and GetActionBarPage() == 1) then
            return GetBonusBarIndex()
        end
    else
        return GetActionBarPage()
    end
end

function Style:UpdateActionBarVisibility()
    local AB1, AB2, AB3, AB4 = GetActionBarToggles()
    if AB1 then
        RegisterStateDriver(Style.bar2, "visibility", "[vehicleui] hide; show")
    else
        RegisterStateDriver(Style.bar2, "visibility", "hide")
    end

    if AB2 then
        RegisterStateDriver(Style.bar3, "visibility", "[vehicleui] hide; show")
    else
        RegisterStateDriver(Style.bar3, "visibility", "hide")
    end

    if AB3 then
        RegisterStateDriver(Style.bar4, "visibility", "[vehicleui] hide; show")
    else
        RegisterStateDriver(Style.bar4, "visibility", "hide")
    end

    if AB3 and AB4 then
        RegisterStateDriver(Style.bar5, "visibility", "[vehicleui] hide; show")
    else
        RegisterStateDriver(Style.bar5, "visibility", "hide")
    end
end

function Style:RepositionMicroButtons()
    for i = 1, #Style.microButtons do
        local button = _G[Style.microButtons[i]]
        local prevButton = _G[Style.microButtons[i - 1]]
        if button then
            button:SetParent(Style.micromenu)
            if i == 1 then
                button:ClearAllPoints()
                button:SetPoint("BOTTOMLEFT", Style.micromenu, "BOTTOMLEFT", 0, 0)
            else
                button:ClearAllPoints()
                button:SetPoint("LEFT", prevButton, "RIGHT", -3, 0)
            end
        end
    end
end

function Style:CreateActionbars()
    -- Create Bars
    Style.bar1 = CreateFrame("Frame", "mUIActionBar1", UIParent, "SecureHandlerStateTemplate")
    Style.bar2 = CreateFrame("Frame", "mUIActionBar2", UIParent)
    Style.bar3 = CreateFrame("Frame", "mUIActionBar3", UIParent)
    Style.bar4 = CreateFrame("Frame", "mUIActionBar4", UIParent)
    Style.bar5 = CreateFrame("Frame", "mUIActionBar5", UIParent)
    Style.micromenu = CreateFrame("Frame", "mUIMicroMenu", UIParent)
    Style.bagbar = CreateFrame("Frame", "mUIBagBar", UIParent)
    Style.petbar = CreateFrame("Frame", "mUIPetActionBar", UIParent)
    Style.stancebar = CreateFrame("Frame", "mUIStanceBar", UIParent)
    Style.expbar = CreateFrame("StatusBar", "mUIExpBar", UIParent, "BackdropTemplate")

    -- Set Bar Sizes
    Style.bar1:SetSize(462, 38)
    Style.bar2:SetSize(462, 38)
    Style.bar3:SetSize(462, 38)
    Style.bar4:SetSize(38, 462)
    Style.bar5:SetSize(38, 462)
    Style.micromenu:SetSize(305, 38)
    Style.bagbar:SetSize(155, 32)
    Style.petbar:SetSize(340, 32)
    Style.stancebar:SetSize(205, 32)
    Style.expbar:SetSize(460, 12)

    -- Set Bars movable
    Style.bar1:SetMovable(true)
    Style.bar2:SetMovable(true)
    Style.bar3:SetMovable(true)
    Style.bar4:SetMovable(true)
    Style.bar5:SetMovable(true)
    Style.micromenu:SetMovable(true)
    Style.bagbar:SetMovable(true)
    Style.petbar:SetMovable(true)
    Style.stancebar:SetMovable(true)
    Style.expbar:SetMovable(true)

    -- Set Attributes
    Style.bar1:SetAttribute("actionpage", Style:FetchActiveBar())
    Style.bar1:SetAttribute("type", "action")
    Style.bar1:SetAttribute("showgrid", 1)
    Style.bar1:SetAttribute("_onstate-page", [[
        local newstate

        -- Get ActionPage
        if (HasVehicleActionBar()) then
            newstate = GetVehicleBarIndex()
        elseif (HasOverrideActionBar()) then
            newstate = GetOverrideBarIndex()
        elseif (HasTempShapeshiftActionBar()) then
            newstate = GetTempShapeshiftBarIndex()
        elseif (HasBonusActionBar() and GetActionBarPage() == 1) then
            newstate = GetBonusBarIndex()
        else
            newstate = GetActionBarPage()
        end

        for id = 1, 12 do
            local button = self:GetFrameRef("ActionButton"..id)
            if button then
                button:SetAttribute("actionpage", newstate)
            end
        end
    ]])
    Style.bar2:SetAttribute("actionpage", 6)
    Style.bar2:SetAttribute("type", "action")
    Style.bar3:SetAttribute("actionpage", 5)
    Style.bar3:SetAttribute("type", "action")
    Style.bar4:SetAttribute("actionpage", 3)
    Style.bar4:SetAttribute("type", "action")
    Style.bar5:SetAttribute("actionpage", 4)
    Style.bar5:SetAttribute("type", "action")

    -- Use State Driver
    RegisterStateDriver(Style.bar1, "page",
        "[vehicleui] v; " ..
        "[overridebar] o; " ..
        "[possessbar] p; " ..
        "[actionbar:2] 2; " ..
        "[actionbar:3] 3; " ..
        "[actionbar:4] 4; " ..
        "[bonusbar:1,stealth] 1s; " ..                            -- cat stealth
        "[bonusbar:1] 1; " ..                                     -- cat
        "[bonusbar:2] 2; " ..                                     -- bear
        "[bonusbar:3] 3; " ..                                     -- moonkin/tree
        "[bonusbar:4] 4; " ..                                     -- other bonus
        "[form:1] f1; [form:2] f2; [form:3] f3; [form:4] f4; " .. -- any other forms
        "[stealth] st; " ..
        "base"
    )
    RegisterStateDriver(Style.bar1, "visibility", "[vehicleui] hide; show")
    RegisterStateDriver(Style.petbar, "visibility", "[vehicleui] hide;[pet] show; hide")
    RegisterStateDriver(Style.stancebar, "visibility", "[vehicleui] hide; show")

    -- Set initial visibility for bar2 and bar3 based on CVars
    Style:UpdateActionBarVisibility() -- Check if player is at max level for current expansion
    local maxLevel = GetMaxLevelForExpansionLevel(GetExpansionLevel())
    if UnitLevel("player") >= maxLevel then
        RegisterStateDriver(Style.expbar, "visibility", "hide")
    else
        RegisterStateDriver(Style.expbar, "visibility", "[vehicleui] hide; show")
    end
end

function Style:CreateStanceButtons()
    for i = 1, NUM_STANCE_SLOTS do
        local button = _G["StanceButton" .. i]
        local prevButton = _G["mUIStanceButton" .. (i - 1)]

        if button then
            local mUIbutton = CreateFrame("CheckButton", "mUIStanceButton" .. i, UIParent, "StanceButtonTemplate")

            mUIbutton:SetParent(Style.stancebar)
            mUIbutton:SetSize(button:GetSize())
            mUIbutton:SetScale(button:GetScale())
            mUIbutton:SetID(button:GetID())
            mUIbutton.icon:SetTexture(button.icon:GetTexture())
            mUIbutton.cooldown:SetCooldown(button.cooldown:GetCooldownTimes())
            mUIbutton:SetChecked(button:GetChecked())
            mUIbutton:SetEnabled(button:IsEnabled())

            mUIbutton:SetScript("OnEnter", function(self)
                button:GetScript("OnEnter")(button)
            end)

            mUIbutton:SetScript("OnLeave", function(self)
                button:GetScript("OnLeave")(button)
            end)

            if i == 1 then
                mUIbutton:SetPoint("BOTTOMLEFT", Style.stancebar, "BOTTOMLEFT", 0, 0)
            else
                mUIbutton:SetPoint("LEFT", prevButton, "RIGHT", 4, 0)
            end

            Style.stanceButtons[i] = mUIbutton

            Style:UpdateBorders("StanceButton", mUIbutton)
        end
    end

    for i = 1, #Style.stanceButtons do
        local mUIbutton = Style.stanceButtons[i]

        if mUIbutton and mUIbutton:IsShown() and i > GetNumShapeshiftForms() then
            mUIbutton:Hide()
        elseif mUIbutton and (not mUIbutton:IsShown()) and i <= GetNumShapeshiftForms() then
            mUIbutton:Show()
        end
    end

    if GetNumShapeshiftForms() > 0 then
        Style.stancebar:Show()
    else
        Style.stancebar:Hide()
    end
end

function Style:UpdateStanceButtons()
    for i = 1, NUM_STANCE_SLOTS do
        local mUIbutton = Style.stanceButtons[i]
        local button = _G["StanceButton" .. i]
        local texture, isActive = GetShapeshiftFormInfo(i)

        if button and mUIbutton then
            mUIbutton.icon:SetTexture(button.icon:GetTexture())

            if isActive then
                mUIbutton:SetChecked(true)
            else
                mUIbutton:SetChecked(false)
                local start, duration, enable = GetShapeshiftFormCooldown(i)

                if start and duration and enable and duration > 0 then
                    CooldownFrame_Set(mUIbutton.cooldown, start, duration, enable)
                end
            end

            if mUIbutton and mUIbutton:IsShown() and i > GetNumShapeshiftForms() then
                mUIbutton:Hide()
            elseif mUIbutton and (not mUIbutton:IsShown()) and i <= GetNumShapeshiftForms() then
                mUIbutton:Show()
            end

            mUI:Skin({ _G["mUIStanceButton" .. i .. "NormalTexture2"] }, true)
        end
    end

    if GetNumShapeshiftForms() > 0 then
        Style.stancebar:Show()
    else
        Style.stancebar:Hide()
    end
end

function Style:CreateExpBar()
    -- Set Experience Bar Values
    Style.expbar:SetMinMaxValues(0, 100)

    -- Create Experience Bar Backdrop
    Style.expbar.backdrop = CreateFrame("Frame", nil, Style.expbar, "BackdropTemplate")
    Style.expbar.backdrop:SetPoint("TOPLEFT", Style.expbar, "TOPLEFT", -1, 1)
    Style.expbar.backdrop:SetPoint("BOTTOMRIGHT", Style.expbar, "BOTTOMRIGHT", 1, -1)
    Style.expbar.backdrop:SetFrameLevel(Style.expbar:GetFrameLevel() + 1)
    Style.expbar.backdrop:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 6,
        bgFile = nil,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    -- Create Experience Bar Text
    Style.expbar.text = Style.expbar:CreateFontString(nil, "OVERLAY")
    Style.expbar.text:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    Style.expbar.text:SetPoint("CENTER", Style.expbar, "CENTER")
    Style.expbar.text:SetTextColor(1, 1, 1)
    Style.expbar.text:SetDrawLayer("OVERLAY", 7)

    -- Add background to expbar
    Style.expbar.bg = Style.expbar:CreateTexture(nil, "BACKGROUND")
    Style.expbar.bg:SetPoint("TOPLEFT", Style.expbar.backdrop, "TOPLEFT", 1, -1)
    Style.expbar.bg:SetPoint("BOTTOMRIGHT", Style.expbar.backdrop, "BOTTOMRIGHT", -1, 1)
    Style.expbar.bg:SetDrawLayer("BACKGROUND", -7)
    Style.expbar.bg:SetColorTexture(0.1, 0.1, 0.1, 0.9)

    -- Add rested XP indicator bar
    Style.expbar.rested = CreateFrame("StatusBar", nil, Style.expbar)
    Style.expbar.rested:SetSize(460, 12)
    Style.expbar.rested:SetPoint("BOTTOMLEFT", Style.expbar, 0, 0)
    Style.expbar.rested:SetMinMaxValues(0, 100)
    Style.expbar.rested:SetFrameLevel(Style.expbar:GetFrameLevel())

    -- Register Events
    Style.expbar:RegisterEvent("PLAYER_ENTERING_WORLD")
    Style.expbar:RegisterEvent("PLAYER_XP_UPDATE")
    Style.expbar:RegisterEvent("UPDATE_EXHAUSTION")
    Style.expbar:RegisterEvent("PLAYER_LEVEL_CHANGED")
    Style.expbar:RegisterEvent("PLAYER_LEVEL_UP")
end

function Style:UpdateExpBar()
    -- Set Experience Bar Texture
    Style.expbar:SetStatusBarTexture(Style.LSM:Fetch('statusbar', mUI.db.profile.unitframes.textures.unitframes))
    Style.expbar.rested:SetStatusBarTexture(Style.LSM:Fetch('statusbar',
        mUI.db.profile.unitframes.textures.unitframes))
    Style.expbar:SetStatusBarColor(0.6, 0.06, 0.9)
    Style.expbar.rested:SetStatusBarColor(0.2, 0.4, 1, 1)
    Style.expbar.backdrop:SetBackdropBorderColor(unpack(mUI:Color(0.25)))

    -- Hide Experience Bar if player is at max level
    if UnitLevel("player") >= GetMaxPlayerLevel() then
        Style.expbar:Hide()
        Style.expbar.bg:Hide()
        Style.expbar.rested:Hide()
        return
    else
        Style.expbar:Show()
    end

    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local restedXP = GetXPExhaustion() or 0
    local percent = 0
    if maxXP and maxXP > 0 then
        percent = (currentXP / maxXP) * 100
    end

    if restedXP > 0 then
        Style.expbar.rested:Show()

        -- Calculate how much of the current level the rested XP represents
        local remainingXPToLevel = maxXP - currentXP
        local restedXPForThisLevel = math.min(restedXP, remainingXPToLevel)
        local restedPercentForThisLevel = (restedXPForThisLevel / maxXP) * 100

        -- Set the rested bar value to current% + rested% (capped at 100% for this level)
        local restedBarValue = math.min(percent + restedPercentForThisLevel, 100)
        Style.expbar.rested:SetValue(restedBarValue)

        -- Set Exp Bar Text with the actual total rested percentage
        Style.expbar.text:SetText(
            mUI:abbrNum(currentXP) .. " / " ..
            mUI:abbrNum(maxXP) .. " XP - " ..
            string.format("%.1f%% (%.1f%% rested)", percent, restedPercentForThisLevel)
        )
    else
        -- Hide Rested XP Bar if not rested
        Style.expbar.rested:Hide()

        -- Set Exp Bar Text
        Style.expbar.text:SetText(
            mUI:abbrNum(currentXP) .. " / " ..
            mUI:abbrNum(maxXP) .. " XP - " ..
            string.format("%.1f%%", percent)
        )
    end

    Style.expbar:SetValue(percent)
end

function Style:UpdateExpBarStateDriver()
    if UnitLevel("player") >= GetMaxLevelForExpansionLevel(GetExpansionLevel()) then
        RegisterStateDriver(Style.expbar, "visibility", "hide")
    else
        RegisterStateDriver(Style.expbar, "visibility", "[vehicleui] hide; show")
    end
end

function Style:UpdateBorders(bar, button)
    if not button or (button.isForbidden and (not button:IsForbidden())) then return end

    -- Create Icon Mask
    if not button.mask then
        button.mask = button:CreateMaskTexture()
        button.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]],
            "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        button.mask:SetAllPoints(button.icon)
        button.icon:AddMaskTexture(button.mask)

        button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end

    -- Set Normal Texture
    button:SetNormalTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
    local normalTexture = button:GetNormalTexture()
    normalTexture:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    normalTexture:SetPoint("TOPLEFT", button)
    normalTexture:SetDrawLayer("OVERLAY", 7)

    if bar == "PetActionButton" then
        normalTexture:SetSize(33, 32)
    elseif bar == "StanceButton" then
        normalTexture:SetSize(33, 32)
    elseif bar == "BagButton" then
        normalTexture:SetSize(31, 31)
    elseif bar == "OverrideActionBar" then
        normalTexture:SetSize(56, 55)
    else
        normalTexture:SetSize(39, 38)
    end

    -- Set Pushed Texture
    button:SetPushedTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
    local pushedTexture = button:GetPushedTexture()
    pushedTexture:SetTexCoord(0.701171875, 0.880859375, 0.43017578125, 0.47412109375)
    pushedTexture:SetAllPoints(normalTexture)
    pushedTexture:SetDrawLayer("OVERLAY", 7)

    if bar ~= "BagButton" then
        -- Set Cooldown Position & Swipe Texture
        button.cooldown:SetEdgeScale(0.5)
        button.cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
        button.cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
        button.cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]])
        button.cooldown:SetFrameLevel(2)
        button.cooldown:SetSwipeColor(0.2, 0.2, 0.2, 0.75)
    end

    -- Set Highlight Texture
    button:SetHighlightTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
    local highlightTexture = button:GetHighlightTexture()
    highlightTexture:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
    highlightTexture:SetAllPoints(normalTexture)

    -- Set Checked Texture
    button:SetCheckedTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
    local checkedTexture = button:GetCheckedTexture()
    checkedTexture:SetTexCoord(0.701171875, 0.880859375, 0.52001953125, 0.56396484375)
    checkedTexture:SetAllPoints(normalTexture)

    if button.HotKey then
        button.HotKey:ClearAllPoints()
        button.HotKey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, -3)
    end

    if button.Name then
        button.Name:ClearAllPoints()
        button.Name:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
        button.Name:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    end

    if button.Count then
        button.Count:ClearAllPoints()
        button.Count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 2)
    end

    if _G[button:GetName() .. "FloatingBG"] then
        _G[button:GetName() .. "FloatingBG"]:Hide()
    end
end

function Style:SetPositions()
    if InCombatLockdown() then return end
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["ActionButton" .. i]
        local prevButton = _G["ActionButton" .. i - 1]

        if button then
            button:SetParent(Style.bar1)
            Style.bar1:SetFrameRef("ActionButton" .. i, button)

            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", Style.bar1, "BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("LEFT", prevButton, "RIGHT", 2.5, 0)
            end

            button:SetAttribute("parent-state-page", Style.bar1:GetAttribute("state-page"))
        end
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomLeftButton" .. i]
        local prevButton = _G["MultiBarBottomLeftButton" .. i - 1]

        if button then
            button:SetParent(Style.bar2)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", Style.bar2, "BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("LEFT", prevButton, "RIGHT", 2.5, 0)
            end
        end
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarBottomRightButton" .. i]
        local prevButton = _G["MultiBarBottomRightButton" .. i - 1]

        if button then
            button:SetParent(Style.bar3)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", Style.bar3, "BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("LEFT", prevButton, "RIGHT", 2.5, 0)
            end
        end
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarRightButton" .. i]
        local prevButton = _G["MultiBarRightButton" .. i - 1]

        if button then
            button:SetParent(Style.bar4)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("TOPLEFT", Style.bar4, "TOPLEFT", 0, 0)
            else
                button:SetPoint("TOP", prevButton, "BOTTOM", 0, -2.5)
            end
        end
    end

    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["MultiBarLeftButton" .. i]
        local prevButton = _G["MultiBarLeftButton" .. i - 1]

        if button then
            button:SetParent(Style.bar5)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("TOPLEFT", Style.bar5, "TOPLEFT", 0, 0)
            else
                button:SetPoint("TOP", prevButton, "BOTTOM", 0, -2.5)
            end
        end
    end

    for i = 1, NUM_PET_ACTION_SLOTS do
        local button = _G["PetActionButton" .. i]
        local prevButton = _G["PetActionButton" .. i - 1]

        if button then
            button:SetParent(Style.petbar)
            button:ClearAllPoints()

            if i == 1 then
                button:SetPoint("BOTTOMLEFT", Style.petbar, "BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("LEFT", prevButton, "RIGHT", 4, 0)
            end
        end
    end

    -- Vehicle Leave Button
    MainMenuBarVehicleLeaveButton:SetParent(Style.bar1)
    MainMenuBarVehicleLeaveButton:SetMovable(true)

    Style:RepositionMicroButtons()

    for i = 1, #Style.bagButtons do
        local button = _G[Style.bagButtons[i]]
        local prevButton = _G[Style.bagButtons[i - 1]]
        if button then
            button:SetParent(Style.bagbar)
            if i == 1 then
                button:ClearAllPoints()
                button:SetPoint("BOTTOMLEFT", Style.bagbar, "BOTTOMLEFT", 0, 0)

                -- Update Border Styles
                Style:UpdateBorders("BagButton", button)
                C_Timer.After(0.1, function()
                    mUI:Skin({ button:GetNormalTexture() }, true)
                end)
            else
                button:ClearAllPoints()
                button:SetPoint("LEFT", prevButton, "RIGHT", 1, 0)

                -- Update Border Styles
                Style:UpdateBorders("BagButton", button)
                C_Timer.After(0.1, function()
                    mUI:Skin({ button:GetNormalTexture() }, true)
                end)
            end
        end
    end
end

function Style:HideDefaultFrames()
    MainMenuBar:Hide()
    MainMenuBar:UnregisterAllEvents()
    MainMenuBar:SetParent(Style.hide)

    MultiBarBottomLeft:Hide()
    MultiBarBottomLeft:UnregisterAllEvents()
    MultiBarBottomLeft:SetParent(Style.hide)

    MultiBarBottomRight:Hide()
    MultiBarBottomRight:UnregisterAllEvents()
    MultiBarBottomRight:SetParent(Style.hide)

    MultiBarLeft:Hide()
    MultiBarLeft:UnregisterAllEvents()
    MultiBarLeft:SetParent(Style.hide)

    MultiBarRight:Hide()
    MultiBarRight:UnregisterAllEvents()
    MultiBarRight:SetParent(Style.hide)

    StanceBarFrame:Hide()
    StanceBarFrame:UnregisterAllEvents()
    StanceBarFrame:SetParent(Style.hide)

    PetActionBarFrame:Hide()
    PetActionBarFrame:SetParent(Style.hide)
end

Style:SecureHookScript(Style.frame, "OnEvent", function(_, event, cvar)
    if C_AddOns.IsAddOnLoaded("Bartender4") or C_AddOns.IsAddOnLoaded("Dominos") then return end
    if mUI.db.profile.actionbars.style ~= "mUI" then
        Style.frame:UnregisterAllEvents()
        return
    end

    if event == "PLAYER_LOGIN" then
        -- Create Stance Buttons
        Style:CreateStanceButtons()
        Style:SecureHookScript(mUIStanceButton1, "OnUpdate", Style.UpdateStanceButtons)
    elseif event == "ADDON_LOADED" then
        if not Style.loaded then
            -- Create Actionbars
            Style:CreateActionbars()

            -- Create Experience Bar
            Style:CreateExpBar()

            -- Set Positions
            Style:SetPositions()

            -- Hide default frames
            Style:HideDefaultFrames()

            -- Update Action Buttons
            Style:SecureHook("ActionButton_OnUpdate", function(button)
                if button:GetName():find("OverrideActionBar") then
                    Style:UpdateBorders("OverrideActionBar", button)
                else
                    Style:UpdateBorders(nil, button)
                end

                mUI:Skin({ button.NormalTexture }, true)
            end)

            -- Update Pet Actionbar
            Style:SecureHookScript(PetActionButton1, "OnUpdate", function()
                for i = 1, NUM_PET_ACTION_SLOTS do
                    Style:UpdateBorders("PetActionButton", _G["PetActionButton" .. i])
                    _G["PetActionButton" .. i .. "AutoCastable"]:Hide()

                    mUI:Skin({ _G["PetActionButton" .. i .. "NormalTexture2"] }, true)
                end
            end)

            -- Update Experience Bar
            Style:SecureHookScript(Style.expbar, "OnEvent", function(_, event)
                Style:UpdateExpBar()

                if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEVEL_UP" or event == "PLAYER_LEVEL_CHANGED" then
                    Style:UpdateExpBarStateDriver()
                end
            end)

            Style:SecureHook("MainMenuBarVehicleLeaveButton_Update", function()
                local point = mUI.db.profile.edit.frames["MainMenuBarVehicleLeaveButton"]

                if point then
                    MainMenuBarVehicleLeaveButton:ClearAllPoints()
                    MainMenuBarVehicleLeaveButton:SetPoint(point.position.point, UIParent, point.position.relativePoint,
                        point.position.x, point.position.y)
                else
                    MainMenuBarVehicleLeaveButton:ClearAllPoints()
                    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOM", UIParent, "BOTTOM", 260, 100)
                end
            end)

            -- Alternate Power Bar
            Style:SecureHookScript(PlayerPowerBarAlt, "OnShow", function()
                PlayerPowerBarAlt:ClearAllPoints()
                PlayerPowerBarAlt:SetPoint("TOP", UIParent, "TOP", 0, -50)
            end)

            Style.loaded = true
        end
    elseif event == "CVAR_UPDATE" and cvar == "enableMultiActionBars" then
        Style:UpdateActionBarVisibility()
    elseif event == "UNIT_ENTERING_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
        -- Reposition microbuttons when entering/exiting vehicles
        if Style.loaded then
            Style:RepositionMicroButtons()
        end
    end
end)
