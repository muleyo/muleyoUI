local PvPRating = mUI:NewModule("mUI.Tooltips.PvPRating", "AceEvent-3.0")

local CACHE_DURATION = 300
local REQUEST_COOLDOWN = 10

function PvPRating:OnInitialize()
    PvPRating.db = mUI.db.profile.tooltips
    PvPRating.cache = {}
    PvPRating.lastRequest = {}

    local RATING_COLOR_THRESHOLDS = {{
        rating = 0,
        r = 0.62,
        g = 0.62,
        b = 0.62
    }, {
        rating = 1000,
        r = 0.12,
        g = 1.00,
        b = 0.00
    }, {
        rating = 1400,
        r = 0.00,
        g = 0.44,
        b = 0.87
    }, {
        rating = 1800,
        r = 0.64,
        g = 0.21,
        b = 0.93
    }, {
        rating = 2100,
        r = 1.00,
        g = 0.50,
        b = 0.00
    }, {
        rating = 2400,
        r = 0.95,
        g = 0.55,
        b = 0.27
    }}

    function PvPRating:GetRatingColor(rating)
        local r, g, b = RATING_COLOR_THRESHOLDS[1].r, RATING_COLOR_THRESHOLDS[1].g, RATING_COLOR_THRESHOLDS[1].b
        for i = #RATING_COLOR_THRESHOLDS, 1, -1 do
            if rating >= RATING_COLOR_THRESHOLDS[i].rating then
                r, g, b = RATING_COLOR_THRESHOLDS[i].r, RATING_COLOR_THRESHOLDS[i].g, RATING_COLOR_THRESHOLDS[i].b
                break
            end
        end
        return r, g, b
    end

    function PvPRating:AddLines(tooltip, ratings)
        local brackets = {{"Solo Shuffle", ratings.solo}, {"2v2 Rating", ratings.v2}, {"3v3 Rating", ratings.v3}}
        for _, bracket in ipairs(brackets) do
            local label, rating = bracket[1], bracket[2]
            if rating and rating > 0 then
                local r, g, b = PvPRating:GetRatingColor(rating)
                tooltip:AddDoubleLine("|cff0099ff" .. label .. "|r", ("|cff%02x%02x%02x%d|r"):format(r * 255, g * 255, b * 255, rating))
            end
        end
    end

    function PvPRating:GetPersonalRatings()
        local solo = GetPersonalRatedInfo(7)
        local v2 = GetPersonalRatedInfo(1)
        local v3 = GetPersonalRatedInfo(2)
        return {
            solo = solo or 0,
            v2 = v2 or 0,
            v3 = v3 or 0
        }
    end

    function PvPRating:RequestRatings(unit, guid)
        if PvPRating.pending == guid then
            return
        end
        local now = GetTime()
        if PvPRating.lastRequest[guid] and now - PvPRating.lastRequest[guid] < REQUEST_COOLDOWN then
            return
        end
        if InspectFrame and InspectFrame:IsShown() then
            return
        end
        if not CanInspect(unit) then
            return
        end

        PvPRating.lastRequest[guid] = now
        PvPRating.pending = guid
        PvPRating:RegisterEvent("INSPECT_READY")
        NotifyInspect(unit)
    end

    function PvPRating:INSPECT_READY(_, guid)
        -- A secret guid can't be compared under tainted execution (throws), and
        -- our pending/shownGuid are only ever set to non-secret guids, so bail.
        if issecretvalue and issecretvalue(guid) then
            return
        end
        if guid ~= PvPRating.pending then
            return
        end
        PvPRating.pending = nil
        PvPRating:UnregisterEvent("INSPECT_READY")

        local v2 = GetInspectArenaData(1)
        local v3 = GetInspectArenaData(2)
        local solo = 0
        local soloData = C_PaperDollInfo and C_PaperDollInfo.GetInspectRatedSoloShuffleData and C_PaperDollInfo.GetInspectRatedSoloShuffleData()
        if soloData then
            solo = soloData.rating or soloData.personalRating or 0
        end

        local ratings = {
            solo = solo,
            v2 = v2 or 0,
            v3 = v3 or 0,
            time = GetTime()
        }
        PvPRating.cache[guid] = ratings

        if GameTooltip:IsShown() and PvPRating.shownGuid == guid then
            PvPRating:AddLines(GameTooltip, ratings)
            GameTooltip:Show()
        end
    end

    function PvPRating:OnTooltipSetPlayer(frame, guid)
        if not frame or frame ~= _G.GameTooltip then
            return
        end

        local unit = UnitTokenFromGUID(guid)
        if not unit then
            return
        end

        PvPRating.shownGuid = guid

        if UnitIsUnit(unit, "player") then
            PvPRating:AddLines(frame, PvPRating:GetPersonalRatings())
            return
        end

        local cached = PvPRating.cache[guid]
        if cached and GetTime() - cached.time < CACHE_DURATION then
            PvPRating:AddLines(frame, cached)
            return
        end

        PvPRating:RequestRatings(unit, guid)
    end
end

function PvPRating:OnEnable()
    if not PvPRating.hooked then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(frame, data)
            if not PvPRating.db.pvprating or not PvPRating:IsEnabled() then
                return
            end

            if not data or data.guid == nil or (issecretvalue and issecretvalue(data.guid)) then
                return
            end

            local _, isPlayer = GetPlayerInfoByGUID(data.guid)
            if isPlayer then
                xpcall(PvPRating.OnTooltipSetPlayer, nop, PvPRating, frame, data.guid)
            end
        end)
        PvPRating.hooked = true
    end
end

function PvPRating:OnDisable()
    PvPRating:UnregisterEvent("INSPECT_READY")
    PvPRating.pending = nil
end
