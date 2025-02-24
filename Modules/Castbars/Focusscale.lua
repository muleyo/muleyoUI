local Focusscale = mUI:NewModule("mUI.Modules.Castbars.Focusscale")

function Focusscale:OnInitialize()
    -- Load Database
    Focusscale.db = mUI.db.profile.castbars

    function Focusscale:Update()
        FocusFrameSpellBar:SetScale(Focusscale.db.focusscale / 100)
    end
end

function Focusscale:OnEnable()
    Focusscale:Update()
end

function Focusscale:OnDisable()
    Focusscale:Update()
end
