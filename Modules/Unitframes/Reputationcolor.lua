local Reputationcolor = mUI:NewModule("mUI.Modules.Unitframes.Reputationcolor")

function Reputationcolor:OnInitialize()
    self.frame = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
    self.frame.ReputationColor = self.frame:CreateTexture(nil, "OVERLAY")
    self.frame.ReputationColor:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Type")
    self.frame.ReputationColor:SetSize(136, 20)
    self.frame.ReputationColor:SetTexCoord(1, 0, 0, 1)
    self.frame.ReputationColor:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -21, -25)
    self.frame.ReputationColor:SetVertexColor(0, 0, 1)
    self.frame.ReputationColor:Hide()

    self.frames = {
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ReputationColor,
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
    }

    function self:Update(option, status)
        if option == "all" and status == "disabled" then
            for _, frame in pairs(self.frames) do
                if frame then
                    frame:Show()
                end
            end
            self.frame.ReputationColor:Hide()
        else
            if option == "player" and status then
                self.frame.ReputationColor:Show()
                for _, frame in pairs(self.frames) do
                    if frame then
                        frame:Show()
                    end
                end
            elseif option == "player" and not status then
                self.frame.ReputationColor:Hide()
            end

            if option == "hide" and status then
                for _, frame in pairs(self.frames) do
                    if frame then
                        frame:Hide()
                    end
                end
                self.frame.ReputationColor:Hide()
            elseif option == "hide" and not status then
                for _, frame in pairs(self.frames) do
                    if frame then
                        frame:Show()
                    end
                end
            end
        end
    end
end

function Reputationcolor:OnEnable()
    if mUI.db.profile.unitframes.reputationcolor then
        self:Update("hide", true)
    elseif mUI.db.profile.unitframes.playerrepcolor then
        self:Update("player", true)
    end
end

function Reputationcolor:OnDisable()
    if not (mUI.db.profile.unitframes.reputationcolor and mUI.db.profile.unitframes.playerrepcolor) then
        self:Update("all", "disabled")
    elseif not mUI.db.profile.unitframes.reputationcolor then
        self:Update("hide", true)
    elseif not mUI.db.profile.unitframes.playerrepcolor then
        self:Update("player", true)
    end
end
