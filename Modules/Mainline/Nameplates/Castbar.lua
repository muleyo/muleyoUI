local Castbar = mUI:NewModule("mUI.Modules.Nameplates.Castbar", "AceHook-3.0")

function Castbar:OnInitialize()
    -- Load Database
    Castbar.db = mUI.db.profile.nameplates

    Castbar.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Castbar.Theme = mUI:GetModule("mUI.Modules.General.Theme")

    -- The moments Blizzard re-applies its own sizing.
    local CAST_EVENTS = {"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_EMPOWER_START"}

    local function GetCastBar(plate)
        local namePlate = plate:GetParent()
        local frame = namePlate and namePlate.UnitFrame
        local container = frame and frame.CastBarsContainer
        return container and container.castBar, container, frame
    end

    -- Skinning ----------------------------------------------------------------

    local function SkinBackground(castBar)
        if not castBar.Background then
            return
        end

        local color = mUI:Color(0.15)
        castBar.Background:SetVertexColor(color[1], color[2], color[3], color[4])
    end

    local ICON_SIZE = 16
    local TEXT_SIZE = 12
    local TEXT_PADDING = 4

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

            hooksecurefunc(icon, "SetTexture", function(_, tex)
                texture:SetTexture(tex)
            end)
            hooksecurefunc(icon, "Show", function()
                iconFrame:Show()
            end)
            hooksecurefunc(icon, "Hide", function()
                iconFrame:Hide()
            end)
            hooksecurefunc(icon, "SetShown", function(_, shown)
                iconFrame:SetShown(shown)
            end)

            local currentTexture = icon:GetTexture()
            if currentTexture then
                texture:SetTexture(currentTexture)
            end
            iconFrame:SetShown(icon:IsShown())

            castBar.iconFrame = iconFrame
        end

        local iconFrame = castBar.iconFrame
        iconFrame:ClearAllPoints()
        iconFrame:SetSize(ICON_SIZE, ICON_SIZE)
        iconFrame:SetPoint("CENTER", castBar, "LEFT", -15, 0)
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

            castBar.shieldFrame = shieldFrame
        end

        local shieldFrame = castBar.shieldFrame
        shieldFrame:ClearAllPoints()
        shieldFrame:SetPoint("CENTER", castBar, "LEFT", -15, 0)
        shieldFrame:Show()
        shieldFrame:SetSize(ICON_SIZE, ICON_SIZE)

        if uninterruptible ~= nil then
            shieldFrame:SetAlphaFromBoolean(uninterruptible, 1, 0)
        end
    end

    local function SkinText(castBar)
        local text = castBar.Text
        if not text then
            return
        end

        text:SetFont(mUI.db.profile.general.fontpath, TEXT_SIZE, "OUTLINE")

        text:ClearAllPoints()
        if castBar.iconFrame then
            text:SetPoint("LEFT", castBar.iconFrame, "RIGHT", TEXT_PADDING, 0)
        else
            text:SetPoint("LEFT", castBar, "LEFT", TEXT_PADDING, 0)
        end
        text:SetPoint("RIGHT", castBar, "RIGHT", -TEXT_PADDING, 0)
    end

    local function ShouldHide(plate)
        local data = Castbar.Core:GetData(plate:GetParent())
        return data and data.isFriend and data.isPlayer and Castbar.db.friendly.hidehealthbar
    end

    local function ApplySize(plate)
        local castBar, container, frame = GetCastBar(plate)
        if not castBar or not container or not frame then
            return
        end

        if ShouldHide(plate) then
            castBar:Hide()
            return
        end

        local config = Castbar.db.size

        castBar:SetHeight(config.castheight)

        local anchorTo = plate.Health or frame
        container:ClearAllPoints()
        container:SetPoint("TOP", anchorTo, "BOTTOM", 0, -Castbar.db.castbar.y)
        container:SetWidth(config.castwidth)

        SkinBackground(castBar)
        SkinIcon(castBar)
        SkinShield(castBar, IsUninterruptible(plate))
        SkinText(castBar)
    end

    -- Cast bars are pooled with their UnitFrame, so each is only hooked once.
    Castbar.hooked = setmetatable({}, {
        __mode = "k"
    })

    local function HookCastBar(plate)
        local castBar = GetCastBar(plate)
        if not castBar or Castbar.hooked[castBar] then
            return
        end

        Castbar.hooked[castBar] = true
        castBar:HookScript("OnEvent", function()
            ApplySize(plate)
        end)
    end

    local function WatchHealthContainer(plate)
        if plate.CastResizeWatcher then
            return
        end

        local _, _, frame = GetCastBar(plate)
        if not frame or not frame.HealthBarsContainer then
            return
        end

        local watcher = CreateFrame("Frame", nil, plate)
        watcher:SetAllPoints(frame.HealthBarsContainer)
        watcher:SetScript("OnSizeChanged", function()
            ApplySize(plate)
        end)

        plate.CastResizeWatcher = watcher
    end

    Castbar.handler = {}

    function Castbar.handler.Create(plate)
        local watcher = CreateFrame("Frame", nil, plate)
        watcher:SetScript("OnEvent", function()
            RunNextFrame(function()
                ApplySize(plate)
            end)
        end)

        plate.CastWatcher = watcher
    end

    function Castbar.handler.Update(plate, data)
        if not plate.CastWatcher then
            Castbar.handler.Create(plate)
        end

        HookCastBar(plate)
        WatchHealthContainer(plate)

        local watcher = plate.CastWatcher
        if watcher then
            watcher:UnregisterAllEvents()
            for i = 1, #CAST_EVENTS do
                watcher:RegisterUnitEvent(CAST_EVENTS[i], data.unit)
            end
        end

        ApplySize(plate)
    end

    function Castbar.handler.Layout(plate)
        ApplySize(plate)

        RunNextFrame(function()
            ApplySize(plate)
        end)
    end

    function Castbar.handler.Remove(plate)
        if plate.CastWatcher then
            plate.CastWatcher:UnregisterAllEvents()
        end
    end

    function Castbar:Update()
        Castbar.Core:ForEach(ApplySize)
    end
end

function Castbar:OnEnable()
    Castbar.db = mUI.db.profile.nameplates
    Castbar.Core:Register("Castbar", Castbar.handler)
end

function Castbar:OnDisable()
    Castbar.Core:Unregister("Castbar")
end
