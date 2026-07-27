local Focuspos = mUI:NewModule("mUI.Modules.Castbars.Focuspos", "AceHook-3.0")

function Focuspos:OnInitialize()
    function Focuspos:Update()
        FocusFrameSpellBar:ClearAllPoints()
        FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 47.5, 10)
    end
end

function Focuspos:OnEnable()
    -- On 12.1.x the focus aura container owns the castbar position (it anchors the
    -- bar to itself and no-ops AdjustPosition). Hooking here would re-pin the bar to
    -- the frame on OnShow and fight that anchor, so stay out of the way.
    if select(4, GetBuildInfo()) >= 120100 then
        return
    end

    Focuspos:SecureHookScript(FocusFrameSpellBar, "OnShow", Focuspos.Update)
    Focuspos:SecureHook(FocusFrameSpellBar, "AdjustPosition", Focuspos.Update)
end

function Focuspos:OnDisable()
    Focuspos:UnhookAll()
end
