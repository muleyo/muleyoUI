local Focuspos = mUI:NewModule("mUI.Modules.Castbars.Focuspos")

function Focuspos:OnInitialize()
    Focuspos.func = FocusFrameSpellBar.SetPoint

    function Focuspos:Update()
        FocusFrameSpellBar:ClearAllPoints()

        if mUI:IsClassic() then
            FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 27.5, 10)
        else
            FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 47.5, 10)
        end

        FocusFrameSpellBar.SetPoint = function() end
    end
end

function Focuspos:OnEnable()
    Focuspos:Update()
end

function Focuspos:OnDisable()
    FocusFrameSpellBar.SetPoint = Focuspos.func
end
