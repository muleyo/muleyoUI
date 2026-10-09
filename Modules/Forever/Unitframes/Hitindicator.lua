local Hitindicator = mUI:NewModule("mUI.Modules.Unitframes.Hitindicator", "AceHook-3.0")

function Hitindicator:OnInitialize()
    local PlayerHitIndicator = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText
    function Hitindicator:Update()
        PlayerHitIndicator:Hide()
        PetHitIndicator:Hide()
    end
end

function Hitindicator:OnEnable()
    Hitindicator:SecureHook("CombatFeedback_OnCombatEvent", Hitindicator.Update)
end

function Hitindicator:OnDisable()
    Hitindicator:UnhookAll()
end
