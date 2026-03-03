local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator", "AceHook-3.0")

function Combatindicator:OnInitialize()
    -- Frames
    local target = TargetFrame:CreateTexture(nil, "BORDER")

    Combatindicator.target = target
    Combatindicator.combatindicator = CreateFrame("Frame")
    Combatindicator.combatindicator:RegisterEvent("UNIT_FLAGS")
    Combatindicator.combatindicator:RegisterEvent("PLAYER_TARGET_CHANGED")
    Combatindicator.combatindicator:RegisterEvent("PLAYER_FOCUS_CHANGED")

    target:SetPoint("CENTER", TargetFrame, "RIGHT", 0, 0)
    target:SetSize(35, 35)
    target:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
    target:Hide()

    function Combatindicator:Update()
        if UnitExists("target") and UnitAffectingCombat("target") then
            target:Show()
        else
            target:Hide()
        end
    end
end

function Combatindicator:OnEnable()
    -- Hook
    Combatindicator:SecureHookScript(Combatindicator.combatindicator, "OnEvent", Combatindicator.Update)
end

function Combatindicator:OnDisable()
    -- Unhook
    Combatindicator:UnhookAll()

    -- Hide
    Combatindicator.target:Hide()
end
