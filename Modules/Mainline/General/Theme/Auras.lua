local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Color Curve
Theme.colorCurve = C_CurveUtil.CreateColorCurve()
Theme.colorCurve:SetType(Enum.LuaCurveType.Step)
Theme.colorCurve:AddPoint(0, DEBUFF_TYPE_NONE_COLOR)
Theme.colorCurve:AddPoint(1, DEBUFF_TYPE_MAGIC_COLOR)
Theme.colorCurve:AddPoint(2, DEBUFF_TYPE_CURSE_COLOR)
Theme.colorCurve:AddPoint(3, DEBUFF_TYPE_DISEASE_COLOR)
Theme.colorCurve:AddPoint(4, DEBUFF_TYPE_POISON_COLOR)
Theme.colorCurve:AddPoint(9, DEBUFF_TYPE_BLEED_COLOR)
Theme.colorCurve:AddPoint(11, DEBUFF_TYPE_BLEED_COLOR)

-- Aura duration text formatter
local AuraDurationFormatter = C_StringUtil.CreateSecondsFormatter()
local mult = 1.5
local curve = C_CurveUtil.CreateCurve()
curve:AddPoint(1 + (mult * 60), Enum.SecondsFormatterInterval.Minutes)
curve:AddPoint(1 + (mult * 3600), Enum.SecondsFormatterInterval.Hours)
curve:AddPoint(1 + (mult * 86400), Enum.SecondsFormatterInterval.Days)
AuraDurationFormatter:SetDefaultAbbreviation(Enum.SecondsFormatterAbbreviation.OneLetter)
AuraDurationFormatter:SetRounding(Enum.SecondsFormatterRounding.Truncate)
AuraDurationFormatter:SetCanRoundUpLastUnit(true)
AuraDurationFormatter:SetMinInterval(Enum.SecondsFormatterInterval.Seconds)
AuraDurationFormatter:SetMaxIntervalCurve(curve)
AuraDurationFormatter:SetDesiredUnitCount(1)
AuraDurationFormatter:SetStripIntervalWhitespace(Enum.SecondsFormatterIntervalWhitespace.StripIgnoreLocale)

-- Tables
Theme.aurabuttons = {}

-- General Functions
local AURA_BORDER_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\atlas.png]]
local AURA_MASK_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]]
local AURA_BORDER_COORD = {0.95263671875, 0.99365234375, 0.17919921875, 0.22021484375}
local AURA_BORDER_INSET_RATIO = 6 / 30 -- 6px border on the 30px player icon

local function ApplyAuraBorderGeometry(border, auraFrame, inset)
    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", auraFrame, "TOPLEFT", -inset, inset)
    border:SetPoint("BOTTOMRIGHT", auraFrame, "BOTTOMRIGHT", inset, -inset)
end

-- Duration/count text size multiplier
local function GetAuraTextScale(category)
    if category == "raidframe" then
        local raid = mUI.db and mUI.db.profile.unitframes.raidframes
        return ((raid and raid.durationTextSize) or 100) / 100, ((raid and raid.countTextSize) or 100) / 100
    elseif category == "unitframe" then
        local bd = mUI.db and mUI.db.profile.unitframes.buffsdebuffs
        return ((bd and bd.durationTextSize) or 100) / 100, ((bd and bd.countTextSize) or 100) / 100
    elseif category == "player" then
        local pa = mUI.db and mUI.db.profile.general.playerauras
        return ((pa and pa.durationTextSize) or 100) / 100, ((pa and pa.countTextSize) or 100) / 100
    end
    return 1, 1
end

local function CreateAuraButton(auraFrame, isDebuff, opts)
    opts = opts or {}
    local size = opts.size or Theme.PLAYER_AURA_SIZE
    auraFrame:SetSize(size, size)

    if not auraFrame.Icon then
        local inset = size * AURA_BORDER_INSET_RATIO

        -- Create Icon
        auraFrame.Icon = auraFrame:CreateTexture(nil, "BACKGROUND")
        auraFrame.Icon:SetAllPoints(auraFrame)
        auraFrame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        auraFrame:SetIcon(auraFrame.Icon)

        -- Create Mask Texture
        auraFrame.MaskTexture = auraFrame:CreateMaskTexture()
        auraFrame.MaskTexture:SetTexture(AURA_MASK_TEX, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        auraFrame.MaskTexture:SetAllPoints(auraFrame.Icon)
        auraFrame.Icon:AddMaskTexture(auraFrame.MaskTexture)

        -- Create Cooldown
        if opts.category ~= "player" then
            auraFrame.Cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
            auraFrame.Cooldown:SetAllPoints(auraFrame.Icon)
            auraFrame.Cooldown:SetSwipeTexture(AURA_MASK_TEX)
            auraFrame.Cooldown:SetSwipeColor(0, 0, 0, 0.75)
            auraFrame.Cooldown:SetReverse(true)
            auraFrame.Cooldown:SetDrawBling(false)
            auraFrame.Cooldown:SetCountdownFont("NumberFontNormalSmall")
            auraFrame:SetDurationCooldown(auraFrame.Cooldown)
        end

        local durationFontSize, countFontSize
        if opts.category == "player" then
            durationFontSize = math.max(math.floor(size / 3.1), 6)
            countFontSize = math.max(math.floor(size / 3), 6)
        else
            durationFontSize = math.max(math.floor(size / 3 + 2), 6)
            countFontSize = math.max(math.floor(size / 3), 6)
        end

        -- Remember the un-scaled sizes so a text-size config change can be
        -- re-applied later without recomputing from the icon size.
        auraFrame.mUIBaseDurationFontSize = durationFontSize
        auraFrame.mUIBaseCountFontSize = countFontSize
        auraFrame.mUICategory = opts.category

        local durationScale, countScale = GetAuraTextScale(opts.category)
        durationFontSize = math.max(math.floor(durationFontSize * durationScale), 6)
        countFontSize = math.max(math.floor(countFontSize * countScale), 6)

        -- Create Border (in its own overlay above the Cooldown frame, otherwise
        -- the cooldown swipe - a child frame - draws over the border textures).
        auraFrame.BorderOverlay = CreateFrame("Frame", nil, auraFrame)
        auraFrame.BorderOverlay:SetAllPoints(auraFrame)
        if opts.category ~= "player" then

            auraFrame.BorderOverlay:SetFrameLevel(auraFrame.Cooldown:GetFrameLevel() + 1)
        end

        auraFrame.mUIBorder = auraFrame.BorderOverlay:CreateTexture(nil, "OVERLAY", nil, 6)
        auraFrame.mUIBorder:SetTexture(AURA_BORDER_TEX)
        auraFrame.mUIBorder:SetTexCoord(unpack(AURA_BORDER_COORD))
        auraFrame.mUIBorder:SetDesaturated(true)
        ApplyAuraBorderGeometry(auraFrame.mUIBorder, auraFrame, inset)

        -- Count Text (its own overlay, one level above the borders)
        auraFrame.CountOverlay = CreateFrame("Frame", nil, auraFrame)
        auraFrame.CountOverlay:SetAllPoints(auraFrame)
        auraFrame.CountOverlay:SetFrameLevel(auraFrame.BorderOverlay:GetFrameLevel() + 1)

        auraFrame.Count = auraFrame.CountOverlay:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
        auraFrame.Count:SetFont(STANDARD_TEXT_FONT, countFontSize, "OUTLINE")
        auraFrame:SetApplicationCount(auraFrame.Count)

        if opts.category == "player" then
            -- Player buffs/debuffs: custom suffixed countdown ("10s", "5m")
            -- auraFrame.Cooldown:SetHideCountdownNumbers(true)
            auraFrame.CooldownText = auraFrame.CountOverlay:CreateFontString(nil, "OVERLAY")
            auraFrame.CooldownText:SetFont(STANDARD_TEXT_FONT, durationFontSize, "OUTLINE")
            auraFrame.CooldownText:SetPoint("BOTTOM", auraFrame.Icon, "BOTTOM", 0, 2)
            auraFrame:SetDurationText(auraFrame.CooldownText, {
                textFormatter = AuraDurationFormatter
            })
            auraFrame.Count:SetPoint("TOPRIGHT", auraFrame.Icon, "TOPRIGHT", -1.5, -1.5)
        else
            -- Unitframe & raidframe auras: Blizzard's countdown numbers, centered.
            auraFrame.CooldownText = auraFrame.Cooldown:GetCountdownFontString()
            auraFrame.CooldownText:SetFont(STANDARD_TEXT_FONT, durationFontSize, "OUTLINE")
            auraFrame.CooldownText:ClearAllPoints()
            auraFrame.CooldownText:SetPoint("CENTER", auraFrame.Icon, "CENTER", 0, 0)
            auraFrame.Count:SetPoint("TOPRIGHT", auraFrame.Icon, "TOPRIGHT", 1, -1)
        end

        if isDebuff and opts.dispelBorder then
            auraFrame.mUIBorder:SetVertexColor(DEBUFF_TYPE_NONE_COLOR.r, DEBUFF_TYPE_NONE_COLOR.g, DEBUFF_TYPE_NONE_COLOR.b, 1)

            auraFrame.mUIDispelBorder = auraFrame.BorderOverlay:CreateTexture(nil, "OVERLAY", nil, 7)
            auraFrame.mUIDispelBorder:SetTexture(AURA_BORDER_TEX)
            auraFrame.mUIDispelBorder:SetTexCoord(unpack(AURA_BORDER_COORD))
            auraFrame.mUIDispelBorder:SetDesaturated(true)
            ApplyAuraBorderGeometry(auraFrame.mUIDispelBorder, auraFrame, inset)

            auraFrame:SetAuraBorder(auraFrame.mUIDispelBorder, {
                showIcon = false,
                showWhenHarmful = true,
                showWhenHelpful = false,
                showWithoutDispelType = true,
                customDispelColorCurve = Theme.colorCurve,
                style = AuraButtonBorderStyle.Color
            })

            auraFrame.mUIDispelBorder:SetAlpha(Theme.showDispelType == false and 0 or 1)
        elseif opts.borderColor then
            auraFrame.mUIBorder:SetVertexColor(opts.borderColor.r, opts.borderColor.g, opts.borderColor.b, 1)
            -- Remember the custom color so theme refreshes (Theme:Auras) that reset
            -- buff borders to the default shade don't clobber it (e.g. stealable).
            auraFrame.mUIBorderColor = opts.borderColor
        else
            auraFrame.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
        end

        -- Apply the selected border style (and keep it re-skinnable on change)
        Theme:RegisterBorder({
            border = auraFrame.mUIBorder,
            coord = true,
            extra = auraFrame.mUIDispelBorder and {auraFrame.mUIDispelBorder} or nil,
            mask = auraFrame.MaskTexture,
            swipe = auraFrame.Cooldown,
            applyGeometry = function(style)
                local ins = size * (style.auraInsetRatio or AURA_BORDER_INSET_RATIO)
                ApplyAuraBorderGeometry(auraFrame.mUIBorder, auraFrame, ins)
                if auraFrame.mUIDispelBorder then
                    ApplyAuraBorderGeometry(auraFrame.mUIDispelBorder, auraFrame, ins)
                end
            end
        })
    end

    if opts.category then
        Theme.aurabuttons[auraFrame] = opts.category .. (isDebuff and "debuff" or "buff")
    end
end

Theme.CreateAuraButton = CreateAuraButton

-- Re-applies the current duration/count text size config to an already-created
-- aura button, without touching icon size or recreating anything.
function Theme:ApplyAuraTextScale(auraFrame)
    if not auraFrame.mUIBaseDurationFontSize or not auraFrame.CooldownText then
        return
    end

    local durationScale, countScale = GetAuraTextScale(auraFrame.mUICategory)
    local durationFontSize = math.max(math.floor(auraFrame.mUIBaseDurationFontSize * durationScale), 6)
    local countFontSize = math.max(math.floor(auraFrame.mUIBaseCountFontSize * countScale), 6)

    local _, _, flags = auraFrame.CooldownText:GetFont()
    auraFrame.CooldownText:SetFont(STANDARD_TEXT_FONT, durationFontSize, flags)
    if auraFrame.Count then
        local _, _, countFlags = auraFrame.Count:GetFont()
        auraFrame.Count:SetFont(STANDARD_TEXT_FONT, countFontSize, countFlags)
    end
end

-- Re-applies the text size
function Theme:UpdateAuraTextSizesForCategory(category)
    for auraFrame, buttonCategory in pairs(Theme.aurabuttons) do
        if buttonCategory == category .. "buff" or buttonCategory == category .. "debuff" then
            Theme:ApplyAuraTextScale(auraFrame)
        end
    end
end

-- ============================================================================
-- Player Auras
-- ============================================================================
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
    CreateAuraButton(auraFrame, isDebuff, {
        size = Theme.PLAYER_AURA_SIZE,
        category = "player",
        dispelBorder = isDebuff
    })

    -- Right click to cancel
    if not isDebuff then
        auraFrame:SetCancelAuraButtons("RightButtonUp")
    end
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

-- Re-applies the duration/count text size
function Theme:UpdateAllPlayerAuraTextSizes()
    Theme:UpdateAuraTextSizesForCategory("player")
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

    local alpha = shown and 1 or 0
    for auraFrame, category in pairs(Theme.aurabuttons) do
        -- Player debuffs only; raid debuffs also carry a dispel border but are
        -- governed by their own settings, not this player-frame toggle.
        if category == "playerdebuff" then
            local border = auraFrame.mUIDispelBorder
            if border then
                pcall(border.SetAlpha, border, alpha)
            end
        end
    end
end

function Theme:DisableDefaultPlayerAuras()
    for _, hostFrame in ipairs({BuffFrame, DebuffFrame}) do
        hostFrame:UnregisterAllEvents()
        hostFrame.AuraContainer:UnregisterAllEvents()
        hostFrame.AuraContainer:Hide()
        CVarCallbackRegistry:UnregisterCallback('consolidateBuffs', BuffFrame)
        CVarCallbackRegistry:UnregisterCallback('collapseExpandBuffs', BuffFrame)
        hostFrame:SetScript("OnUpdate", nil)

        for _, auraFrame in ipairs(hostFrame.auraFrames or {}) do
            if not auraFrame.isAuraAnchor then
                auraFrame:SetScript("OnUpdate", nil)
                auraFrame:Hide()
            else
                auraFrame:Hide()
                if not Theme:IsHooked(auraFrame, "Show") then
                    Theme:SecureHook(auraFrame, "Show", function(self)
                        self:Hide()
                    end)
                end

                if auraFrame.Duration and not Theme:IsHooked(auraFrame.Duration, "Show") then
                    auraFrame.Duration:Hide()
                    Theme:SecureHook(auraFrame.Duration, "Show", function(text)
                        text:Hide()
                    end)
                end
            end
        end
    end

    BuffFrame.ConsolidatedBuffs:Hide()
    BuffFrame.CollapseAndExpandButton:Hide()
end

function Theme:InitPlayerAuraContainers()
    Theme:CreatePlayerAuraContainer(BuffFrame, false)
    Theme:CreatePlayerAuraContainer(DebuffFrame, true)
    Theme:DisableDefaultPlayerAuras()

    for _, hostFrame in ipairs({BuffFrame, DebuffFrame}) do
        Theme:SecureHook(hostFrame, "UpdateSystemSetting", function(self)
            Theme:ApplyPlayerAuraLayout(self)
        end)
    end
end

-- ============================================================================
-- Unitframes Auras
-- ============================================================================
Theme.MAX_UNITFRAME_BUFFS = 32
Theme.MAX_UNITFRAME_DEBUFFS = 16
Theme.UNITFRAME_AURA_SIZE = 24

local STEALABLE_BORDER_COLOR = {
    r = 0.8,
    g = 0.3,
    b = 1
}

local IMPORTANT_DEBUFFS = {
    [25771] = true, -- Forbearance
    [41425] = true -- Hypothermia
}

local IMPORTANT_BUFFS = {
    [10060] = true, -- Power Infusion
    [1044] = true, -- Blessing of Freedom
    [210256] = true, -- Blessing of Sanctuary
    [106898] = true, -- Stampeding Roar (No Form)
    [77764] = true, -- Stampeding Roar (Cat)
    [77761] = true, -- Stampeding Roar (Bear)
    [116841] = true, -- Tiger's Lust
    [53563] = true, -- Beacon of Light
    [156910] = true, -- Beacon of Faith
    [200025] = true, -- Beacon of Virtue
    [1244893] = true, -- Beacon of the Survivor
    [974] = true, -- Earth Shield
    [383648] = true, -- Earth Shield
    [57934] = true, -- Tricks of the Trade
    [1224098] = true, -- Tricks of the Trade
    [59628] = true -- Tricks of the Trade
}

local UNITFRAME_DEBUFF_FILTER_MINE = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player)
local UNITFRAME_DEBUFF_FILTER_ALL = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful)
local UNITFRAME_BUFF_FILTER_ALL = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful)
local UNITFRAME_BUFF_FILTER_DISPELLABLE = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Dispellable,
    "!" .. AuraUtil.AuraFilters.Important)
local UNITFRAME_BUFF_FILTER_IMPORTANT = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Important)

local AURA_START_X = 5
local AURA_START_Y = 4
local AURA_MIRRORED_START_Y = -6
local AURA_LINE_SIZE = 155

function Theme:InitializeCustomAuraButton(auraFrame, isDebuff, borderColor, size, dispelBorder)
    CreateAuraButton(auraFrame, isDebuff, {
        size = size or Theme.UNITFRAME_AURA_SIZE,
        category = "unitframe",
        borderColor = borderColor,
        dispelBorder = dispelBorder
    })
end

function Theme:DisableDefaultUnitAuraContainer(frame)
    if not frame or not frame.GetAuraContainer then
        return
    end

    local defaultAuraContainer = frame:GetAuraContainer()
    frame.maxBuffs = 0
    frame.maxDebuffs = 0
    defaultAuraContainer:SetEnabled(false)
    defaultAuraContainer:Hide()
end

function Theme:CreateUnitAuraContainer(frame, unit)
    if not frame or not frame.GetAuraContainer then
        return
    end

    if frame.mUI_debuffContainer then
        return
    end

    Theme:DisableDefaultUnitAuraContainer(frame)

    local parent = frame.TargetFrameContent.TargetFrameContentContextual

    local buffContainer = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
    buffContainer:SetFrameLevel(math.max(parent:GetFrameLevel() + 2, 0))
    buffContainer:SetSize(1, 1)
    buffContainer:SetFlowLayoutPadding(0, 0, 0, 10)
    frame.mUI_buffContainer = buffContainer

    local debuffContainer = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate")
    debuffContainer:SetFrameLevel(math.max(parent:GetFrameLevel() + 2, 0))
    debuffContainer:SetSize(1, 1)
    debuffContainer:SetFlowLayoutPadding(0, 0, 0, 10)
    frame.mUI_debuffContainer = debuffContainer

    -- Buff/Debuff sizes
    local buffSize, debuffSize = Theme:GetUnitframeAuraSizes()
    buffContainer.mUI_baseSize = buffSize
    debuffContainer.mUI_baseSize = debuffSize

    -- Track for live size updates (config sliders re-scale these containers).
    Theme.unitframeAuraFrames = Theme.unitframeAuraFrames or {}
    Theme.unitframeAuraFrames[frame] = true

    Theme:ReflowUnitAuraContainer(frame)
    buffContainer:SetUnit(unit)
    debuffContainer:SetUnit(unit)

    local spellbar = _G[frame:GetName() .. "SpellBar"]
    if spellbar then
        spellbar:ClearAllPoints()
        spellbar:SetPoint("TOPLEFT", buffContainer, "BOTTOMLEFT", 18, -2)
    end
    Theme:AnchorSpellbarToContainer(frame)

    buffContainer:SetEnabled(true)
    debuffContainer:SetEnabled(true)

    local dispellableOnly = mUI.db.profile.unitframes.buffsdebuffs.dispellableOnly
    buffContainer.mUI_dispellableButtons = {}
    buffContainer:AddAuraGroup("Buffs", dispellableOnly and UNITFRAME_BUFF_FILTER_DISPELLABLE or UNITFRAME_BUFF_FILTER_ALL, {
        maxFrameCount = Theme.MAX_UNITFRAME_BUFFS,
        candidateFilters = {
            isStealable = false
        },
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, false, dispellableOnly and STEALABLE_BORDER_COLOR or nil, buffSize)
            table.insert(buffContainer.mUI_dispellableButtons, auraFrame)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    -- Stealable/purgeable buffs
    buffContainer:AddAuraGroup("BuffsStealable", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
        maxFrameCount = Theme.MAX_UNITFRAME_BUFFS,
        candidateFilters = {
            isStealable = true
        },
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, false, STEALABLE_BORDER_COLOR, buffSize)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    buffContainer.mUI_importantBuffGroupKey = "BuffsImportantFilter"
    buffContainer:AddAuraGroup("BuffsImportantFilter", UNITFRAME_BUFF_FILTER_IMPORTANT, {
        maxFrameCount = dispellableOnly and Theme.MAX_UNITFRAME_BUFFS or 0,
        candidateFilters = {
            isStealable = false
        },
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, false, nil, buffSize)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    local debuffFilterString = UNITFRAME_DEBUFF_FILTER_MINE
    local debuffGroups = {}
    debuffContainer.mUI_debuffGroups = debuffGroups

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

        for _, groupInfo in ipairs(DEBUFF_TYPE_GROUPS) do
            table.insert(debuffGroups, groupInfo)
            debuffContainer:AddAuraGroup(groupInfo.key, debuffFilterString, {
                maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
                candidateFilters = {
                    includeDispelTypes = groupInfo.includeDispelTypes,
                    excludeDispelTypes = groupInfo.excludeDispelTypes,
                    excludeSpellIDs = IMPORTANT_DEBUFFS
                },
                initializeFrame = function(auraFrame)
                    Theme:InitializeCustomAuraButton(auraFrame, true, groupInfo.color, debuffSize)
                end,
                layout = {
                    elementSpacing = 3,
                    lineSpacing = 3
                }
            })
        end
    else
        table.insert(debuffGroups, {
            key = "Debuffs"
        })
        debuffContainer:AddAuraGroup("Debuffs", debuffFilterString, {
            maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
            candidateFilters = {
                excludeSpellIDs = IMPORTANT_DEBUFFS
            },
            initializeFrame = function(auraFrame)
                Theme:InitializeCustomAuraButton(auraFrame, true, nil, debuffSize)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })
    end

    debuffContainer.mUI_importantGroupKey = "DebuffsImportant"
    debuffContainer:AddAuraGroup("DebuffsImportant", UNITFRAME_DEBUFF_FILTER_ALL, {
        maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
        candidateFilters = {
            includeSpellIDs = IMPORTANT_DEBUFFS
        },
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, true, nil, debuffSize, true)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    Theme:UpdateUnitDebuffCasterFilter(frame)
    Theme:UpdateUnitBuffFilter(frame)

    if not Theme:IsHooked(frame, "UpdateAuras") then
        Theme:SecureHook(frame, "UpdateAuras", function(self)
            Theme:UpdateUnitDebuffCasterFilter(self)
            Theme:UpdateUnitBuffFilter(self)
            buffContainer:UpdateAllAuras()
            debuffContainer:UpdateAllAuras()
            Theme:ReflowUnitAuraContainer(self)
            Theme:AnchorSpellbarToContainer(self)
        end)
    end

    return buffContainer, debuffContainer
end

function Theme:UpdateUnitDebuffCasterFilter(frame)
    local debuffContainer = frame and frame.mUI_debuffContainer
    local groups = debuffContainer and debuffContainer.mUI_debuffGroups
    if not groups then
        return
    end

    local unit = frame.unit or debuffContainer:GetUnit()
    local showAllCasters = unit ~= nil and not UnitCanAttack("player", unit)

    local filterString = showAllCasters and UNITFRAME_DEBUFF_FILTER_ALL or UNITFRAME_DEBUFF_FILTER_MINE
    for _, groupInfo in ipairs(groups) do
        debuffContainer:SetAuraGroupFilterString(groupInfo.key, filterString)
        debuffContainer:SetAuraGroupCandidateFilters(groupInfo.key, {
            includeDispelTypes = groupInfo.includeDispelTypes,
            excludeDispelTypes = groupInfo.excludeDispelTypes,
            excludeSpellIDs = IMPORTANT_DEBUFFS
        })
    end

    local importantKey = debuffContainer.mUI_importantGroupKey
    if importantKey then
        debuffContainer:SetAuraGroupMaxFrameCount(importantKey, showAllCasters and 0 or Theme.MAX_UNITFRAME_DEBUFFS)
    end
end

function Theme:UpdateUnitBuffFilter(frame)
    local buffContainer = frame and frame.mUI_buffContainer
    if not buffContainer then
        return
    end

    local unit = frame.unit or buffContainer:GetUnit()
    local dispellableOnly = mUI.db.profile.unitframes.buffsdebuffs.dispellableOnly and unit ~= nil and UnitCanAttack("player", unit)
    buffContainer:SetAuraGroupFilterString("Buffs", dispellableOnly and UNITFRAME_BUFF_FILTER_DISPELLABLE or UNITFRAME_BUFF_FILTER_ALL)

    for _, auraFrame in ipairs(buffContainer.mUI_dispellableButtons or {}) do
        if dispellableOnly then
            auraFrame.mUIBorderColor = STEALABLE_BORDER_COLOR
            pcall(auraFrame.mUIBorder.SetVertexColor, auraFrame.mUIBorder, STEALABLE_BORDER_COLOR.r, STEALABLE_BORDER_COLOR.g,
                STEALABLE_BORDER_COLOR.b, 1)
        else
            auraFrame.mUIBorderColor = nil
            pcall(auraFrame.mUIBorder.SetVertexColor, auraFrame.mUIBorder, unpack(mUI:Color(0.25)))
        end
    end

    local importantKey = buffContainer.mUI_importantBuffGroupKey
    if importantKey then
        buffContainer:SetAuraGroupMaxFrameCount(importantKey, dispellableOnly and Theme.MAX_UNITFRAME_BUFFS or 0)
    end
end

-- Re-applies it to every live target/focus frame, for the config option's
-- live-update path.
function Theme:UpdateAllUnitframeBuffFilters()
    for frame in pairs(Theme.unitframeAuraFrames or {}) do
        Theme:UpdateUnitBuffFilter(frame)
    end
end

function Theme:GetUnitframeAuraSizes()
    local bd = mUI.db.profile.unitframes.buffsdebuffs
    local buffSize = (bd and bd.buffsize and bd.buffsize > 0) and bd.buffsize or Theme.UNITFRAME_AURA_SIZE
    local debuffSize = (bd and bd.debuffsize and bd.debuffsize > 0) and bd.debuffsize or Theme.UNITFRAME_AURA_SIZE
    return buffSize, debuffSize
end

function Theme:UpdateAllUnitframeAuraSizes()
    local buffSize, debuffSize = Theme:GetUnitframeAuraSizes()
    for frame in pairs(Theme.unitframeAuraFrames or {}) do
        local buffContainer = frame and frame.mUI_buffContainer
        local debuffContainer = frame and frame.mUI_debuffContainer

        if buffContainer and buffContainer.mUI_baseSize and buffContainer.mUI_baseSize > 0 then
            buffContainer:SetScale(buffSize / buffContainer.mUI_baseSize)
        end

        if debuffContainer and debuffContainer.mUI_baseSize and debuffContainer.mUI_baseSize > 0 then
            debuffContainer:SetScale(debuffSize / debuffContainer.mUI_baseSize)
        end
    end
end

function Theme:ReflowUnitAuraContainer(frame)
    local buffContainer = frame.mUI_buffContainer
    local debuffContainer = frame.mUI_debuffContainer
    if not buffContainer or not debuffContainer then
        return
    end

    local mirrorVertically = frame.buffsOnTop == true

    local point, relativePoint, offsetY
    if mirrorVertically then
        point, relativePoint, offsetY = "BOTTOMLEFT", "TOPLEFT", AURA_MIRRORED_START_Y
    else
        point, relativePoint, offsetY = "TOPLEFT", "BOTTOMLEFT", AURA_START_Y
    end

    local vGrowth = mirrorVertically and AnchorUtil.FlowDirection.Up or AnchorUtil.FlowDirection.Down
    local lineSize = AURA_LINE_SIZE

    -- Debuffs: anchored to the frame (always the block nearest the unit frame).
    -- Not on top: debuffs sit above buffs. On top: debuffs sit below buffs.
    debuffContainer:ClearAllPoints()
    debuffContainer:SetPoint(point, frame.TargetFrameContainer.FrameTexture, relativePoint, AURA_START_X, offsetY)
    debuffContainer:SetFlowLayoutAnchorPoint(point)
    debuffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, vGrowth)
    debuffContainer:SetFlowLayoutMaximumLineSize(lineSize)

    -- Buffs: anchored just past the debuff block (debuffs grow toward it), same direction.
    buffContainer:ClearAllPoints()
    buffContainer:SetPoint(point, debuffContainer, relativePoint, 0, offsetY)
    buffContainer:SetFlowLayoutAnchorPoint(point)
    buffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, vGrowth)
    buffContainer:SetFlowLayoutMaximumLineSize(lineSize)
end

function Theme:AnchorSpellbarToContainer(frame)
    local spellbar = _G[frame:GetName() .. "SpellBar"]
    if not spellbar then
        return
    end
    frame.mUI_spellbar = spellbar

    -- Buffs are the outermost aura block (debuffs sit nearest the frame), so the
    -- bar anchors below the buff container.
    local container = frame.mUI_buffContainer
    if not container then
        return
    end

    -- Watchdog: correct any future re-anchor, whatever its source. Installed once per bar.
    if not Theme:IsHooked(spellbar, "SetPoint") then
        Theme:SecureHook(spellbar, "SetPoint", function(bar)
            if not bar.mUI_reanchoring then
                Theme:AnchorSpellbarToContainer(frame)
            end
        end)
    end

    local _, relTo = spellbar:GetPoint()

    if frame.buffsOnTop == true then
        if relTo ~= container then
            return
        end
        local pointX = frame.smallSize and 38 or 43
        local pointY = frame.smallSize and 3 or 5
        if frame.haveToT then
            pointY = frame.smallSize and -48 or -46
        end
        spellbar.mUI_reanchoring = true
        spellbar:ClearAllPoints()
        spellbar:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", pointX, pointY)
        spellbar.mUI_reanchoring = false
        return
    end

    -- Buffs below: the bar goes just below the aura block (container BOTTOM).
    if relTo == container then
        return
    end
    spellbar.mUI_reanchoring = true
    spellbar:ClearAllPoints()
    spellbar:SetPoint("TOPLEFT", container, "BOTTOMLEFT", 18, -2)
    spellbar.mUI_reanchoring = false
end

-- ============================================================================
-- Raid- & Partyframe Auras
-- ============================================================================
local RAID_MAX_BUFFS = 6
local RAID_MAX_DEBUFFS = 5 -- Default for the configurable "Max Debuff Icons" option.
local RAID_MAX_DEFENSIVE = 3
local RAID_BUFFS_PER_ROW = 3
local RAID_ICON_GAP = 1
local RAID_MAX_BIG_DEBUFFS = 2

-- Only applied in PvP instances (see IsPvpInstance): permanent auras like
-- Dampening would otherwise clutter raidframes, but PvE fights routinely have
-- legitimate no-timer debuffs that should stay visible.
local RAID_DEBUFF_MAX_DURATION = 100000
local RAID_BUFF_MAX_DURATION = 100000

local function IsPvpInstance()
    local _, instanceType = IsInInstance()
    return instanceType == "pvp" or instanceType == "arena"
end

local RAID_DEBUFF_EXCLUDE = {
    [57723] = true, -- Exhaustion (Heroism)
    [57724] = true, -- Sated (Bloodlust)
    [80354] = true, -- Temporal Displacement (Time Warp)
    [95809] = true, -- Insanity (Hunter pet Ancient Hysteria)
    [264689] = true, -- Fatigued (Drums of Fury / Primal Rage)
    [390435] = true, -- Exhaustion (Evoker Fury of the Aspects)
    [308312] = true, -- Time Trial Practice (Time Trial)
    [1254550] = true, -- Arcane Empowerment
    [26013] = true, -- Deserter
    [71041] = true, -- Deserter
    [405692] = true -- Deserter
}

-- Cooldowns force-shown in the BIG DEFENSIVE frame
local RAID_DEFENSIVES = {
    [498] = true, -- Divine Protection
    [403876] = true, -- Divine Protection
    [33206] = true, -- Pain Suppression
    [228050] = true, -- Guardian of the Forgotten Queen
    [31821] = true, -- Aura Mastery
    [363534] = true, -- Rewind
    [370960] = true, -- Emerald Communion
    [378441] = true, -- Time Stop
    [325174] = true, -- Spirit Link Totem
    [409293] = true, -- Burrow
    [353319] = true, -- Revival
    [108416] = true, -- Dark Pact
    [200183] = true, -- Apotheosis
    [215769] = true, -- Spirit of the Redeemer
    [421453] = true, -- Ultimate Penitence
    [374227] = true, -- Zephyr
    -- [193065] = true, -- Protective Light
    [15286] = true, -- Vampiric Embrace
    [102558] = true, -- Incarnation (Guardian)
    [125174] = true, -- Touch of Karma
    [386208] = true, -- Defensive Stance
    [97463] = true, -- Rallying Cry
    [5277] = true, -- Evasion
    [187827] = true, -- Metamorphosis
    [145629] = true, -- Anti-Magic Zone
    [410358] = true, -- Spellwarden (AMS)
    [49039] = true, -- Lichborne
    [81256] = true, -- Dancing Rune Weapon
    [216331] = true, -- Avenging Crusader
    [389539] = true, -- Sentinel
    [1261872] = true, -- Heart of the Wild (Bear)
    [5487] = true, -- Bear Form
    [1966] = true, -- Feint
    [586] = true -- Fade
}

local RAID_CURATED_EXCLUDE = {}
for id in pairs(IMPORTANT_BUFFS) do
    RAID_CURATED_EXCLUDE[id] = true
end
for id in pairs(RAID_DEFENSIVES) do
    RAID_CURATED_EXCLUDE[id] = true
end

local BLIZZARD_RAID_AURA_CVARS = {"raidFramesDisplayBuffs", "raidFramesDisplayDebuffs", "raidFramesCenterBigDefensive"}

function Theme:DisableDefaultRaidAuras(status)
    local value = status and "0" or "1"
    for _, cvar in ipairs(BLIZZARD_RAID_AURA_CVARS) do
        pcall(SetCVar, cvar, value)
    end
end

local function RaidFilter(...)
    return AuraUtil.CreateFilterString(...)
end

local function GetRaidMaxDebuffIcons()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.maxDebuffIcons) or RAID_MAX_DEBUFFS
end

local function AreRaidAuraTooltipsEnabled()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return not raid or raid.auraTooltips ~= false
end

local function InitRaidAuraButton(auraFrame, container, groupKey, isDebuff)
    local size = (container.mUI_groupSizes and container.mUI_groupSizes[groupKey]) or 16
    CreateAuraButton(auraFrame, isDebuff, {
        size = size,
        category = "raidframe",
        dispelBorder = isDebuff,
        countSize = 9,
        countOffsetX = 1,
        countOffsetY = -1
    })

    auraFrame:SetMouseMotionEnabled(AreRaidAuraTooltipsEnabled())
end

function Theme:EnsureRaidAuraContainers(frame, data)
    if data.buffContainer then
        return
    end

    local buffSize, debuffSize = Theme:GetSizes(frame)
    local raidDB = mUI.db and mUI.db.profile.unitframes.raidframes
    local bigDebuffSize = math.floor(debuffSize * ((raidDB and raidDB.dispelScale) or 1.3) + 0.5)
    local frameH = frame:GetHeight()
    if not frameH or frameH < 1 then
        frameH = 36
    end
    local defensiveSize = math.floor(frameH * (Theme:GetDefensiveSize() / 100) + 0.5)

    -- Buffs
    local buffContainer = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    buffContainer.mUI_groupSizes = {
        Buffs = buffSize,
        BuffsImportant = buffSize
    }
    buffContainer.mUI_groupKeys = {"Buffs", "BuffsImportant"}
    buffContainer:SetFlowLayoutAnchorPoint("BOTTOMRIGHT")
    buffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Left, AnchorUtil.FlowDirection.Up)
    data.buffsFilters = {
        excludeSpellIDs = RAID_CURATED_EXCLUDE,
        isFriendly = true
    }
    buffContainer:AddAuraGroup("Buffs", RaidFilter("HELPFUL", "PLAYER", "RAID_IN_COMBAT", "!BIG_DEFENSIVE", "!EXTERNAL_DEFENSIVE"), {
        maxFrameCount = RAID_MAX_BUFFS,
        candidateFilters = data.buffsFilters,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, buffContainer, "Buffs", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    buffContainer:AddAuraGroup("BuffsImportant", RaidFilter("HELPFUL", "PLAYER"), {
        maxFrameCount = RAID_MAX_BUFFS,
        candidateFilters = {
            includeSpellIDs = IMPORTANT_BUFFS,
            isFriendly = true
        },
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, buffContainer, "BuffsImportant", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    buffContainer:SetEnabled(false)
    data.buffContainer = buffContainer

    -- Debuffs
    local debuffContainer = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    debuffContainer:SetFrameLevel(buffContainer:GetFrameLevel() + 10)
    debuffContainer.mUI_groupSizes = {
        DebuffsBig = bigDebuffSize,
        DebuffsNormal = debuffSize
    }
    debuffContainer.mUI_groupKeys = {"DebuffsBig", "DebuffsNormal"}
    debuffContainer:SetFlowLayoutAnchorPoint("BOTTOMLEFT")
    debuffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Up)
    -- Enlarged: boss & role auras (exactly what the default frame enlarges).
    data.debuffsBigFilters = {
        isBossOrRoleAura = true,
        excludeSpellIDs = RAID_DEBUFF_EXCLUDE,
        isFriendly = true
    }
    debuffContainer:AddAuraGroup("DebuffsBig", RaidFilter("HARMFUL"), {
        maxFrameCount = RAID_MAX_BIG_DEBUFFS,
        candidateFilters = data.debuffsBigFilters,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, debuffContainer, "DebuffsBig", true)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    -- Normal: everything else (not boss/role), shown at the base debuff size.
    data.debuffsNormalFilters = {
        isBossOrRoleAura = false,
        excludeSpellIDs = RAID_DEBUFF_EXCLUDE,
        isFriendly = true
    }
    debuffContainer:AddAuraGroup("DebuffsNormal", RaidFilter("HARMFUL"), {
        maxFrameCount = GetRaidMaxDebuffIcons(),
        candidateFilters = data.debuffsNormalFilters,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, debuffContainer, "DebuffsNormal", true)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    debuffContainer:SetEnabled(false)
    data.debuffContainer = debuffContainer

    -- Defensives
    local defensiveContainer = CreateFrame("AuraContainer", nil, frame, "CustomAuraContainerTemplate")
    local healthLevel = (frame.healthBar and frame.healthBar:GetFrameLevel()) or frame:GetFrameLevel()
    defensiveContainer:SetFrameLevel(math.max(healthLevel, frame:GetFrameLevel()) + 10)
    defensiveContainer.mUI_groupSizes = {
        BigDefensives = defensiveSize,
        AdditionalDefensives = defensiveSize,
        DefensivesImportant = defensiveSize
    }
    defensiveContainer.mUI_groupKeys = {"BigDefensives", "AdditionalDefensives", "DefensivesImportant"}
    defensiveContainer:AddAuraGroup("BigDefensives", RaidFilter("HELPFUL", "BIG_DEFENSIVE"), {
        maxFrameCount = RAID_MAX_DEFENSIVE,
        candidateFilters = {
            excludeSpellIDs = RAID_CURATED_EXCLUDE,
            isFriendly = true
        },
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, defensiveContainer, "BigDefensives", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    data.additionalDefensivesFilters = {
        includeSpellIDs = RAID_DEFENSIVES,
        isFriendly = true
    }
    defensiveContainer:AddAuraGroup("AdditionalDefensives", RaidFilter("HELPFUL"), {
        maxFrameCount = RAID_MAX_DEFENSIVE,
        candidateFilters = data.additionalDefensivesFilters,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, defensiveContainer, "BigDefensives", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })

    defensiveContainer.mUI_importantGroupKey = "DefensivesImportant"
    defensiveContainer:AddAuraGroup("DefensivesImportant", RaidFilter("HELPFUL", "IMPORTANT", "!BIG_DEFENSIVE", "!EXTERNAL_DEFENSIVE"), {
        maxFrameCount = Theme:ShowImportantDefensives() and RAID_MAX_DEFENSIVE or 0,
        candidateFilters = {
            excludeSpellIDs = RAID_CURATED_EXCLUDE,
            isFriendly = true
        },
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, defensiveContainer, "DefensivesImportant", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    defensiveContainer:SetEnabled(false)
    data.defensiveContainer = defensiveContainer
end

-- Re-applies the PvP-only maxDuration cap (see IsPvpInstance) to the groups
-- that carry permanent/no-timer auras, only touching groups whose state
-- actually changed.
function Theme:ApplyRaidAuraDurationFilters(data)
    if not data.buffContainer then
        return
    end

    local maxDur = IsPvpInstance() and RAID_BUFF_MAX_DURATION or nil
    local maxDebuffDur = IsPvpInstance() and RAID_DEBUFF_MAX_DURATION or nil

    if data.buffsFilters.maxDuration ~= maxDur then
        data.buffsFilters.maxDuration = maxDur
        data.buffContainer:SetAuraGroupCandidateFilters("Buffs", data.buffsFilters)
    end

    if data.debuffsBigFilters.maxDuration ~= maxDebuffDur then
        data.debuffsBigFilters.maxDuration = maxDebuffDur
        data.debuffContainer:SetAuraGroupCandidateFilters("DebuffsBig", data.debuffsBigFilters)
    end

    if data.debuffsNormalFilters.maxDuration ~= maxDebuffDur then
        data.debuffsNormalFilters.maxDuration = maxDebuffDur
        data.debuffContainer:SetAuraGroupCandidateFilters("DebuffsNormal", data.debuffsNormalFilters)
    end

    if data.additionalDefensivesFilters.maxDuration ~= maxDur then
        data.additionalDefensivesFilters.maxDuration = maxDur
        data.defensiveContainer:SetAuraGroupCandidateFilters("AdditionalDefensives", data.additionalDefensivesFilters)
    end
end

local function ApplyRaidDefensivePosition(frame, defensiveContainer, defPoint, defX, defY)
    defensiveContainer:ClearAllPoints()
    if defPoint == "RIGHT" then
        defensiveContainer:SetFlowLayoutAnchorPoint("RIGHT")
        defensiveContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Left, AnchorUtil.FlowDirection.Down)
        defensiveContainer:SetPoint("RIGHT", frame, "RIGHT", defX, defY)
    elseif defPoint == "LEFT" then
        defensiveContainer:SetFlowLayoutAnchorPoint("LEFT")
        defensiveContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        defensiveContainer:SetPoint("LEFT", frame, "LEFT", defX, defY)
    else
        defensiveContainer:SetFlowLayoutAnchorPoint("LEFT")
        defensiveContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        defensiveContainer:SetPoint("CENTER", frame, "CENTER", defX, defY)
    end
end

function Theme:UpdateAllRaidDefensivePositions()
    local defPoint, defX, defY = Theme:GetDefensivePosition()
    for frame in pairs(Theme.raidAuraFrames or {}) do
        local data = frame and frame.mUI_AD
        local defensiveContainer = data and data.defensiveContainer
        if defensiveContainer and not frame:IsForbidden() then
            ApplyRaidDefensivePosition(frame, defensiveContainer, defPoint, defX, defY)
            defensiveContainer:UpdateAllAuras()
        end
    end
end

function Theme:UpdateRaidAuraContainers(frame, data, unit, unreachable, notAssistable, buffSize, debuffSize, defensiveSize, defPoint, defX, defY)
    local buffContainer = data.buffContainer
    local debuffContainer = data.debuffContainer
    local defensiveContainer = data.defensiveContainer
    if not buffContainer then
        return
    end

    Theme:ApplyRaidAuraDurationFilters(data)

    -- Sizes
    local buffS = buffContainer.mUI_groupSizes.Buffs or buffSize
    local bigS = debuffContainer.mUI_groupSizes.DebuffsBig or debuffSize
    local normalS = debuffContainer.mUI_groupSizes.DebuffsNormal or debuffSize
    local defS = defensiveContainer.mUI_groupSizes.BigDefensives or defensiveSize
    buffContainer:SetFlowLayoutMaximumLineSize(RAID_BUFFS_PER_ROW * (buffS + RAID_ICON_GAP))
    debuffContainer:SetFlowLayoutMaximumLineSize(RAID_MAX_BIG_DEBUFFS * (bigS + RAID_ICON_GAP) + GetRaidMaxDebuffIcons() * (normalS + RAID_ICON_GAP))
    defensiveContainer:SetFlowLayoutMaximumLineSize(RAID_MAX_DEFENSIVE * (defS + RAID_ICON_GAP))

    Theme:ApplyRaidAuraSides(data)

    ApplyRaidDefensivePosition(frame, defensiveContainer, defPoint, defX, defY)

    -- Out of phase/range: no reliable aura data at all, hide everything.
    if unreachable then
        for _, container in ipairs({buffContainer, debuffContainer, defensiveContainer}) do
            if container.mUI_unit ~= nil then
                container:SetEnabled(false)
                container.mUI_unit = nil
                container:Hide()
            end
        end
        return
    end

    -- Not assistable (e.g. dueling a friendly unit): buffs/debuffs keep
    -- working via the isFriendly candidate filter, but the defensive
    -- container still breaks in this state, so hide just that one.
    if notAssistable then
        if defensiveContainer.mUI_unit ~= nil then
            defensiveContainer:SetEnabled(false)
            defensiveContainer.mUI_unit = nil
            defensiveContainer:Hide()
        end
    else
        if defensiveContainer.mUI_unit ~= unit then
            defensiveContainer:SetUnit(unit)
            defensiveContainer:SetEnabled(true)
            defensiveContainer.mUI_unit = unit
            defensiveContainer:Show()
        end
        defensiveContainer:UpdateAllAuras()
    end

    for _, container in ipairs({buffContainer, debuffContainer}) do
        if container.mUI_unit ~= unit then
            container:SetUnit(unit)
            container:SetEnabled(true)
            container.mUI_unit = unit
            container:Show()
        end
        container:UpdateAllAuras()
    end
end

function Theme:GetSizes(frame)
    local h = frame:GetHeight()
    if not h or h < 1 then
        h = 36
    end
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    local buffPct = (raid and raid.buffsize or 33) / 100
    local debuffPct = (raid and raid.debuffsize or 55) / 100
    return math.floor(h * buffPct + 0.5), math.floor(h * debuffPct + 0.5)
end

function Theme:GetDefensiveSize()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.centerDefensiveSize) or 60
end

function Theme:ShowImportantDefensives()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.defensivesShowImportant) == true
end

function Theme:UpdateAllRaidDefensiveImportantFilter()
    local maxCount = Theme:ShowImportantDefensives() and RAID_MAX_DEFENSIVE or 0
    for frame in pairs(Theme.raidAuraFrames or {}) do
        local data = frame and frame.mUI_AD
        local defensiveContainer = data and data.defensiveContainer
        local importantKey = defensiveContainer and defensiveContainer.mUI_importantGroupKey
        if importantKey and not frame:IsForbidden() then
            defensiveContainer:SetAuraGroupMaxFrameCount(importantKey, maxCount)
        end
    end
end

function Theme:GetRaidDebuffSide()
    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    return (raid and raid.debuffPoint == "RIGHT") and "RIGHT" or "LEFT"
end

function Theme:ApplyRaidAuraSides(data)
    local buffContainer = data.buffContainer
    local debuffContainer = data.debuffContainer
    if not buffContainer or not debuffContainer or not data.buffAnchor then
        return
    end

    local debuffsRight = Theme:GetRaidDebuffSide() == "RIGHT"
    -- buffAnchor sits in the bottom-right corner, debuffAnchor in the
    -- bottom-left; the containers just swap which one they use.
    local debuffAnchor = debuffsRight and data.buffAnchor or data.debuffAnchor
    local buffAnchor = debuffsRight and data.debuffAnchor or data.buffAnchor
    local debuffPoint = debuffsRight and "BOTTOMRIGHT" or "BOTTOMLEFT"
    local buffPoint = debuffsRight and "BOTTOMLEFT" or "BOTTOMRIGHT"
    local debuffGrowth = debuffsRight and AnchorUtil.FlowDirection.Left or AnchorUtil.FlowDirection.Right
    local buffGrowth = debuffsRight and AnchorUtil.FlowDirection.Right or AnchorUtil.FlowDirection.Left

    debuffContainer:ClearAllPoints()
    debuffContainer:SetPoint(debuffPoint, debuffAnchor, debuffPoint, 0, 0)
    debuffContainer:SetFlowLayoutAnchorPoint(debuffPoint)
    debuffContainer:SetFlowLayoutGrowthDirection(debuffGrowth, AnchorUtil.FlowDirection.Up)

    buffContainer:ClearAllPoints()
    buffContainer:SetPoint(buffPoint, buffAnchor, buffPoint, 0, 0)
    buffContainer:SetFlowLayoutAnchorPoint(buffPoint)
    buffContainer:SetFlowLayoutGrowthDirection(buffGrowth, AnchorUtil.FlowDirection.Up)
end

function Theme:UpdateAllRaidAuraSides()
    for frame in pairs(Theme.raidAuraFrames or {}) do
        local data = frame and frame.mUI_AD
        if data and data.buffContainer and not frame:IsForbidden() then
            Theme:ApplyRaidAuraSides(data)
        end
    end
end

function Theme:GetDefensivePosition()
    local DEFENSIVE_POINTS = {
        CENTER = true,
        LEFT = true,
        RIGHT = true
    }

    local raid = mUI.db and mUI.db.profile.unitframes.raidframes
    local point = raid and raid.centerDefensivePoint or "CENTER"
    if not DEFENSIVE_POINTS[point] then
        point = "CENTER"
    end
    local x = (raid and raid.centerDefensiveX) or 0
    local y = (raid and raid.centerDefensiveY) or 0
    return point, x, y
end

function Theme:EnsureContainers(frame)
    if frame.mUI_AD then
        return frame.mUI_AD
    end

    local data = {
        buffs = {},
        debuffs = {},
        defensives = {}
    }

    local buffAnchor = CreateFrame("Frame", nil, frame)
    buffAnchor:SetSize(1, 1)
    data.buffAnchor = buffAnchor

    local debuffAnchor = CreateFrame("Frame", nil, frame)
    debuffAnchor:SetSize(1, 1)
    data.debuffAnchor = debuffAnchor

    local defensiveAnchor = CreateFrame("Frame", nil, frame)
    defensiveAnchor:SetSize(1, 1)
    data.defensiveAnchor = defensiveAnchor

    Theme:EnsureRaidAuraContainers(frame, data)

    frame.mUI_AD = data

    -- Track for live size updates (config sliders re-scale these containers).
    Theme.raidAuraFrames = Theme.raidAuraFrames or {}
    Theme.raidAuraFrames[frame] = true

    return data
end

function Theme:UpdateAllRaidAuras()
    for frame in pairs(Theme.raidAuraFrames or {}) do
        local data = frame and frame.mUI_AD
        if data and data.buffContainer and not frame:IsForbidden() then
            local buffSize, debuffSize = Theme:GetSizes(frame)
            local frameH = frame:GetHeight()
            if not frameH or frameH < 1 then
                frameH = 36
            end
            local defensiveSize = math.floor(frameH * (Theme:GetDefensiveSize() / 100) + 0.5)

            local base = data.buffContainer.mUI_groupSizes.Buffs
            if base and base > 0 then
                data.buffContainer:SetScale(buffSize / base)
            end

            base = data.debuffContainer.mUI_groupSizes.DebuffsNormal
            if base and base > 0 then
                data.debuffContainer:SetScale(debuffSize / base)
            end

            base = data.defensiveContainer.mUI_groupSizes.BigDefensives
            if base and base > 0 then
                data.defensiveContainer:SetScale(defensiveSize / base)
            end
        end
    end
end

function Theme:UpdateAllRaidAuraTextSizes()
    Theme:UpdateAuraTextSizesForCategory("raidframe")
end

function Theme:UpdateAllRaidAuraTooltips()
    local enabled = AreRaidAuraTooltipsEnabled()
    for auraFrame, category in pairs(Theme.aurabuttons) do
        if category == "raidframebuff" or category == "raidframedebuff" then
            pcall(auraFrame.SetMouseMotionEnabled, auraFrame, enabled)
        end
    end
end

function Theme:UpdateAllRaidAuraDebuffLimit()
    local maxDebuffs = GetRaidMaxDebuffIcons()
    for frame in pairs(Theme.raidAuraFrames or {}) do
        local data = frame and frame.mUI_AD
        if data and data.debuffContainer and not frame:IsForbidden() then
            data.debuffContainer:SetAuraGroupMaxFrameCount("DebuffsNormal", maxDebuffs)
        end
    end
end

function Theme:PositionAnchors(frame, data)
    local powerBar = frame.powerBar
    local hasPower = powerBar and powerBar:IsShown()
    local refFrame = hasPower and powerBar or frame
    local rightRef = hasPower and "TOPRIGHT" or "BOTTOMRIGHT"
    local leftRef = hasPower and "TOPLEFT" or "BOTTOMLEFT"
    local yOffset = hasPower and 1 or 2

    data.buffAnchor:ClearAllPoints()
    data.buffAnchor:SetPoint("BOTTOMRIGHT", refFrame, rightRef, -2, yOffset)

    data.debuffAnchor:ClearAllPoints()
    data.debuffAnchor:SetPoint("BOTTOMLEFT", refFrame, leftRef, 2, yOffset)
end
