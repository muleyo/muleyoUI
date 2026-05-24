local RF_Auras = mUI:NewModule("mUI.Modules.Unitframes.RF_Auras", "AceHook-3.0")

-- AuraUtil.ForEachAura -> C_UnitAuras.GetAuraSlots errors on any compound
-- unit token (e.g. boss1targetpet, partypet1target). Compact party/raid
-- frames legitimately only ever display these simple tokens; anything else
-- (compound forms, boss/arena/nameplate, vehicle re-bindings from other
-- addons, etc.) is skipped rather than passed through.
local function isSimpleRaidUnit(unit)
    if not unit then
        return false
    end
    return unit == "player"
        or unit == "pet"
        or unit:match("^party%d+$") ~= nil
        or unit:match("^partypet%d+$") ~= nil
        or unit:match("^raid%d+$") ~= nil
        or unit:match("^raidpet%d+$") ~= nil
end

function RF_Auras:OnInitialize()
    local LCG = LibStub("LibCustomGlow-1.0")
    local GLOW_KEY = "mUI_RF_Dispel"

    RF_Auras.trackedFrames = RF_Auras.trackedFrames or {}

    function RF_Auras:Track(frame)
        if frame and not frame:IsForbidden() then
            RF_Auras.trackedFrames[frame] = true
        end
    end

    function RF_Auras:UpdateFrame(frame)
        if not frame or frame:IsForbidden() or not frame.unit then
            return
        end

        local unit = frame.displayedUnit or frame.unit
        if not isSimpleRaidUnit(unit) then
            return
        end

        -- Hide glow for units we can't observe: in a different phase/shard
        -- or out of visible range. Their aura data is stale because UNIT_AURA
        -- no longer fires for them. Disconnected players still in-world stay
        -- visible since they can still be healed/dispelled.
        local unreachable = (UnitPhaseReason and UnitPhaseReason(unit) ~= nil) or (UnitIsVisible and not UnitIsVisible(unit))
        if unreachable then
            LCG.PixelGlow_Stop(frame, GLOW_KEY)
            return
        end

        local colorCurve = RF_Auras.Theme and RF_Auras.Theme.colorCurve
        local glowR, glowG, glowB

        if unit then
            AuraUtil.ForEachAura(unit, "HARMFUL|RAID_PLAYER_DISPELLABLE", nil, function(aura)
                if colorCurve then
                    local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorCurve)
                    if color then
                        glowR, glowG, glowB = color.r, color.g, color.b
                    end
                end
                return true
            end, true)
        end

        if glowR then
            LCG.PixelGlow_Start(frame, {glowR, glowG, glowB, 1}, 8, 0.25, nil, 2, 0, 0, false, GLOW_KEY)
        else
            LCG.PixelGlow_Stop(frame, GLOW_KEY)
        end
    end

    function RF_Auras:UpdateFrameForUnit(unit)
        for frame in pairs(RF_Auras.trackedFrames) do
            if frame and not frame:IsForbidden() and (frame.unit == unit or frame.displayedUnit == unit) then
                RF_Auras:UpdateFrame(frame)
            end
        end
    end

    function RF_Auras:UpdateAllFrames()
        for frame in pairs(RF_Auras.trackedFrames) do
            if frame and not frame:IsForbidden() and frame.unit then
                RF_Auras:UpdateFrame(frame)
            end
        end
    end
end

local function isCompactFrame(frame)
    local name = frame and frame:GetName()
    if not name then
        return false
    end
    return name:match("^CompactPartyFrameMember")
        or name:match("^CompactRaidFrame%d")
        or name:match("^CompactRaidGroup%d+Member%d") ~= nil
end

function RF_Auras:OnEnable()
    RF_Auras.Theme = mUI:GetModule("mUI.Modules.General.Theme", true)

    RF_Auras:SecureHook("DefaultCompactUnitFrameSetup", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            RF_Auras:Track(frame)
            RF_Auras:UpdateFrame(frame)
        end
    end)

    RF_Auras:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        if not frame or frame:IsForbidden() then
            return
        end
        if isCompactFrame(frame) then
            RF_Auras:Track(frame)
            RF_Auras:UpdateFrame(frame)
        end
    end)

    if not RF_Auras.eventFrame then
        RF_Auras.eventFrame = CreateFrame("Frame")
        RF_Auras.eventFrame:SetScript("OnEvent", function(_, event, unit)
            if (event == "UNIT_AURA" or event == "UNIT_PHASE" or event == "UNIT_FLAGS") and unit then
                RF_Auras:UpdateFrameForUnit(unit)
            else
                C_Timer.After(0, function()
                    RF_Auras:UpdateAllFrames()
                end)
            end
        end)
    end

    RF_Auras.eventFrame:RegisterEvent("UNIT_AURA")
    RF_Auras.eventFrame:RegisterEvent("UNIT_PHASE")
    RF_Auras.eventFrame:RegisterEvent("UNIT_FLAGS")
    RF_Auras.eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    RF_Auras.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    -- Visibility (UnitIsVisible) doesn't fire a dedicated event, so poll on
    -- our own (insecure) frame to avoid tainting Blizzard's range-update path.
    if not RF_Auras.visibilityTicker then
        RF_Auras.visibilityTicker = C_Timer.NewTicker(0.5, function()
            for frame in pairs(RF_Auras.trackedFrames) do
                if frame and not frame:IsForbidden() and frame.unit then
                    local u = frame.displayedUnit or frame.unit
                    local visible = UnitIsVisible and UnitIsVisible(u)
                    if frame.mUI_RFA_lastVisible ~= visible then
                        frame.mUI_RFA_lastVisible = visible
                        RF_Auras:UpdateFrame(frame)
                    end
                end
            end
        end)
    end

    C_Timer.After(0, function()
        RF_Auras:UpdateAllFrames()
    end)
end

function RF_Auras:OnDisable()
    RF_Auras:UnhookAll()
    if RF_Auras.eventFrame then
        RF_Auras.eventFrame:UnregisterAllEvents()
    end
    if RF_Auras.visibilityTicker then
        RF_Auras.visibilityTicker:Cancel()
        RF_Auras.visibilityTicker = nil
    end

    local LCG = LibStub("LibCustomGlow-1.0")
    for frame in pairs(RF_Auras.trackedFrames) do
        if frame and not frame:IsForbidden() then
            LCG.PixelGlow_Stop(frame, "mUI_RF_Dispel")
        end
    end
end
