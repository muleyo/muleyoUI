local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator")

function Combatindicator:OnInitialize()
    -- Frames
    local target = CreateFrame("Frame")
    local focus = CreateFrame("Frame")

    self.target = target
    self.focus = focus
    self.combatindicator = CreateFrame("Frame")

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

    function self:Update()
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
    mUI:HookScript(self.combatindicator, "OnUpdate", Combatindicator.Update)
end

function Combatindicator:OnDisable()
    -- Unhook
    mUI:Unhook(self.combatindicator, "OnUpdate")

    -- Hide
    self.target:Hide()
    self.focus:Hide()
end
