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
        auraFrame.Cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
        auraFrame.Cooldown:SetAllPoints(auraFrame.Icon)
        auraFrame.Cooldown:SetSwipeTexture(AURA_MASK_TEX)
        auraFrame.Cooldown:SetSwipeColor(0, 0, 0, 0.75)
        auraFrame.Cooldown:SetReverse(true)
        auraFrame.Cooldown:SetDrawBling(false)
        auraFrame.Cooldown:SetCountdownFont("NumberFontNormalSmall")
        auraFrame:SetDurationCooldown(auraFrame.Cooldown)

        -- Cooldown Text
        auraFrame.CooldownText = auraFrame.Cooldown:GetCountdownFontString()
        auraFrame.CooldownText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        auraFrame.CooldownText:ClearAllPoints()
        auraFrame.CooldownText:SetPoint("BOTTOM", auraFrame.Icon, "BOTTOM", 0, 0)

        -- Create Border (in its own overlay above the Cooldown frame, otherwise
        -- the cooldown swipe - a child frame - draws over the border textures).
        auraFrame.BorderOverlay = CreateFrame("Frame", nil, auraFrame)
        auraFrame.BorderOverlay:SetAllPoints(auraFrame)
        auraFrame.BorderOverlay:SetFrameLevel(auraFrame.Cooldown:GetFrameLevel() + 1)

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
        auraFrame.Count:SetFont(STANDARD_TEXT_FONT, opts.countSize or 11, "OUTLINE")
        auraFrame.Count:SetPoint("TOPRIGHT", auraFrame.Icon, "TOPRIGHT", opts.countOffsetX or -1, opts.countOffsetY or -1)
        auraFrame:SetApplicationCount(auraFrame.Count)

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
        else
            auraFrame.mUIBorder:SetVertexColor(unpack(mUI:Color(opts.baseShade or 0.25)))
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
    for auraFrame in pairs(Theme.aurabuttons) do
        local border = auraFrame.mUIDispelBorder
        if border then
            pcall(border.SetAlpha, border, alpha)
        end
    end
end

function Theme:DisableDefaultPlayerAuras()
    for _, hostFrame in ipairs({BuffFrame, DebuffFrame}) do
        hostFrame:UnregisterAllEvents()
        hostFrame.AuraContainer:UnregisterAllEvents()
        hostFrame.AuraContainer:Hide()
        hostFrame:SetScript("OnUpdate", nil)

        for _, auraFrame in ipairs(hostFrame.auraFrames or {}) do
            if not auraFrame.isAuraAnchor then
                auraFrame:SetScript("OnUpdate", nil)
                auraFrame:Hide()
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
local AURA_START_X = 5
local AURA_START_Y = 4
local AURA_MIRRORED_START_Y = -6
local AURA_LINE_SIZE = 155
local AURA_LINE_SIZE_TOT = 125

function Theme:InitializeCustomAuraButton(auraFrame, isDebuff, borderColor, size)
    -- Debuff coloring is baked per aura group (see CreateUnitAuraContainer), so
    -- the color is passed in statically rather than via a live dispel border.
    CreateAuraButton(auraFrame, isDebuff, {
        size = size or Theme.UNITFRAME_AURA_SIZE,
        category = "unitframe",
        borderColor = borderColor
    })
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

    Theme:ReflowUnitAuraContainer(frame)
    buffContainer:SetUnit(unit)
    debuffContainer:SetUnit(unit)

    local spellbar = _G[frame:GetName() .. "SpellBar"]
    if spellbar then
        spellbar:ClearAllPoints()
        spellbar:SetPoint("TOPLEFT", debuffContainer, "BOTTOMLEFT", 18, -2)
    end
    Theme:AnchorSpellbarToContainer(frame)

    buffContainer:SetEnabled(true)
    debuffContainer:SetEnabled(true)

    buffContainer:AddAuraGroup("Buffs", AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful), {
        maxFrameCount = Theme.MAX_UNITFRAME_BUFFS,
        initializeFrame = function(auraFrame)
            Theme:InitializeCustomAuraButton(auraFrame, false, nil, buffSize)
        end,
        layout = {
            elementSpacing = 3,
            lineSpacing = 3
        }
    })

    -- PLAYER: show only debuffs cast by the player (or player's pet/vehicle).
    local debuffFilterString = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player)

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
            debuffContainer:AddAuraGroup(groupInfo.key, debuffFilterString, {
                maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
                candidateFilters = {
                    includeDispelTypes = groupInfo.includeDispelTypes,
                    excludeDispelTypes = groupInfo.excludeDispelTypes
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
        debuffContainer:AddAuraGroup("Debuffs", debuffFilterString, {
            maxFrameCount = Theme.MAX_UNITFRAME_DEBUFFS,
            initializeFrame = function(auraFrame)
                Theme:InitializeCustomAuraButton(auraFrame, true, nil, debuffSize)
            end,
            layout = {
                elementSpacing = 3,
                lineSpacing = 3
            }
        })
    end

    if not Theme:IsHooked(frame, "UpdateAuras") then
        Theme:SecureHook(frame, "UpdateAuras", function(self)
            buffContainer:UpdateAllAuras()
            debuffContainer:UpdateAllAuras()
            Theme:ReflowUnitAuraContainer(self)
            Theme:AnchorSpellbarToContainer(self)
        end)
    end

    return buffContainer, debuffContainer
end

function Theme:GetUnitframeAuraSizes()
    local bd = mUI.db.profile.unitframes.buffsdebuffs
    local buffSize = (bd and bd.buffsize and bd.buffsize > 0) and bd.buffsize or Theme.UNITFRAME_AURA_SIZE
    local debuffSize = (bd and bd.debuffsize and bd.debuffsize > 0) and bd.debuffsize or Theme.UNITFRAME_AURA_SIZE
    return buffSize, debuffSize
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
    local totShown = frame.IsTargetOfTargetShown and frame:IsTargetOfTargetShown()
    local lineSize = (not mirrorVertically and totShown) and AURA_LINE_SIZE_TOT or AURA_LINE_SIZE

    -- Buffs: anchored to the frame.
    buffContainer:ClearAllPoints()
    buffContainer:SetPoint(point, frame.TargetFrameContainer.FrameTexture, relativePoint, AURA_START_X, offsetY)
    buffContainer:SetFlowLayoutAnchorPoint(point)
    buffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, vGrowth)
    buffContainer:SetFlowLayoutMaximumLineSize(lineSize)

    -- Debuffs: anchored just past the buff block (buffs grow toward it), same direction.
    debuffContainer:ClearAllPoints()
    debuffContainer:SetPoint(point, buffContainer, relativePoint, 0, offsetY)
    debuffContainer:SetFlowLayoutAnchorPoint(point)
    debuffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, vGrowth)
    debuffContainer:SetFlowLayoutMaximumLineSize(lineSize)
end

function Theme:AnchorSpellbarToContainer(frame)
    local spellbar = _G[frame:GetName() .. "SpellBar"]
    if not spellbar then
        return
    end
    frame.mUI_spellbar = spellbar

    local container = frame.mUI_debuffContainer
    if not container then
        return
    end

    -- Watchdog: correct any future re-anchor, whatever its source. Installed once per bar.
    if not spellbar.mUI_setpointHooked then
        spellbar.mUI_setpointHooked = true
        hooksecurefunc(spellbar, "SetPoint", function(bar)
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
local RAID_MAX_DEBUFFS = 5
local RAID_MAX_DEFENSIVE = 3
local RAID_BUFFS_PER_ROW = 3
local RAID_ICON_GAP = 1
local RAID_MAX_BIG_DEBUFFS = 2

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

local RAID_DEBUFF_MAX_DURATION = 100000

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

local function InitRaidAuraButton(auraFrame, container, groupKey, isDebuff)
    local size = (container.mUI_groupSizes and container.mUI_groupSizes[groupKey]) or 16
    -- Raid buttons aren't tracked in Theme.aurabuttons (no category): their size
    -- is driven by container:SetScale in UpdateAllRaidAuras, not theme recolors.
    CreateAuraButton(auraFrame, isDebuff, {
        size = size,
        baseShade = 0.15,
        dispelBorder = isDebuff,
        countSize = 9,
        countOffsetX = 1,
        countOffsetY = -1
    })
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
        Buffs = buffSize
    }
    buffContainer.mUI_groupKeys = {"Buffs"}
    buffContainer:SetFlowLayoutAnchorPoint("BOTTOMRIGHT")
    buffContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Left, AnchorUtil.FlowDirection.Up)
    buffContainer:AddAuraGroup("Buffs", RaidFilter("RAID_IN_COMBAT", "PLAYER", "HELPFUL"), {
        maxFrameCount = RAID_MAX_BUFFS,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, buffContainer, "Buffs", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    buffContainer:SetEnabled(false)
    data.buffContainer = buffContainer

    -- Debuffs (kept above buffs, matching the default raid frame where debuffs
    -- draw over buffs when the containers overlap).
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
    debuffContainer:AddAuraGroup("DebuffsBig", RaidFilter("HARMFUL"), {
        maxFrameCount = RAID_MAX_BIG_DEBUFFS,
        candidateFilters = {
            isBossOrRoleAura = true,
            excludeSpellIDs = RAID_DEBUFF_EXCLUDE
        },
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, debuffContainer, "DebuffsBig", true)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    -- Normal: everything else (not boss/role), shown at the base debuff size.
    debuffContainer:AddAuraGroup("DebuffsNormal", RaidFilter("HARMFUL"), {
        maxFrameCount = RAID_MAX_DEBUFFS,
        candidateFilters = {
            isBossOrRoleAura = false,
            excludeSpellIDs = RAID_DEBUFF_EXCLUDE,
            -- Drops permanent (duration 0) debuffs like Dampening, which can't be
            -- excluded by spellID (see note above). NOT applied to DebuffsBig -
            -- boss/role debuffs are often permanent and must stay visible.
            maxDuration = RAID_DEBUFF_MAX_DURATION
        },
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
    defensiveContainer.mUI_groupSizes = {
        BigDefensives = defensiveSize
    }
    defensiveContainer.mUI_groupKeys = {"BigDefensives", "ExternalDefensives"}
    defensiveContainer:AddAuraGroup("BigDefensives", RaidFilter("HELPFUL", "BIG_DEFENSIVE"), {
        maxFrameCount = RAID_MAX_DEFENSIVE,
        initializeFrame = function(auraFrame)
            InitRaidAuraButton(auraFrame, defensiveContainer, "BigDefensives", false)
        end,
        layout = {
            elementSpacing = RAID_ICON_GAP,
            lineSpacing = RAID_ICON_GAP
        }
    })
    defensiveContainer:SetEnabled(false)
    data.defensiveContainer = defensiveContainer
end

function Theme:UpdateRaidAuraContainers(frame, data, unit, unreachable, buffSize, debuffSize, defensiveSize, defPoint, defX, defY)
    local buffContainer = data.buffContainer
    local debuffContainer = data.debuffContainer
    local defensiveContainer = data.defensiveContainer
    if not buffContainer then
        return
    end

    -- Sizes are baked at creation; read them back for the flow layout wrap width.
    local buffS = buffContainer.mUI_groupSizes.Buffs or buffSize
    local bigS = debuffContainer.mUI_groupSizes.DebuffsBig or debuffSize
    local normalS = debuffContainer.mUI_groupSizes.DebuffsNormal or debuffSize
    local defS = defensiveContainer.mUI_groupSizes.BigDefensives or defensiveSize
    buffContainer:SetFlowLayoutMaximumLineSize(RAID_BUFFS_PER_ROW * (buffS + RAID_ICON_GAP))
    -- Keep debuffs on a single line: wide enough to hold every possible icon
    -- (max big + max normal), so no group ever wraps onto a second row.
    debuffContainer:SetFlowLayoutMaximumLineSize(RAID_MAX_BIG_DEBUFFS * (bigS + RAID_ICON_GAP) + RAID_MAX_DEBUFFS * (normalS + RAID_ICON_GAP))
    defensiveContainer:SetFlowLayoutMaximumLineSize(RAID_MAX_DEFENSIVE * (defS + RAID_ICON_GAP))

    buffContainer:ClearAllPoints()
    buffContainer:SetPoint("BOTTOMRIGHT", data.buffAnchor, "BOTTOMRIGHT", 0, 0)
    debuffContainer:ClearAllPoints()
    debuffContainer:SetPoint("BOTTOMLEFT", data.debuffAnchor, "BOTTOMLEFT", 0, 0)

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

    -- Out of phase/range
    if unreachable then
        for _, container in ipairs({buffContainer, debuffContainer, defensiveContainer}) do
            container:SetEnabled(false)
            container.mUI_unit = nil
        end
        return
    end

    for _, container in ipairs({buffContainer, debuffContainer, defensiveContainer}) do
        if container.mUI_unit ~= unit then
            container:SetUnit(unit)
            container:SetEnabled(true)
            container.mUI_unit = unit
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

-- ============================================================================
-- Pre 12.1.0 Code
-- ============================================================================

local function SkinLegacyAuraButton(frame, category, opts)
    opts = opts or {}

    if not frame.mUIBorder then
        frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Border
        frame.mUIBorder = frame:CreateTexture(nil, "OVERLAY", nil, 7)
        frame.mUIBorder:SetDesaturated(true)
        frame.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Icon mask
        frame.mUIBorder.mask = frame:CreateMaskTexture()
        frame.mUIBorder.mask:SetAllPoints(frame.Icon)
        frame.Icon:AddMaskTexture(frame.mUIBorder.mask)

        if opts.swipe then
            opts.swipe:SetSwipeColor(0, 0, 0, 0.75)
        end

        -- Known icon size, updated by callers (e.g. unitframe auras pass the
        -- configured buff/debuff size). Captured by the geometry closure below.
        local geom = {size = opts.size}

        -- Style-driven texture, mask, swipe and geometry (live-switchable)
        frame.mUIBorderRecord = Theme:RegisterBorder({
            border = frame.mUIBorder,
            coord = true,
            mask = frame.mUIBorder.mask,
            swipe = opts.swipe,
            applyGeometry = function(style)
                -- Use the known configured size. Never read Icon:GetWidth() for
                -- unitframe auras - it returns a secret value in tainted paths
                -- and secret numbers can't be compared or tostring'd (only
                -- arithmetic / flowing into setters is allowed). Player auras
                -- are untainted and pass no size, so they fall back to the live
                -- icon width.
                local size = geom.size or frame.Icon:GetWidth()
                ApplyAuraBorderGeometry(frame.mUIBorder, frame.Icon, size * style.auraInsetRatio)
            end
        })
        frame.mUIBorderRecord.geom = geom

        if category then
            Theme.aurabuttons[frame] = category
        end
    end

    return frame.mUIBorderRecord
end

function Theme:ButtonDefault(button, isDebuff)
    SkinLegacyAuraButton(button, isDebuff and "playerdebuff" or "playerbuff")
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

function Theme:UpdateUnitframeAuras(aura, isDebuff, unit)
    -- Unitframe auras run in a tainted path where Icon:GetWidth() is secret, so
    -- drive the border geometry from the configured size instead.
    local db = mUI.db.profile.unitframes.buffsdebuffs
    local size = isDebuff and db.debuffsize or db.buffsize

    local record = SkinLegacyAuraButton(aura, isDebuff and "unitframedebuff" or "unitframebuff", {
        swipe = aura.Cooldown,
        size = size
    })

    -- Aura icons can resize between updates, so re-apply the border geometry
    -- for the current configured size and active style.
    if record then
        if record.geom then
            record.geom.size = size
        end
        if record.applyGeometry then
            record.applyGeometry(Theme:GetBorderStyle())
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
        aura.Border:SetAlpha(0)
    else
        aura.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
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
    end
end
