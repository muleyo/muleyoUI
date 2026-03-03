local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Buffs & Debuffs
Theme.colorCurve = C_CurveUtil.CreateColorCurve()
Theme.colorCurve:SetType(Enum.LuaCurveType.Step)
Theme.colorCurve:AddPoint(0, DEBUFF_TYPE_NONE_COLOR)
Theme.colorCurve:AddPoint(1, DEBUFF_TYPE_MAGIC_COLOR)
Theme.colorCurve:AddPoint(2, DEBUFF_TYPE_CURSE_COLOR)
Theme.colorCurve:AddPoint(3, DEBUFF_TYPE_DISEASE_COLOR)
Theme.colorCurve:AddPoint(4, DEBUFF_TYPE_POISON_COLOR)
Theme.colorCurve:AddPoint(9, DEBUFF_TYPE_BLEED_COLOR)
Theme.colorCurve:AddPoint(11, DEBUFF_TYPE_BLEED_COLOR)

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

-- Disable Flashing of Buffs and Debuffs
BuffFrame.AuraContainer.GetAuraWarningAlphaForDuration = nil
DebuffFrame.AuraContainer.GetAuraWarningAlphaForDuration = nil

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

            local auraData = C_UnitAuras.GetDebuffDataByIndex("player", index)

            if auraData and auraData.auraInstanceID then
                local color = C_UnitAuras.GetAuraDispelTypeColor("player", auraData.auraInstanceID, Theme.colorCurve)
                if color then
                    -- Set the color of the Debuff Border
                    frame.mUIBorder:SetVertexColor(color.r, color.g, color.b, 1)
                else
                    color = DEBUFF_TYPE_NONE_COLOR
                    frame.mUIBorder:SetVertexColor(color.r, color.g, color.b, 1)
                end
            end
        end
    end
end

function Theme:UpdateUnitframeAuras(aura, isDebuff, unit)
    if not aura.mUIBorder then
        aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Border
        aura.mUIBorder = aura:CreateTexture(nil, "OVERLAY", nil, 7)
        aura.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border.png]])
        aura.mUIBorder:SetPoint("CENTER", aura.Icon, "CENTER", 0, 0)

        -- Set Icon Mask
        aura.mUIBorder.mask = aura:CreateMaskTexture()
        aura.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        aura.mUIBorder.mask:SetAllPoints(aura.Icon)
        aura.Icon:AddMaskTexture(aura.mUIBorder.mask)

        -- Cooldown Swipe
        aura.Cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]])
        aura.Cooldown:SetSwipeColor(0.2, 0.2, 0.2, 0.75)

        -- Set Border Position
        aura.mUIBorder:SetPoint("TOPLEFT", aura.Icon, "TOPLEFT", -1, 1)
        aura.mUIBorder:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", 1, -1)

        if not isDebuff then
            Theme.aurabuttons[aura] = "unitframebuff"
        else
            Theme.aurabuttons[aura] = "unitframedebuff"
        end
    end

    -- Set Count Position
    if aura.Count then
        aura.Count:ClearAllPoints()
        aura.Count:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", -2, 2.5)
    end

    if aura.Border and mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
        local r, g, b = aura.Border:GetVertexColor()
        aura.mUIBorder:SetVertexColor(r, g, b, 1)
        aura.Border:Hide()
    else
        aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
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
        local frameHeight

        if IsInRaid() then
            frameHeight = EditModeManagerFrame:GetRaidFrameHeight(Enum.EditModeUnitFrameSystemIndices.Raid, 36)
        else
            frameHeight = EditModeManagerFrame:GetRaidFrameHeight(Enum.EditModeUnitFrameSystemIndices.Party, 36)
        end

        if aura.border then
            local r, g, b = aura.border:GetVertexColor()
            aura.mUIBorder:SetVertexColor(r, g, b, 1)
            aura.border:Hide()

            local unit = aura:GetParent() and aura:GetParent().displayedUnit
            -- C_UnitAuras does not accept compound unit tokens (e.g. "boss1target"),
            -- so resolve to a base token via UnitGUID + UnitTokenFromGUID.
            if unit and UnitGUID(unit) then
                unit = UnitTokenFromGUID(UnitGUID(unit)) or unit
            end
            local PvP = C_PvP.IsMatchActive() or UnitIsPVP("player")
            local isDispellable = false
            local isCrowdControl = false
            if unit and aura.auraInstanceID and not issecretvalue(unit) and not issecretvalue(aura.auraInstanceID) then
                isDispellable = not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, "HARMFUL|RAID_PLAYER_DISPELLABLE")
                if PvP then
                    isCrowdControl = not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, "HARMFUL|CROWD_CONTROL")
                end
            end

            if PvP then
                if isCrowdControl then
                    local auraSize = frameHeight * 0.55
                    aura:SetSize(auraSize, auraSize)
                end
            else
                if isDispellable then
                    local auraSize = frameHeight * 0.55
                    aura:SetSize(auraSize, auraSize)
                end
            end
        else
            aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))

            local auraSize = frameHeight * (mUI.db.profile.unitframes.raidframes.buffsize / 100)
            aura:SetSize(auraSize, auraSize)
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
