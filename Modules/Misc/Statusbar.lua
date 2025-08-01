local Statusbar = mUI:NewModule("mUI.Modules.Misc.Statusbar", "AceHook-3.0")

function Statusbar:OnInitialize()
    if not mUI:IsClassic() then
        Statusbar.func = StatusTrackingBarManager.Show
    end
end

function Statusbar:OnEnable()
    if not mUI:IsClassic() then
        StatusTrackingBarManager.Show = function() end
        StatusTrackingBarManager:Hide()
    end
end

function Statusbar:OnDisable()
    if not mUI:IsClassic() then
        StatusTrackingBarManager.Show = Statusbar.func
        StatusTrackingBarManager:Show()
    end
end
