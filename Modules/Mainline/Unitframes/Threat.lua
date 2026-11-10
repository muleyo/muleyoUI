local Threat = mUI:NewModule("mUI.Modules.Unitframes.Threat", "AceHook-3.0")

-- Blizzard shows the threat percentage above the target/focus frame only while threatShowNumeric is on and threatWarning allows it,
-- and neither has an option in the settings
function Threat:OnInitialize()
    -- threatWarning: 3 = always, the lower values only count in a dungeon / party
    Threat.cvars = {
        threatShowNumeric = "1",
        threatWarning = "3"
    }

    function Threat:ApplyCVars()
        for name, value in pairs(Threat.cvars) do
            local current = C_CVar.GetCVar(name)
            if current ~= nil and current ~= value then
                C_CVar.SetCVar(name, value)
            end
        end
    end

    -- Tanking with nobody else on the threat list leaves nothing to compare with, so Blizzard hides the percentage. That is the
    -- situation when you are not in a group: you have all the threat.
    function Threat:ShowSoloThreat(indicator, numericIndicator, unit)
        if not indicator or not numericIndicator or numericIndicator:IsShown() then
            return
        end
        if unit and unit ~= indicator.feedbackUnit then
            return
        end
        if IsInGroup() or not ShowNumericThreat() or not IsThreatWarningEnabled() then
            return
        end

        local target = indicator.unit
        if not target then
            return
        end

        local isDead = UnitIsDead(target)
        local classification = UnitClassification(target)
        if issecretvalue(isDead) or isDead or issecretvalue(classification) or classification == "minus" then
            return
        end

        local isTanking = UnitDetailedThreatSituation(indicator.feedbackUnit, target)
        if issecretvalue(isTanking) or not isTanking then
            return
        end

        numericIndicator.text:SetText("100%")
        numericIndicator.bg:SetVertexColor(GetThreatStatusColor(3))
        numericIndicator:Show()
    end
end

function Threat:OnEnable()
    Threat:ApplyCVars()
    Threat:SecureHook("UnitFrame_UpdateThreatIndicator", "ShowSoloThreat")
end

function Threat:OnDisable()
    Threat:UnhookAll()
end
