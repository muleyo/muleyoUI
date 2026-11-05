local Focuspos = mUI:NewModule("mUI.Modules.Castbars.Focuspos", "AceHook-3.0")

function Focuspos:OnInitialize()
    function Focuspos:Update()
        FocusFrameSpellBar:ClearAllPoints()
        FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 47.5, 10)
    end
end

function Focuspos:OnEnable()
    FocusFrame.mUI_castbarOnTop = true

    Focuspos:SecureHookScript(FocusFrameSpellBar, "OnShow", Focuspos.Update)
    Focuspos:SecureHook(FocusFrameSpellBar, "AdjustPosition", Focuspos.Update)
    Focuspos:Update()
end

function Focuspos:OnDisable()
    Focuspos:UnhookAll()
    FocusFrame.mUI_castbarOnTop = nil

    -- Blizzard places the bar again, the aura container then corrects it if it is in use
    FocusFrameSpellBar:AdjustPosition()
end
