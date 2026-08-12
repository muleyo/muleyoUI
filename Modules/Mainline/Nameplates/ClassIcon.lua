local ClassIcon = mUI:NewModule("mUI.Modules.Nameplates.ClassIcon")

function ClassIcon:OnInitialize()
    -- Load Database
    ClassIcon.db = mUI.db.profile.nameplates

    ClassIcon.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    ClassIcon.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")

    local Core = ClassIcon.Core
    local Units = ClassIcon.Units
    local RING = {
        atlas = "UI-Journeys-Delve-rewardicon-ring-frame",
        scale = 1.25
    }
    local RING_TARGET = {
        atlas = "charactercreate-ring-select",
        scale = 1.4
    }

    local RING_SCALE = math.max(RING.scale, RING_TARGET.scale)

    local function ApplyRing(ring, style, size)
        ring:SetAtlas(style.atlas)

        if ring.SetTextureSliceMargins then
            ring:SetTextureSliceMargins(0, 0, 0, 0)
        end

        ring:SetSize(size * style.scale, size * style.scale)
    end

    local ANCHORS = {
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    ClassIcon.handler = {}

    function ClassIcon.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 5)
        holder:SetIgnoreParentAlpha(true)
        holder:Hide()

        local ringOverlay = CreateFrame("Frame", nil, holder)
        ringOverlay:SetFrameLevel(holder:GetFrameLevel() + 5)
        ringOverlay:SetAllPoints(holder)
        holder.ringOverlay = ringOverlay

        local ring = ringOverlay:CreateTexture(nil, "OVERLAY")
        ring:SetPoint("CENTER", holder, "CENTER", 0, 0)
        holder.ring = ring

        local texture = holder:CreateTexture(nil, "ARTWORK")
        texture:SetPoint("CENTER", holder, "CENTER", 0, 0)
        holder.texture = texture

        local mask = holder:CreateMaskTexture()
        mask:SetPoint("CENTER", texture, "CENTER", 0, 0)
        mask:SetTexture([[Interface\Masks\CircleMaskScalable]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        texture:AddMaskTexture(mask)
        holder.mask = mask

        plate.ClassIcon = holder
    end

    local function ShouldShow(data)
        if not data.isPlayer then
            return false
        end

        local config = ClassIcon.db.classicons

        if config.arenaonly and not Core.inArena then
            return false
        end

        if data.isFriend then
            if config.hidehealers and Units:IsHealer(data) then
                return false
            end

            return config.friendly
        end

        return config.enemy
    end

    function ClassIcon.handler.Update(plate, data)
        local holder = plate.ClassIcon
        if not holder then
            return
        end

        if not ShouldShow(data) then
            holder:Hide()
            return
        end

        local shown = false

        if ClassIcon.db.classicons.spec then
            local info = Units:GetSpecInfo(Units:GetSpecID(data))
            if info and info.icon then
                holder.texture:SetTexture(info.icon)
                shown = true
            end
        end

        local classFile = Units:GetClassFile(data)
        if not shown and classFile then
            local atlas = GetClassAtlas(classFile)
            if atlas then
                holder.texture:SetTexCoord(0, 1, 0, 1)
                holder.texture:SetAtlas(atlas)
                shown = true
            end
        end

        holder:SetShown(shown)
    end

    function ClassIcon.handler.Layout(plate, data)
        local holder = plate.ClassIcon
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = ClassIcon.db.classicons
        local anchor = ANCHORS[config.anchor] or ANCHORS.LEFT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]
        local outer = config.size * RING_SCALE

        local friendly = data and data.isFriend
        local x = friendly and config.friendlyx or config.enemyx
        local y = friendly and config.friendlyy or config.enemyy

        holder:ClearAllPoints()
        holder:SetSize(outer, outer)
        holder:SetPoint(point, health, relativePoint, x * xSign, y * ySign)

        holder.texture:SetSize(config.size, config.size)
        holder.mask:SetSize(config.size, config.size)

        local ring = holder.ring
        ApplyRing(ring, data.isTarget and RING_TARGET or RING, config.size)
        ring:SetDesaturated(true)

        local color = Units:GetClassFile(data) and C_ClassColor.GetClassColor(Units:GetClassFile(data))
        if color then
            ring:SetVertexColor(color.r, color.g, color.b)
        else
            ring:SetVertexColor(1, 1, 1)
        end
    end

    function ClassIcon.handler.Remove(plate)
        if plate.ClassIcon then
            plate.ClassIcon:Hide()
        end
    end

    function ClassIcon:Update()
        Core:UpdateAll()
    end
end

function ClassIcon:OnEnable()
    ClassIcon.db = mUI.db.profile.nameplates
    ClassIcon.Core:Register("ClassIcon", ClassIcon.handler)
end

function ClassIcon:OnDisable()
    ClassIcon.Core:Unregister("ClassIcon")
end
