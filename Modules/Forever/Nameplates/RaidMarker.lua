local RaidMarker = mUI:NewModule("mUI.Modules.Nameplates.RaidMarker")

function RaidMarker:OnInitialize()
    -- Load Database
    RaidMarker.db = mUI.db.profile.nameplates

    RaidMarker.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")

    local Core = RaidMarker.Core

    local ANCHORS = {
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    RaidMarker.handler = {}

    function RaidMarker.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 7)
        holder:Hide()

        holder.texture = holder:CreateTexture(nil, "OVERLAY")
        holder.texture:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
        holder.texture:SetAllPoints(holder)

        plate.RaidMarker = holder
    end

    function RaidMarker.handler.Update(plate, data)
        local holder = plate.RaidMarker
        if not holder then
            return
        end

        if RaidMarker.db.raidmarker.hide then
            holder:Hide()
            return
        end

        local index = GetRaidTargetIndex(data.unit)
        if not Core:Exists(index) then
            holder:Hide()
            return
        end

        SetRaidTargetIconTexture(holder.texture, index)
        holder:Show()
    end

    function RaidMarker.handler.Layout(plate)
        local holder = plate.RaidMarker
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = RaidMarker.db.raidmarker
        local anchor = ANCHORS[config.anchor] or ANCHORS.LEFT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        holder:SetAlpha(config.alpha)
        holder:ClearAllPoints()
        holder:SetSize(config.size, config.size)
        holder:SetPoint(point, health, relativePoint, config.x * xSign, config.y * ySign)
    end

    function RaidMarker.handler.Remove(plate)
        if plate.RaidMarker then
            plate.RaidMarker:Hide()
        end
    end

    function RaidMarker:Update()
        Core:UpdateAll()
    end
end

function RaidMarker:OnEnable()
    RaidMarker.db = mUI.db.profile.nameplates
    RaidMarker.Core:Register("RaidMarker", RaidMarker.handler)
end

function RaidMarker:OnDisable()
    RaidMarker.Core:Unregister("RaidMarker")
end
