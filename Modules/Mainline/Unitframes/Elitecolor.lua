local Elitecolor = mUI:NewModule("mUI.Modules.Unitframes.Elitecolor")

function Elitecolor:OnEnable()
    Elitecolor.frames = {
        target = TargetFrame.TargetFrameContainer,
        focus = FocusFrame.TargetFrameContainer
    }

    C_Timer.After(0.1, function()
        for _, frame in pairs(Elitecolor.frames) do
            local texture = frame.BossPortraitFrameTexture
            if texture then
                texture:SetDesaturated(false)
                texture:SetVertexColor(1, 1, 1)
            end
        end
    end)
end

function Elitecolor:OnDisable()
    for _, frame in pairs(Elitecolor.frames) do
        local texture = frame.BossPortraitFrameTexture
        if texture then
            texture:SetDesaturated(true)
            texture:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end
end
