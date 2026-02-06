local Restingtextures = mUI:NewModule("mUI.Modules.Unitframes.Restingtextures", "AceHook-3.0")

function Restingtextures:OnInitialize()
    function Restingtextures:Update()
        PlayerStatusTexture:Hide()
        PlayerStatusGlow:Hide()
        PlayerRestIcon:Hide()
    end
end

function Restingtextures:OnEnable()
    if IsResting() then
        Restingtextures:Update()
    end

    Restingtextures:SecureHook("PlayerFrame_UpdateStatus", Restingtextures.Update)
end

function Restingtextures:OnDisable()
    Restingtextures:UnhookAll()
    PlayerFrame_UpdateStatus()
end
