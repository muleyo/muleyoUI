local Reputationcolor = mUI:NewModule("mUI.Modules.Unitframes.Reputationcolor")

function Reputationcolor:OnInitialize()
    self.frames = {
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
    }
    function self:Update(isEnabled)
        if isEnabled then
            for _, frame in pairs(self.frames) do
                frame:Hide()
            end
        else
            for _, frame in pairs(self.frames) do
                frame:Show()
            end
        end
    end
end

function Reputationcolor:OnEnable()
    self:Update(true)
end

function Reputationcolor:OnDisable()
    self:Update(false)
end
