local Navigation = mUI:NewModule("mUI.Modules.Misc.Navigation", "AceHook-3.0")

local INVALID = Enum.NavigationState and Enum.NavigationState.Invalid or 0
local IN_RANGE = Enum.NavigationState and Enum.NavigationState.InRange or 2

local reportInRange = false
local getTargetState

-- The client reports Invalid for waypoints and the marker fades out for it
local function InstallStateFix()
    if getTargetState or not (C_Navigation and C_Navigation.GetTargetState) then
        return
    end

    getTargetState = C_Navigation.GetTargetState
    C_Navigation.GetTargetState = function(...)
        local state = getTargetState(...)
        if reportInRange and state == INVALID then
            return IN_RANGE
        end
        return state
    end
end

local look

local function CreateLook()
    local frame = SuperTrackedFrame
    look = {}

    look.label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    look.label:SetPoint("TOP", frame.Icon, "BOTTOM", 0, -6)
end

local function LabelText()
    local types = Enum.SuperTrackingType
    local kind = C_SuperTrack.GetHighestPrioritySuperTrackingType()

    if kind == types.UserWaypoint then
        return MAP_PIN or "Map Pin"
    elseif kind == types.Quest then
        local questID = C_SuperTrack.GetSuperTrackedQuestID()
        return questID and questID ~= 0 and C_QuestLog.GetTitleForQuestID(questID) or ""
    elseif kind == types.Corpse then
        return CORPSE or ""
    elseif kind == types.PartyMember then
        local unit = C_Navigation.GetNearestPartyMemberToken()
        return unit and UnitName(unit) or ""
    end

    return ""
end

local function UpdateLabel()
    -- Some of these APIs are restricted at times
    local ok, text = pcall(LabelText)
    look.label:SetText(ok and type(text) == "string" and text or "")
end

-- Only the arrow is shown at the screen edge
local function UpdateEdge(frame)
    look.label:SetShown(not frame.isClamped)
end

local function ApplyLook()
    local frame = SuperTrackedFrame
    if not (frame.Icon and frame.DistanceText and frame.CreateFontString) then
        return
    end

    if not look then
        CreateLook()
    end

    look.distanceFont = look.distanceFont or frame.DistanceText:GetFontObject()
    frame.DistanceText:SetFontObject(GameFontHighlightSmall)
    frame.DistanceText:ClearAllPoints()
    frame.DistanceText:SetPoint("TOP", look.label, "BOTTOM", 0, -2)

    UpdateLabel()
    UpdateEdge(frame)

    if frame.UpdateIcon and not Navigation:IsHooked(frame, "UpdateIcon") then
        Navigation:SecureHook(frame, "UpdateIcon", UpdateLabel)
    end
    if frame.UpdateClampedState and not Navigation:IsHooked(frame, "UpdateClampedState") then
        Navigation:SecureHook(frame, "UpdateClampedState", UpdateEdge)
    end
end

local function RemoveLook()
    if not look then
        return
    end

    look.label:Hide()

    local frame = SuperTrackedFrame
    if look.distanceFont then
        frame.DistanceText:SetFontObject(look.distanceFont)
    end
    frame.DistanceText:ClearAllPoints()
    frame.DistanceText:SetPoint("TOP", frame.Icon, "BOTTOM", 0, -8)
end

local function Hide()
    SuperTrackedFrame:Hide()
end

local function ShowAgain()
    -- Its init didn't run while hidden
    if SuperTrackedFrame.CheckInitializeNavigationFrame then
        SuperTrackedFrame:CheckInitializeNavigationFrame()
    end
    SuperTrackedFrame:SetShown(SuperTrackedFrame.navFrame ~= nil)
end

function Navigation:Apply()
    if not SuperTrackedFrame then
        return
    end

    local db = mUI.db.profile.misc

    reportInRange = not db.hidenavigation
    if reportInRange then
        InstallStateFix()
    end

    Navigation:UnhookAll()

    if db.hidenavigation then
        RemoveLook()
        Hide()

        -- The game shows it again on its own
        Navigation:SecureHook(SuperTrackedFrame, "Show", Hide)
        Navigation:SecureHook(SuperTrackedFrame, "SetShown", Hide)
    else
        ShowAgain()
        ApplyLook()
    end
end

function Navigation:OnEnable()
    Navigation:Apply()
end

function Navigation:OnDisable()
    reportInRange = false
    Navigation:UnhookAll()

    if SuperTrackedFrame then
        RemoveLook()
        ShowAgain()
    end
end
