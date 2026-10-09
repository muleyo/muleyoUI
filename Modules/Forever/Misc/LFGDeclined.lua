local LFGDeclined = mUI:NewModule("mUI.Modules.Misc.LFGDeclined", "AceHook-3.0")

function LFGDeclined:OnInitialize()
    LFGDeclined.frame = CreateFrame("Frame")
    LFGDeclined.frame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")

    function LFGDeclined:GetSearchResultInfo(resultID)
        local searchResultInfo = securecallfunction(C_LFGList.GetSearchResultInfo, resultID)
        -- In rare cases such as when an application is full or rejected,
        -- C_LFGList.GetSearchResultInfo returns nil
        if not searchResultInfo then
            return nil
        end
        -- Copy the table so we don't taint the cached version
        local info = CopyTable(searchResultInfo)
        if info.activityIDs then
            info.activityID = info.activityIDs[1]
        end
        if info.leaderDungeonScoreInfo then
            info.leaderDungeonScoreInfo = info.leaderDungeonScoreInfo[1]
        end
        if info.leaderPvpRatingInfo then
            info.leaderPvpRatingInfo = info.leaderPvpRatingInfo[1]
        end
        return info
    end

    function LFGDeclined:GetGroupKey(searchResultInfo)
        if searchResultInfo.partyGUID then -- retail now provides a partyGUID
            return searchResultInfo.partyGUID
        elseif searchResultInfo.leaderName then -- leaderName is not available for very new groups
            return searchResultInfo.activityID .. searchResultInfo.leaderName
        else
            return nil
        end
    end

    function LFGDeclined:OnEvent(_, id, newStatus)
        local searchResultInfo = LFGDeclined:GetSearchResultInfo(id)
        if not searchResultInfo then
            return
        end
        local key = LFGDeclined:GetGroupKey(searchResultInfo)
        if newStatus == "declined" or newStatus == "declined_delisted" or newStatus == "declined_full" or newStatus == "timedout" then
            if not LFGListFrame.declines then
                LFGListFrame.declines = {}
            end
            LFGListFrame.declines[key] = nil
            securecallfunction(LFGListSearchPanel_UpdateResults, LFGListFrame.SearchPanel)
        end
    end
end

function LFGDeclined:OnEnable()
    LFGDeclined:SecureHookScript(LFGDeclined.frame, "OnEvent", LFGDeclined.OnEvent)
end

function LFGDeclined:OnDisable()
    LFGDeclined:UnhookAll()
end
