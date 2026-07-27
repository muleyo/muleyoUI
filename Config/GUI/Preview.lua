local mGUI = mUI.mGUI

local Preview = {}
mGUI.Preview = Preview

local UNITFRAMES_KEY = "mUIOptions_Unitframes_Tab"
local RAIDFRAMES_KEY = "mUIOptions_Raidframes_Tab"

local PARTY_CLASSES = {"WARRIOR", "PRIEST", "MAGE", "HUNTER", "DRUID"}
local PARTY_NAMES = {"Muleyo", "Lumen", "Arcanis", "Fenwick", "Thorn"}

local BUFF_SPELL_IDS = {33763, 774, 8936} -- Lifebloom, Rejuvenation, Regrowth
local DEBUFF_DISPELLABLE_SPELL_ID = 2818 -- Deadly Poison
local DEBUFF_CC_SPELL_ID = 408 -- Kidney Shot
local DEBUFF_REGULAR_SPELL_ID = 8921 -- Moonfire

local function GetSpellIcon(spellID, fallback)
    local texture = C_Spell and C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(spellID)
    return texture or fallback
end

local function SetMaskAtlas(mask, atlas, wrapH, wrapV)
    local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas)
    if info and info.file then
        mask:SetTexture(info.file, wrapH or "CLAMPTOBLACKADDITIVE", wrapV or "CLAMPTOBLACKADDITIVE")
        mask:SetTexCoord(info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord)
        if info.width and info.height then
            mask:SetSize(info.width, info.height)
        end
    else
        mask:SetAtlas(atlas, false)
    end
end

local AURA_BORDER_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\border.png]]
local AURA_MASK_TEX = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]]

local function CreateAuraIcon(parent)
    local f = CreateFrame("Frame", nil, parent)

    local icon = f:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f.icon = icon

    local cd = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
    cd:SetAllPoints(icon)
    cd:SetDrawBling(false)
    cd:SetDrawEdge(false)
    cd:SetSwipeTexture(AURA_MASK_TEX)
    cd:SetSwipeColor(0.2, 0.2, 0.2, 0.75)
    cd:SetHideCountdownNumbers(false)
    cd.noCooldownCount = true
    cd:SetReverse(true)
    f.cooldown = cd

    local border = f:CreateTexture(nil, "OVERLAY", nil, 7)
    border:SetTexture(AURA_BORDER_TEX)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
    border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
    f.border = border

    local mask = f:CreateMaskTexture()
    mask:SetTexture(AURA_MASK_TEX, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(icon)
    icon:AddMaskTexture(mask)

    return f
end

-- Fake but plausible elapsed/duration pairs so each mock aura shows a live,
-- already-ticking countdown (swipe + number) instead of a static full icon.
local function StartAuraTimer(auraFrame, duration, elapsed)
    auraFrame.cooldown:SetCooldown(GetTime() - elapsed, duration)
end

local function FetchStatusbar(key)
    local LSM = LibStub("LibSharedMedia-3.0")
    return LSM:Fetch("statusbar", key, true) or "Interface\\TargetingFrame\\UI-StatusBar"
end

-- ============================================================================
-- Panel
-- ============================================================================

local function GetPanel()
    if Preview.panel then
        return Preview.panel
    end

    local Gui = mUI:GetModule("mUI.Config.Gui")
    local panel = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    panel:SetPoint("TOPLEFT", Gui.frame, "TOPRIGHT", 8, 0)
    -- Tall enough to fit 5 stacked raidframe mock units (each +25px taller
    -- than the default raid frame height) without clipping the last one.
    panel:SetSize(340, 460)
    mGUI:ApplyBackdrop(panel, "bg", "border")
    mGUI:ApplyWindowArt(panel, 60)
    panel:Hide()

    local header = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    header:SetPoint("TOPLEFT", 1, -1)
    header:SetPoint("TOPRIGHT", -1, -1)
    header:SetHeight(32)
    mGUI:ApplyBackdrop(header, "bgAlt", false)

    local title = header:CreateFontString(nil, "OVERLAY")
    title:SetPoint("LEFT", 10, 0)
    mGUI:SetFont(title, 13)
    title:SetTextColor(unpack(mGUI.Colors.accent))
    title:SetText("Preview")
    panel.title = title

    local close = CreateFrame("Button", nil, header)
    close:SetPoint("RIGHT", -8, 0)
    close:SetSize(20, 20)
    close:SetNormalAtlas("RedButton-Exit")
    close:SetPushedAtlas("RedButton-exit-pressed")
    close:SetHighlightAtlas("RedButton-Highlight", "ADD")
    mGUI:TintIconButton(close)
    close:SetScript("OnClick", function()
        mGUI:FadeHide(panel)
    end)

    local content = CreateFrame("Frame", nil, panel)
    content:SetPoint("TOPLEFT", 12, -44)
    content:SetPoint("BOTTOMRIGHT", -12, 12)
    panel.content = content

    Preview.panel = panel
    return panel
end

-- ============================================================================
-- Mock frames
-- ============================================================================

local function GetPlayerMock(content)
    if Preview.playerMock then
        return Preview.playerMock
    end

    local mock = CreateFrame("Frame", nil, content)
    mock:SetPoint("TOP", content, "TOP", 0, -10)
    mock:SetSize(232, 100)

    local portrait = mock:CreateTexture(nil, "BACKGROUND", nil, 1)
    portrait:SetSize(60, 60)
    portrait:SetPoint("TOPLEFT", 24, -19)
    SetPortraitTexture(portrait, "player")
    mock.portrait = portrait

    local portraitMask = mock:CreateMaskTexture()
    SetMaskAtlas(portraitMask, "UI-HUD-UnitFrame-Player-Portrait-Mask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    portraitMask:SetSize(60, 60)
    portraitMask:SetPoint("TOPLEFT", 24, -19)
    portrait:AddMaskTexture(portraitMask)

    local health = CreateFrame("StatusBar", nil, mock)
    health:SetPoint("TOPLEFT", 85, -41)
    health:SetSize(124, 19)
    health:SetMinMaxValues(0, 100)
    health:SetValue(100)
    mock.health = health

    local power = CreateFrame("StatusBar", nil, mock)
    power:SetPoint("TOPLEFT", 85, -61)
    power:SetSize(124, 10)
    power:SetMinMaxValues(0, 100)
    power:SetValue(62)
    mock.power = power

    power:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    local powerMask = mock:CreateMaskTexture()
    powerMask:SetAtlas("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask", true)
    powerMask:SetPoint("TOPLEFT", power, "TOPLEFT", -2, 2)
    power:GetStatusBarTexture():AddMaskTexture(powerMask)

    local frameTexture = mock:CreateTexture(nil, "BACKGROUND", nil, 2)
    frameTexture:SetAtlas("UI-HUD-UnitFrame-Player-PortraitOn", true)
    frameTexture:SetPoint("CENTER")
    mock.frameTexture = frameTexture

    local reputation = mock:CreateTexture(nil, "OVERLAY")
    reputation:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Type")
    reputation:SetSize(136, 20)
    reputation:SetTexCoord(1, 0, 0, 1)
    reputation:SetPoint("TOPRIGHT", -21, -25)
    reputation:SetVertexColor(0, 0, 1)
    mock.reputation = reputation

    local name = mock:CreateFontString(nil, "OVERLAY")
    name:SetPoint("TOPLEFT", 88, -27)
    mock.name = name

    local level = mock:CreateFontString(nil, "OVERLAY")
    level:SetPoint("TOPRIGHT", -24.5, -28)
    mock.level = level

    Preview.playerMock = mock
    return mock
end

local function GetTargetMock(content)
    if Preview.targetMock then
        return Preview.targetMock
    end

    local mock = CreateFrame("Frame", nil, content)
    mock:SetPoint("TOP", content, "TOP", 0, -130)
    mock:SetSize(232, 100)

    local portrait = mock:CreateTexture(nil, "BACKGROUND", nil, 1)
    portrait:SetSize(58, 58)
    portrait:SetPoint("TOPRIGHT", -26, -19)
    SetPortraitTexture(portrait, "player")
    mock.portrait = portrait

    local portraitMask = mock:CreateMaskTexture()
    portraitMask:SetAtlas("CircleMask", false)
    portraitMask:SetAllPoints(portrait)
    portrait:AddMaskTexture(portraitMask)

    local health = CreateFrame("StatusBar", nil, mock)
    health:SetPoint("TOPLEFT", 23, -39.5)
    health:SetSize(126, 19)
    health:SetMinMaxValues(0, 100)
    health:SetValue(100)
    mock.health = health

    health:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    local healthMask = mock:CreateMaskTexture()
    healthMask:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Bar-Health-Mask", true)
    healthMask:SetPoint("TOPLEFT", health, "TOPLEFT", -1, 6)
    health:GetStatusBarTexture():AddMaskTexture(healthMask)

    local power = CreateFrame("StatusBar", nil, mock)
    power:SetPoint("TOPLEFT", health, "BOTTOMLEFT", -0.9, -2.5)
    power:SetSize(134, 10)
    power:SetMinMaxValues(0, 100)
    power:SetValue(70)
    mock.power = power

    power:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
    local powerMask = mock:CreateMaskTexture()
    powerMask:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Bar-Mana-Mask", true)
    powerMask:SetPoint("TOPLEFT", power, "TOPLEFT", -61, 3)
    power:GetStatusBarTexture():AddMaskTexture(powerMask)

    local frameTexture = mock:CreateTexture(nil, "BACKGROUND", nil, 2)
    frameTexture:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn", true)
    frameTexture:SetPoint("CENTER")
    mock.frameTexture = frameTexture

    local reputation = mock:CreateTexture(nil, "ARTWORK")
    reputation:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Type", true)
    reputation:SetPoint("TOPRIGHT", -75, -25)
    mock.reputation = reputation

    local name = mock:CreateFontString(nil, "OVERLAY")
    name:SetPoint("TOPLEFT", 51, -26)
    mock.name = name

    local level = mock:CreateFontString(nil, "OVERLAY")
    level:SetPoint("TOPLEFT", 24, -27)
    mock.level = level

    Preview.targetMock = mock
    return mock
end

local function GetPartyMock(content)
    if Preview.partyMock then
        return Preview.partyMock
    end

    local mock = CreateFrame("Frame", nil, content)
    mock:SetPoint("TOP", content, "TOP", 0, -10)
    mock:SetSize(150, 5 * 62)
    mock.units = {}

    for i = 1, 5 do
        local unit = CreateFrame("Frame", nil, mock, "BackdropTemplate")
        unit:SetPoint("TOP", mock, "TOP", 0, -(i - 1) * 62)
        unit:SetSize(150, 58)
        mGUI:ApplyBackdrop(unit, "bgAlt", "border")

        local health = CreateFrame("StatusBar", nil, unit)
        health:SetPoint("TOPLEFT", 2, -2)
        health:SetPoint("TOPRIGHT", -2, -2)
        health:SetPoint("BOTTOMLEFT", 2, 6)
        health:SetMinMaxValues(0, 100)
        health:SetValue(100 - (i - 1) * 12)
        unit.health = health

        local power = CreateFrame("StatusBar", nil, unit)
        power:SetPoint("BOTTOMLEFT", 2, 2)
        power:SetPoint("BOTTOMRIGHT", -2, 2)
        power:SetHeight(4)
        power:SetMinMaxValues(0, 100)
        power:SetValue(100)
        unit.power = power

        local name = health:CreateFontString(nil, "OVERLAY")
        name:SetPoint("TOPLEFT", 4, -2)
        unit.name = name

        local roleIcon = health:CreateTexture(nil, "OVERLAY")
        roleIcon:SetSize(12, 12)
        roleIcon:SetPoint("TOPLEFT", 2, -2)
        local roleAtlases = {"roleicon-tiny-tank", "roleicon-tiny-healer", "roleicon-tiny-dps", "roleicon-tiny-dps", "roleicon-tiny-dps"}
        roleIcon:SetAtlas(roleAtlases[i], true)
        unit.roleIcon = roleIcon

        local statusText = health:CreateFontString(nil, "OVERLAY")
        statusText:SetPoint("CENTER", 0, -2)
        unit.statusText = statusText

        local auraOverlay = CreateFrame("Frame", nil, unit)
        auraOverlay:SetAllPoints(unit)
        auraOverlay:SetFrameLevel(unit:GetFrameLevel() + 60)
        auraOverlay:SetFrameStrata("TOOLTIP")
        unit.auraOverlay = auraOverlay

        unit.buffIcons = {}
        local buffDurations = {15, 15, 21} -- Lifebloom, Rejuvenation, Regrowth
        local buffElapsed = {4, 9, 2}
        for j, spellID in ipairs(BUFF_SPELL_IDS) do
            local icon = CreateAuraIcon(auraOverlay)
            icon.icon:SetTexture(GetSpellIcon(spellID, 136224))
            StartAuraTimer(icon, buffDurations[j], buffElapsed[j])
            icon:Hide()
            unit.buffIcons[j] = icon
        end

        unit.debuffBig = CreateAuraIcon(auraOverlay)
        unit.debuffBig.icon:SetTexture(GetSpellIcon(DEBUFF_CC_SPELL_ID, 132298))
        unit.debuffBig.border:SetVertexColor(0.9, 0.1, 0.1) -- none/physical (boss)
        StartAuraTimer(unit.debuffBig, 12, 5)
        unit.debuffBig:Hide()

        unit.debuffMagic = CreateAuraIcon(auraOverlay)
        unit.debuffMagic.icon:SetTexture(GetSpellIcon(DEBUFF_DISPELLABLE_SPELL_ID, 136137))
        unit.debuffMagic.border:SetVertexColor(0.2, 0.6, 1.0) -- Magic (dispellable)
        StartAuraTimer(unit.debuffMagic, 16, 7)
        unit.debuffMagic:Hide()

        unit.debuffNone = CreateAuraIcon(auraOverlay)
        unit.debuffNone.icon:SetTexture(GetSpellIcon(DEBUFF_REGULAR_SPELL_ID, 136121))
        unit.debuffNone.border:SetVertexColor(0.9, 0.1, 0.1) -- none/physical
        StartAuraTimer(unit.debuffNone, 16, 3)
        unit.debuffNone:Hide()
        unit.debuffIcons = {unit.debuffBig, unit.debuffMagic, unit.debuffNone}

        local defensiveIcon = CreateAuraIcon(auraOverlay)
        defensiveIcon.icon:SetTexture(135936) -- Spell_Holy_PainSuppression
        StartAuraTimer(defensiveIcon, 8, 1)
        defensiveIcon:Hide()
        unit.defensiveIcon = defensiveIcon

        mock.units[i] = unit
    end

    Preview.partyMock = mock
    return mock
end

-- ============================================================================
-- Applying current settings to the mocks
-- ============================================================================

local function StyleFont(fontString, size)
    mGUI:SetFont(fontString, size or 11)
end

function Preview:UpdatePlayer()
    local db = mUI.db.profile.unitframes
    local mock = GetPlayerMock(self.panel.content)
    local texture = FetchStatusbar(db.textures.unitframes)

    mock.health:SetStatusBarTexture(texture)
    mock.power:SetStatusBarTexture(texture)

    mock.frameTexture:SetDesaturated(true)
    mock.frameTexture:SetVertexColor(unpack(mUI:Color(0.15)))

    local _, playerClass = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[playerClass or "WARRIOR"]

    if db.color then
        mock.health:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
    else
        mock.health:SetStatusBarColor(0, 0.8, 0.1)
    end
    mock.power:SetStatusBarColor(0.1, 0.4, 0.9)

    StyleFont(mock.name, 11)
    mock.name:SetText(UnitName("player"))
    StyleFont(mock.level, 10)
    mock.level:SetText(UnitLevel("player"))
    mock.name:SetShown(not db.name)
    mock.level:SetShown(not db.level)
    mock.reputation:SetShown(db.playerrepcolor)
    if db.color then
        mock.reputation:SetVertexColor(classColor.r, classColor.g, classColor.b)
    else
        mock.reputation:SetVertexColor(0, 0, 1)
    end
end

function Preview:UpdateTarget()
    local db = mUI.db.profile.unitframes
    local mock = GetTargetMock(self.panel.content)
    local texture = FetchStatusbar(db.textures.unitframes)

    mock.health:SetStatusBarTexture(texture)
    mock.power:SetStatusBarTexture(texture)

    mock.frameTexture:SetDesaturated(true)
    mock.frameTexture:SetVertexColor(unpack(mUI:Color(0.15)))

    if db.color then
        mock.health:SetStatusBarColor(0.85, 0.1, 0.1)
    else
        mock.health:SetStatusBarColor(0, 0.8, 0.1)
    end
    mock.power:SetStatusBarColor(0.1, 0.4, 0.9)

    StyleFont(mock.name, 11)
    mock.name:SetText("Training Dummy")
    StyleFont(mock.level, 10)
    mock.level:SetText(90)
    mock.name:SetShown(not db.name)
    mock.level:SetShown(not db.level)
    mock.reputation:SetVertexColor(0.85, 0.1, 0.1)
    mock.reputation:SetShown(not db.reputationcolor)
end

function Preview:UpdateParty()
    local db = mUI.db.profile.unitframes
    local rf = db.raidframes
    local mock = GetPartyMock(self.panel.content)
    local texture = FetchStatusbar(db.textures.raidframes)

    -- Custom raidframe size option
    local width = rf.size.enabled and rf.size.width or 100
    local height = rf.size.enabled and rf.size.height or 58
    -- +25px so each mock unit reads more clearly in the preview panel
    local unitHeight = height * 0.8 + 25

    local activeSection = mGUI.Renderer.activeSection and mGUI.Renderer.activeSection[RAIDFRAMES_KEY]
    local auraDisplay = rf.auraDisplay or select(4, GetBuildInfo()) >= 120100
    local showAuras = auraDisplay and activeSection == "Auras"

    local buffSize = math.floor(unitHeight * (rf.buffsize or 33) / 100 + 0.5)
    local debuffSize = math.floor(unitHeight * (rf.debuffsize or 55) / 100 + 0.5)
    local defensiveSize = math.floor(unitHeight * (rf.centerDefensiveSize or 60) / 100 + 0.5)
    local dispelScale = rf.dispelScale or 1.3
    local defensivePoint = rf.centerDefensivePoint or "CENTER"
    if defensivePoint ~= "CENTER" and defensivePoint ~= "LEFT" and defensivePoint ~= "RIGHT" then
        defensivePoint = "CENTER"
    end

    for i, unit in ipairs(mock.units) do
        unit:SetSize(width * 1.5, unitHeight)
        unit:SetPoint("TOP", mock, "TOP", 0, -(i - 1) * (unitHeight + 4))
        unit.health:SetStatusBarTexture(texture)
        unit.power:SetStatusBarTexture(texture)
        unit.power:SetStatusBarColor(0.1, 0.4, 0.9)

        local classColor = RAID_CLASS_COLORS[PARTY_CLASSES[i]]
        unit.health:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

        -- "Hide Role Icons" option
        unit.roleIcon:SetShown(not rf.roleicons)

        StyleFont(unit.name, 11)
        unit.name:SetText(PARTY_NAMES[i])
        unit.name:ClearAllPoints()
        if rf.partyNameCentered then
            unit.name:SetPoint("TOP", unit.health, "TOP", 0, -2)
        else
            -- Leave room for the role icon so the name doesn't overlap it
            unit.name:SetPoint("TOPLEFT", unit.health, "TOPLEFT", rf.roleicons and 4 or 16, -2)
        end
        -- "Classcolor Names" option - separate from the statusText color mode below
        if rf.names then
            unit.name:SetTextColor(classColor.r, classColor.g, classColor.b)
        else
            unit.name:SetTextColor(1, 1, 1)
        end
        unit.name:SetShown(not rf.hidenames)

        -- "Party StatusText Color" option (default/class/custom)
        StyleFont(unit.statusText, 11)
        unit.statusText:SetText((100 - (i - 1) * 12) .. "%")
        local statusMode = rf.partyStatusColorMode or "default"
        if statusMode == "class" then
            unit.statusText:SetTextColor(classColor.r, classColor.g, classColor.b)
        elseif statusMode == "custom" then
            local c = rf.partyStatusCustomColor or {1, 0.82, 0, 1}
            unit.statusText:SetTextColor(c[1] or 1, c[2] or 0.82, c[3] or 0)
        else
            unit.statusText:SetTextColor(1, 0.82, 0)
        end

        for j, icon in ipairs(unit.buffIcons) do
            icon:SetShown(showAuras)
            if showAuras then
                icon:SetSize(buffSize, buffSize)
                icon:ClearAllPoints()
                if j == 1 then
                    icon:SetPoint("BOTTOMRIGHT", unit.power, "TOPRIGHT", -2, 1)
                else
                    icon:SetPoint("BOTTOMRIGHT", unit.buffIcons[j - 1], "BOTTOMLEFT", -1, 0)
                end
                icon.border:SetVertexColor(unpack(mUI:Color(0.15)))
            end
        end

        -- Debuffs (bottom-left of the power bar, growing right). The first is the
        -- enlarged boss/role debuff ("Big Debuff Size"); the rest are normal size.
        local debuffSizes = {math.floor(debuffSize * dispelScale + 0.5), debuffSize, debuffSize}
        for j, icon in ipairs(unit.debuffIcons) do
            icon:SetShown(showAuras)
            if showAuras then
                local size = debuffSizes[j]
                icon:SetSize(size, size)
                icon:ClearAllPoints()
                if j == 1 then
                    icon:SetPoint("BOTTOMLEFT", unit.power, "TOPLEFT", 2, 1)
                else
                    icon:SetPoint("BOTTOMLEFT", unit.debuffIcons[j - 1], "BOTTOMRIGHT", 1, 0)
                end
            end
        end

        -- Defensive icon (anchored per the "Defensive Anchor"/X/Y options),
        -- border tinted with the same theme color as buffs/frame borders.
        unit.defensiveIcon:SetShown(showAuras)
        if showAuras then
            unit.defensiveIcon:SetSize(defensiveSize, defensiveSize)
            unit.defensiveIcon:ClearAllPoints()
            unit.defensiveIcon:SetPoint(defensivePoint, unit, defensivePoint, rf.centerDefensiveX or 0, rf.centerDefensiveY or 0)
            unit.defensiveIcon.border:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end

    mock:SetSize(width * 1.5, 5 * (unitHeight + 4))
end

-- ============================================================================
-- Mode switching + wiring
-- ============================================================================

function Preview:SetMode(mode)
    if not self.panel or not self.panel:IsShown() then
        self.mode = mode
        return
    end
    self.mode = mode

    if self.playerMock then
        self.playerMock:Hide()
    end
    if self.targetMock then
        self.targetMock:Hide()
    end
    if self.partyMock then
        self.partyMock:Hide()
    end

    if mode == "raid" then
        self.panel.title:SetText("Preview — Raidframes")
        GetPartyMock(self.panel.content):Show()
        self:UpdateParty()
    else
        self.panel.title:SetText("Preview — Unitframes")
        GetPlayerMock(self.panel.content):Show()
        GetTargetMock(self.panel.content):Show()
        self:UpdatePlayer()
        self:UpdateTarget()
    end
end

function Preview:Toggle()
    local panel = GetPanel()
    if panel:IsShown() then
        mGUI:FadeHide(panel)
        return
    end
    mGUI:FadeShow(panel)
    self:UpdateModeFromCategory()
end

function Preview:UpdateModeFromCategory()
    self:SetMode(mGUI.Renderer.currentKey == RAIDFRAMES_KEY and "raid" or "player")
end

-- Called by the Renderer after every category render/refresh
function Preview:OnCategoryChanged(key)
    if not self.panel or not self.panel:IsShown() then
        return
    end
    if key ~= UNITFRAMES_KEY and key ~= RAIDFRAMES_KEY then
        mGUI:FadeHide(self.panel)
        return
    end
    -- A setting changed or the page re-rendered: re-apply to the visible
    -- mock(s) - SetMode already calls the right Update* function(s).
    self:UpdateModeFromCategory()
end
