local Overshields = mUI:NewModule("mUI.Modules.Unitframes.Overshields", "AceHook-3.0")

function Overshields:OnInitialize()
    function Overshields:Update(frame)
        if not frame or frame:IsForbidden() then return end
        if not frame.totalAbsorbBar then return end
        if not frame.overAbsorbGlow then return end
        if not frame.healthBar then return end

        local absorbBar = frame.totalAbsorbBar
        local absorbGlow = frame.overAbsorbGlow
        local healthBar = frame.healthbar or frame.healthBar

        -- Get Textures
        local healthBarTexture = healthBar:GetStatusBarTexture()
        local absorbFillMaskTexture = absorbBar.FillMask

        local curHealth = healthBar:GetValue()
        if curHealth <= 0 then return end

        local _, maxHealth = healthBar:GetMinMaxValues()
        if maxHealth <= 0 then return end

        local totalAbsorb = UnitGetTotalAbsorbs(frame.unit) or 0
        if totalAbsorb <= 0 then return end

        local effectiveHealth = curHealth + totalAbsorb
        if effectiveHealth <= maxHealth then
            -- normal - fill health deficit with absorb bar
            absorbGlow:ClearAllPoints()
            absorbGlow:SetPoint("TOPLEFT", healthBarTexture, "TOPRIGHT", -7, 0)
            absorbGlow:SetPoint("BOTTOMLEFT", healthBarTexture, "BOTTOMRIGHT", -7, 0)
            absorbGlow:SetAlpha(0.6)
        else
            -- overshield - fill health deficit and remaining absorb percentage into health bar
            local xOffset = (maxHealth / effectiveHealth) - 1
            absorbBar:UpdateFillPosition(healthBar:GetStatusBarTexture(), totalAbsorb, xOffset)

            -- anchor overabsorb glow left into health bar
            absorbGlow:ClearAllPoints()
            absorbGlow:SetPoint("TOPLEFT", absorbFillMaskTexture, "TOPLEFT", -7, 0)
            absorbGlow:SetPoint("BOTTOMLEFT", absorbFillMaskTexture, "BOTTOMLEFT", -7, 0)
            absorbGlow:SetAlpha(0.6)
        end
    end

    function Overshields:UpdateHealPrediction(frame)
        if not frame or frame:IsForbidden() then return end
        if not frame.totalAbsorb then return end
        if not frame.totalAbsorbOverlay then return end
        if not frame.overAbsorbGlow then return end
        if not frame.healthBar then return end

        local absorbBar = frame.totalAbsorb
        local absorbOverlay = frame.totalAbsorbOverlay
        local absorbGlow = frame.overAbsorbGlow
        local healthBar = frame.healthBar

        local _, maxHealth = healthBar:GetMinMaxValues()
        if maxHealth <= 0 then return end

        local totalAbsorb = UnitGetTotalAbsorbs(frame.displayedUnit) or 0
        if totalAbsorb > maxHealth then
            totalAbsorb = maxHealth
        end

        if totalAbsorb > 0 then
            absorbOverlay:SetParent(healthBar)
            absorbOverlay:ClearAllPoints()

            if absorbBar:IsShown() then
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
