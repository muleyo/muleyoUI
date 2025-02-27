local Statusbar = mUI:NewModule("mUI.Modules.Misc.Statusbar", "AceHook-3.0")

function Statusbar:OnInitialize()
    Statusbar.func = StatusTrackingBarManager.Show
end

function Statusbar:OnEnable()
    StatusTrackingBarManager.Show = function() end
    StatusTrackingBarManager:Hide()
end

function Statusbar:OnDisable()
    StatusTrackingBarManager.Show = Statusbar.func
    StatusTrackingBarManager:Show()
end
