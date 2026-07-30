local Health = mUI:NewModule("mUI.Modules.Nameplates.Health", "AceEvent-3.0")

function Health:OnInitialize()
    -- Load Database
    Health.db = mUI.db.profile.nameplates

    Health.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Health.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")
    Health.LSM = LibStub("LibSharedMedia-3.0")

    local Core = Health.Core
    local Units = Health.Units

    local function DisplayName(data)
        if data.isPlayer and data.isEnemy then
            local config = Health.db.names

            local arena = config.arena and Units:GetArenaIndex(data)

            local info = config.spec and Units:GetSpecInfo(Units:GetSpecID(data))
            local spec = info and info.name

            if spec and arena then
                return spec .. " " .. arena, true
            elseif spec then
                return spec, true
            elseif arena then
                return tostring(arena), true
            end
        end

        return data.displayName, false
    end

    local function HideFriendlyBar(data)
        return data.isFriend and data.isPlayer and Health.db.friendly.hidehealthbar
    end

    Health.HideFriendlyBar = HideFriendlyBar

    local FOCUS_TEXTURE = [[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]]

    local function BarTexture(data)
        if data and data.isFocus and Health.db.focus then
            return FOCUS_TEXTURE
        end

        local name = Health.db.texture
        if name and name ~= "None" then
            local fetched = Health.LSM:Fetch("statusbar", name, true)
            if fetched then
                return fetched
            end
        end
        return [[Interface\Buttons\WHITE8X8]]
    end

    Health.handler = {}

    function Health.handler.Create(plate)
        local bar = CreateFrame("StatusBar", nil, plate)
        bar:SetStatusBarTexture(BarTexture())
        bar:SetFrameLevel(plate:GetFrameLevel() + 1)

        local background = bar:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints(bar)
        background:SetColorTexture(0, 0, 0, 0.6)
        bar.background = background

        bar.border = Core:CreateBorder(bar, bar)

        local name = plate:CreateFontString(nil, "OVERLAY")
        name:SetFontObject("SystemFont_NamePlate_Outlined")
        name:SetWordWrap(false)

        local percent = bar:CreateFontString(nil, "OVERLAY")
        percent:SetFontObject("SystemFont_NamePlate_Outlined")
        percent:SetWordWrap(false)
        percent:Hide()
        bar.percent = percent

        bar.plate = plate
        bar:SetScript("OnEvent", Health.OnBarEvent)

        plate.Health = bar
        plate.Name = name
    end

    -- Color ---------------------------------------------------------------

    local function BarColor(data)
        local classcolor = data.isFriend and Health.db.friendly.classcolor or (not data.isFriend and Health.db.classcolor)

        local classFile = data.isPlayer and classcolor and Units:GetClassFile(data)
        if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
                return color.r, color.g, color.b
            end
        end

        if data.isFriend and data.isPlayer then
            return 0.65, 0.65, 1
        elseif data.isFriend and not data.isPlayer then
            return 0.2, 0.8, 0.2
        elseif data.isNeutral then
            return 0.9, 0.8, 0.2
        end

        return 0.8, 0.2, 0.2
    end

    -- Values ---------------------------------------------------------------

    local HEALTH_PERCENT_CURVE = CurveConstants.ScaleTo100

    local function UpdateValues(plate, data)
        local bar = plate.Health
        if not bar then
            return
        end

        bar:SetMinMaxValues(0, UnitHealthMax(data.unit))
        bar:SetValue(UnitHealth(data.unit))

        local percent = bar.percent
        if not percent then
            return
        end

        if not Health.db.health.percent then
            percent:Hide()
            return
        end

        local pct = UnitHealthPercent(data.unit, true, HEALTH_PERCENT_CURVE)
        if pct then
            percent:SetFormattedText("%.0f%%", pct)
            percent:Show()
        else
            percent:Hide()
        end
    end

    Health.UpdateValues = UpdateValues

    local HEALTH_EVENTS = {"UNIT_HEALTH", "UNIT_MAXHEALTH", "UNIT_ABSORB_AMOUNT_CHANGED"}

    function Health.OnBarEvent(bar)
        local data = bar.plate and Health.Core:GetData(bar.plate:GetParent())
        if data and data.unit then
            UpdateValues(bar.plate, data)
        end
    end

    function Health.handler.Update(plate, data)
        local bar = plate.Health
        if not bar then
            return
        end

        -- Re-subscribe to whichever unit this pooled plate now belongs to.
        bar:UnregisterAllEvents()
        for i = 1, #HEALTH_EVENTS do
            bar:RegisterUnitEvent(HEALTH_EVENTS[i], data.unit)
        end

        local hideBar = HideFriendlyBar(data)
        bar:SetShown(not hideBar)

        bar:SetStatusBarTexture(BarTexture(data))
        bar:SetStatusBarColor(BarColor(data))
        local border = mUI:Color(0.15)
        bar.border:SetThickness(1)
        bar.border:SetBorderColor(border[1], border[2], border[3], border[4])

        UpdateValues(plate, data)

        local label, replaced
        label, replaced = DisplayName(data)
        plate.Name:SetText(label)

        -- Players only
        plate.Name:SetShown(not (hideBar or (data.isFriend and data.isPlayer and Health.db.friendly.hidenames)))
        local classcolor = replaced or (data.isFriend and Health.db.friendly.classcolor or (not data.isFriend and Health.db.classcolor))

        local classFile = Units:GetClassFile(data)
        local color = classFile and C_ClassColor.GetClassColor(classFile)
        if data.isPlayer and color and classcolor then
            plate.Name:SetTextColor(color.r, color.g, color.b)
        else
            plate.Name:SetTextColor(1, 1, 1)
        end
    end

    local ANCHORS = {
        LEFT = {"LEFT", "LEFT", 1, 1},
        RIGHT = {"RIGHT", "RIGHT", -1, 1},
        CENTER = {"CENTER", "CENTER", 1, 1},
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1}
    }

    function Health.handler.Layout(plate)
        local bar = plate.Health
        local percent = bar and bar.percent
        if not percent then
            return
        end

        local config = Health.db.health
        local anchor = ANCHORS[config.anchor] or ANCHORS.RIGHT
        local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]

        percent:ClearAllPoints()
        percent:SetPoint(point, bar, relativePoint, config.x * xSign, config.y * ySign)
        percent:SetFont(mUI.db.profile.general.fontpath, Health.db.name.size, "OUTLINE")
    end

    function Health.handler.Remove(plate)
        if plate.Health then
            plate.Health:UnregisterAllEvents()
        end
    end

    function Health:Update()
        Core:UpdateAll()
    end
end

function Health:OnEnable()
    Health.db = mUI.db.profile.nameplates
    Health.Core:Register("Health", Health.handler)
end

function Health:OnDisable()
    Health.Core:Unregister("Health")
end
