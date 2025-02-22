local Targetscale = mUI:NewModule("mUI.Modules.Castbars.Targetscale")

function Targetscale:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.castbars

    function self:Update()
        TargetFrameSpellBar:SetScale(self.db.targetscale / 100)
    end
end

function Targetscale:OnEnable()
    self:Update()
end

function Targetscale:OnDisable()
    self:Update()
end
