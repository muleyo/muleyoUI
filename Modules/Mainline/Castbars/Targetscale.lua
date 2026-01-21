local Targetscale = mUI:NewModule("mUI.Modules.Castbars.Targetscale")

function Targetscale:OnInitialize()
    -- Load Database
    Targetscale.db = mUI.db.profile.castbars

    function Targetscale:Update()
        TargetFrameSpellBar:SetScale(Targetscale.db.targetscale / 100)
    end
end

function Targetscale:OnEnable()
    Targetscale:Update()
end

function Targetscale:OnDisable()
    Targetscale:Update()
end
