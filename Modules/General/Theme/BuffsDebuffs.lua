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

    local border = CreateFrame("Frame", nil, button)
    border:SetSize(icon:GetWidth() + 4, icon:GetHeight() + 4)
    if BuffFrame.AuraContainer.isHorizontal then
        if BuffFrame.AuraContainer.addIconsToTop then
            border:SetPoint("CENTER", button, "CENTER", 0, -5)
        else
            border:SetPoint("CENTER", button, "CENTER", 0, 5)
        end
    elseif not BuffFrame.AuraContainer.isHorizontal then
        if not BuffFrame.AuraContainer.addIconsToRight then
            border:SetPoint("CENTER", button, "CENTER", 15, 0)
        else
            border:SetPoint("CENTER", button, "CENTER", -15, 0)
        end
    end


    border.texture = border:CreateTexture()
    border.texture:SetAllPoints()
    border.texture:SetTexture("Interface\\Addons\\mUI\\Media\\Textures\\Core\\gloss")
    border.texture:SetTexCoord(0, 1, 0, 1)
    border.texture:SetDrawLayer("BACKGROUND", -7)
    border.texture:SetVertexColor(0.4, 0.35, 0.35)

    border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
    border.shadow:SetPoint("TOPLEFT", border, "TOPLEFT", -4, 4)
    border.shadow:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 4, -4)
    border.shadow:SetBackdrop(Backdrop)
    border.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.15)))

    button.mUIBorder = border

    if not isDebuff then
        Theme.aurabuttons[button] = "buff"
    else
        Theme.aurabuttons[button] = "debuff"
    end
end

function Theme:UpdateBuffs()
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

function Theme:UpdateDebuffs()
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
        if frame.mUIBorder then
            local color
            if (debuffType) then
                color = Theme.debuffColors[debuffType]
            else
                color = Theme.debuffColors["none"]
            end

            if color then
                frame.mUIBorder.shadow:SetBackdropBorderColor(color.r, color.g, color.b, 1)
            else
                frame.mUIBorder.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.15)))
            end
        end
    end
end

function Theme:AuraTextPositions()
    -- Buffs - Text Positioning
    if BuffFrame.AuraContainer.isHorizontal then
        if BuffFrame.AuraContainer.addIconsToTop then
            for i = 1, #BuffFrame.auraFrames do
                local duration = BuffFrame.auraFrames[i].Duration
                local count = BuffFrame.auraFrames[i].Count

                count:SetPoint("TOPRIGHT", 0, 12)
                count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 0, -15)
            end
        else
            for i = 1, #BuffFrame.auraFrames do
                local duration = BuffFrame.auraFrames[i].Duration
                local count = BuffFrame.auraFrames[i].Count

                count:SetPoint("TOPRIGHT", 0, 12)
                count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 0, -5)
            end
        end
    elseif not BuffFrame.AuraContainer.isHorizontal then
        if not BuffFrame.AuraContainer.addIconsToRight then
            for i = 1, #BuffFrame.auraFrames do
                local duration = BuffFrame.auraFrames[i].Duration
                local count = BuffFrame.auraFrames[i].Count

                count:SetPoint("TOPRIGHT", 0, 12)
                count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", 15, -10)
            end
        else
            for i = 1, #BuffFrame.auraFrames do
                local duration = BuffFrame.auraFrames[i].Duration
                local count = BuffFrame.auraFrames[i].Count

                count:SetPoint("TOPRIGHT", -30, 12)
                count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

                duration:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
                duration:ClearAllPoints()
                duration:SetPoint("CENTER", -13.5, -10)
            end
        end
    end

    for i = 1, #BuffFrame.auraFrames do
        local duration = BuffFrame.auraFrames[i].Duration
        duration:SetDrawLayer("OVERLAY")
    end


    -- Debuffs - Text Positioning
    if DebuffFrame.AuraContainer.isHorizontal then
        if DebuffFrame.AuraContainer.addIconsToTop then
            for i = 1, #DebuffFrame.auraFrames do
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
            end
        else
            for i = 1, #DebuffFrame.auraFrames do
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
            end
        end
    elseif not DebuffFrame.AuraContainer.isHorizontal then
        if not DebuffFrame.AuraContainer.addIconsToRight then
            for i = 1, #DebuffFrame.auraFrames do
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
            end
        else
            for i = 1, #DebuffFrame.auraFrames do
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
            end
        end
    end

    for i = 1, #DebuffFrame.auraFrames do
        if DebuffFrame.auraFrames[i].DebuffBorder then
            DebuffFrame.auraFrames[i].DebuffBorder:SetAlpha(0)
        end
    end
end
