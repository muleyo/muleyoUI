local Targetpos = mUI:NewModule("mUI.Modules.Castbars.Targetpos")

function Targetpos:OnInitialize()
    Targetpos.func = TargetFrameSpellBar.SetPoint

    function Targetpos:Update()
        TargetFrameSpellBar:ClearAllPoints()

        if mUI:IsClassic() then
            TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 27.5, 10)
        else
            TargetFrameSpellBar:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 47.5, 10)
        end

        TargetFrameSpellBar.SetPoint = function() end
    end
end

function Targetpos:OnEnable()
    Targetpos:Update()
end

function Targetpos:OnDisable()
    TargetFrameSpellBar.SetPoint = Targetpos.func
end
