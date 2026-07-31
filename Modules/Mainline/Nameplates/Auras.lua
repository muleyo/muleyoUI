local Auras = mUI:NewModule("mUI.Modules.Nameplates.Auras")

function Auras:OnInitialize()
    -- Load Database
    Auras.db = mUI.db.profile.nameplates

    Auras.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Auras.Theme = mUI:GetModule("mUI.Modules.General.Theme")
    Auras.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")

    local Core = Auras.Core
    local Theme = Auras.Theme
    local AF = AuraUtil.AuraFilters
    local CC_FILTER = AuraUtil.CreateFilterString(AF.Harmful, AF.CrowdControl)
    local PLAYER_DEBUFF_FILTER = AuraUtil.CreateFilterString(AF.Harmful, AF.Player, "!CROWD_CONTROL")
    local DEFENSIVE_FILTER = AuraUtil.CreateFilterString(AF.Helpful, AF.BigDefensive)
    local IMPORTANT_FILTER = AuraUtil.CreateFilterString(AF.Helpful, AF.Important, "!BIG_DEFENSIVE")
    local BASE_ICON_SIZE = 20
    local ICON_GAP = 2

    local function InitIcon(auraFrame)
        Theme.CreateAuraButton(auraFrame, false, {
            size = BASE_ICON_SIZE,
            category = "nameplate"
        })
        auraFrame:SetMouseMotionEnabled(false)
    end

    -- Crowd control Border Color
    local CC_BORDER_COLOR = {
        r = 1,
        g = 0,
        b = 0
    }
    local function InitCCIcon(auraFrame)
        Theme.CreateAuraButton(auraFrame, false, {
            size = BASE_ICON_SIZE,
            category = "nameplate",
            borderColor = CC_BORDER_COLOR
        })
        auraFrame:SetMouseMotionEnabled(false)
    end

    local CLASS_ICON_MASK = [[Interface\Masks\CircleMaskScalable]]

    local function InitFriendlyCCIcon(auraFrame)
        auraFrame:SetSize(BASE_ICON_SIZE, BASE_ICON_SIZE)
        auraFrame:SetFrameLevel(auraFrame:GetParent():GetFrameLevel() + 1)

        local icon = auraFrame:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(auraFrame)
        auraFrame:SetIcon(icon)

        local mask = auraFrame:CreateMaskTexture()
        mask:SetAllPoints(icon)
        mask:SetTexture(CLASS_ICON_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        icon:AddMaskTexture(mask)

        local cooldown = CreateFrame("Cooldown", nil, auraFrame, "CooldownFrameTemplate")
        cooldown:SetPoint("TOPLEFT", icon, "TOPLEFT", 1, -1)
        cooldown:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 1)
        cooldown:SetSwipeTexture(CLASS_ICON_MASK)
        cooldown:SetSwipeColor(0, 0, 0, 0.75)
        cooldown:SetReverse(true)
        cooldown:SetDrawBling(false)
        cooldown:SetCountdownFont("NumberFontNormalSmall")
        auraFrame:SetDurationCooldown(cooldown)

        local countdownText = cooldown:GetCountdownFontString()
        if countdownText then
            countdownText:SetFont(STANDARD_TEXT_FONT, math.max(math.floor(BASE_ICON_SIZE / 3 + 2), 6), "OUTLINE")
        end

        auraFrame:SetMouseMotionEnabled(false)
    end

    local function NewContainer(plate, key, anchorPoint, growH, growV)
        local container = CreateFrame("AuraContainer", nil, plate, "CustomAuraContainerTemplate")
        container:SetFlowLayoutAnchorPoint(anchorPoint)
        container:SetFlowLayoutGrowthDirection(growH, growV)
        container:SetEnabled(false)
        container.mUI_key = key
        return container
    end

    Auras.handler = {}

    function Auras.handler.Create(plate)
        local cc = NewContainer(plate, "cc", "LEFT", AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        cc:AddAuraGroup("CrowdControl", CC_FILTER, {
            maxFrameCount = 3,
            initializeFrame = InitCCIcon,
            layout = {
                elementSpacing = ICON_GAP,
                lineSpacing = ICON_GAP
            }
        })
        plate.AuraCC = cc

        local top = NewContainer(plate, "top", "BOTTOMLEFT", AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Up)
        top:AddAuraGroup("PlayerDebuffs", PLAYER_DEBUFF_FILTER, {
            maxFrameCount = 3,
            initializeFrame = InitIcon,
            layout = {
                elementSpacing = ICON_GAP,
                lineSpacing = ICON_GAP
            }
        })
        plate.AuraTop = top

        local left = NewContainer(plate, "left", "RIGHT", AnchorUtil.FlowDirection.Left, AnchorUtil.FlowDirection.Down)
        left:AddAuraGroup("Important", IMPORTANT_FILTER, {
            maxFrameCount = 2,
            initializeFrame = InitIcon,
            layout = {
                elementSpacing = ICON_GAP,
                lineSpacing = ICON_GAP
            }
        })
        left:AddAuraGroup("Defensive", DEFENSIVE_FILTER, {
            maxFrameCount = 2,
            initializeFrame = InitIcon,
            layout = {
                elementSpacing = ICON_GAP,
                lineSpacing = ICON_GAP
            }
        })
        plate.AuraLeft = left

        -- Friendly-only: a single crowd-control icon shown inside the class icon
        local friendlyCC = NewContainer(plate, "friendlycc", "CENTER", AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        friendlyCC:SetFrameLevel(plate:GetFrameLevel() + 6)
        friendlyCC:AddAuraGroup("FriendlyCrowdControl", CC_FILTER, {
            maxFrameCount = 1,
            initializeFrame = InitFriendlyCCIcon,
            layout = {
                elementSpacing = ICON_GAP,
                lineSpacing = ICON_GAP
            }
        })
        plate.AuraFriendlyCC = friendlyCC

        local watcher = CreateFrame("Frame", nil, plate)
        watcher:SetScript("OnEvent", function()
            cc:UpdateAllAuras()
            top:UpdateAllAuras()
            left:UpdateAllAuras()
            friendlyCC:UpdateAllAuras()
        end)
        plate.AuraWatcher = watcher
    end

    local function SetContainerUnit(container, unit)
        if container.mUI_unit ~= unit then
            container:SetUnit(unit)
            container:SetEnabled(true)
            container.mUI_unit = unit
        end
        container:UpdateAllAuras()
    end

    local function ShouldShowFriendlyCC(plate, data)
        return data.isFriend and Auras.db.classicons.enabled and Auras.db.classicons.friendly and plate.ClassIcon ~= nil
    end

    function Auras.handler.Update(plate, data)
        if not plate.AuraCC then
            return
        end

        local isMinion = Auras.db.totem.enabled and Core:Safe(UnitIsMinion(data.unit), false)
        local hideBar = (Auras.Health.HideFriendlyBar and Auras.Health.HideFriendlyBar(data)) or isMinion
        plate.AurasHidden = hideBar

        if hideBar then
            for _, container in ipairs({plate.AuraCC, plate.AuraTop, plate.AuraLeft}) do
                container:SetEnabled(false)
                container.mUI_unit = nil
                container:Hide()
            end
        else
            plate.AuraCC:Show()
            plate.AuraTop:Show()
            plate.AuraLeft:Show()

            SetContainerUnit(plate.AuraCC, data.unit)
            SetContainerUnit(plate.AuraTop, data.unit)
            SetContainerUnit(plate.AuraLeft, data.unit)
        end

        plate.AurasShowFriendlyCC = ShouldShowFriendlyCC(plate, data)
        if plate.AurasShowFriendlyCC then
            plate.AuraFriendlyCC:Show()
            SetContainerUnit(plate.AuraFriendlyCC, data.unit)
        else
            plate.AuraFriendlyCC:SetEnabled(false)
            plate.AuraFriendlyCC.mUI_unit = nil
            plate.AuraFriendlyCC:Hide()
        end

        if plate.AuraWatcher then
            plate.AuraWatcher:UnregisterAllEvents()
            plate.AuraWatcher:RegisterUnitEvent("UNIT_AURA", data.unit)
        end
    end

    local SIDE_ANCHORS = {
        LEFT = {
            point = "RIGHT",
            relativePoint = "LEFT",
            xSign = -1,
            flowAnchor = "RIGHT",
            flowDirection = AnchorUtil.FlowDirection.Left
        },
        RIGHT = {
            point = "LEFT",
            relativePoint = "RIGHT",
            xSign = 1,
            flowAnchor = "LEFT",
            flowDirection = AnchorUtil.FlowDirection.Right
        }
    }

    local function ApplySide(container, health, side, x)
        local anchor = SIDE_ANCHORS[side] or SIDE_ANCHORS.RIGHT
        container:SetFlowLayoutAnchorPoint(anchor.flowAnchor)
        container:SetFlowLayoutGrowthDirection(anchor.flowDirection, AnchorUtil.FlowDirection.Down)
        container:ClearAllPoints()
        container:SetPoint(anchor.point, health, anchor.relativePoint, x * anchor.xSign, 0)
    end

    function Auras.handler.Layout(plate)
        local health, _, frame = Core:GetHealthBar(plate)
        if not health or not plate.AuraCC then
            return
        end

        local config = Auras.db.auras

        local function ApplySize(container, size)
            container:SetScale(size / BASE_ICON_SIZE)
        end

        if not plate.AurasHidden then
            ApplySide(plate.AuraCC, health, config.cc.anchor, config.cc.x)
            plate.AuraCC:SetFlowLayoutMaximumLineSize(3 * (BASE_ICON_SIZE + ICON_GAP))
            ApplySize(plate.AuraCC, config.cc.size)

            local topAnchor = (frame and frame.name) or health
            plate.AuraTop:ClearAllPoints()
            plate.AuraTop:SetPoint("BOTTOM", topAnchor, "TOP", 0, config.top.y)
            plate.AuraTop:SetFlowLayoutMaximumLineSize(3 * (BASE_ICON_SIZE + ICON_GAP))
            ApplySize(plate.AuraTop, config.top.size)

            ApplySide(plate.AuraLeft, health, config.left.anchor, config.left.x)
            plate.AuraLeft:SetFlowLayoutMaximumLineSize(3 * (BASE_ICON_SIZE + ICON_GAP))
            ApplySize(plate.AuraLeft, config.left.size)
        end

        if plate.AurasShowFriendlyCC and plate.ClassIcon then
            local size = Auras.db.classicons.size
            plate.AuraFriendlyCC:ClearAllPoints()
            plate.AuraFriendlyCC:SetPoint("CENTER", plate.ClassIcon.texture, "CENTER", 0, 0)
            ApplySize(plate.AuraFriendlyCC, size)
        end
    end

    function Auras.handler.Remove(plate)
        for _, container in ipairs({plate.AuraCC, plate.AuraTop, plate.AuraLeft, plate.AuraFriendlyCC}) do
            if container then
                container:SetEnabled(false)
                container.mUI_unit = nil
                container:Hide()
            end
        end

        if plate.AuraWatcher then
            plate.AuraWatcher:UnregisterAllEvents()
        end
    end

    function Auras:Update()
        Core:LayoutAll()
    end
end

function Auras:OnEnable()
    Auras.db = mUI.db.profile.nameplates
    Auras.Core:Register("Auras", Auras.handler)
end

function Auras:OnDisable()
    Auras.Core:Unregister("Auras")
end
