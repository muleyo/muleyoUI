local Clock = mUI:NewModule("mUI.MapMinimap.Clock")

function Clock:OnEnable()
    TimeManagerClockButton:Hide()
end

function Clock:OnDisable()
    TimeManagerClockButton:Show()
end
