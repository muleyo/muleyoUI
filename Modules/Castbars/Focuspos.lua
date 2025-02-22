local Focuspos = mUI:NewModule("mUI.Modules.Castbars.Focuspos")

function Focuspos:OnInitialize()
    self.func = FocusFrameSpellBar.SetPoint

    function self:Update()
        FocusFrameSpellBar:ClearAllPoints()
        FocusFrameSpellBar:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 47.5, 10)
        FocusFrameSpellBar.SetPoint = function() end
    end
end

function Focuspos:OnEnable()
    self:Update()
end

function Focuspos:OnDisable()
    FocusFrameSpellBar.SetPoint = self.func
end
