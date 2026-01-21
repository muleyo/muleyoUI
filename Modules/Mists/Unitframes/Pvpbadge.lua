local Pvpbadge = mUI:NewModule("mUI.Modules.Unitframes.Pvpbadge")

function Pvpbadge:OnInitialize()
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
end

function Pvpbadge:OnEnable()
    for _, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"]:Hide()
        frame["pvpicon"].Show = function()
        end
    end
end

function Pvpbadge:OnDisable()
    for unitframe, frame in pairs(Pvpbadge.pvpbadge) do
        frame["pvpicon"].Show = Pvpbadge.functions[unitframe]["pvpicon"]
        frame["pvpicon"]:Show()
    end
end
