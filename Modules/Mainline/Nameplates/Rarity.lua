local Rarity = mUI:NewModule("mUI.Modules.Nameplates.Rarity")

function Rarity:OnInitialize()
    -- Load Database
    Rarity.db = mUI.db.profile.nameplates

    Rarity.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Rarity.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")

    local Core = Rarity.Core

    local ANCHORS = {
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    -- The icons of the game's own nameplate, which mUI hides
    local ICONS = {
        elite = {option = "elite", atlas = "nameplates-icon-elite-gold"},
        worldboss = {option = "elite", atlas = "nameplates-icon-elite-gold"},
        rare = {option = "rare", atlas = "UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star"},
        rareelite = {option = "rareelite", atlas = "nameplates-icon-elite-silver"}
    }

    Rarity.handler = {}

    function Rarity.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 7)
        holder:Hide()

        holder.texture = holder:CreateTexture(nil, "OVERLAY")
        holder.texture:SetAllPoints(holder)

        plate.Rarity = holder
    end

    function Rarity.handler.Update(plate, data)
        local holder = plate.Rarity
        if not holder then
            return
        end

        local icon = ICONS[Core:Safe(UnitClassification(data.unit), "")]
        local health = Core:GetHealthBar(plate)

        -- No bar, no icon: names only, or a friendly player without a bar
        if not icon or not Rarity.db.rarity[icon.option] or not health or health:IsShowOnlyName() or
            Rarity.Health.HideFriendlyBar(data) then
            holder:Hide()
            return
        end

        holder.texture:SetAtlas(icon.atlas)
        holder:Show()
    end

    function Rarity.handler.Layout(plate)
        local holder = plate.Rarity
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = Rarity.db.rarity
        local anchor = ANCHORS[config.anchor] or ANCHORS.LEFT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        holder:SetAlpha(config.alpha)
        holder:ClearAllPoints()
        holder:SetSize(config.size, config.size)
        holder:SetPoint(point, health, relativePoint, config.x * xSign, config.y * ySign)
    end

    function Rarity.handler.Remove(plate)
        if plate.Rarity then
            plate.Rarity:Hide()
        end
    end

    function Rarity:Update()
        Core:UpdateAll()
    end
end

function Rarity:OnEnable()
    Rarity.db = mUI.db.profile.nameplates
    Rarity.Core:Register("Rarity", Rarity.handler)
end

function Rarity:OnDisable()
    Rarity.Core:Unregister("Rarity")
end
