local Totem = mUI:NewModule("mUI.Modules.Nameplates.Totem")

-- Ported from BetterBlizzPlates (modules/totem.lua) with the author's explicit permission.

function Totem:OnInitialize()
    -- Load Database
    Totem.db = mUI.db.profile.nameplates

    Totem.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Totem.Theme = mUI:GetModule("mUI.Modules.General.Theme")

    local Core = Totem.Core
    local Theme = Totem.Theme

    local ICON_GENERIC = [[Interface\Icons\Spell_shaman_totemrecall]]
    local ICON_CAP = C_Spell.GetSpellTexture(192058) or ICON_GENERIC
    local ICON_PSYFIEND = C_Spell.GetSpellTexture(199824) or ICON_GENERIC
    local COLOR_CAP = {1, 0.69, 0}
    local COLOR_PSYFIEND = {0.49, 0, 1}
    local COLOR_GROUNDING = {1, 0.8, 0}
    local MASK_TEXTURE = [[Interface\Masks\CircleMaskScalable]]
    local BASE_ICON_SIZE = 20

    local ANCHORS = {
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    local function IsTotem(unit)
        return Core:Safe(UnitIsMinion(unit), false) and not Core:Safe(UnitIsOtherPlayersPet(unit), false) and
                   not Core:Safe(UnitIsUnit(unit, "pet"), false)
    end

    local function TotemState(data)
        local config = Totem.db.totem

        if not config.enabled or not data or not data.unit then
            return nil
        end

        if not IsTotem(data.unit) or (config.enemyOnly and data.isFriend) then
            return nil
        end

        local unit = data.unit

        if Core:Exists(UnitChannelInfo(unit)) then
            return "channel", COLOR_PSYFIEND, ICON_PSYFIEND
        end

        if Core:Exists(UnitCastingInfo(unit)) then
            return "cast", COLOR_CAP, ICON_CAP
        end

        return "idle", config.color
    end

    function Totem:GetBarColor(data)
        if not Totem:IsEnabled() or not Totem.db.totem.colorHealthBar then
            return nil
        end

        local _, color = TotemState(data)
        return color
    end

    Totem.handler = {}

    function Totem.handler.Create(plate)
        local holder = CreateFrame("Frame", nil, plate)
        holder:SetFrameLevel(plate:GetFrameLevel() + 6)
        holder:SetSize(BASE_ICON_SIZE, BASE_ICON_SIZE)
        holder:Hide()

        local texture = holder:CreateTexture(nil, "ARTWORK")
        texture:SetAllPoints(holder)
        texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        holder.texture = texture

        local mask = holder:CreateMaskTexture()
        mask:SetAllPoints(texture)
        mask:SetTexture(MASK_TEXTURE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        texture:AddMaskTexture(mask)
        holder.mask = mask

        local borderOverlay = CreateFrame("Frame", nil, holder)
        borderOverlay:SetFrameLevel(holder:GetFrameLevel() + 1)
        borderOverlay:SetAllPoints(holder)

        local border = borderOverlay:CreateTexture(nil, "OVERLAY", nil, 7)
        border:SetDesaturated(true)
        border:SetVertexColor(unpack(mUI:Color(0.25)))
        holder.border = border

        Theme:RegisterBorder({
            border = border,
            coord = true,
            mask = mask,
            applyGeometry = function(style)
                local inset = style.totemIcon or 3.5
                border:ClearAllPoints()
                border:SetPoint("TOPLEFT", texture, "TOPLEFT", -inset, inset)
                border:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT", inset, -inset)
            end
        })

        local auraContainer = CreateFrame("AuraContainer", nil, holder, "CustomAuraContainerTemplate")
        auraContainer:SetPoint("CENTER", holder, "CENTER", 0, 0)
        auraContainer:SetFlowLayoutAnchorPoint("CENTER")
        auraContainer:SetFlowLayoutGrowthDirection(AnchorUtil.FlowDirection.Right, AnchorUtil.FlowDirection.Down)
        auraContainer:SetEnabled(false)
        auraContainer:Hide()
        auraContainer:AddAuraGroup("TotemBuff", "HELPFUL", {
            maxFrameCount = 1,
            initializeFrame = function(auraFrame)
                auraFrame:SetSize(BASE_ICON_SIZE, BASE_ICON_SIZE)

                local auraTexture = auraFrame:CreateTexture(nil, "ARTWORK")
                auraTexture:SetAllPoints(auraFrame)
                auraTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                auraFrame:SetIcon(auraTexture)

                local auraMask = auraFrame:CreateMaskTexture()
                auraMask:SetAllPoints(auraTexture)
                auraMask:SetTexture(MASK_TEXTURE, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                auraTexture:AddMaskTexture(auraMask)

                local auraBorderOverlay = CreateFrame("Frame", nil, auraFrame)
                auraBorderOverlay:SetFrameLevel(auraFrame:GetFrameLevel() + 1)
                auraBorderOverlay:SetAllPoints(auraFrame)

                local auraBorder = auraBorderOverlay:CreateTexture(nil, "OVERLAY", nil, 7)
                auraBorder:SetDesaturated(true)
                auraBorder:SetVertexColor(COLOR_GROUNDING[1], COLOR_GROUNDING[2], COLOR_GROUNDING[3])

                Theme:RegisterBorder({
                    border = auraBorder,
                    coord = true,
                    mask = auraMask,
                    applyGeometry = function(style)
                        local inset = style.totemIcon or 3.5
                        auraBorder:ClearAllPoints()
                        auraBorder:SetPoint("TOPLEFT", auraTexture, "TOPLEFT", -inset, inset)
                        auraBorder:SetPoint("BOTTOMRIGHT", auraTexture, "BOTTOMRIGHT", inset, -inset)
                    end
                })
                auraFrame.border = auraBorder

                auraFrame:SetMouseMotionEnabled(false)
            end,
            layout = {
                elementSpacing = 0,
                lineSpacing = 0
            }
        })
        holder.auraContainer = auraContainer

        local animation = holder:CreateAnimationGroup()
        local grow = animation:CreateAnimation("Scale")
        grow:SetOrder(1)
        grow:SetScale(1.1, 1.1)
        grow:SetDuration(0.5)
        local shrink = animation:CreateAnimation("Scale")
        shrink:SetOrder(2)
        shrink:SetScale(0.9091, 0.9091)
        shrink:SetDuration(0.5)
        animation:SetLooping("REPEAT")
        holder.animation = animation

        plate.Totem = holder
    end

    local function HideAuraContainer(holder)
        holder.auraContainer:SetEnabled(false)
        holder.auraContainer.mUI_unit = nil
        holder.auraContainer:Hide()
    end

    local function HideAll(holder)
        holder:Hide()
        holder.animation:Stop()
        HideAuraContainer(holder)
    end

    function Totem.handler.Update(plate, data)
        local holder = plate.Totem
        if not holder then
            return
        end

        local config = Totem.db.totem
        local state, color, icon = TotemState(data)

        if not state then
            HideAll(holder)
            return
        end

        if state == "idle" then
            local unit = data.unit
            local container = holder.auraContainer
            if container.mUI_unit ~= unit then
                container:SetUnit(unit)
                container:SetEnabled(true)
                container.mUI_unit = unit
            end
            container:UpdateAllAuras()
            container:Show()

            holder.texture:Hide()
            holder.border:Hide()
        else
            HideAuraContainer(holder)
            holder.texture:Show()
            holder.border:Show()
            holder.texture:SetTexture(icon)
            holder.border:SetVertexColor(color[1], color[2], color[3])
        end

        holder:Show()

        if config.noAnimation then
            holder.animation:Stop()
        else
            holder.animation:Play()
        end
    end

    function Totem.handler.Layout(plate)
        local holder = plate.Totem
        local health = holder and holder:IsShown() and Core:GetHealthBar(plate)
        if not health then
            return
        end

        local config = Totem.db.totem
        local anchor = ANCHORS[config.anchor] or ANCHORS.TOP
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        holder:ClearAllPoints()
        holder:SetPoint(point, health, relativePoint, config.x * xSign, config.y * ySign)
        holder:SetScale(config.size / BASE_ICON_SIZE)
    end

    function Totem.handler.Remove(plate)
        if plate.Totem then
            HideAll(plate.Totem)
        end
    end

    function Totem:Update()
        Core:UpdateAll()

        local Health = mUI:GetModule("mUI.Modules.Nameplates.Health", true)
        if Health and Health:IsEnabled() then
            Health:Update()
        end
    end
end

function Totem:OnEnable()
    Totem.db = mUI.db.profile.nameplates
    Totem.Core:Register("Totem", Totem.handler)
end

function Totem:OnDisable()
    Totem.Core:Unregister("Totem")
end
