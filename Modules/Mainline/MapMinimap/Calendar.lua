local Calendar = mUI:NewModule("mUI.MapMinimap.Calendar")

function Calendar:OnInitialize()
end

function Calendar:OnEnable()
    GameTimeFrame:Hide()
end

function Calendar:OnDisable()
    GameTimeFrame:Show()
end
