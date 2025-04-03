local Elitecolor = mUI:NewModule("mUI.Modules.Unitframes.Elitecolor")

function Elitecolor:OnEnable()
    C_Timer.After(0, function()
        if select(5, TargetFrame.TargetFrameContainer:GetRegions()) then
            select(5, TargetFrame.TargetFrameContainer:GetRegions()):SetDesaturated(false)
            select(5, TargetFrame.TargetFrameContainer:GetRegions()):SetVertexColor(1, 1, 1)
        end
    end)
end

function Elitecolor:OnDisable()
    if select(5, TargetFrame.TargetFrameContainer:GetRegions()) then
        select(5, TargetFrame.TargetFrameContainer:GetRegions()):SetDesaturated(true)
        select(5, TargetFrame.TargetFrameContainer:GetRegions()):SetVertexColor(unpack(mUI:Color(0.15)))
    end
end
