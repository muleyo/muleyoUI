local Losecontrol = mUI:NewModule("mUI.Modules.Misc.Losecontrol")

function Losecontrol:OnInitialize()
    -- Backup
    Losecontrol.points = {}

    Losecontrol.points[1], Losecontrol.points[2], Losecontrol.points[3], Losecontrol.points[4], Losecontrol.points[5] =
        LossOfControlFrame:GetPoint()
end

function Losecontrol:OnEnable()
    LossOfControlFrame:ClearAllPoints()
    LossOfControlFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    select(1, LossOfControlFrame:GetRegions()):SetAlpha(0)
    select(2, LossOfControlFrame:GetRegions()):SetAlpha(0)
    select(3, LossOfControlFrame:GetRegions()):SetAlpha(0)
end

function Losecontrol:OnDisable()
    LossOfControlFrame:ClearAllPoints()
    LossOfControlFrame:SetPoint(Losecontrol.points[1], Losecontrol.points[2], Losecontrol.points[3],
        Losecontrol.points[4], Losecontrol.points[5])
    select(1, LossOfControlFrame:GetRegions()):SetAlpha(1)
    select(2, LossOfControlFrame:GetRegions()):SetAlpha(1)
    select(3, LossOfControlFrame:GetRegions()):SetAlpha(1)
end
