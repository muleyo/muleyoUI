local Castbar = mUI:NewModule("mUI.Modules.Nameplates.Castbar", "AceHook-3.0")

function Castbar:OnInitialize()
    -- Load Database
    Castbar.db = mUI.db.profile.nameplates

    Castbar.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Castbar.Theme = mUI:GetModule("mUI.Modules.General.Theme")

    -- The moments Blizzard re-applies its own styling.
    local CAST_EVENTS = {"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_EMPOWER_START"}

    local function GetCastBar(plate)
        local namePlate = plate:GetParent()
        local frame = namePlate and namePlate.UnitFrame
        local container = frame and frame.CastBarsContainer
        return container and container.castBar, container, frame
    end

    local function SkinBackground(castBar)
        if not castBar.Background then
            return
        end

        castBar.Background:ClearAllPoints()
        castBar.Background:SetAllPoints(castBar)

        local color = mUI:Color(0.15)
        castBar.Background:SetVertexColor(color[1], color[2], color[3], color[4])
    end

    local ICON_GAP = 2
    local TEXT_SIZE = 12
    local TEXT_PADDING = 2

    local function IconSize()
        return math.max((Castbar.db.size.castheight or 10), 16)
    end

    local function HookIcon(castBar, icon)
        if not Castbar:IsHooked(icon, "SetTexture") then
            Castbar:SecureHook(icon, "SetTexture", function(_, tex)
                castBar.iconFrame.texture:SetTexture(tex)
            end)
        end

        if not Castbar:IsHooked(icon, "SetShown") then
            Castbar:SecureHook(icon, "SetShown", function(_, shown)
                castBar.iconFrame:SetShown(shown)
            end)
        end

        if not Castbar:IsHooked(icon, "Hide") then
            Castbar:SecureHook(icon, "Hide", function()
                castBar.iconFrame:Hide()
            end)
        end

        if not Castbar:IsHooked(icon, "Show") then
            Castbar:SecureHook(icon, "Show", function()
                castBar.iconFrame:Show()
            end)
        end
    end

    local function SkinIcon(castBar)
        local icon = castBar.Icon
        if not icon then
            return
        end

        if not castBar.iconFrame then
            local iconFrame = CreateFrame("Frame", nil, castBar)
            iconFrame:SetFrameLevel(castBar:GetFrameLevel() + 1)

            local texture = iconFrame:CreateTexture(nil, "OVERLAY")
            texture:SetAllPoints(iconFrame)
            texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            iconFrame.texture = texture

            local mUIBorder = iconFrame:CreateTexture(nil, "OVERLAY", nil, 7)
            mUIBorder:SetDesaturated(true)
            mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

            local mask = iconFrame:CreateMaskTexture()
            mask:SetAllPoints(texture)
            texture:AddMaskTexture(mask)

            Castbar.Theme:RegisterBorder({
                border = mUIBorder,
                coord = true,
                mask = mask,
                applyGeometry = function(style)
                    local inset = style.nameplateIcons or 3.5
                    mUIBorder:ClearAllPoints()
                    mUIBorder:SetPoint("TOPLEFT", texture, "TOPLEFT", -inset, inset)
                    mUIBorder:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT", inset, -inset)
                end
            })

            icon:SetAlpha(0)
            icon:SetIgnoreParentAlpha(false)

            local currentTexture = icon:GetTexture()
            if currentTexture then
                texture:SetTexture(currentTexture)
            end
            iconFrame:SetShown(icon:IsShown())

            castBar.iconFrame = iconFrame
        end

        HookIcon(castBar, icon)

        local size = IconSize()
        local iconFrame = castBar.iconFrame
        iconFrame:ClearAllPoints()
        iconFrame:SetSize(size, size)
        iconFrame:SetPoint("RIGHT", castBar, "LEFT", -ICON_GAP, 0)
    end

    local SHIELD_ATLAS = "ui-castingbar-shield"

    local function IsUninterruptible(plate)
        local data = Castbar.Core:GetData(plate:GetParent())
        local unit = data and data.unit
        if not unit then
            return false
        end

        local notInterruptible = select(8, UnitCastingInfo(unit))
        if notInterruptible == nil then
            notInterruptible = select(7, UnitChannelInfo(unit))
        end

        return notInterruptible
    end

    local function SkinShield(castBar, uninterruptible)
        local shield = castBar.BorderShield
        if not shield or not castBar.iconFrame then
            return
        end

        if not castBar.shieldFrame then
            local shieldFrame = CreateFrame("Frame", nil, castBar)
            shieldFrame:SetFrameLevel(castBar.iconFrame:GetFrameLevel() + 1)

            local texture = shieldFrame:CreateTexture(nil, "OVERLAY")
            texture:SetAllPoints(shieldFrame)
            texture:SetAtlas(SHIELD_ATLAS, false)
            shieldFrame.texture = texture

            -- Hide default shield border
            shield:SetAlpha(0)
            shield:SetIgnoreParentAlpha(false)

            castBar.shieldFrame = shieldFrame
        end

        local size = IconSize()
        local shieldFrame = castBar.shieldFrame
        shieldFrame:ClearAllPoints()
        shieldFrame:SetPoint("CENTER", castBar.iconFrame, "CENTER", 0, 0)
        shieldFrame:SetSize(size, size)
        shieldFrame:Show()

        if uninterruptible ~= nil then
            shieldFrame:SetAlphaFromBoolean(uninterruptible, 1, 0)
        end
    end

    local function SkinText(castBar)
        local text = castBar.Text
        if not text then
            return
        end

        text:SetFont(mUI.db.profile.general.fontpath, TEXT_SIZE, "OUTLINE, SLUG")
        text:SetJustifyH("CENTER")

        text:ClearAllPoints()
        text:SetPoint("TOPLEFT", castBar, "TOPLEFT", -TEXT_PADDING, 0)
        text:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", TEXT_PADDING, 0)
    end

    local function SkinSpark(castBar)
        if castBar.Spark then
            castBar.Spark:SetSize(4, Castbar.db.size.castheight or 10)
        end
    end

    local function ReapplyStyle(unitFrame)
        if not Castbar:IsEnabled() or issecretvalue(unitFrame) then
            return
        end
        if not unitFrame.unit or unitFrame:IsForbidden() then
            return
        end

        if Castbar.Core:Safe(UnitIsUnit(unitFrame.unit, "player"), false) then
            return
        end

        local container = unitFrame.CastBarsContainer
        local castBar = container and container.castBar
        if not castBar then
            return
        end

        SkinBackground(castBar)
        SkinText(castBar)
        SkinSpark(castBar)
    end

    function Castbar:InstallHooks()
        if not Castbar:IsHooked(NamePlateUnitFrameMixin, "UpdateAnchors") then
            Castbar:SecureHook(NamePlateUnitFrameMixin, "UpdateAnchors", ReapplyStyle)
        end
    end

    local function ShouldHide(plate)
        local data = Castbar.Core:GetData(plate:GetParent())
        return data and data.isFriend and data.isPlayer and not data.canAttack and Castbar.db.friendly.hidehealthbar
    end

    local function ApplyCastbar(plate)
        if not Castbar:IsEnabled() or not plate then
            return
        end

        local castBar, container, frame = GetCastBar(plate)
        if not castBar or not container or not frame then
            return
        end

        if ShouldHide(plate) then
            castBar:Hide()
            return
        end

        local uninterruptible = IsUninterruptible(plate)

        SkinBackground(castBar)
        SkinIcon(castBar)
        SkinShield(castBar, uninterruptible)
        SkinText(castBar)
        SkinSpark(castBar)
    end

    local function HookCastBar(plate)
        local castBar = GetCastBar(plate)
        if not castBar or Castbar:IsHooked(castBar, "OnEvent") then
            return
        end

        Castbar:SecureHookScript(castBar, "OnEvent", function()
            ApplyCastbar(plate)
        end)
    end

    Castbar.handler = {}

    function Castbar.handler.Create(plate)
        local watcher = CreateFrame("Frame", nil, plate)
        watcher:SetScript("OnEvent", function()
            RunNextFrame(function()
                ApplyCastbar(plate)
            end)
        end)

        plate.CastWatcher = watcher
    end

    function Castbar.handler.Update(plate, data)
        if not plate.CastWatcher then
            Castbar.handler.Create(plate)
        end

        HookCastBar(plate)

        local watcher = plate.CastWatcher
        if watcher then
            watcher:UnregisterAllEvents()
            for i = 1, #CAST_EVENTS do
                watcher:RegisterUnitEvent(CAST_EVENTS[i], data.unit)
            end
        end

        ApplyCastbar(plate)
    end

    function Castbar.handler.Layout(plate)
        ApplyCastbar(plate)
    end

    function Castbar.handler.Remove(plate)
        if plate.CastWatcher then
            plate.CastWatcher:UnregisterAllEvents()
        end
    end

    function Castbar:Update()
        Castbar.Core:ForEach(ApplyCastbar)

        local Health = mUI:GetModule("mUI.Modules.Nameplates.Health", true)
        if Health and Health:IsEnabled() then
            Health:Update()
        end
    end
end

function Castbar:OnEnable()
    Castbar.db = mUI.db.profile.nameplates
    Castbar:InstallHooks()
    Castbar.Core:Register("Castbar", Castbar.handler)
end

function Castbar:OnDisable()
    Castbar.Core:Unregister("Castbar")
    Castbar:UnhookAll()
end
