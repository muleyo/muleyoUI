local Healer = mUI:NewModule("mUI.Modules.Nameplates.Healer")

function Healer:OnInitialize()
    -- Load Database
    Healer.db = mUI.db.profile.nameplates

    Healer.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Healer.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")

    local Core = Healer.Core
    local Units = Healer.Units

    -- Where the icon sits relative to the health bar.
    local ANCHORS = {
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    Healer.handler = {}

    function Healer.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 6)
        holder:SetIgnoreParentAlpha(true)
        holder:Hide()

        local texture = holder:CreateTexture(nil, "OVERLAY")
        texture:SetAtlas("bags-icon-addslots")
        texture:SetAllPoints(holder)
        holder.texture = texture

        plate.Healer = holder
    end

    local function ShouldShow(data)
        if not data.isPlayer then
            return false
        end

        local config = Healer.db.healer

        if config.arenaonly and not Core.inArena then
            return false
        end

        if data.isFriend then
            return config.friendly
        end

        return config.enemy
    end

    function Healer.handler.Update(plate, data)
        local holder = plate.Healer
        if not holder then
            return
        end

        holder:SetShown(ShouldShow(data) and Units:IsHealer(data))
    end

    function Healer.handler.Layout(plate, data)
        local holder = plate.Healer
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = Healer.db.healer
        local anchor = ANCHORS[config.anchor] or ANCHORS.RIGHT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        local friendly = data and data.isFriend
        local x = friendly and config.friendlyx or config.enemyx
        local y = friendly and config.friendlyy or config.enemyy

        holder:ClearAllPoints()
        holder:SetSize(config.size, config.size)
        holder:SetPoint(point, health, relativePoint, x * xSign, y * ySign)
    end

    function Healer.handler.Remove(plate)
        if plate.Healer then
            plate.Healer:Hide()
        end
    end

    function Healer:Update()
        Core:UpdateAll()
    end
end

function Healer:OnEnable()
    Healer.db = mUI.db.profile.nameplates
    Healer.Core:Register("Healer", Healer.handler)
end

function Healer:OnDisable()
    Healer.Core:Unregister("Healer")
end
