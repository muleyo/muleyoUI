local Focusscale = mUI:NewModule("mUI.Modules.Castbars.Focusscale")

function Focusscale:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.castbars

    function self:Update()
        FocusFrameSpellBar:SetScale(self.db.focusscale / 100)
    end
end

function Focusscale:OnEnable()
    self:Update()
end

function Focusscale:OnDisable()
    self:Update()
end
