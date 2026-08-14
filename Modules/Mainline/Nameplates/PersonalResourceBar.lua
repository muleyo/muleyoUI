local PersonalResourceBar = mUI:NewModule("mUI.Modules.Nameplates.PersonalResourceBar", "AceEvent-3.0", "AceHook-3.0")

function PersonalResourceBar:OnInitialize()
    -- Load Database
    PersonalResourceBar.db = mUI.db.profile.nameplates

    PersonalResourceBar.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    local Core = PersonalResourceBar.Core

    local ANCHORS = {
        TOP = {"BOTTOM", "TOP", 1, 1},
        BOTTOM = {"TOP", "BOTTOM", 1, -1},
        LEFT = {"RIGHT", "LEFT", -1, 1},
        RIGHT = {"LEFT", "RIGHT", 1, 1}
    }

    local classResourceYOffsets = {
        PALADIN = 4,
        DEATHKNIGHT = -3,
        MAGE = -4,
        MONK = -4,
        DRUID = -4,
        ROGUE = -4,
        WARLOCK = 0,
        EVOKER = -1
    }

    local playerClass = select(2, UnitClass("player"))

    function PersonalResourceBar:FixRogue()
        local xOfs = 0
        if playerClass == "ROGUE" then
            local maxComboPoints = RogueComboPointBarFrame.maxUsablePoints
            if maxComboPoints == 7 then
                xOfs = xOfs + 20
            elseif maxComboPoints == 6 then
                xOfs = xOfs + 10
            end
        end

        return xOfs
    end

    function PersonalResourceBar:Reposition()
        local config = PersonalResourceBar.db.personalresource
        if not config.enabled then
            return
        end

        local frame = PersonalResourceDisplayFrame
        local classFrame = frame and frame.classFrame
        if not classFrame then
            return
        end

        local plate = Core:GetPlateForUnit("target")
        local health = plate and Core:GetHealthBar(plate)

        classFrame:ClearAllPoints()
        if health then
            local anchor = ANCHORS[config.anchor] or ANCHORS.TOP
            local point, relativePoint, xSign, ySign = anchor[1], anchor[2], anchor[3], anchor[4]
            local xOfs = config.x * xSign + PersonalResourceBar:FixRogue()
            local yOfs = (config.y + (classResourceYOffsets[playerClass] or 0)) * ySign
            classFrame:SetPoint(point, health, relativePoint, xOfs, yOfs)
        else
            classFrame:SetPoint("CENTER", frame.ClassFrameContainer, "CENTER")
        end
    end

    function PersonalResourceBar:Apply()
        C_CVar.SetCVar("nameplateShowSelf", "1")

        local frame = PersonalResourceDisplayFrame
        frame:SetHideHealth(true)
        frame:SetHidePower(true)
        frame:SetHideAltPower(true)
        frame:SetHideClassInfo(false)

        if not PersonalResourceBar:IsHooked(frame, "UpdateAdditionalBarAnchors") then
            PersonalResourceBar:SecureHook(frame, "UpdateAdditionalBarAnchors", "Reposition")
        end

        PersonalResourceBar:Reposition()
    end

    function PersonalResourceBar:Update()
        PersonalResourceBar:Apply()
    end
end

function PersonalResourceBar:OnEnable()
    PersonalResourceBar.db = mUI.db.profile.nameplates

    PersonalResourceBar:RegisterEvent("PLAYER_TARGET_CHANGED", "Reposition")
    PersonalResourceBar:RegisterEvent("NAME_PLATE_UNIT_ADDED", "Reposition")
    PersonalResourceBar:RegisterEvent("NAME_PLATE_UNIT_REMOVED", "Reposition")

    PersonalResourceBar:Apply()
end

function PersonalResourceBar:OnDisable()
    PersonalResourceBar:UnregisterAllEvents()
end
