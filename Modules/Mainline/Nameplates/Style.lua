local Style = mUI:NewModule("mUI.Modules.Nameplates.Style", "AceEvent-3.0")

function Style:OnInitialize()
    -- Load Database
    Style.db = mUI.db.profile.nameplates

    Style.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")

    local Core = Style.Core

    function Style:ApplyScale()
        if InCombatLockdown() then
            Style.pendingScale = true
            return
        end

        Style.pendingScale = nil

        local scale = Style.db.scale
        C_CVar.SetCVar("nameplateSelectedScale", scale.target)
        C_CVar.SetCVar("nameplateMinScale", scale.other)
        C_CVar.SetCVar("nameplateShowClassColor", Style.db.showClassColor and "1" or "0")
    end

    function Style:OnRegenEnabled()
        if Style.pendingScale then
            Style:ApplyScale()
        end
    end

    function Style:Update()
        Style:ApplyScale()
        Core:LayoutAll()
    end
end

function Style:OnEnable()
    Style.db = mUI.db.profile.nameplates

    Style:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRegenEnabled")
    Style:ApplyScale()
end

function Style:OnDisable()
    Style:UnregisterAllEvents()
end
