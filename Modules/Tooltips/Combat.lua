local Combat = mUI:NewModule("mUI.Tooltips.Combat")

function Combat:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.tooltips

    -- Create Frame
    self.combat = CreateFrame("Frame")

    function self:Update(event)
        if event == "PLAYER_REGEN_DISABLED" then
            if not mUI:IsHooked(GameTooltip, "OnShow") then
                GameTooltip:Hide()
                mUI:RawHookScript(GameTooltip, "OnShow", GameTooltip.Hide)
            end
        else
            if mUI:IsHooked(GameTooltip, "OnShow") then
                mUI:Unhook(GameTooltip, "OnShow")
            end
        end
    end
end

function Combat:OnEnable()
    -- Register Events and hook the OnEvent function
    self.combat:RegisterEvent("PLAYER_REGEN_DISABLED")
    self.combat:RegisterEvent("PLAYER_REGEN_ENABLED")
    mUI:HookScript(self.combat, "OnEvent", function(_, event)
        self:Update(event)
    end)
end

function Combat:OnDisable()
    -- Unhook the OnEvent function and unregister all events
    mUI:Unhook(self.combat, "OnEvent")
    mUI:Unhook(GameTooltip, "OnShow")
    self.combat:UnregisterAllEvents()
end
