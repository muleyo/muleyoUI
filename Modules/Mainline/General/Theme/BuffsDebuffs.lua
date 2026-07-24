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
    button.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
    button.mUIBorder:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
    button.mUIBorder:SetDesaturated(true)

    -- Set Border Position
    button.mUIBorder:SetPoint("TOPLEFT", button.Icon, "TOPLEFT", -12.25, 12.25)
    button.mUIBorder:SetPoint("BOTTOMRIGHT", button.Icon, "BOTTOMRIGHT", 12.75, -12.75)

    -- Create Border Mask
    button.mUIBorder.mask = button:CreateMaskTexture()
    button.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    button.mUIBorder.mask:SetAllPoints(button.Icon)
    button.Icon:AddMaskTexture(button.mUIBorder.mask)

    -- Set Border Color
    button.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

    if not isDebuff then
        Theme.aurabuttons[button] = "playerbuff"
    else
        Theme.aurabuttons[button] = "playerdebuff"
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
            frame.DebuffBorder:SetAlpha(0)

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

-- Player Buffs & Debuffs (Custom Aura Containers)
Theme.PLAYER_AURA_SIZE = 30
Theme.MAX_PLAYER_BUFFS = BUFF_MAX_DISPLAY or 32
Theme.MAX_PLAYER_DEBUFFS = DEBUFF_MAX_DISPLAY or 16

local function GetAuraFrameLayoutSettings(hostFrame)
    local container = hostFrame.AuraContainer

    return {
        isHorizontal = container.isHorizontal ~= false,
        addIconsToRight = container.addIconsToRight == true,
        addIconsToTop = container.addIconsToTop == true,
        iconStride = container.iconStride or 1,
        iconScale = container.iconScale or 1,
        iconPadding = container.iconPadding or 0,
        showDispelType = container.showDispelType == true
    }
end

local function GetAuraFlowAnchorPoint(settings)
    if settings.addIconsToTop then
        return settings.addIconsToRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    end

    return settings.addIconsToRight and "TOPLEFT" or "TOPRIGHT"
end

function Theme:InitializePlayerAuraButton(auraFrame, isDebuff)
    local size = Theme.PLAYER_AURA_SIZE
    auraFrame:SetSize(size, size)

    -- Icon
    local icon = auraFrame:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints(auraFrame)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    auraFrame:SetIcon(icon)

    -- Icon Mask
    local mask = auraFrame:CreateMaskTexture()
    mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(icon)
    icon:AddMaskTexture(mask)

    -- Base Border
    local border = auraFrame:CreateTexture(nil, "OVERLAY", nil, 6)
    border:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
    border:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
    border:SetDesaturated(true)
    border:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -12.25, 12.25)
    border:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 12.75, -12.75)

    if isDebuff then
        border:SetVertexColor(DEBUFF_TYPE_NONE_COLOR.r, DEBUFF_TYPE_NONE_COLOR.g, DEBUFF_TYPE_NONE_COLOR.b, 1)
    else
        border:SetVertexColor(unpack(mUI:Color(0.25)))
    end

    auraFrame.mUIBorder = border
    auraFrame.mUIBorder.mask = mask

    -- Dispel Border
    if isDebuff then
        local dispelBorder = auraFrame:CreateTexture(nil, "OVERLAY", nil, 7)
        dispelBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
        dispelBorder:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
        dispelBorder:SetDesaturated(true)
        dispelBorder:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -12.25, 12.25)
        dispelBorder:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", 12.75, -12.75)

        auraFrame.mUIDispelBorder = dispelBorder

        auraFrame:SetAuraBorder(dispelBorder, {
            showIcon = false,
            showWhenHarmful = true,
            showWhenHelpful = false,
            style = AuraButtonBorderStyle.Color
        })

        dispelBorder:SetAlpha(Theme.showDispelType == false and 0 or 1)
    end

    -- Cooldown Swipe
    local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
    cooldown:SetAllPoints(icon)
    cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]])
    cooldown:SetSwipeColor(0, 0, 0, 0.75)
    cooldown:SetReverse(true)
    cooldown:SetDrawBling(false)
    cooldown:SetCountdownFont("NumberFontNormalSmall")
    auraFrame:SetDurationCooldown(cooldown)

    -- Cooldown Text
    local countdownText = cooldown:GetCountdownFontString()
    countdownText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    countdownText:ClearAllPoints()
    countdownText:SetPoint("BOTTOM", icon, "BOTTOM", 0, 0)
    auraFrame.mUIDuration = countdownText

    -- Count Text - kept above the cooldown so the swipe can't cover it.
    local countOverlay = CreateFrame("Frame", nil, auraFrame)
    countOverlay:SetAllPoints(auraFrame)
    countOverlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)

    local count = countOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    count:SetPoint("TOPRIGHT", icon, "TOPRIGHT", -1, -1)
    auraFrame:SetApplicationCount(count)
    auraFrame.mUICount = count

    -- Right click to cancel
    if not isDebuff then
        auraFrame:SetCancelAuraButtons("RightButtonUp")
    end

    Theme.aurabuttons[auraFrame] = isDebuff and "playerdebuff" or "playerbuff"
end

function Theme:CreatePlayerAuraContainer(hostFrame, isDebuff)
    local container = CreateFrame("AuraContainer", nil, hostFrame, "CustomAuraContainerTemplate")
    container:SetUnit("player")
    container:SetEnabled(true)

    local filterString = isDebuff and AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful) or
                             AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful)

    container:AddAuraGroup(isDebuff and "PlayerDebuffs" or "PlayerBuffs", filterString, {
        maxFrameCount = isDebuff and Theme.MAX_PLAYER_DEBUFFS or Theme.MAX_PLAYER_BUFFS,
        initializeFrame = function(auraFrame)
            Theme:InitializePlayerAuraButton(auraFrame, isDebuff)
        end
    })

    if not isDebuff then
        for _, slot in ipairs({AuraContainerItemEnchantmentSlot.MainHand, AuraContainerItemEnchantmentSlot.OffHand,
                               AuraContainerItemEnchantmentSlot.Ranged}) do
            container:AddItemEnchantment(slot, {
                initializeFrame = function(auraFrame)
                    Theme:InitializePlayerAuraButton(auraFrame, false)
                end
            })
        end
    end

    hostFrame.mUIAuraContainer = container
    Theme:ApplyPlayerAuraLayout(hostFrame)

    return container
end

function Theme:ApplyPlayerAuraLayout(hostFrame)
    local container = hostFrame.mUIAuraContainer
    if not container then
        return
    end

    local settings = GetAuraFrameLayoutSettings(hostFrame)
    local anchorPoint = GetAuraFlowAnchorPoint(settings)
    local spacing = settings.iconPadding

    container:SetScale(settings.iconScale)
    container:SetFlowLayoutAnchorPoint(anchorPoint)
    container:SetFlowLayoutGrowthDirection(settings.addIconsToRight and AnchorUtil.FlowDirection.Right or AnchorUtil.FlowDirection.Left,
        settings.addIconsToTop and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down)

    local perRow = settings.isHorizontal and settings.iconStride or 1
    container:SetFlowLayoutMaximumLineSize(perRow * (Theme.PLAYER_AURA_SIZE + spacing))

    local layout = {
        elementSpacing = spacing,
        lineSpacing = spacing
    }

    container:SetAuraGroupLayout(hostFrame == DebuffFrame and "PlayerDebuffs" or "PlayerBuffs", layout)

    if hostFrame == BuffFrame then
        container:SetItemEnchantmentLayout({
            placement = CustomAuraContainerItemEnchantmentPlacement.BeforeAuraGroups,
            elementSpacing = layout.elementSpacing,
            lineSpacing = layout.lineSpacing
        })
    end

    if hostFrame == DebuffFrame then
        Theme:SetPlayerDebuffDispelTypeShown(settings.showDispelType)
    end

    container:ClearAllPoints()
    container:SetPoint(anchorPoint, hostFrame, anchorPoint, 0, 0)

    Theme:ResizePlayerAuraHost(hostFrame, settings)
end

function Theme:ResizePlayerAuraHost(hostFrame, settings)
    local maxAuras = hostFrame == DebuffFrame and Theme.MAX_PLAYER_DEBUFFS or Theme.MAX_PLAYER_BUFFS
    local perRow = math.max(settings.iconStride, 1)

    local iconWidth = Theme.PLAYER_AURA_SIZE + settings.iconPadding
    local iconHeight = Theme.PLAYER_AURA_SIZE + settings.iconPadding

    local across = perRow
    local down = math.ceil(maxAuras / perRow)

    local width, height
    if settings.isHorizontal then
        width, height = iconWidth * across, iconHeight * down
    else
        width, height = iconWidth * down, iconHeight * across
    end

    hostFrame:SetSize(width * settings.iconScale, height * settings.iconScale)
end

function Theme:SetPlayerDebuffDispelTypeShown(shown)
    local container = DebuffFrame.mUIAuraContainer
    if not container then
        return
    end

    if Theme.showDispelType == shown then
        return
    end

    Theme.showDispelType = shown

    for auraFrame in pairs(Theme.aurabuttons) do
        if auraFrame.mUIDispelBorder then
            auraFrame.mUIDispelBorder:SetAlpha(shown and 1 or 0)
        end
    end
end

function Theme:DisableDefaultPlayerAuras()
    local nop = function()
    end

    for _, hostFrame in ipairs({BuffFrame, DebuffFrame}) do
        hostFrame:UnregisterEvent("UNIT_AURA")
        hostFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
        hostFrame:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")
        hostFrame:UnregisterEvent("WEAPON_ENCHANT_CHANGED")
        hostFrame:UnregisterEvent("WEAPON_SLOT_CHANGED")

        hostFrame:SetScript("OnUpdate", nil)

        -- Layout and button work is entirely ours now.
        hostFrame.UpdateAuraButtons = nop
        hostFrame.UpdateGridLayout = nop

        for _, auraFrame in ipairs(hostFrame.auraFrames or {}) do
            if not auraFrame.isAuraAnchor then
                auraFrame:SetScript("OnUpdate", nil)
                auraFrame:Hide()
            end
        end
    end

    BuffFrame.ConsolidatedBuffs:Hide()
    BuffFrame.ConsolidatedBuffs.ShouldShow = function()
        return false
    end

    BuffFrame.CollapseAndExpandButton:Hide()
    BuffFrame.RefreshConsolidationFrameVisibility = nop
end

function Theme:StyleAuraButtonTooltip()
    if not (AuraContainerInbound and AuraContainerInbound.SetTooltipBackdrop) then
        return
    end

    local bg = Theme.backdrop
    if not bg then
        return
    end

    local borderColor
    if Theme.db.theme == "Default" then
        borderColor = CreateColor(1, 1, 1, 1)
    else
        borderColor = CreateColor(unpack(Theme.backdrop.borderColor))
    end

    AuraContainerInbound.SetTooltipBackdrop({
        backdropInfo = Theme.backdrop,
        centerColor = CreateColor(0.03, 0.03, 0.03, 0.95),
        borderColor = borderColor
    })
end

function Theme:InitPlayerAuraContainers()
    Theme:CreatePlayerAuraContainer(BuffFrame, false)
    Theme:CreatePlayerAuraContainer(DebuffFrame, true)

    Theme:DisableDefaultPlayerAuras()

    -- Global, one-time skin covering every aura button tooltip.
    Theme:StyleAuraButtonTooltip()

    for _, hostFrame in ipairs({BuffFrame, DebuffFrame}) do
        Theme:SecureHook(hostFrame, "UpdateSystemSetting", function(self)
            Theme:ApplyPlayerAuraLayout(self)
        end)
    end
end

function Theme:UpdateUnitframeAuras(aura, isDebuff, unit)
    if not aura.mUIBorder then
        aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Border
        aura.mUIBorder = aura:CreateTexture(nil, "OVERLAY", nil, 7)
        aura.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
        aura.mUIBorder:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
        aura.mUIBorder:SetDesaturated(true)

        -- Set Border Position
        aura.mUIBorder:SetPoint("CENTER", aura.Icon, "CENTER", 0, 0)

        -- Set Icon Mask
        aura.mUIBorder.mask = aura:CreateMaskTexture()
        aura.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        aura.mUIBorder.mask:SetAllPoints(aura.Icon)
        aura.Icon:AddMaskTexture(aura.mUIBorder.mask)

        -- Cooldown Swipe
        aura.Cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]])
        aura.Cooldown:SetSwipeColor(0.0, 0.0, 0.0, 0.75)

        if not isDebuff then
            Theme.aurabuttons[aura] = "unitframebuff"
        else
            Theme.aurabuttons[aura] = "unitframedebuff"
        end
    end

    local width, height = aura:GetSize()
    aura.mUIBorder:SetSize(width * 1.85, height * 1.85)

    -- Set Count Position
    if aura.Count then
        aura.Count:ClearAllPoints()
        aura.Count:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", -2, 2.5)
    end

    if aura.Border and mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
        local r, g, b = aura.Border:GetVertexColor()
        aura.mUIBorder:SetVertexColor(r, g, b, 1)
        aura.Border:SetAlpha(0)
    else
        aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
    end
end

-- Target/Focus Custom Aura Containers
Theme.MAX_UNITFRAME_BUFFS = 32
Theme.MAX_UNITFRAME_DEBUFFS = 16
Theme.UNITFRAME_AURA_SIZE = 24

-- Border color for purgeable/stealable buffs on Target/Focus frames
Theme.STEALABLE_BUFF_COLOR = {
    r = 0.2,
    g = 0.8,
    b = 1
}

function Theme:InitializeCustomAuraButton(auraFrame, isDebuff, borderColor)
    auraFrame:SetSize(Theme.UNITFRAME_AURA_SIZE, Theme.UNITFRAME_AURA_SIZE)

    -- Icon
    local icon = auraFrame:CreateTexture(nil, "BACKGROUND")
    icon:SetAllPoints(auraFrame)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    auraFrame:SetIcon(icon)

    -- mUI Border
    local mUIBorder = auraFrame:CreateTexture(nil, "OVERLAY", nil, 7)
    mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
    mUIBorder:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
    mUIBorder:SetDesaturated(true)

    -- Set Border Position
    mUIBorder:SetSize(Theme.UNITFRAME_AURA_SIZE * 1.85, Theme.UNITFRAME_AURA_SIZE * 1.85)
    mUIBorder:SetPoint("CENTER", auraFrame, "CENTER", 0, 0)

    -- Create Border Mask
    mUIBorder.mask = auraFrame:CreateMaskTexture()
    mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mUIBorder.mask:SetAllPoints(icon)
    icon:AddMaskTexture(mUIBorder.mask)

    -- Cooldown Swipe
    local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
    cooldown:SetPoint("TOPLEFT", icon, "TOPLEFT", -0.25, 0.25)
    cooldown:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0.25, -0.25)
    cooldown:SetSwipeTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]])
    cooldown:SetSwipeColor(0.2, 0.2, 0.2, 0.75)
    cooldown:SetReverse(true)
    cooldown:SetDrawBling(false)
    cooldown:SetCountdownFont("NumberFontNormalSmall")
    auraFrame:SetDurationCooldown(cooldown)

    -- Cooldown Text
    local countdownText = cooldown:GetCountdownFontString()
    countdownText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    countdownText:ClearAllPoints()
    countdownText:SetPoint("CENTER", icon, "CENTER", 0, 3)

    -- Count Text
    local countOverlay = CreateFrame("Frame", nil, auraFrame)
    countOverlay:SetAllPoints(auraFrame)
    countOverlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)

    local count = countOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, 0)
    auraFrame:SetApplicationCount(count)

    -- Set Border Color
    if borderColor then
        mUIBorder:SetVertexColor(borderColor.r, borderColor.g, borderColor.b, 1)
    else
        mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
    end

    auraFrame.mUIBorder = mUIBorder

    Theme.aurabuttons[auraFrame] = isDebuff and "unitframedebuff" or "unitframebuff"
end

function Theme:CreateUnitAuraContainer(frame, unit)
    if not frame or not frame.GetAuraContainer then
        return
    end

    -- Fully disable Blizzard's built-in aura container
    local defaultAuraContainer = frame:GetAuraContainer()
    frame.maxBuffs = 0
    frame.maxDebuffs = 0
    defaultAuraContainer:SetEnabled(false)

    local container = CreateFrame("AuraContainer", nil, frame.TargetFrameContent.TargetFrameContentContextual, "CustomAuraContainerTemplate")

    local spellbar = _G[frame:GetName() .. "SpellBar"]
    if spellbar then
        container:SetFrameLevel(math.max(spellbar:GetFrameLevel() - 2, 0))
    end

    container:SetFlowLayoutMaximumLineSize(122)
    container:SetFlowLayoutPadding(0, 0, 0, 10)
    container:SetUnit(unit)
    container:SetEnabled(true)

    container:AddAuraGroup("Buffs", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
        maxFrameCount = Theme.MAX_UNITFRAME_BUFFS,
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, false)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    local debuffFilterString = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player,
        AuraUtil.AuraFilters.IncludeNameplateOnly)

    if mUI.db.profile.unitframes.buffsdebuffs.debuffcolors then
        local DEBUFF_TYPE_GROUPS = {{
            key = "DebuffsNone",
            excludeDispelTypes = {
                Magic = true,
                Curse = true,
                Disease = true,
                Poison = true
            },
            color = DEBUFF_TYPE_NONE_COLOR
        }, {
            key = "DebuffsMagic",
            includeDispelTypes = {
                Magic = true
            },
            color = DEBUFF_TYPE_MAGIC_COLOR
        }, {
            key = "DebuffsCurse",
            includeDispelTypes = {
                Curse = true
            },
            color = DEBUFF_TYPE_CURSE_COLOR
        }, {
            key = "DebuffsDisease",
            includeDispelTypes = {
                Disease = true
            },
            color = DEBUFF_TYPE_DISEASE_COLOR
        }, {
            key = "DebuffsPoison",
            includeDispelTypes = {
                Poison = true
            },
            color = DEBUFF_TYPE_POISON_COLOR
        }}

        for index, groupInfo in ipairs(DEBUFF_TYPE_GROUPS) do
            container:AddAuraGroup(groupInfo.key, debuffFilterString, {
                maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
                candidateFilters = {
                    includeDispelTypes = groupInfo.includeDispelTypes,
                    excludeDispelTypes = groupInfo.excludeDispelTypes
                },
                initializeFrame = function(auraFrame)
                    Theme:InitializeCustomAuraButton(auraFrame, true, groupInfo.color)
                end,
                layout = {
                    elementSpacing = 3,
                    lineSpacing = 3,
                    forceNewLine = (index == 1),
                    groupLineSpacing = (index == 1) and 5 or nil
                }
            })
        end
    else
        container:AddAuraGroup("Debuffs", debuffFilterString, {
            maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
            initializeFrame = function(auraFrame)
                Theme:InitializeCustomAuraButton(auraFrame, true)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3,
                forceNewLine = true,
                groupLineSpacing = 5
            }
        })
    end

    Theme:ReflowUnitAuraContainer(frame, container)

    if not Theme:IsHooked(frame, "UpdateAuras") then
        Theme:SecureHook(frame, "UpdateAuras", function(self)
            container:UpdateAllAuras()
            Theme:ReflowUnitAuraContainer(self, container)
        end)
    end

    if not Theme:IsHooked(spellbar, "OnShow") then
        Theme:SecureHookScript(spellbar, "OnShow", function()
            local pointX = frame.smallSize and 38 or 43
            local pointY = frame.smallSize and 3 or 5
            if frame.haveToT then
                pointY = frame.smallSize and -48 or -46
            end

            spellbar:ClearAllPoints()

            if frame.buffsOnTop then
                spellbar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", pointX, pointY)
            else
                spellbar:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 18, -2)
            end
        end)
    end

    if not Theme:IsHooked(spellbar, "AdjustPosition") then
        Theme:SecureHook(spellbar, "AdjustPosition", function()
            local pointX = frame.smallSize and 38 or 43
            local pointY = frame.smallSize and 3 or 5
            if frame.haveToT then
                pointY = frame.smallSize and -48 or -46
            end

            spellbar:ClearAllPoints()

            if frame.buffsOnTop then
                spellbar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", pointX, pointY)
            else
                spellbar:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 18, -2)
            end
        end)
    end

    return container
end

local AURA_START_X = 5
local AURA_START_Y = 4
local AURA_MIRRORED_START_Y = -6

function Theme:ReflowUnitAuraContainer(frame, container)
    local mirrorVertically = frame.buffsOnTop == true

    local point, relativePoint, offsetY
    if mirrorVertically then
        point, relativePoint, offsetY = "BOTTOMLEFT", "TOPLEFT", AURA_MIRRORED_START_Y
    else
        point, relativePoint, offsetY = "TOPLEFT", "BOTTOMLEFT", AURA_START_Y
    end

    container:ClearAllPoints()
    container:SetPoint(point, frame.TargetFrameContainer.FrameTexture, relativePoint, AURA_START_X, offsetY)
    container:SetFlowLayoutAnchorPoint(point)
    container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right,
        mirrorVertically and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down)
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
    end
end
