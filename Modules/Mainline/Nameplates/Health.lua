local Health = mUI:NewModule("mUI.Modules.Nameplates.Health", "AceEvent-3.0", "AceHook-3.0")

function Health:OnInitialize()
    -- Load Database
    Health.db = mUI.db.profile.nameplates

    Health.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")
    Health.LSM = LibStub("LibSharedMedia-3.0")

    local Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    local Units = Health.Units

    local function DisplayName(data)
        if data.isPlayer and data.isEnemy then
            local config = Health.db.names

            local arena = config.arena and Units:GetArenaIndex(data)

            local info = config.spec and Units:GetSpecInfo(Units:GetSpecID(data))
            local spec = info and info.name

            if spec and arena then
                return spec .. " " .. arena, true
            elseif spec then
                return spec, true
            elseif arena then
                return tostring(arena), true
            end
        end

        return data.displayName, false
    end

    local function HideFriendlyBar(data)
        return data.isFriend and data.isPlayer and not data.canAttack and Health.db.friendly.hidehealthbar
    end

    Health.HideFriendlyBar = HideFriendlyBar

    local instanceLevel = UnitEffectiveLevel("player")
    local lieutenantLevel
    local inRelevantInstance = false

    local function RefreshInstanceInfo()
        local _, instanceType, _, _, _, _, _, _, _, lfgDungeonID = GetInstanceInfo()

        inRelevantInstance = instanceType == "party" or instanceType == "raid"
        lieutenantLevel = nil

        if lfgDungeonID then
            instanceLevel = GetMaxLevelForExpansionLevel(GetMaximumExpansionLevel())
        else
            instanceLevel = UnitEffectiveLevel("player")
        end
    end

    local function HasMana(unit)
        if UnitHasPowerType then
            return UnitHasPowerType(unit, Enum.PowerType.Mana)
        end
        return UnitPowerType(unit) == Enum.PowerType.Mana
    end

    local function NpcType(unit)
        local classification = UnitClassification(unit)

        if classification == "elite" then
            local level = UnitEffectiveLevel(unit)

            if level == instanceLevel + 1 or UnitIsLieutenant(unit) then
                -- Remember what a lieutenant weighs here: the boss test keys
                -- off being one level above it.
                lieutenantLevel = level
                return "miniboss"
            end

            if level == -1 or level == instanceLevel + 2 or (lieutenantLevel and level == lieutenantLevel + 1) then
                return "boss"
            end

            return HasMana(unit) and "caster" or "melee"
        end

        if classification == "normal" or classification == "trivial" or classification == "minus" then
            if Health.db.classification.casteralways and HasMana(unit) then
                return "caster"
            end
            return "trivial"
        end

        return nil
    end

    Health.RefreshInstanceInfo = RefreshInstanceInfo

    local FOCUS_TEXTURE = [[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]]
    local CLASSIC_TEXTURE = [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]]
    local cachedTexture = CLASSIC_TEXTURE

    local function BarTexture(data)
        if data and data.isFocus and Health.db.focus then
            return FOCUS_TEXTURE
        end

        return cachedTexture
    end

    local Totem

    local function BarColor(data)
        if Totem == nil then
            Totem = mUI:GetModule("mUI.Modules.Nameplates.Totem", true) or false
        end

        local override = Totem and Totem.GetBarColor and Totem:GetBarColor(data)
        if override then
            return override[1], override[2], override[3]
        end

        -- Tapped by another player/group: grey out instead of applying our own
        -- reaction/class/NPC-type coloring, matching Blizzard's default behavior.
        if data.isTapDenied then
            return 0.9, 0.9, 0.9
        end

        local npc = Health.db.classification
        if npc.enabled and not data.isPlayer and (inRelevantInstance or not npc.instancesonly) then
            local npcType = NpcType(data.unit)
            local color = npcType and npc[npcType]
            if color then
                return color[1], color[2], color[3]
            end
        end

        local classcolor = data.isFriend and Health.db.friendly.classcolor or (not data.isFriend and Health.db.classcolor)

        local classFile = data.isPlayer and classcolor and Units:GetClassFile(data)
        if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
                return color.r, color.g, color.b
            end
        end

        if data.isFriend and data.isPlayer then
            return 0.65, 0.65, 1
        elseif data.isFriend and not data.isPlayer then
            return 0.2, 0.8, 0.2
        elseif data.isNeutral then
            return 0.9, 0.8, 0.2
        end

        return 0.8, 0.2, 0.2
    end

    local function IsNamePlate(frame)
        if issecretvalue(frame) then
            return false
        end

        local unit = frame.unit
        return unit ~= nil and strfind(unit, "nameplate", 1, true) == 1 and not frame:IsForbidden()
    end

    local function GetInfo(frame, unit)
        return Core:GetUnitData(unit, frame:GetParent())
    end

    local healthFormat = "%.0f%%"
    local edgeR, edgeG, edgeB, edgeA = 0, 0, 0, 1

    local function RefreshCachedStyle()
        healthFormat = "%." .. (Health.db.decimals or 0) .. "f%%"

        cachedTexture = CLASSIC_TEXTURE
        local textureName = Health.db.texture
        if textureName and textureName ~= "None" then
            cachedTexture = Health.LSM:Fetch("statusbar", textureName, true) or CLASSIC_TEXTURE
        end

        local color = mUI:Color(0.15)
        if color then
            edgeR, edgeG, edgeB, edgeA = color[1], color[2], color[3], color[4]
        end
    end

    Health.RefreshCachedStyle = RefreshCachedStyle

    local function SuppressBlizzardBar(frame)
        local container = frame.HealthBarsContainer
        local bar = container and container.healthBar
        if not bar then
            return
        end

        if bar.bgTexture then
            bar.bgTexture:SetAlpha(0)
        end
        if bar.selectedBorder then
            bar.selectedBorder:SetAlpha(0)
        end
        if bar.deselectedOverlay then
            bar.deselectedOverlay:SetAlpha(0)
        end
        if bar.MaskTexture then
            bar.MaskTexture:Hide()
        end
    end

    local function EnsureChrome(frame)
        local container = frame.HealthBarsContainer
        if not container then
            return
        end

        if not container.mUIBackground then
            local background = container:CreateTexture(nil, "BACKGROUND")
            background:SetAllPoints(container)
            background:SetColorTexture(0, 0, 0, 0.7)
            container.mUIBackground = background
        end

        if not container.mUIBorder then
            container.mUIBorder = Core:CreateBorder(container, container)
        end

        return container.mUIBackground, container.mUIBorder
    end

    local BOTTOM_POS = 3
    local HP_CAST_BUFFER = 2

    local function BarWidth(frame)
        local friendly = Health.db.friendly
        if friendly.small then
            local reaction = UnitReaction(frame.unit, "player")
            if reaction ~= nil and reaction >= 5 then
                return friendly.width
            end
        end
        return Health.db.size.healthwidth
    end

    local function ApplyBarLayout(frame)
        if not Health:IsEnabled() or not frame or frame:IsForbidden() or not frame.unit then
            return
        end

        local healthContainer = frame.HealthBarsContainer
        local castContainer = frame.CastBarsContainer
        local healthBar = healthContainer and healthContainer.healthBar
        local castBar = castContainer and castContainer.castBar
        if not healthBar or not castBar then
            return
        end

        healthBar:ClearAllPoints()
        healthBar:SetPoint("TOPLEFT", healthContainer, "TOPLEFT", 0, 0)
        healthBar:SetPoint("BOTTOMRIGHT", healthContainer, "BOTTOMRIGHT", 0, 0)

        castBar:ClearAllPoints()
        castBar:SetPoint("BOTTOMLEFT", castContainer, "BOTTOMLEFT", 0, 0)
        castBar:SetPoint("BOTTOMRIGHT", castContainer, "BOTTOMRIGHT", 0, 0)

        local castHeight = Health.db.size.castheight or 10
        castContainer:SetHeight(castHeight)
        castBar:SetHeight(castHeight)

        healthContainer:SetHeight(Health.db.size.healthheight or 16)

        local widthToUse = BarWidth(frame) / 2
        local hpBotPos = castHeight + BOTTOM_POS + HP_CAST_BUFFER

        castContainer:ClearAllPoints()
        castContainer:SetPoint("BOTTOMLEFT", frame, "BOTTOM", -widthToUse, BOTTOM_POS)
        castContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", widthToUse, BOTTOM_POS)

        healthContainer:ClearAllPoints()
        healthContainer:SetPoint("BOTTOMLEFT", frame, "BOTTOM", -widthToUse, hpBotPos)
        healthContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", widthToUse, hpBotPos)
    end

    local NAME_SPACING = 4
    -- Independent from the Name Text Size setting, so changing one doesn't
    -- resize the other.
    local HEALTH_TEXT_SIZE = 12

    local function WithSlug(flags)
        if not flags or flags == "" then
            return "SLUG"
        end
        if not flags:find("SLUG") then
            return flags .. ", SLUG"
        end
        return flags
    end

    local function ApplyNamePlateFontObjects()
        local path = mUI.db.profile.general.fontpath
        if not path then
            return
        end

        local size = Health.db.name.size
        local flags = WithSlug("OUTLINE")

        local objects = {{SystemFont_NamePlate, size}, {SystemFont_NamePlate_Outlined, size}, {SystemFont_NamePlateFixed, size},
                         {SystemFont_LargeNamePlate, size + 1}, {SystemFont_LargeNamePlateFixed, size + 1}}

        for i = 1, #objects do
            local object, height = objects[i][1], objects[i][2]
            if object then
                object:SetFont(path, height + 1, flags)
                object:SetFont(path, height, flags)
            end
        end
    end

    ApplyNamePlateFontObjects()

    local function ApplyNamePosition(frame)
        if not Health:IsEnabled() or not frame then
            return
        end

        local name = frame.name
        local container = frame.HealthBarsContainer
        if not name or not container then
            return
        end

        name:ClearAllPoints()
        name:SetJustifyH("CENTER")
        name:SetPoint("BOTTOM", container, "TOP", 0, NAME_SPACING)

        name:SetTextHeight(Health.db.name.size)
        name:SetWidth(0)
        name:SetHeight(0)
    end

    local HEALTH_TEXT_ANCHORS = {
        LEFT = {"LEFT", "LEFT", 1, 1},
        CENTER = {"CENTER", "CENTER", 1, 1},
        RIGHT = {"RIGHT", "RIGHT", -1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    local function EnsureHealthText(bar)
        if not bar.mUIHealthText then
            local text = bar:CreateFontString(nil, "OVERLAY")
            bar.mUIHealthText = text
        end

        return bar.mUIHealthText
    end

    local function UpdateHealthText(frame)
        if not Health:IsEnabled() or not Health.db.health.percent or not UnitHealthPercent then
            return
        end
        if not IsNamePlate(frame) then
            return
        end

        local container = frame.HealthBarsContainer
        local bar = container and container.healthBar
        if not bar or not bar.mUIHealthText then
            return
        end

        bar.mUIHealthText:SetFormattedText(healthFormat, UnitHealthPercent(frame.unit, true, CurveConstants.ScaleTo100))
    end

    -- Blizzard's own health text (frame.statusText) would otherwise overlap
    -- ours whenever the nameplate's healthText option shows a percentage too.
    local function OnStatusTextUpdate(frame)
        if not Health:IsEnabled() or not Health.db.health.percent then
            return
        end
        if not IsNamePlate(frame) or not frame.statusText then
            return
        end

        frame.statusText:Hide()
    end

    local function ApplyHealthText(frame)
        local container = frame.HealthBarsContainer
        local bar = container and container.healthBar
        if not bar then
            return
        end

        local config = Health.db.health
        local text = EnsureHealthText(bar)

        if not config.percent then
            text:Hide()
            return
        end

        local anchor = HEALTH_TEXT_ANCHORS[config.anchor] or HEALTH_TEXT_ANCHORS.RIGHT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        text:ClearAllPoints()
        text:SetPoint(point, bar, relativePoint, config.x * xSign, config.y * ySign)

        local path = mUI.db.profile.general.fontpath
        local size = HEALTH_TEXT_SIZE
        if path and (text.mUIFontPath ~= path or text.mUIFontSize ~= size) then
            text.mUIFontPath, text.mUIFontSize = path, size
            text:SetFont(path, size, WithSlug("OUTLINE"))
        end

        text:Show()
        UpdateHealthText(frame)
    end

    local function ApplyLayout(frame)
        if not Health:IsEnabled() or not frame then
            return
        end
        if not frame.unit or frame:IsForbidden() then
            return
        end

        local container = frame.HealthBarsContainer
        local bar = container and container.healthBar
        if bar then
            bar.mUITexture = nil
        end
        if container and container.mUIBorder then
            container.mUIBorder:Invalidate()
        end

        SuppressBlizzardBar(frame)
        ApplyBarLayout(frame)
        ApplyNamePosition(frame)
        ApplyHealthText(frame)
    end

    local function OnHealthColorUpdate(frame)
        if not Health:IsEnabled() or not IsNamePlate(frame) then
            return
        end

        local container = frame.HealthBarsContainer
        local bar = container and container.healthBar
        if not bar then
            return
        end

        local data = GetInfo(frame, frame.unit)

        local hideBar = HideFriendlyBar(data)
        bar:SetShown(not hideBar)

        local texture = BarTexture(data)
        if bar.mUITexture ~= texture then
            bar.mUITexture = texture
            bar:SetStatusBarTexture(texture)
        end

        bar:SetStatusBarColor(BarColor(data))

        local background, border = EnsureChrome(frame)
        if not background or not border then
            return
        end

        local shown = not hideBar
        background:SetShown(shown)
        border:SetShown(shown)

        if shown then
            border:SetThickness(Health.db.border.size or 1)

            if data.isTarget then
                border:SetBorderColor(1, 1, 1, 1)
            else
                border:SetBorderColor(edgeR, edgeG, edgeB, edgeA)
            end
        end
    end

    local function OnNameUpdate(frame)
        if not Health:IsEnabled() or not IsNamePlate(frame) then
            return
        end

        local name = frame.name
        if not name then
            return
        end

        local data = GetInfo(frame, frame.unit)
        local hideBar = HideFriendlyBar(data)

        local label, replaced = DisplayName(data)
        name:SetText(label)

        -- Players only
        name:SetShown(not (hideBar or (data.isFriend and data.isPlayer and Health.db.friendly.hidenames)))

        local classcolor = replaced or (data.isFriend and Health.db.friendly.classcolor or (not data.isFriend and Health.db.classcolor))

        local classFile = Units:GetClassFile(data)
        local color = classFile and C_ClassColor.GetClassColor(classFile)

        if data.isPlayer and color and classcolor then
            name:SetTextColor(color.r, color.g, color.b)
        else
            name:SetTextColor(1, 1, 1)
        end
    end

    if not Health:IsHooked("CompactUnitFrame_UpdateHealthColor") then
        Health:SecureHook("CompactUnitFrame_UpdateHealthColor", OnHealthColorUpdate)
    end

    if not Health:IsHooked("CompactUnitFrame_UpdateName") then
        Health:SecureHook("CompactUnitFrame_UpdateName", OnNameUpdate)
    end

    if not Health:IsHooked("CompactUnitFrame_UpdateHealth") then
        Health:SecureHook("CompactUnitFrame_UpdateHealth", UpdateHealthText)
    end

    if not Health:IsHooked("CompactUnitFrame_UpdateStatusText") then
        Health:SecureHook("CompactUnitFrame_UpdateStatusText", OnStatusTextUpdate)
    end

    if not Health:IsHooked(NamePlateUnitFrameMixin, "UpdateAnchors") then
        Health:SecureHook(NamePlateUnitFrameMixin, "UpdateAnchors", function(unitFrame)
            ApplyLayout(unitFrame)
            OnHealthColorUpdate(unitFrame)
            OnNameUpdate(unitFrame)
        end)
    end

    if not Health:IsHooked(NamePlateUnitFrameMixin, "ApplyFrameOptions") then
        Health:SecureHook(NamePlateUnitFrameMixin, "ApplyFrameOptions", function(unitFrame)
            OnNameUpdate(unitFrame)
        end)
    end

    if not Health:IsHooked(NamePlateUnitFrameMixin, "OnUnitFactionChanged") then
        Health:SecureHook(NamePlateUnitFrameMixin, "OnUnitFactionChanged", ApplyLayout)
    end

    if NamePlateClassificationFrameMixin and not Health:IsHooked(NamePlateClassificationFrameMixin, "UpdateClassificationIndicator") then
        Health:SecureHook(NamePlateClassificationFrameMixin, "UpdateClassificationIndicator", function(classificationFrame)
            if not Health.db.classification.enabled then
                return
            end

            if issecretvalue(classificationFrame) or classificationFrame:IsForbidden() then
                return
            end

            OnHealthColorUpdate(classificationFrame:GetParent())
        end)
    end

    local function RefreshFrame(frame)
        if frame and frame.unit then
            OnHealthColorUpdate(frame)
            OnNameUpdate(frame)
            ApplyLayout(frame)
        end
    end

    local activeFrames = {}
    local unitToFrame = {}

    local plateWatcher = CreateFrame("Frame")
    plateWatcher:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    plateWatcher:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    plateWatcher:SetScript("OnEvent", function(_, event, unit)
        if event == "NAME_PLATE_UNIT_ADDED" then
            local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
            local frame = namePlate and namePlate.UnitFrame
            if frame then
                unitToFrame[unit] = frame
                activeFrames[frame] = true
                ApplyLayout(frame)
            end
        else
            local frame = unitToFrame[unit]
            if frame then
                activeFrames[frame] = nil
                unitToFrame[unit] = nil
            end
        end
    end)

    local previousFocusFrame

    local focusWatcher = CreateFrame("Frame")
    focusWatcher:RegisterEvent("PLAYER_FOCUS_CHANGED")
    focusWatcher:SetScript("OnEvent", function()
        RefreshFrame(previousFocusFrame)

        local namePlate = C_NamePlate.GetNamePlateForUnit("focus", false)
        local frame = namePlate and namePlate.UnitFrame
        RefreshFrame(frame)
        previousFocusFrame = frame
    end)

    function Health:Update()
        RefreshCachedStyle()
        ApplyNamePlateFontObjects()
        for frame in pairs(activeFrames) do
            RefreshFrame(frame)
        end
    end
end

function Health:OnEnable()
    Health.db = mUI.db.profile.nameplates
    Health:RefreshCachedStyle()
    Health:RegisterEvent("PLAYER_ENTERING_WORLD", "RefreshInstanceInfo")
    Health:RegisterEvent("ZONE_CHANGED_NEW_AREA", "RefreshInstanceInfo")
    Health:RefreshInstanceInfo()
end

function Health:OnDisable()
    Health:UnregisterEvent("PLAYER_ENTERING_WORLD")
    Health:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
end
