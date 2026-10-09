local Statusbar = mUI:NewModule("mUI.Modules.Misc.Statusbar", "AceHook-3.0")

local function HideFrame(frame)
    frame:Hide()
end

function Statusbar:OnEnable()
    StatusTrackingBarManager:Hide()
    if not Statusbar:IsHooked(StatusTrackingBarManager, "Show") then
        Statusbar:SecureHook(StatusTrackingBarManager, "Show", HideFrame)
    end
end

function Statusbar:OnDisable()
    Statusbar:UnhookAll()
    StatusTrackingBarManager:Show()
end
