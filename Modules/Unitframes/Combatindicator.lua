local Combatindicator = mUI:NewModule("mUI.Modules.Unitframes.Combatindicator")

function Combatindicator:OnInitialize()
    local target = CreateFrame("Frame")
    local focus = CreateFrame("Frame")

    self.target = target
    self.focus = focus

    target:SetPoint("CENTER", TargetFrame, "RIGHT", 10, 0)
    focus:SetPoint("CENTER", FocusFrame, "RIGHT", 10, 0)

    target:SetSize(25, 25)
    focus:SetSize(25, 25)

    target.texture = self.target:CreateTexture(nil, "BORDER")
    focus.texture = self.focus:CreateTexture(nil, "BORDER")

    target.texture:SetAllPoints()
    focus.texture:SetAllPoints()

    target.texture:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])
    focus.texture:SetTexture([[Interface\Icons\ABILITY_DUALWIELD]])

    target:Hide()
    focus:Hide()

    function self:UpdateTarget()
        if UnitAffectingCombat("target") then
            target:Show()
        else
            target:Hide()
        end
    end

    function self:UpdateFocus()
        if UnitAffectingCombat("focus") then
            focus:Show()
        else
            focus:Hide()
        end
    end
end

function Combatindicator:OnEnable()
    self.target:RegisterEvent("UNIT_COMBAT")
    self.target:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.target:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.target:RegisterEvent("PLAYER_TARGET_CHANGED")

    self.focus:RegisterEvent("UNIT_COMBAT")
    self.focus:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.focus:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.focus:RegisterEvent("PLAYER_FOCUS_CHANGED")
    mUI:HookScript(self.target, "OnEvent", Combatindicator.UpdateTarget)
    mUI:HookScript(self.focus, "OnEvent", Combatindicator.UpdateFocus)
end

function Combatindicator:OnDisable()
    mUI:Unhook(self.target, "OnEvent")
    mUI:Unhook(self.focus, "OnEvent")

    self.target:UnregisterAllEvents()
    self.focus:UnregisterAllEvents()

    self.target:Hide()
    self.focus:Hide()
end
