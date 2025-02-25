local Statusbar = mUI:NewModule("mUI.Modules.Misc.Statusbar", "AceHook-3.0")

function Statusbar:OnEnable()
    Statusbar:RawHookScript(StatusTrackingBarManager, "OnEvent", StatusTrackingBarManager.Hide)
end

function Statusbar:OnDisable()
    Statusbar:UnhookAll()
end
