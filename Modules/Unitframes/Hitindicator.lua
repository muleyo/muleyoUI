local Hitindicator = mUI:NewModule("mUI.Modules.Unitframes.Hitindicator")

function Hitindicator:OnInitialize()
    -- Backup original function
    self.pet = PetHitIndicator.SetText
end

function Hitindicator:OnEnable()
    -- Hide PlayerFrame Hit Indicator
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:Hide()

    -- Hide PetFrame Hit Indicator
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function() end
end

function Hitindicator:OnDisable()
    -- Restore functionality
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:Show()
    PetHitIndicator.SetText = self.pet
end
