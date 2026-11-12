local Navigation = mUI:NewModule("mUI.Modules.Misc.Navigation", "AceHook-3.0")

-- Retail has "Show in-game navigation" in Interface > Display, it turns on the marker in the world that points to the tracked quest
-- or the waypoint on the map. Forever has all of it (C_Navigation, C_SuperTrack, Blizzard_QuestNavigation), but the setting that
-- turns it on is empty on Forever. This adds it back, where Retail has it.
function Navigation:OnInitialize()
    local CVAR = "showInGameNavigation"

    -- Called by the settings of the game for the Display section of Interface, with its category
    function Navigation:AddSetting(category)
        -- The game has no setting for what it doesn't have
        if not C_CVar.GetCVar(CVAR) then
            return
        end

        local ok, result = pcall(Settings.SetupCVarCheckbox, category, CVAR, SHOW_IN_GAME_NAVIGATION or "Show in-game navigation",
            OPTION_TOOLTIP_SHOW_IN_GAME_NAVIGATION or "Shows a marker in the world that points to the tracked quest or waypoint.")
        if not ok then
            mUI:Debug("Navigation: " .. tostring(result))
        end
    end
end

function Navigation:OnEnable()
    -- The settings are made after the login, this is in time. Turning this on later needs a UI reload.
    if InterfaceOverrides and InterfaceOverrides.AdjustInGameNavigationSettings then
        Navigation:SecureHook(InterfaceOverrides, "AdjustInGameNavigationSettings", "AddSetting")
    end
end

function Navigation:OnDisable()
    Navigation:UnhookAll()
end
