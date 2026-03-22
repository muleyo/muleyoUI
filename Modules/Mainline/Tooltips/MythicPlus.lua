local MythicPlus = mUI:NewModule("mUI.Tooltips.MythicPlus", "AceHook-3.0")

function MythicPlus:OnInitialize()
    MythicPlus.db = mUI.db.profile.tooltips

    local RATING_COLOR_THRESHOLDS = {{
        rating = 0,
        r = 0.62,
        g = 0.62,
        b = 0.62
    }, {
        rating = 500,
        r = 0.12,
        g = 1.00,
        b = 0.00
    }, {
        rating = 1000,
        r = 0.00,
        g = 0.44,
        b = 0.87
    }, {
        rating = 1500,
        r = 0.64,
        g = 0.21,
        b = 0.93
    }, {
        rating = 2000,
        r = 1.00,
        g = 0.50,
        b = 0.00
    }, {
        rating = 2500,
        r = 0.95,
        g = 0.55,
        b = 0.27
    }}

    function MythicPlus:GetRatingColor(rating)
        if C_ChallengeMode and C_ChallengeMode.GetDungeonScoreRarityColor then
            local color = C_ChallengeMode.GetDungeonScoreRarityColor(rating)
            if color then
                return color.r, color.g, color.b
            end
        end

        local r, g, b = RATING_COLOR_THRESHOLDS[1].r, RATING_COLOR_THRESHOLDS[1].g, RATING_COLOR_THRESHOLDS[1].b
        for i = #RATING_COLOR_THRESHOLDS, 1, -1 do
            if rating >= RATING_COLOR_THRESHOLDS[i].rating then
                r, g, b = RATING_COLOR_THRESHOLDS[i].r, RATING_COLOR_THRESHOLDS[i].g, RATING_COLOR_THRESHOLDS[i].b
                break
            end
        end
        return r, g, b
    end

    function MythicPlus:OnTooltipSetPlayer(frame, guid)
        if not frame or frame ~= _G.GameTooltip then
            return
        end

        local unit = UnitTokenFromGUID(guid)
        if not unit then
            return
        end

        local profile = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
        if not profile then
            return
        end

        local rating = profile.currentSeasonScore or 0
        if rating <= 0 then
            return
        end

        local r, g, b = MythicPlus:GetRatingColor(rating)
        GameTooltip:AddDoubleLine("|cff0099ffMythic+ Rating|r", ("|cff%02x%02x%02x%d|r"):format(r * 255, g * 255, b * 255, rating))
    end
end

function MythicPlus:OnEnable()
    if not MythicPlus.hooked then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(frame, data)
            if not MythicPlus.db.mythicplus then
                return
            end

            local _, isPlayer = GetPlayerInfoByGUID(data.guid)
            if isPlayer then
                xpcall(MythicPlus.OnTooltipSetPlayer, nop, MythicPlus, frame, data.guid)
            end
        end)
        MythicPlus.hooked = true
    end
end

function MythicPlus:OnDisable()
    MythicPlus:UnhookAll()
end
