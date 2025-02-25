local Pvpbadge = mUI:NewModule("mUI.Modules.Unitframes.Pvpbadge")

function Pvpbadge:OnInitialize()
    Pvpbadge.pvpbadge = {
        player = {
            badge = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge,
            portrait = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait
        },
        target = {
            badge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
            portrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait
        },
        focus = {
            badge = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
            portrait = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait
        }
    }

    Pvpbadge.functions = {
        player = {
            badge = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge.Show,
            portrait = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait.Show
        },
        target = {
            badge = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge.Show,
            portrait = TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait.Show
        },
        focus = {
            badge = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge.Show,
            portrait = FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait.Show
        }
    }
end

function Pvpbadge:OnEnable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["badge"]:Hide()
        frame["portrait"]:Hide()
        frame["badge"].Show = function() end
        frame["portrait"].Show = function() end
    end
end

function Pvpbadge:OnDisable()
    for unitframe, frame in pairs(Pvpbadge.pvpbadge) do
        frame["badge"].Show = Pvpbadge.functions[unitframe]["badge"]
        frame["portrait"].Show = Pvpbadge.functions[unitframe]["portrait"]
        frame["badge"]:Show()
        frame["portrait"]:Show()
    end
end
