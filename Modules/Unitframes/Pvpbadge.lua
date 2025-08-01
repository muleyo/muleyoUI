local Pvpbadge = mUI:NewModule("mUI.Modules.Unitframes.Pvpbadge")

function Pvpbadge:OnInitialize()
    if mUI:IsClassic() then
        Pvpbadge.pvpbadge = {
            player = {
                pvpicon = PlayerPVPIcon
            },
            target = {
                pvpicon = TargetFrameTextureFramePVPIcon
            },
            focus = {
                pvpicon = FocusFrameTextureFramePVPIcon
            }
        }

        Pvpbadge.functions = {
            player = {
                pvpicon = PlayerPVPIcon.Show
            },
            target = {
                pvpicon = TargetFrameTextureFramePVPIcon.Show
            },
            focus = {
                pvpicon = FocusFrameTextureFramePVPIcon.Show
            }
        }
    else
        Pvpbadge.pvpbadge = {
            player = {
                badge = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge,
                portrait = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait,
                pvpicon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PVPIcon
            },
            target = {
                badge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
                portrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait,
                pvpicon = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon
            },
            focus = {
                badge = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
                portrait = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait,
                pvpicon = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon
            }
        }

        Pvpbadge.functions = {
            player = {
                badge = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge.Show,
                portrait = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait.Show,
                --pvpicon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PvpIcon.Show
            },
            target = {
                badge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge.Show,
                portrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait.Show,
                pvpicon = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon.Show
            },
            focus = {
                badge = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge.Show,
                portrait = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait.Show,
                pvpicon = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon.Show
            }
        }
    end
end

function Pvpbadge:OnEnable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"]:Hide()
        frame["pvpicon"].Show = function() end

        if not mUI:IsClassic() then
            frame["badge"]:Hide()
            frame["portrait"]:Hide()
            frame["badge"].Show = function() end
            frame["portrait"].Show = function() end
        end
    end
end

function Pvpbadge:OnDisable()
    for unitframe, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"].Show = Pvpbadge.functions[unitframe]["pvpicon"]
        frame["pvpicon"]:Show()

        if not mUI:IsClassic() then
            frame["badge"].Show = Pvpbadge.functions[unitframe]["badge"]
            frame["portrait"].Show = Pvpbadge.functions[unitframe]["portrait"]
            frame["badge"]:Show()
            frame["portrait"]:Show()
        end
    end
end
