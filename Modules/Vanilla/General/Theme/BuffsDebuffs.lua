local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Buffs & Debuffs
Theme.debuffColors = {
    ["none"] = {
        r = 0.80,
        g = 0,
        b = 0
    },
    ["Magic"] = {
        r = 0.20,
        g = 0.60,
        b = 1.00
    },
    ["Curse"] = {
        r = 0.60,
        g = 0.00,
        b = 1.00
    },
    ["Disease"] = {
        r = 0.60,
        g = 0.40,
        b = 0
    },
    ["Poison"] = {
        r = 0.00,
        g = 0.60,
        b = 0
    }
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
    button.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Create Border
    button.mUIBorder = button:CreateTexture(nil, "OVERLAY", nil, 7)
    button.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border.png]])

    -- Set Border Position
    button.mUIBorder:SetPoint("TOPLEFT", button.Icon, "TOPLEFT", -1, 1)
    button.mUIBorder:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 1, -1)

    -- Create Border Mask
    button.mUIBorder.mask = button:CreateMaskTexture()
    button.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    button.mUIBorder.mask:SetAllPoints(button.Icon)
    button.Icon:AddMaskTexture(button.mUIBorder.mask)

    -- Set Border Color
    button.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))

    if not isDebuff then
        Theme.aurabuttons[button] = "playerbuff"
    else
        Theme.aurabuttons[button] = "playerdebuff"
    end
end

function Theme:ApplySkin(button, icon, unit, isDebuff)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Create Border
    button.mUIBorder = button:CreateTexture()
    button.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
    button.mUIBorder:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
    button.mUIBorder:SetPoint("TOPLEFT", icon)
    button.mUIBorder:SetDrawLayer("OVERLAY", 6)
    if unit then
        button:SetFrameLevel(TargetFrameToT:GetFrameLevel() - 1)
        button.mUIBorder:SetSize(button:GetWidth() + 1, button:GetHeight())
    else
        button.mUIBorder:SetSize(button:GetWidth() + 3, button:GetHeight() + 2)
    end

    -- Set Icon Mask
    button.mUIBorder.mask = button:CreateMaskTexture()
    button.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    button.mUIBorder.mask:SetAllPoints(icon)
    icon:AddMaskTexture(button.mUIBorder.mask)

    if button.duration then
        button.duration:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
        button.duration:ClearAllPoints()
        button.duration:SetPoint("BOTTOM", 0, 0)
    elseif _G[button:GetName() .. "Cooldown"] then
        _G[button:GetName() .. "Cooldown"]:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]])
        _G[button:GetName() .. "Cooldown"]:SetAllPoints(icon)
        _G[button:GetName() .. "Cooldown"]:SetSize(button:GetSize() - 3, button:GetSize() - 3)
    end

    if button.count then
        button.count:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
        button.count:ClearAllPoints()
        button.count:SetPoint("TOPRIGHT", -1, -2)
    elseif _G[button:GetName() .. "Count"] then
        _G[button:GetName() .. "Count"]:SetFont(STANDARD_TEXT_FONT, 8.5, "THINOUTLINE")
        _G[button:GetName() .. "Count"]:ClearAllPoints()
        _G[button:GetName() .. "Count"]:SetPoint("BOTTOMRIGHT", 0, 0)
    end

    if _G[button:GetName() .. "Stealable"] then
        _G[button:GetName() .. "Stealable"]:SetDrawLayer("OVERLAY", 7)
    end
end

HOUR_ONELETTER_ABBR = "%dh"
DAY_ONELETTER_ABBR = "%dd"
MINUTE_ONELETTER_ABBR = "%dm"
SECOND_ONELETTER_ABBR = "%ds"

function Theme:UpdatePlayerBuffs()
    local Children = BuffFrame.auraFrames

    for index, child in pairs(Children) do
        local frame = select(index, BuffFrame.AuraContainer:GetChildren())
        frame.TempEnchantBorder:SetAlpha(0)

        if not frame.mUIBorder then
            Theme:ButtonDefault(frame)
        end
    end
end

function Theme:UpdatePlayerDebuffs()
    local Children = {DebuffFrame.AuraContainer:GetChildren()}

    for index, child in pairs(Children) do
        local frame = select(index, DebuffFrame.AuraContainer:GetChildren())
        if not frame.mUIBorder then
            Theme:ButtonDefault(frame, true)
        end

        if frame.DebuffBorder then
            frame.DebuffBorder:Hide()

            local color = {}
            color.r, color.g, color.b = frame.DebuffBorder:GetVertexColor()
            frame.mUIBorder:SetVertexColor(color.r, color.g, color.b, 1)
        end
    end
end

function Theme:UpdateUnitframeAuras(frame)
    if not frame then
        return
    end

    local debuffType
    local color

    for i = 1, MAX_TARGET_BUFFS do
        if _G["TargetFrameBuff" .. i] and (not _G["TargetFrameBuff" .. i].mUIBorder) then
            Theme:ApplySkin(_G["TargetFrameBuff" .. i], _G["TargetFrameBuff" .. i .. "Icon"], frame.unit)
            Theme.aurabuttons[_G["TargetFrameBuff" .. i]] = "unitframebuff"
        end

        if _G["FocusFrameBuff" .. i] and (not _G["FocusFrameBuff" .. i].mUIBorder) then
            Theme:ApplySkin(_G["FocusFrameBuff" .. i], _G["FocusFrameBuff" .. i .. "Icon"], frame.unit)
            Theme.aurabuttons[_G["FocusFrameBuff" .. i]] = "unitframebuff"
        end

        if _G["TargetFrameBuff" .. i] and _G["TargetFrameBuff" .. i].mUIBorder then
            _G["TargetFrameBuff" .. i].mUIBorder:SetSize(_G["TargetFrameBuff" .. i]:GetWidth() + 2, _G["TargetFrameBuff" .. i]:GetHeight() + 1)

            _G["TargetFrameBuff" .. i].mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
        end

        if _G["FocusFrameBuff" .. i] and _G["FocusFrameBuff" .. i].mUIBorder then
            _G["FocusFrameBuff" .. i].mUIBorder:SetSize(_G["FocusFrameBuff" .. i]:GetWidth() + 2, _G["FocusFrameBuff" .. i]:GetHeight() + 1)

            _G["FocusFrameBuff" .. i].mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end
    for i = 1, MAX_TARGET_DEBUFFS do
        debuffType = select(4, UnitDebuff(frame.unit, i))
        if _G["TargetFrameDebuff" .. i] and (not _G["TargetFrameDebuff" .. i].mUIBorder) then
            Theme:ApplySkin(_G["TargetFrameDebuff" .. i], _G["TargetFrameDebuff" .. i .. "Icon"], frame.unit)
            Theme.aurabuttons[_G["TargetFrameDebuff" .. i]] = "unitframedebuff"
        end

        if _G["FocusFrameDebuff" .. i] and (not _G["FocusFrameDebuff" .. i].mUIBorder) then
            Theme:ApplySkin(_G["FocusFrameDebuff" .. i], _G["FocusFrameDebuff" .. i .. "Icon"], frame.unit)
            Theme.aurabuttons[_G["FocusFrameDebuff" .. i]] = "unitframedebuff"
        end

        color = Theme.debuffColors[debuffType or "none"]

        if _G["TargetFrameDebuff" .. i] and _G["TargetFrameDebuff" .. i].mUIBorder then
            if mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
                _G["TargetFrameDebuff" .. i].mUIBorder:SetVertexColor(color.r, color.g, color.b)
            else
                _G["TargetFrameDebuff" .. i].mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
            end
            _G["TargetFrameDebuff" .. i].mUIBorder:SetSize(_G["TargetFrameDebuff" .. i]:GetWidth() + 2, _G["TargetFrameDebuff" .. i]:GetHeight() + 1)
            _G["TargetFrameDebuff" .. i .. "Border"]:Hide()
        end

        if _G["FocusFrameDebuff" .. i] and _G["FocusFrameDebuff" .. i].mUIBorder then
            if mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
                _G["FocusFrameDebuff" .. i].mUIBorder:SetVertexColor(color.r, color.g, color.b)
            else
                _G["FocusFrameDebuff" .. i].mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
            end
            _G["FocusFrameDebuff" .. i].mUIBorder:SetSize(_G["FocusFrameDebuff" .. i]:GetWidth() + 2, _G["FocusFrameDebuff" .. i]:GetHeight() + 1)
            _G["FocusFrameDebuff" .. i .. "Border"]:Hide()
        end
    end
end

function Theme:UpdateUnitframeAuraPositions(aura, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX,
    mirrorAurasVertically)
    local LARGE_AURA_SIZE = mUI.db.profile.unitframes.buffsdebuffs.buffsize
    local SMALL_AURA_SIZE = mUI.db.profile.unitframes.buffsdebuffs.debuffsize
    local AURA_OFFSET_Y = 3
    local AURA_ROW_WIDTH = 122
    local NUM_TOT_AURA_ROWS = 2

    local size
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1
    for i = 1, numAuras do
        if (largeAuraList[i]) then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y
        else
            size = SMALL_AURA_SIZE
        end
        if (i == 1) then
            rowWidth = size
            aura.auraRows = aura.auraRows + 1
        else
            rowWidth = rowWidth + size + offsetX
        end
        if (rowWidth > maxRowWidth) then
            updateFunc(aura, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
            rowWidth = size
            aura.auraRows = aura.auraRows + 1
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
            if (aura.auraRows > NUM_TOT_AURA_ROWS) then
                maxRowWidth = AURA_ROW_WIDTH
            end
        else
            updateFunc(aura, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
        end
    end
end

function Theme:UpdateRaidframeAuras(aura)
    if not aura.mUIBorder then
        aura.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        aura.mUIBorder = aura:CreateTexture(nil, "OVERLAY", nil, 7)
        aura.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border.png]])
        aura.mUIBorder:SetPoint("TOPLEFT", aura.icon, "TOPLEFT", -1, 1)
        aura.mUIBorder:SetPoint("BOTTOMRIGHT", aura.icon, "BOTTOMRIGHT", 1, -1)
        if aura.border then
            local r, g, b = aura.border:GetVertexColor()
            aura.mUIBorder:SetVertexColor(r, g, b, 1)
            aura.border:Hide()
        else
            aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
        end

        -- Mask
        aura.mask = aura:CreateMaskTexture()
        aura.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        aura.mask:SetAllPoints(aura.icon)
        aura.icon:AddMaskTexture(aura.mask)

        -- Cooldown Swipe
        aura.cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]])
        aura.cooldown:SetSwipeColor(0.2, 0.2, 0.2, 0.75)

        aura.count:ClearAllPoints()
        aura.count:SetPoint("BOTTOMRIGHT", aura.icon, "BOTTOMRIGHT", -1.5, 2.5)
    else
        if aura.border then
            local r, g, b = aura.border:GetVertexColor()
            aura.mUIBorder:SetVertexColor(r, g, b, 1)
            aura.border:Hide()
        else
            aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end
end

function Theme:AuraPositions()
    -- Buffs - Text Positioning
    for i = 1, #BuffFrame.auraFrames do
        local duration = BuffFrame.auraFrames[i].Duration
        local count = BuffFrame.auraFrames[i].Count

        count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        duration:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        duration:ClearAllPoints()
        duration:SetDrawLayer("OVERLAY")

        if BuffFrame.AuraContainer.isHorizontal then
            if BuffFrame.AuraContainer.addIconsToTop then
                count:SetPoint("TOPRIGHT", -1, 0)
                duration:SetPoint("CENTER", 0, -14)
            else
                count:SetPoint("TOPRIGHT", -1, 12)
                duration:SetPoint("CENTER", 0, -4)
            end
        else
            if not BuffFrame.AuraContainer.addIconsToRight then
                count:SetPoint("TOPRIGHT", -1, 12)
                duration:SetPoint("CENTER", 15, -9)
            else
                count:SetPoint("TOPRIGHT", -31, 12)
                duration:SetPoint("CENTER", -13.5, -9)
            end
        end
    end

    -- Debuffs - Text Positioning
    for i = 1, #DebuffFrame.auraFrames do
        local duration = DebuffFrame.auraFrames[i].Duration
        local count = DebuffFrame.auraFrames[i].Count

        if count and count.SetFont then
            count:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        end

        if duration and duration.SetFont then
            duration:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            duration:ClearAllPoints()
        end

        if DebuffFrame.AuraContainer.isHorizontal then
            if DebuffFrame.AuraContainer.addIconsToTop then
                if count then
                    count:SetPoint("TOPRIGHT", -1, 0)
                end

                if duration then
                    duration:SetPoint("CENTER", 0, -14)
                end
            else
                if count then
                    count:SetPoint("TOPRIGHT", -1, 12)
                end

                if duration then
                    duration:SetPoint("CENTER", 0, -4)
                end
            end
        else
            if not DebuffFrame.AuraContainer.addIconsToRight then
                if count then
                    count:SetPoint("TOPRIGHT", 0, 13)
                end

                if duration then
                    duration:SetPoint("CENTER", 16, -9)
                end
            else
                if count then
                    count:SetPoint("TOPRIGHT", -30, 13)
                end

                if duration then
                    duration:SetPoint("CENTER", -14.5, -9)
                end
            end
        end

        --[[if DebuffFrame.auraFrames[i].DebuffBorder then
            DebuffFrame.auraFrames[i].DebuffBorder:SetAlpha(0)
        end]]
    end
end
