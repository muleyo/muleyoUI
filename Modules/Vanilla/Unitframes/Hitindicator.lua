local Hitindicator = mUI:NewModule("mUI.Modules.Unitframes.Hitindicator")

function Hitindicator:OnInitialize()
    -- Backup original function
    Hitindicator.pet = PetHitIndicator.SetText
    Hitindicator.player = PlayerHitIndicator.SetText
end

function Hitindicator:OnEnable()
    -- Hide PlayerFrame Hit Indicator
    PlayerHitIndicator:SetText(nil)
    PlayerHitIndicator.SetText = function()
    end

    -- Hide PetFrame Hit Indicator
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function()
    end
end

function Hitindicator:OnDisable()
    -- Restore functionality
    PlayerHitIndicator.SetText = Hitindicator.player
    PetHitIndicator.SetText = Hitindicator.pet
end
