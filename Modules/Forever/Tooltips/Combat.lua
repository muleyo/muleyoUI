local Combat = mUI:NewModule("mUI.Tooltips.Combat", "AceHook-3.0")

function Combat:OnInitialize()
    -- Load Database
    Combat.db = mUI.db.profile.tooltips

    -- Create Frame
    Combat.combat = CreateFrame("Frame")

    function Combat:Update(event)
        if event == "PLAYER_REGEN_DISABLED" then
            if not Combat:IsHooked(GameTooltip, "OnShow") then
                GameTooltip:Hide()
                Combat:RawHookScript(GameTooltip, "OnShow", GameTooltip.Hide)
            end
        else
            if Combat:IsHooked(GameTooltip, "OnShow") then
                Combat:Unhook(GameTooltip, "OnShow")
            end
        end
    end
end

function Combat:OnEnable()
    -- Register Events and hook the OnEvent function
    Combat.combat:RegisterEvent("PLAYER_REGEN_DISABLED")
    Combat.combat:RegisterEvent("PLAYER_REGEN_ENABLED")
    Combat:SecureHookScript(Combat.combat, "OnEvent", function(_, event)
        Combat:Update(event)
    end)
end

function Combat:OnDisable()
    -- Unhook the OnEvent function and unregister all events
    Combat:UnhookAll()
    Combat.combat:UnregisterAllEvents()
end
