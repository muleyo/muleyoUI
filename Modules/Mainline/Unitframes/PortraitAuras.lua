local PortraitAuras = mUI:NewModule("mUI.Modules.Unitframes.PortraitAuras", "AceEvent-3.0")

function PortraitAuras:OnInitialize()
    local filters = AuraUtil and AuraUtil.AuraFilters
    if not (filters and filters.CrowdControl and filters.BigDefensive and filters.Important and AuraUtil.CreateFilterString) then
        return
    end

    local CIRCLE_MASK = [[Interface\Masks\CircleMaskScalable]]
    local CIRCLE_SWIPE = [[Interface\CharacterFrame\TempPortraitAlphaMask]]
    local SWIPE_ALPHA = 0.75
    -- one strata under the unit frame, so its ring and art stay on top
    local STRATA_BELOW = {
        BACKGROUND = "BACKGROUND",
        LOW = "BACKGROUND",
        MEDIUM = "LOW",
        HIGH = "MEDIUM",
        DIALOG = "HIGH",
        FULLSCREEN = "DIALOG",
        FULLSCREEN_DIALOG = "FULLSCREEN",
        TOOLTIP = "FULLSCREEN_DIALOG"
    }

    local PORTRAIT_LEVEL = 1

    -- two levels per source: its icon, then its cooldown
    local function IconLevel(step)
        return PORTRAIT_LEVEL + 1 + (step - 1) * 2
    end

    local SPELLS = mUI.PortraitAuraSpells or {}
    local MAX_BUFF_DURATION = 60
    -- highest priority first
    local SOURCES = { {
        filter = AuraUtil.CreateFilterString(filters.Harmful),
        list = "CrowdControl",
        -- spell IDs only match on hostile units
        notFor = {
            player = true
        }
    }, {
        filter = AuraUtil.CreateFilterString(filters.Harmful, filters.CrowdControl)
    }, {
        filter = AuraUtil.CreateFilterString(filters.Harmful),
        list = "SoftCrowdControl",
        notFor = {
            player = true
        }
    }, {
        filter = AuraUtil.CreateFilterString(filters.Helpful, filters.BigDefensive)
    }, {
        filter = AuraUtil.CreateFilterString(filters.Helpful),
        list = "Defensive",
        maxDuration = MAX_BUFF_DURATION
    }, {
        filter = AuraUtil.CreateFilterString(filters.Helpful, filters.Important, "!" .. filters.BigDefensive)
    }, {
        filter = AuraUtil.CreateFilterString(filters.Helpful),
        list = "Important",
        maxDuration = MAX_BUFF_DURATION
    } }

    local UNITS = { {
        unit = "player",
        frame = function()
            local art = PlayerFrame.PlayerFrameContainer
            return PlayerFrame.PlayerFrameContent.PlayerFrameContentMain, art.PlayerPortrait, art.PlayerPortraitMask
        end
    }, {
        unit = "target",
        frame = function()
            local art = TargetFrame.TargetFrameContainer
            return TargetFrame.TargetFrameContent.TargetFrameContentMain, art.Portrait, art.PortraitMask
        end
    }, {
        unit = "focus",
        frame = function()
            local art = FocusFrame.TargetFrameContainer
            return FocusFrame.TargetFrameContent.TargetFrameContentMain, art.Portrait, art.PortraitMask
        end
    } }

    -- the portrait's own mask so the icon fits the ring, circle as fallback
    local function SetIconShape(mask, portraitMask)
        local atlas = portraitMask and portraitMask:GetAtlas()

        if atlas then
            mask:SetAtlas(atlas)
        else
            mask:SetTexture((portraitMask and portraitMask:GetTexture()) or CIRCLE_MASK, "CLAMPTOBLACKADDITIVE",
                "CLAMPTOBLACKADDITIVE")
        end
    end

    -- the game locks the frame once auras are secret, so do it all here
    local function InitializeIcon(auraFrame, size, strata, level, portraitMask)
        auraFrame:SetSize(size, size)
        auraFrame:SetFrameStrata(strata)
        auraFrame:SetFrameLevel(level)
        auraFrame:SetMouseMotionEnabled(false)
        auraFrame:SetMouseClickEnabled(false)

        local icon = auraFrame:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(auraFrame)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        auraFrame:SetIcon(icon)

        local mask = auraFrame:CreateMaskTexture()
        mask:SetAllPoints(icon)
        SetIconShape(mask, portraitMask)
        icon:AddMaskTexture(mask)

        local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
        cooldown:SetFrameStrata(strata)
        -- one above the icon, otherwise the swipe hides under it
        cooldown:SetFrameLevel(level + 1)
        cooldown:SetAllPoints(auraFrame)
        cooldown:SetReverse(true)
        cooldown:SetDrawBling(false)
        cooldown:SetSwipeColor(0, 0, 0, SWIPE_ALPHA)
        cooldown:SetSwipeTexture(CIRCLE_SWIPE)
        cooldown:SetCountdownFont("NumberFontNormal")
        auraFrame:SetDurationCooldown(cooldown)
    end

    local function Build(unit, content, portrait, mask)
        local size = portrait:GetWidth()
        -- the portrait moves into a frame below the ring
        local art = portrait:GetParent()
        local strata = STRATA_BELOW[art:GetFrameStrata()] or "BACKGROUND"
        local home = CreateFrame("Frame", nil, art)
        home:SetAllPoints(art)
        home:SetFrameStrata(strata)
        home:SetFrameLevel(PORTRAIT_LEVEL)
        PortraitAuras.portraits[unit] = {
            art = art,
            home = home,
            portrait = portrait,
            mask = mask
        }

        local containers = {}

        for index = #SOURCES, 1, -1 do
            local source = SOURCES[index]
            local level = IconLevel(#SOURCES - index + 1)
            local spells = source.list and SPELLS[source.list]
            local skip = (source.notFor and source.notFor[unit]) or (source.list and not (spells and next(spells)))

            if not skip then
                local container = CreateFrame("AuraContainer", nil, content, "CustomAuraContainerTemplate")
                -- set before AddAuraGroup, the group's frame copies it
                container:SetFrameStrata(strata)
                container:SetFrameLevel(level)
                container:SetFlowLayoutAnchorPoint("CENTER")
                container:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
                container:SetFlowLayoutMaximumLineSize(size)
                container:SetEnabled(false)

                local candidateFilters
                if spells then
                    candidateFilters = {
                        includeSpellIDs = spells,
                        maxDuration = source.maxDuration
                    }
                end

                container:AddAuraGroup("Icon", source.filter, {
                    maxFrameCount = 1,
                    candidateFilters = candidateFilters,
                    initializeFrame = function(auraFrame)
                        InitializeIcon(auraFrame, size, strata, level, mask)
                    end,
                    layout = {
                        elementSpacing = 0,
                        lineSpacing = 0
                    }
                })

                container:ClearAllPoints()
                container:SetPoint("CENTER", portrait, "CENTER", 0, 0)
                container:SetUnit(unit)
                container:SetEnabled(true)

                containers[#containers + 1] = container
            end
        end

        return containers
    end

    PortraitAuras.containers = {}
    PortraitAuras.portraits = {}

    function PortraitAuras:Setup()
        for _, info in ipairs(UNITS) do
            if not PortraitAuras.containers[info.unit] then
                local content, portrait, mask = info.frame()
                PortraitAuras.containers[info.unit] = Build(info.unit, content, portrait, mask)
            end
        end
    end

    -- portrait and mask go below the ring, or back to the game's frame
    function PortraitAuras:MovePortraits(under)
        for _, entry in pairs(PortraitAuras.portraits) do
            local parent = under and entry.home or entry.art
            entry.portrait:SetParent(parent)
            if entry.mask then
                entry.mask:SetParent(parent)
            end
        end
    end

    function PortraitAuras:Refresh(unit)
        for _, container in ipairs(PortraitAuras.containers[unit] or {}) do
            container:UpdateAllAuras()
        end
    end

    function PortraitAuras:OnTargetChanged()
        PortraitAuras:Refresh("target")
    end

    function PortraitAuras:OnFocusChanged()
        PortraitAuras:Refresh("focus")
    end
end

function PortraitAuras:OnEnable()
    -- client without the aura filters
    if not PortraitAuras.Setup then
        return
    end

    PortraitAuras:Setup()
    PortraitAuras:MovePortraits(true)

    for _, containers in pairs(PortraitAuras.containers) do
        for _, container in ipairs(containers) do
            container:SetEnabled(true)
            container:Show()
        end
    end

    PortraitAuras:RegisterEvent("PLAYER_TARGET_CHANGED", "OnTargetChanged")
    PortraitAuras:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnFocusChanged")
end

function PortraitAuras:OnDisable()
    PortraitAuras:UnregisterAllEvents()

    if PortraitAuras.MovePortraits then
        PortraitAuras:MovePortraits(false)
    end

    for _, containers in pairs(PortraitAuras.containers or {}) do
        for _, container in ipairs(containers) do
            container:SetEnabled(false)
            container:Hide()
        end
    end
end
