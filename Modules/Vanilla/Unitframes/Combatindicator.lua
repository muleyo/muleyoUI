local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator", "AceHook-3.0")

function Combatindicator:OnInitialize()
    -- Frames
    local target = CreateFrame("Frame")

    Combatindicator.target = target
    Combatindicator.combatindicator = CreateFrame("Frame")

    target:SetPoint("CENTER", TargetFrame, "RIGHT", 0, 0)
    target:SetSize(25, 25)
    target.texture = target:CreateTexture(nil, "BORDER")
    target.texture:SetAllPoints()
    target.texture:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
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
    Combatindicator:SecureHookScript(Combatindicator.combatindicator, "OnUpdate", Combatindicator.Update)
end

function Combatindicator:OnDisable()
    -- Unhook
    Combatindicator:UnhookAll()

    -- Hide
    Combatindicator.target:Hide()
end
