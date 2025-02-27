local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Buffs & Debuffs
Theme.debuffColors = {
    ["none"] = { r = 0.80, g = 0, b = 0 },
    ["Magic"] = { r = 0.20, g = 0.60, b = 1.00 },
    ["Curse"] = { r = 0.60, g = 0.00, b = 1.00 },
    ["Disease"] = { r = 0.60, g = 0.40, b = 0 },
    ["Poison"] = { r = 0.00, g = 0.60, b = 0 }
}

Theme.aurabuttons = {}

function Theme:UpdateDuration(aura, timeLeft)
    if timeLeft >= 86400 then
        aura.Duration:SetFormattedText("%dd", ceil(timeLeft / 86400))
    elseif timeLeft >= 3600 then
        aura.Duration:SetFormattedText("%dh", ceil(timeLeft / 3600))
    elseif timeLeft >= 60 then
        aura.Duration:SetFormattedText("%dm", ceil(timeLeft / 60))
    else
        aura.Duration:SetFormattedText("%ds", timeLeft)
    end
end

function Theme:HookDurationUpdates(auraFrames)
    for _, auraFrame in pairs(auraFrames) do
        if auraFrame.SetFormattedText then
            if not Theme:IsHooked(auraFrame, "UpdateDuration") then
                Theme:SecureHook(auraFrame, "UpdateDuration", function(aura)
                    Theme:UpdateDuration(aura, aura.timeLeft)
                end)
            end
        end
    end
end

function Theme:ButtonDefault(button, isDebuff)
    local Backdrop = {
        bgFile = nil,
        edgeFile = "Interface\\Addons\\mUI\\Media\\Textures\\Core\\outer_shadow",
        tile = false,
        tileSize = 32,
        edgeSize = 6,
        insets = { left = 6, right = 6, top = 6, bottom = 6 },
    }

    local icon = button.Icon

    local border = CreateFrame("Frame", button.mUIBorder, button)
    border:SetSize(icon:GetWidth() + 4, icon:GetHeight() + 4)
    if not isDebuff then
        if BuffFrame.AuraContainer.isHorizontal then
            if BuffFrame.AuraContainer.addIconsToTop then
                border:SetPoint("CENTER", button, "CENTER", 0, -5)
            else
                border:SetPoint("CENTER", button, "CENTER", 0, 5)
            end
        else
            if not BuffFrame.AuraContainer.addIconsToRight then
                border:SetPoint("CENTER", button, "CENTER", 15, 0)
            else
                border:SetPoint("CENTER", button, "CENTER", -15, 0)
            end
        end
    else
        if DebuffFrame.AuraContainer.isHorizontal then
            if DebuffFrame.AuraContainer.addIconsToTop then
                border:SetPoint("CENTER", button, "CENTER", 0, -5)
            else
                border:SetPoint("CENTER", button, "CENTER", 0, 5)
            end
        else
            if not DebuffFrame.AuraContainer.addIconsToRight then
                border:SetPoint("CENTER", button, "CENTER", 15, 0)
            else
                border:SetPoint("CENTER", button, "CENTER", -15, 0)
            end
        end
    end

    border.texture = border:CreateTexture()
    border.texture:SetAllPoints()
    border.texture:SetTexture("Interface\\Addons\\mUI\\Media\\Textures\\Core\\gloss")
    border.texture:SetTexCoord(0, 1, 0, 1)
    border.texture:SetDrawLayer("BACKGROUND", -7)
    border.texture:SetVertexColor(unpack(mUI:Color(0.25)))

    border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
    border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
    border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
    border.shadow:SetBackdrop(Backdrop)
    border.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.25)))

    button.mUIBorder = border

    if not isDebuff then
        Theme.aurabuttons[button] = "playerbuff"
    else
        Theme.aurabuttons[button] = "playerdebuff"
    end
end

function Theme:UpdatePlayerBuffs()
    local Children = BuffFrame.auraFrames

    for index, child in pairs(Children) do
        local frame = select(index, BuffFrame.AuraContainer:GetChildren())
        local icon = frame.Icon
        local count = frame.count

        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

        if frame.TempEnchantBorder then frame.TempEnchantBorder:Hide() end

        if not frame.mUIBorder then
            Theme:ButtonDefault(frame)
        end
    end
end

function Theme:UpdatePlayerDebuffs()
    local Children = { DebuffFrame.AuraContainer:GetChildren() }

    for index, child in pairs(Children) do
        local frame = select(index, DebuffFrame.AuraContainer:GetChildren())
        local icon = frame.Icon

        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        if not frame.mUIBorder then
            Theme:ButtonDefault(frame, true)
        end

        -- Set the color of the Debuff Border
        local debuffType
        if (child.buttonInfo) then
            debuffType = child.buttonInfo.debuffType
        end
        local color
        if debuffType then
            color = DebuffTypeColor[debuffType]
        else
            color = DebuffTypeColor["none"]
        end

        frame.mUIBorder.shadow:SetBackdropBorderColor(color.r, color.g, color.b, 1)
    end
end

function Theme:UpdateUnitframeAuras(aura, isDebuff, unit)
    if not aura.mUIBorder then
        local Backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\mUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 4,
            insets = {
                left = 4,
                right = 4,
                top = 4,
                bottom = 4,
            },
        }

        local icon = aura.Icon
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetDrawLayer("BACKGROUND", -8)

        local border = CreateFrame("Frame", aura.mUIBorder, aura)

        border.texture = border:CreateTexture(aura.mUIBorder, "BACKGROUND", nil, -7)
        border.texture:SetTexture("Interface\\Addons\\mUI\\Media\\Textures\\Core\\gloss")
        border.texture:SetTexCoord(0, 1, 0, 1)
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:ClearAllPoints()
        border.texture:SetPoint("TOPLEFT", aura, "TOPLEFT", -1, 1)
        border.texture:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 1, -1)
        border.texture:SetVertexColor(0.4, 0.35, 0.35)

        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", aura, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetFrameLevel(aura:GetFrameLevel() - 1)
        border.shadow:SetBackdrop(Backdrop)

        aura.mUIBorder = border

        if not isDebuff then
            Theme.aurabuttons[aura] = "unitframebuff"
        else
            Theme.aurabuttons[aura] = "unitframedebuff"
        end
    end

    local color
    if unit and aura.auraInstanceID then
        local auraData = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, aura.auraInstanceID)
        color = Theme.debuffColors[auraData and auraData.dispelName or "none"]

        if mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
            aura.mUIBorder.shadow:SetBackdropBorderColor(color.r, color.g, color.b)
        else
            aura.mUIBorder.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.25)))
        end
    else
        aura.mUIBorder.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.25)))
    end

    if aura.Border then
        aura.Border:SetAlpha(0)
    end
end

function Theme:AuraPositions()
    -- Buffs - Text Positioning
    for i = 1, #BuffFrame.auraFrames do
        local duration = BuffFrame.auraFrames[i].Duration
        local count = BuffFrame.auraFrames[i].Count
        local border = BuffFrame.auraFrames[i].mUIBorder

        count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
        duration:SetDrawLayer("OVERLAY")

        if BuffFrame.AuraContainer.isHorizontal then
            if BuffFrame.AuraContainer.addIconsToTop then
                count:SetPoint("TOPRIGHT", 0, 12)
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 0, -15)
                if border then
                    border:SetPoint("CENTER", BuffFrame.auraFrames[i], "CENTER", 0, -5)
                end
            else
                count:SetPoint("TOPRIGHT", 0, 12)
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 0, -5)
                if border then
                    border:SetPoint("CENTER", BuffFrame.auraFrames[i], "CENTER", 0, 5)
                end
            end
        else
            if not BuffFrame.AuraContainer.addIconsToRight then
                count:SetPoint("TOPRIGHT", 0, 12)
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 15, -10)
                if border then
                    border:SetPoint("CENTER", BuffFrame.auraFrames[i], "CENTER", 15, 0)
                end
            else
                count:SetPoint("TOPRIGHT", -30, 12)
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", -13.5, -10)
                if border then
                    border:SetPoint("CENTER", BuffFrame.auraFrames[i], "CENTER", -15, 0)
                end
            end
        end
    end

    -- Debuffs - Text Positioning
    for i = 1, #DebuffFrame.auraFrames do
        if DebuffFrame.AuraContainer.isHorizontal then
            if DebuffFrame.AuraContainer.addIconsToTop then
                if DebuffFrame.auraFrames[i].Count then
                    local count = DebuffFrame.auraFrames[i].Count

                    count:SetPoint("TOPRIGHT", 0, 12)
                    count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                end

                if DebuffFrame.auraFrames[i].Duration then
                    local duration = DebuffFrame.auraFrames[i].Duration
                    if duration.SetFont then
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    end

                    duration:ClearAllPoints()
                    duration:SetPoint("CENTER", 0, -15)
                end

                local border = DebuffFrame.auraFrames[i].mUIBorder
                if border then
                    border:SetPoint("CENTER", DebuffFrame.auraFrames[i], "CENTER", 0, -5)
                end
            else
                if DebuffFrame.auraFrames[i].Count then
                    local count = DebuffFrame.auraFrames[i].Count

                    count:SetPoint("TOPRIGHT", 0, 12)
                    count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                end

                if DebuffFrame.auraFrames[i].Duration then
                    local duration = DebuffFrame.auraFrames[i].Duration
                    if duration.SetFont then
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    end

                    duration:ClearAllPoints()
                    duration:SetPoint("CENTER", 0, -5)
                end

                local border = DebuffFrame.auraFrames[i].mUIBorder
                if border then
                    border:SetPoint("CENTER", DebuffFrame.auraFrames[i], "CENTER", 0, 5)
                end
            end
        else
            if not DebuffFrame.AuraContainer.addIconsToRight then
                if DebuffFrame.auraFrames[i].Count then
                    local count = DebuffFrame.auraFrames[i].Count

                    count:SetPoint("TOPRIGHT", 0, 12)
                    count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                end

                if DebuffFrame.auraFrames[i].Duration then
                    local duration = DebuffFrame.auraFrames[i].Duration
                    if duration.SetFont then
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    end

                    duration:ClearAllPoints()
                    duration:SetPoint("CENTER", 15, -10)
                end

                local border = DebuffFrame.auraFrames[i].mUIBorder
                if border then
                    border:SetPoint("CENTER", DebuffFrame.auraFrames[i], "CENTER", 15, 0)
                end
            else
                if DebuffFrame.auraFrames[i].Count then
                    local count = DebuffFrame.auraFrames[i].Count

                    count:SetPoint("TOPRIGHT", -30, 12)
                    count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                end

                if DebuffFrame.auraFrames[i].Duration then
                    local duration = DebuffFrame.auraFrames[i].Duration
                    if duration.SetFont then
                        duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                    end

                    duration:ClearAllPoints()
                    duration:SetPoint("CENTER", -13.5, -10)
                end

                local border = DebuffFrame.auraFrames[i].mUIBorder
                if border then
                    border:SetPoint("CENTER", DebuffFrame.auraFrames[i], "CENTER", -15, 0)
                end
            end
        end

        if DebuffFrame.auraFrames[i].DebuffBorder then
            DebuffFrame.auraFrames[i].DebuffBorder:SetAlpha(0)
        end
    end
end
