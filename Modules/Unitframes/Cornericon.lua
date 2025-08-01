local Cornericon = mUI:NewModule("mUI.Modules.Unitframes.Cornericon")

function Cornericon:OnEnable()
    if not mUI:IsClassic() then
        C_Timer.After(0, function()
            PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(0)
        end)
    end
end

function Cornericon:OnDisable()
    if not mUI:IsClassic() then
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:SetAlpha(1)
    end
end
