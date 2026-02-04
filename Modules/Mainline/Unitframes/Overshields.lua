local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

function Overshields:OnInitialize()
    Overshields.calculator = CreateUnitHealPredictionCalculator()

    -- Curve that returns 1 when health is below 100%, and 0 when at 100%
    -- X is health percentage (0-1), Y is the alpha value
    Overshields.curve = C_CurveUtil.CreateCurve()
    Overshields.curve:SetType(Enum.LuaCurveType.Linear)
    Overshields.curve:AddPoint(0, 0) -- At 0% health, show (alpha = 1)
    Overshields.curve:AddPoint(0.98, 0) -- At 99% health, show (alpha = 1)
    Overshields.curve:AddPoint(1, 1) -- At 100% health, hide (alpha = 0)

    function Overshields:CreateAbsorbBar(frame)
        if frame.mUIAbsorbBar then
            return frame.mUIAbsorbBar
        end

        -- Create a real StatusBar - it can handle secret values internally
        local absorbBar = CreateFrame("StatusBar", nil, frame)
        local texture = absorbBar:CreateTexture(nil, "BORDER")
        texture:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
        texture:SetAllPoints()
        absorbBar:SetStatusBarTexture(texture)
        absorbBar:GetStatusBarTexture():SetHorizTile(true)
        absorbBar:GetStatusBarTexture():SetVertTile(true)
        absorbBar:SetStatusBarColor(1, 1, 1, 1)

        frame.mUIAbsorbBar = absorbBar

        return absorbBar
    end

    function Overshields:Update(frame)
        if not frame or frame:IsForbidden() then
            return
        end

        if not frame:GetName() or not frame.displayedUnit then
            return
        end

        local name = frame:GetName()
        if not name:match("^Compact") then
            return
        end

        local unit = frame.unit
        local healthBar = frame.healthBar

        if not healthBar or not UnitExists(unit) then
            return
        end

        -- Create absorb bar if needed
        local absorbBar = Overshields:CreateAbsorbBar(frame)

        -- Hide the default overabsorb glow
        if frame.overAbsorbGlow then
            frame.overAbsorbGlow:Hide()
        end

        -- Get health max value for the bar scale
        local _, maxHealth = healthBar:GetMinMaxValues()

        -- Use UnitGetDetailedHealPrediction to populate the calculator
        UnitGetDetailedHealPrediction(unit, nil, Overshields.calculator)

        -- Get absorb amount from the calculator
        Overshields.calculator:SetDamageAbsorbClampMode(Enum.UnitDamageAbsorbClampMode.MaximumHealth)
        local absorbAmount = Overshields.calculator:GetDamageAbsorbs()

        -- Use curve to get alpha value (1 if health < 100%, 0 if health = 100%)
        local alpha = UnitHealthPercent(unit, true, Overshields.curve)

        -- Configure the StatusBar - it handles secret values internally
        absorbBar:SetOrientation("HORIZONTAL")
        absorbBar:SetReverseFill(true) -- Fill from right to left
        absorbBar:SetMinMaxValues(0, maxHealth) -- Pass secret value directly, no arithmetic!
        absorbBar:SetValue(absorbAmount, 1) -- Pass absorb amount directly
        absorbBar:SetAlpha(alpha) -- Hide when at 100% health

        -- Anchor the LEFT side to the RIGHT edge of health, so it grows rightward
        local defaultWidth = 72
        local frameWidth = EditModeManagerFrame:GetRaidFrameWidth(Enum.EditModeUnitFrameSystemIndices.Party,
            defaultWidth) - 2
        absorbBar:ClearAllPoints()
        absorbBar:SetPoint("TOPRIGHT", healthBar:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
        absorbBar:SetPoint("BOTTOMRIGHT", healthBar:GetStatusBarTexture(), "BOTTOMLEFT", 0, 0)
        absorbBar:SetWidth(frameWidth)

        absorbBar:Show()

        absorbBar:SetAlpha(alpha)
    end
end

function Overshields:OnEnable()
    Overshields:SecureHook("CompactUnitFrame_UpdateHealPrediction", function(frame)
        Overshields:Update(frame)
    end)

    -- Also hook absorb amount changes to update immediately
    Overshields:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        if frame and not frame:IsForbidden() then
            Overshields:Update(frame)
        end
    end)
end

function Overshields:OnDisable()
    Overshields:UnhookAll()

    -- Hide all custom absorb bars
    for i = 1, 40 do
        local frame = _G["CompactRaidFrame" .. i]
        if frame and frame.mUIAbsorbBar then
            frame.mUIAbsorbBar:Hide()
        end
    end
end
