local Reputationcolor = mUI:NewModule("mUI.Modules.Unitframes.Reputationcolor")

function Reputationcolor:OnInitialize()
    -- Load Database
    Reputationcolor.db = mUI.db.profile.unitframes
    Reputationcolor.frame = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
    Reputationcolor.frame.ReputationColor = Reputationcolor.frame:CreateTexture(nil, "OVERLAY")
    Reputationcolor.frame.ReputationColor:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Type")
    Reputationcolor.frame.ReputationColor:SetSize(136, 20)
    Reputationcolor.frame.ReputationColor:SetTexCoord(1, 0, 0, 1)
    Reputationcolor.frame.ReputationColor:SetPoint("TOPRIGHT", Reputationcolor.frame, "TOPRIGHT", -21, -25)
    Reputationcolor.frame.ReputationColor:SetVertexColor(0, 0, 1)
    Reputationcolor.frame.ReputationColor:Hide()

    Reputationcolor.frames = {
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ReputationColor,
        TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss1TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss2TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss3TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss4TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor,
        Boss5TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
    }

    function Reputationcolor:Update(option, status)
        if option == "all" and status == "disabled" then
            for _, frame in pairs(Reputationcolor.frames) do
                if frame then
                    frame:Show()
                end
            end
            Reputationcolor.frame.ReputationColor:Hide()
        else
            if option == "player" and status then
                Reputationcolor.frame.ReputationColor:Show()
                for _, frame in pairs(Reputationcolor.frames) do
                    if frame then
                        frame:Show()
                    end
                end
            elseif option == "player" and not status then
                Reputationcolor.frame.ReputationColor:Hide()
            end

            if option == "hide" and status then
                for _, frame in pairs(Reputationcolor.frames) do
                    if frame then
                        frame:Hide()
                    end
                end
                Reputationcolor.frame.ReputationColor:Hide()
            elseif option == "hide" and not status then
                for _, frame in pairs(Reputationcolor.frames) do
                    if frame then
                        frame:Show()
                    end
                end
            end
        end
    end
end

function Reputationcolor:OnEnable()
    if Reputationcolor.db.reputationcolor then
        Reputationcolor:Update("hide", true)
    elseif Reputationcolor.db.playerrepcolor then
        Reputationcolor:Update("player", true)
    end
end

function Reputationcolor:OnDisable()
    if not (Reputationcolor.db.reputationcolor and Reputationcolor.db.playerrepcolor) then
        Reputationcolor:Update("all", "disabled")
    elseif not Reputationcolor.db.reputationcolor then
        Reputationcolor:Update("hide", true)
    elseif not Reputationcolor.db.playerrepcolor then
        Reputationcolor:Update("player", true)
    end
end
