local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

local containers = {}

local function ReanchorOverAbsorbGlow(container)
    local overAbsorbGlow = container.OverAbsorbGlow
    local texture = container.Absorb:GetStatusBarTexture()

    overAbsorbGlow:ClearAllPoints()
    overAbsorbGlow:SetPoint("TOP", texture, "TOP", 0, 0)
    overAbsorbGlow:SetPoint("BOTTOM", texture, "BOTTOM", 0, 0)
    overAbsorbGlow:SetPoint("LEFT", texture, "LEFT", -7, 0)
end

local function EnsureContainer(unitFrame, healthBar, overAbsorbGlow)
    if containers[unitFrame] then
        return containers[unitFrame]
    end

    local absorb = CreateFrame("StatusBar", nil, healthBar)
    absorb:SetAllPoints(healthBar)
    absorb:SetReverseFill(true)
    absorb:SetStatusBarTexture("Interface\\RaidFrame\\Shield-Overlay")
    -- Don't draw above the health bar
    absorb:SetFrameLevel(healthBar:GetFrameLevel())

    -- Child frames inherit the parent's strata; setting it explicitly can
    -- fail on secure frames where GetFrameStrata returns a secret value.
    absorb:SetStatusBarColor(1, 1, 1, 0.5)
    absorb:Hide()

    local texture = absorb:GetStatusBarTexture()
    texture:SetTexture("Interface\\RaidFrame\\Shield-Overlay", "REPEAT", "REPEAT")
    texture:SetHorizTile(true)
    texture:SetVertTile(true)
    -- Draw behind other artifacts such as the frame selection border
    texture:SetDrawLayer("ARTWORK", 1)

    local container = {
        UnitFrame = unitFrame,
        HealthBar = healthBar,
        Absorb = absorb,
        OverAbsorbGlow = overAbsorbGlow
    }
    containers[unitFrame] = container

    if overAbsorbGlow then
        ReanchorOverAbsorbGlow(container)
    end

    return container
end

local function Update(container, unit)
    local absorb = container.Absorb
    local healthBar = container.HealthBar
    local _, maxHealth = healthBar:GetMinMaxValues()

    -- Use calculator to get absorb amount
    UnitGetDetailedHealPrediction(unit, nil, Overshields.calculator)
    Overshields.calculator:SetDamageAbsorbClampMode(Enum.UnitDamageAbsorbClampMode.MaximumHealth)
    local absorbAmount = Overshields.calculator:GetDamageAbsorbs()

    absorb:SetMinMaxValues(0, maxHealth)
    absorb:SetValue(absorbAmount, 1)

    -- Use curve to get alpha (1 at full health, 0 below ~99%)
    local alpha = UnitHealthPercent(unit, true, Overshields.curve)
    absorb:SetAlpha(alpha)

    local glow = container.OverAbsorbGlow

    if not glow then
        absorb:Show()
        return
    end

    -- If the glow is visible then we know there is an overshield
    if glow:IsVisible() then
        absorb:Show()
    else
        absorb:Hide()
    end
end

local function GetBlizzardUnitHealthBar(unit)
    if unit == "player" then
        if PlayerFrame and PlayerFrame.healthbar then
            return PlayerFrame, PlayerFrame.healthbar, PlayerFrame.overAbsorbGlow
        end
        if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentMain and
            PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBar then
            return PlayerFrame, PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBar, PlayerFrame.overAbsorbGlow
        end
    elseif unit == "target" then
        if TargetFrame and TargetFrame.healthbar then
            return TargetFrame, TargetFrame.healthbar, TargetFrame.overAbsorbGlow
        end
        if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentMain and
            TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar then
            return TargetFrame, TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar, TargetFrame.overAbsorbGlow
        end
    elseif unit == "focus" then
        if FocusFrame and FocusFrame.healthbar then
            return FocusFrame, FocusFrame.healthbar, FocusFrame.overAbsorbGlow
        end
        if FocusFrame and FocusFrame.TargetFrameContent and FocusFrame.TargetFrameContent.TargetFrameContentMain and
            FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar then
            return FocusFrame, FocusFrame.TargetFrameContent.TargetFrameContentMain.HealthBar, FocusFrame.overAbsorbGlow
        end
    end

    return nil, nil, nil
end

local function UpdateBlizzardUnitFrame(unit)
    local unitFrame, healthBar, overAbsorbGlow = GetBlizzardUnitHealthBar(unit)

    if not unitFrame or not healthBar then
        return
    end

    local container = EnsureContainer(unitFrame, healthBar, overAbsorbGlow)
    Update(container, unit)
end

local function UpdateCompactFrame(frame)
    if not frame or frame:IsForbidden() or not frame.healthBar or not frame.unit then
        return
    end

    local unit = frame.unit

    local container = EnsureContainer(frame, frame.healthBar, frame.overAbsorbGlow)
    Update(container, unit)

    if container.OverAbsorbGlow then
        ReanchorOverAbsorbGlow(container)

        if frame.UpdateAnchors then
            if not Overshields:IsHooked(frame, "UpdateAnchors") then
                Overshields:SecureHook(frame, "UpdateAnchors", function()
                    ReanchorOverAbsorbGlow(container)
                end)
            end
        end
    end
end

function Overshields:OnInitialize()
    Overshields.calculator = CreateUnitHealPredictionCalculator()

    -- Curve that returns 1 when health is at 100%, and 0 when below
    Overshields.curve = C_CurveUtil.CreateCurve()
    Overshields.curve:SetType(Enum.LuaCurveType.Linear)
    Overshields.curve:AddPoint(0.98, 0) -- Below ~99% health, hide (alpha = 0)
    Overshields.curve:AddPoint(1, 1) -- At 100% health, show (alpha = 1)
end

function Overshields:OnEnable()
    -- Hook compact unit frames (raid/party)
    Overshields:SecureHook("CompactUnitFrame_UpdateHealPrediction", function(frame)
        UpdateCompactFrame(frame)
    end)

    Overshields:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        UpdateCompactFrame(frame)
    end)

    -- Create events frame for player/target/focus unit frames
    if not Overshields.eventsFrame then
        Overshields.eventsFrame = CreateFrame("Frame")
    end

    local eventsFrame = Overshields.eventsFrame
    eventsFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    eventsFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    eventsFrame:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player", "target", "focus")
    eventsFrame:RegisterUnitEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", "player", "target", "focus")

    eventsFrame:SetScript("OnEvent", function()
        UpdateBlizzardUnitFrame("player")
        UpdateBlizzardUnitFrame("target")
        UpdateBlizzardUnitFrame("focus")
    end)

    -- Run an initial update for the Blizzard unit frames
    UpdateBlizzardUnitFrame("player")
    UpdateBlizzardUnitFrame("target")
    UpdateBlizzardUnitFrame("focus")
end

function Overshields:OnDisable()
    Overshields:UnhookAll()

    -- Unregister events
    if Overshields.eventsFrame then
        Overshields.eventsFrame:UnregisterAllEvents()
        Overshields.eventsFrame:SetScript("OnEvent", nil)
    end

    -- Hide all absorb bars
    for _, container in pairs(containers) do
        if container.Absorb then
            container.Absorb:Hide()
        end
    end
end
