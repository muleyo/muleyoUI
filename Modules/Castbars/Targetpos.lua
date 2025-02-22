local Targetpos = mUI:NewModule("mUI.Modules.Castbars.Targetpos")

function Targetpos:OnInitialize()
    self.func = TargetFrameSpellBar.SetPoint

    function self:Update()
        TargetFrameSpellBar:ClearAllPoints()
        TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 47.5, 10)
        TargetFrameSpellBar.SetPoint = function() end
    end
end

function Targetpos:OnEnable()
    self:Update()
end

function Targetpos:OnDisable()
    TargetFrameSpellBar.SetPoint = self.func
end
