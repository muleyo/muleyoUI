local Targetpos = mUI:NewModule("mUI.Modules.Castbars.Targetpos", "AceHook-3.0")

function Targetpos:OnInitialize()
    function Targetpos:Update()
        TargetFrameSpellBar:ClearAllPoints()
        TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 47.5, 10)
    end
end

function Targetpos:OnEnable()
    TargetFrame.mUI_castbarOnTop = true

    Targetpos:SecureHookScript(TargetFrameSpellBar, "OnShow", Targetpos.Update)
    Targetpos:SecureHook(TargetFrameSpellBar, "AdjustPosition", Targetpos.Update)
    Targetpos:Update()
end

function Targetpos:OnDisable()
    Targetpos:UnhookAll()
    TargetFrame.mUI_castbarOnTop = nil

    -- Blizzard places the bar again, the aura container then corrects it if it is in use
    TargetFrameSpellBar:AdjustPosition()
end
