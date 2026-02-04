local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

function Overshields:OnInitialize()
    Overshields.orientation = nil
    -- No calculator needed - we use UnitGetTotalAbsorbs directly

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

        local unit = frame.displayedUnit
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

        -- Get absorb amount directly - no Calculator needed
        local absorbAmount = UnitGetTotalAbsorbs(unit) or 0

        -- Get health max value for the bar scale
        local _, maxHealth = healthBar:GetMinMaxValues()

        -- Configure the StatusBar - it handles secret values internally
        absorbBar:SetOrientation("HORIZONTAL")
        absorbBar:SetReverseFill(true) -- Fill from right to left (or top to bottom)
        absorbBar:SetMinMaxValues(0, maxHealth) -- Pass secret value directly, no arithmetic!
        absorbBar:SetValue(absorbAmount, 1) -- Pass absorb amount directly

        -- Don't set size, let anchoring control it
        absorbBar:ClearAllPoints()
        absorbBar:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT", 0, 0)
        absorbBar:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)
        absorbBar:SetPoint("LEFT", healthBar, "LEFT", 0, 0) -- Stretch full width

        absorbBar:Show()
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
