local Targetpos = mUI:NewModule("mUI.Modules.Castbars.Targetpos", "AceHook-3.0")

function Targetpos:OnInitialize()
    function Targetpos:Update()
        TargetFrameSpellBar:ClearAllPoints()
        TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 47.5, 10)
    end
end

function Targetpos:OnEnable()
    -- On 12.1.x the target aura container owns the castbar position (it anchors the
    -- bar to itself and no-ops AdjustPosition). Hooking here would re-pin the bar to
    -- the frame on OnShow and fight that anchor, so stay out of the way.
    if select(4, GetBuildInfo()) >= 120100 then
        return
    end

    Targetpos:SecureHookScript(TargetFrameSpellBar, "OnShow", Targetpos.Update)
    Targetpos:SecureHook(TargetFrameSpellBar, "AdjustPosition", Targetpos.Update)
end

function Targetpos:OnDisable()
    Targetpos:UnhookAll()
end
