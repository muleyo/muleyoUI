local Style = mUI:NewModule("mUI.Modules.Nameplates.Style", "AceEvent-3.0")

function Style:OnInitialize()
    -- Load Database
    Style.db = mUI.db.profile.nameplates

    Style.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")

    local Core = Style.Core
    local NAME_SPACING = 2

    function Style:BarWidth(data, default)
        if data and data.isFriend and Style.db.friendly.small then
            return Style.db.friendly.width
        end
        return default
    end

    Style.handler = {}

    function Style.handler.Layout(plate, data)
        local health = plate.Health
        local name = plate.Name
        if not health or not name then
            return
        end

        local config = Style.db.size

        health:ClearAllPoints()
        PixelUtil.SetSize(health, Style:BarWidth(data, config.healthwidth), config.healthheight)
        health:SetPoint("CENTER", plate, "CENTER", 0, 0)

        -- Unit name.
        name:ClearAllPoints()
        name:SetJustifyH("CENTER")
        name:SetPoint("BOTTOM", health, "TOP", 0, NAME_SPACING)
        name:SetWidth(0)
        name:SetFont(mUI.db.profile.general.fontpath, Style.db.name.size, "OUTLINE")
    end

    function Style:ApplyScale()
        if InCombatLockdown() then
            Style.pendingScale = true
            return
        end

        Style.pendingScale = nil

        local scale = Style.db.scale
        C_CVar.SetCVar("nameplateSelectedScale", scale.target)
        C_CVar.SetCVar("nameplateMinScale", scale.other)
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

    Style.Core:Register("Style", Style.handler)
end

function Style:OnDisable()
    Style:UnregisterAllEvents()
    Style.Core:Unregister("Style")
end
