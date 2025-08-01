local Restingtextures = mUI:NewModule("mUI.Modules.Unitframes.Restingtextures", "AceHook-3.0")

function Restingtextures:OnInitialize()
    if mUI:IsClassic() then
        function Restingtextures:Update()
            PlayerStatusTexture:Hide()
            PlayerStatusGlow:Hide()
            PlayerRestIcon:Hide()
        end
    end
end

function Restingtextures:OnEnable()
    if mUI:IsClassic() then
        if IsResting() then
            Restingtextures:Update()
        end

        Restingtextures:SecureHook("PlayerFrame_UpdateStatus", Restingtextures.Update)
    else
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(0)

        Restingtextures:SecureHook("PlayerFrame_UpdatePlayerRestLoop", function()
            PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
        end)
    end
end

function Restingtextures:OnDisable()
    Restingtextures:UnhookAll()
    if mUI:IsClassic() then
        PlayerFrame_UpdateStatus()
    else
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:SetAlpha(1)
    end
end
