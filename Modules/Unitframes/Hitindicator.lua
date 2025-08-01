local Hitindicator = mUI:NewModule("mUI.Modules.Unitframes.Hitindicator")

function Hitindicator:OnInitialize()
    -- Backup original function
    Hitindicator.pet = PetHitIndicator.SetText

    if mUI:IsClassic() then
        Hitindicator.player = PlayerHitIndicator.SetText
    else
        Hitindicator.player = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText
    end
end

function Hitindicator:OnEnable()
    -- Hide PlayerFrame Hit Indicator
    if mUI:IsClassic() then
        PlayerHitIndicator:SetText(nil)
        PlayerHitIndicator.SetText = function() end
    else
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText:SetText(nil)
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText = function() end
    end

    -- Hide PetFrame Hit Indicator
    PetHitIndicator:SetText(nil)
    PetHitIndicator.SetText = function() end
end

function Hitindicator:OnDisable()
    -- Restore functionality
    if mUI:IsClassic() then
        PlayerHitIndicator.SetText = Hitindicator.player
    else
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText.SetText = Hitindicator.player
    end

    PetHitIndicator.SetText = Hitindicator.pet
end
