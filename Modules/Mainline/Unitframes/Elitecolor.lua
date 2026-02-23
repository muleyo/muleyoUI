local Elitecolor = mUI:NewModule("mUI.Modules.Unitframes.Elitecolor")

function Elitecolor:OnEnable()
    Elitecolor.frames = {
        target = TargetFrame.TargetFrameContainer,
        focus = FocusFrame.TargetFrameContainer,
        boss1 = Boss1TargetFrame.TargetFrameContainer,
        boss2 = Boss2TargetFrame.TargetFrameContainer,
        boss3 = Boss3TargetFrame.TargetFrameContainer,
        boss4 = Boss4TargetFrame.TargetFrameContainer,
        boss5 = Boss5TargetFrame.TargetFrameContainer
    }

    C_Timer.After(0.1, function()
        for _, frame in pairs(Elitecolor.frames) do
            if select(5, frame:GetRegions()) then
                select(5, frame:GetRegions()):SetDesaturated(false)
                select(5, frame:GetRegions()):SetVertexColor(1, 1, 1)
            end
        end
    end)
end

function Elitecolor:OnDisable()
    for _, frame in pairs(Elitecolor.frames) do
        if select(5, frame:GetRegions()) then
            select(5, frame:GetRegions()):SetDesaturated(true)
            select(5, frame:GetRegions()):SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end
end
