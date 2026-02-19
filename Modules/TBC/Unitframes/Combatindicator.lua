local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator", "AceHook-3.0")

function Combatindicator:OnInitialize()
    -- Frames
    local target = TargetFrame:CreateTexture(nil, "BORDER")
    local focus = FocusFrame:CreateTexture(nil, "BORDER")

    Combatindicator.target = target
    Combatindicator.focus = focus
    Combatindicator.combatindicator = CreateFrame("Frame")
    Combatindicator.combatindicator:RegisterEvent("UNIT_FLAGS")
    Combatindicator.combatindicator:RegisterEvent("PLAYER_TARGET_CHANGED")
    Combatindicator.combatindicator:RegisterEvent("PLAYER_FOCUS_CHANGED")

    target:SetPoint("CENTER", TargetFrame, "RIGHT", 0, 0)
    focus:SetPoint("CENTER", FocusFrame, "RIGHT", 0, 0)

    target:SetSize(35, 35)
    focus:SetSize(35, 35)

    target:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
    focus:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])

    target:Hide()
    focus:Hide()

    function Combatindicator:Update()
        if UnitExists("target") and UnitAffectingCombat("target") then
            target:Show()
        else
            target:Hide()
        end

        if UnitExists("focus") and UnitAffectingCombat("focus") then
            focus:Show()
        else
            focus:Hide()
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
    Combatindicator.focus:Hide()
end
