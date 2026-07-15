local Style = mUI:NewModule("mUI.Modules.Actionbars.Style", "AceHook-3.0")

function Style:OnInitialize()
    Style.bars = {
        MainActionBar = MainActionBar,
        MultiBarBottomLeft = MultiBarBottomLeft,
        MultiBarBottomRight = MultiBarBottomRight,
        MultiBarLeft = MultiBarLeft,
        MultiBarRight = MultiBarRight,
        MultiBar5 = MultiBar5,
        MultiBar6 = MultiBar6,
        MultiBar7 = MultiBar7,
        PetActionBar = PetActionBar,
        StanceBar = StanceBar
    }

    function Style:HideDefaultArt()
        if StanceBar then
            if StanceBar.BackgroundArtLeft then
                StanceBar.BackgroundArtLeft:Hide()
                StanceBar.BackgroundArtLeft:SetAlpha(0)
            end

            if StanceBar.BackgroundArtMiddle then
                StanceBar.BackgroundArtMiddle:Hide()
                StanceBar.BackgroundArtMiddle:SetAlpha(0)
            end

            if StanceBar.BackgroundArtRight then
                StanceBar.BackgroundArtRight:Hide()
                StanceBar.BackgroundArtRight:SetAlpha(0)
            end
        end
    end

    function Style:UpdateBorders(bar, button, enabled)
        if not enabled or not button or (button.isForbidden and (not button:IsForbidden())) then
            return
        end

        if button.SlotBackground then
            button.SlotBackground:Hide()
        end

        -- Create Icon Mask
        if not button.mask then
            button.mask = button:CreateMaskTexture()
            button.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
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
            normalTexture:SetSize(40, 40)
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

        if button.Flash then
            button.Flash:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
            button.Flash:SetTexCoord(0.701171875, 0.880859375, 0.47509765625, 0.51904296875)
            button.Flash:SetAllPoints(normalTexture)
        end

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

    function Style:Update(isEnabled)
        local numButtons
        local button
        for name, bar in pairs(Style.bars) do
            if bar then
                numButtons = bar.numButtonsShowable

                for i = 1, numButtons do
                    if name == "MainActionBar" then
                        button = _G["ActionButton" .. i]
                    else
                        button = _G[name .. "Button" .. i]
                    end

                    if button then
                        if isEnabled then
                            Style:UpdateBorders(name, button, true)
                        end
                    end
                end
            end
        end
    end
end

function Style:OnEnable()
    Style:Update(true)
    Style:HideDefaultArt()
end
