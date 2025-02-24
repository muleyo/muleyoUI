local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator", "AceHook-3.0")

function Combatindicator:OnInitialize()
    -- Frames
    local target = CreateFrame("Frame")
    local focus = CreateFrame("Frame")

    Combatindicator.target = target
    Combatindicator.focus = focus
    Combatindicator.combatindicator = CreateFrame("Frame")

    target:SetPoint("CENTER", TargetFrame, "RIGHT", 10, 0)
    focus:SetPoint("CENTER", FocusFrame, "RIGHT", 10, 0)

    target:SetSize(25, 25)
    focus:SetSize(25, 25)

    target.texture = target:CreateTexture(nil, "BORDER")
    focus.texture = focus:CreateTexture(nil, "BORDER")

    target.texture:SetAllPoints()
    focus.texture:SetAllPoints()

    target.texture:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
    focus.texture:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])

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
    Combatindicator:HookScript(Combatindicator.combatindicator, "OnUpdate", Combatindicator.Update)
end

function Combatindicator:OnDisable()
    -- Unhook
    Combatindicator:UnhookAll()

    -- Hide
    Combatindicator.target:Hide()
    Combatindicator.focus:Hide()
end
