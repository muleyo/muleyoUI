local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

function Overshields:OnInitialize()
    function Overshields:Update(frame)
        -- Skip Target of Target frames to avoid protected function calls
        if frame == TargetFrameToT or frame == FocusFrameToT then
            return
        end

        local absorbBar = frame.totalAbsorbBar
        if not absorbBar or absorbBar:IsForbidden() then
            return
        end

        local absorbGlow = frame.overAbsorbGlow
        if not absorbGlow or absorbGlow:IsForbidden() then
            return
        end

        local healthBar = frame.healthbar
        if not healthBar or healthBar:IsForbidden() then
            return
        end

        local healthBarTexture = healthBar:GetStatusBarTexture()
        local absorbFillMaskTexture = absorbBar.FillMask

        local curHealth = healthBar:GetValue()
        if curHealth <= 0 then
            return
        end

        local _, maxHealth = healthBar:GetMinMaxValues()
        if maxHealth <= 0 then
            return
        end

        local totalAbsorb = UnitGetTotalAbsorbs(frame.unit) or 0
        if totalAbsorb <= 0 then
            return
        end

        local effectiveHealth = curHealth + totalAbsorb
        if effectiveHealth <= maxHealth then
            absorbGlow:ClearAllPoints()
            absorbGlow:SetPoint("TOPLEFT", healthBarTexture, "TOPRIGHT", -7, 0)
            absorbGlow:SetPoint("BOTTOMLEFT", healthBarTexture, "BOTTOMRIGHT", -7, 0)
            absorbGlow:SetAlpha(0.6)
        else
            local xOffset = (maxHealth / effectiveHealth) - 1
            absorbBar:UpdateFillPosition(healthBar:GetStatusBarTexture(), totalAbsorb, xOffset)

            absorbGlow:ClearAllPoints()
            absorbGlow:SetPoint("TOPLEFT", absorbFillMaskTexture, "TOPLEFT", -7, 0)
            absorbGlow:SetPoint("BOTTOMLEFT", absorbFillMaskTexture, "BOTTOMLEFT", -7, 0)
            absorbGlow:SetAlpha(0.6)
        end
    end

    function Overshields:UpdateHealPrediction(frame)
        -- Skip Target of Target frames to avoid protected function calls
        if frame == TargetFrameToT or frame == FocusFrameToT then
            return
        end

        local absorbBar = frame.totalAbsorb
        if not absorbBar or absorbBar:IsForbidden() then
            return
        end

        local absorbOverlay = frame.totalAbsorbOverlay
        if not absorbOverlay or absorbOverlay:IsForbidden() then
            return
        end

        local absorbGlow = frame.overAbsorbGlow
        if not absorbGlow or absorbGlow:IsForbidden() then
            return
        end

        local healthBar = frame.healthBar
        if not healthBar or healthBar:IsForbidden() then
            return
        end

        local _, maxHealth = healthBar:GetMinMaxValues()
        if maxHealth <= 0 then
            return
        end

        local totalAbsorb = UnitGetTotalAbsorbs(frame.displayedUnit) or 0
        if totalAbsorb > maxHealth then
            totalAbsorb = maxHealth
        end

        if totalAbsorb > 0 then            -- show overlay when there's a positive absorb amount
            absorbOverlay:SetParent(healthBar)
            absorbOverlay:ClearAllPoints() -- we'll be attaching the overlay on heal prediction update.

            if absorbBar:IsShown() then    -- If absorb bar is shown, attach absorb overlay to it; otherwise, attach to health bar.
                absorbOverlay:SetPoint("TOPRIGHT", absorbBar, "TOPRIGHT", 0, 0)
                absorbOverlay:SetPoint("BOTTOMRIGHT", absorbBar, "BOTTOMRIGHT", 0, 0)
            else
                absorbOverlay:SetPoint("TOPRIGHT", healthBar, "TOPRIGHT", 0, 0)
                absorbOverlay:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)
            end

            local totalWidth, totalHeight = healthBar:GetSize()
            local barSize = totalAbsorb / maxHealth * totalWidth

            absorbOverlay:SetWidth(barSize)
            absorbOverlay:SetTexCoord(0, barSize / absorbOverlay.tileSize, 0, totalHeight / absorbOverlay.tileSize)
            absorbOverlay:Show()

            absorbGlow:ClearAllPoints()
            absorbGlow:SetPoint("TOPLEFT", absorbOverlay, "TOPLEFT", -7, 0)
            absorbGlow:SetPoint("BOTTOMLEFT", absorbOverlay, "BOTTOMLEFT", -7, 0)
            absorbGlow:SetAlpha(0.6)

            -- frame.overAbsorbGlow:Show();	--uncomment this if you want to ALWAYS show the glow to the left of the shield overlay
        end
    end
end

function Overshields:OnEnable()
    hooksecurefunc("CompactUnitFrame_UpdateHealPrediction", function(frame)
        Overshields:UpdateHealPrediction(frame)
    end)

    hooksecurefunc("UnitFrameHealPredictionBars_Update", function(frame)
        Overshields:Update(frame)
    end)
end

function Overshields:OnDisable()
    Overshields:UnhookAll()
end
