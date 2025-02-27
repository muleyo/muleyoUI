local Pvpbadge = mUI:NewModule("mUI.Modules.Unitframes.Pvpbadge")

function Pvpbadge:OnInitialize()
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

function Pvpbadge:OnEnable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["badge"]:Hide()
        frame["portrait"]:Hide()
        frame["pvpicon"]:Hide()
        frame["badge"].Show = function() end
        frame["portrait"].Show = function() end
        frame["pvpicon"].Show = function() end
    end
end

function Pvpbadge:OnDisable()
    for unitframe, frame in pairs(Pvpbadge.pvpbadge) do
        frame["badge"].Show = Pvpbadge.functions[unitframe]["badge"]
        frame["portrait"].Show = Pvpbadge.functions[unitframe]["portrait"]
        frame["pvpicon"].Show = Pvpbadge.functions[unitframe]["pvpicon"]
        frame["badge"]:Show()
        frame["portrait"]:Show()
        frame["pvpicon"]:Show()
    end
end
