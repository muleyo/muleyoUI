local QuestAnnounce = mUI:NewModule("mUI.Modules.Misc.QuestAnnounce", "AceEvent-3.0")

-- Quest data is still being delivered for a moment after a loading screen, objectives look unfinished until then
local LOADING_GRACE = 5

function QuestAnnounce:OnInitialize()
    -- questID = { finished = { [objective] = bool }, announced = { [objective] = true } }
    QuestAnnounce.quests = {}
    QuestAnnounce.silentUntil = 0

    function QuestAnnounce:GetChannel()
        if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            return "INSTANCE_CHAT"
        elseif IsInRaid() then
            return "RAID"
        elseif IsInGroup() then
            return "PARTY"
        end
    end

    function QuestAnnounce:Announce(questID, title, objective)
        local channel = QuestAnnounce:GetChannel()
        if not channel then
            return
        end
        if C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown() then
            return
        end

        local link = GetQuestLink(questID) or title
        SendChatMessage("{rt1} mUI: " .. objective .. " of Quest " .. link .. " completed!", channel)
    end

    -- Compares the objectives of a quest with the last known state. Objectives of quests we have not seen yet are only remembered,
    -- they have not been completed just now.
    function QuestAnnounce:CheckQuest(questID, title, announce)
        local objectives = C_QuestLog.GetQuestObjectives(questID)
        if not objectives then
            return
        end

        local quest = QuestAnnounce.quests[questID]
        local isNew = quest == nil
        if isNew then
            quest = { finished = {}, announced = {} }
            QuestAnnounce.quests[questID] = quest
        end

        for index, objective in ipairs(objectives) do
            local finished = objective.finished and true or false

            if announce and not isNew and finished and quest.finished[index] == false and not quest.announced[index] and
                objective.text and objective.text ~= "" then
                -- Items can be dropped and picked up again, announce every objective once
                quest.announced[index] = true
                QuestAnnounce:Announce(questID, title, objective.text)
            end

            quest.finished[index] = finished
        end
    end

    function QuestAnnounce:Scan()
        local announce = GetTime() >= QuestAnnounce.silentUntil
        local current = {}

        for index = 1, C_QuestLog.GetNumQuestLogEntries() do
            local info = C_QuestLog.GetInfo(index)
            if info and not info.isHeader and not info.isHidden and info.questID then
                current[info.questID] = true
                QuestAnnounce:CheckQuest(info.questID, info.title, announce)
            end
        end

        -- Forget quests that left the log
        for questID in pairs(QuestAnnounce.quests) do
            if not current[questID] then
                QuestAnnounce.quests[questID] = nil
            end
        end
    end

    function QuestAnnounce:OnLoadingScreen()
        QuestAnnounce.silentUntil = GetTime() + LOADING_GRACE
    end

    function QuestAnnounce:OnUnitQuestLogChanged(_, unit)
        if unit == "player" then
            QuestAnnounce:Scan()
        end
    end
end

function QuestAnnounce:OnEnable()
    QuestAnnounce.quests = {}
    QuestAnnounce.silentUntil = GetTime() + LOADING_GRACE

    QuestAnnounce:RegisterEvent("PLAYER_ENTERING_WORLD", "OnLoadingScreen")
    QuestAnnounce:RegisterEvent("QUEST_LOG_UPDATE", "Scan")
    QuestAnnounce:RegisterEvent("QUEST_WATCH_UPDATE", "Scan")
    QuestAnnounce:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "OnUnitQuestLogChanged")

    -- Remember the current state (silently, see above) so later changes can be compared against it
    QuestAnnounce:Scan()
end

function QuestAnnounce:OnDisable()
    QuestAnnounce:UnregisterAllEvents()
    QuestAnnounce.quests = {}
end
