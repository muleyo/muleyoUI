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
end

function Pvpbadge:OnEnable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"]:SetAlpha(0)
        frame["badge"]:SetAlpha(0)
        frame["portrait"]:SetAlpha(0)
    end
end

function Pvpbadge:OnDisable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"]:SetAlpha(1)
        frame["badge"]:SetAlpha(1)
        frame["portrait"]:SetAlpha(1)
    end
end
