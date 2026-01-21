local Hitindicator = mUI:NewModule("mUI.Modules.Unitframes.Hitindicator")

function Hitindicator:OnInitialize()
    -- Backup original function
    Hitindicator.pet = PetHitIndicator.SetText
    Hitindicator.player = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText
end

function Hitindicator:OnEnable()
    -- Hide PlayerFrame Hit Indicator
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText:SetText(nil)
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText = function()
    end

    -- Hide PetFrame Hit Indicator
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function()
    end
end

function Hitindicator:OnDisable()
    -- Restore functionality
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText = Hitindicator.player
    PetHitIndicator.SetText = Hitindicator.pet
end
