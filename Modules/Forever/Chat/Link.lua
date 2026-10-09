local Link = mUI:NewModule("mUI.Modules.Chat.Link", "AceHook-3.0")

-- Chat events whose messages may carry player-typed URLs.
local CHAT_EVENTS = {"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_EMOTE", "CHAT_MSG_TEXT_EMOTE", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER",
                     "CHAT_MSG_RAID", "CHAT_MSG_RAID_LEADER", "CHAT_MSG_RAID_WARNING", "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER",
                     "CHAT_MSG_GUILD", "CHAT_MSG_OFFICER", "CHAT_MSG_WHISPER", "CHAT_MSG_WHISPER_INFORM", "CHAT_MSG_BN_WHISPER",
                     "CHAT_MSG_BN_WHISPER_INFORM", "CHAT_MSG_BN_INLINE_TOAST_ALERT", "CHAT_MSG_CHANNEL", "CHAT_MSG_SYSTEM", "CHAT_MSG_AFK",
                     "CHAT_MSG_DND", "CHAT_MSG_COMMUNITIES_CHANNEL"}

function Link:OnInitialize()
    Link.URL_PATTERNS = {"(https://[^|%s]+%.[^|%s]+)", "(http://[^|%s]+%.[^|%s]+)", "(www%.[^|%s]+%.[^|%s]+)", "(%d+%.%d+%.%d+%.%d+:?%d*/?[^|%s]*)"}
    Link.URL_REPLACEMENT = "|cff0394ff|Hurl:%1|h[%1]|h|r"

    function Link:TransformURLs(msg)
        if canaccessvalue and not canaccessvalue(msg) then
            return msg
        end

        if type(msg) ~= "string" then
            return msg
        end

        -- Skip messages that already contain our URL hyperlinks
        if msg:find("|Hurl:") then
            return msg
        end

        for _, pattern in ipairs(Link.URL_PATTERNS) do
            local result, count = msg:gsub(pattern, Link.URL_REPLACEMENT)
            if count > 0 then
                return result
            end
        end
        return msg
    end

    -- Single filter callback shared by every event.  Runs inside
    -- Blizzard's ChatFrame_MessageEventHandler *before* AddMessage.
    -- Only return modified args when a URL was actually transformed;
    -- returning nothing preserves the original untainted values and
    -- prevents lineID taint that breaks FCF_RemoveAllMessagesFromChanSender.
    Link.urlFilter = function(_, _, msg, ...)
        if msg then
            local newMsg = Link:TransformURLs(msg)
            if newMsg ~= msg then
                return false, newMsg, ...
            end
        end
    end

    Link.SetHyperlink = ItemRefTooltip.SetHyperlink
    function Link:EnableHyperlink()
        local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
        function _G.ItemRefTooltip:SetHyperlink(link, ...)
            if link and (strsub(link, 1, 3) == "url") then
                local editbox = ChatFrameUtil.ChooseBoxForSend()
                ChatFrameUtil.ActivateChat(editbox)
                editbox:SetText(string.sub(link, 5))
                editbox:HighlightText()
                return
            end

            SetHyperlink(self, link, ...)
        end
    end
end

function Link:OnEnable()
    for _, event in ipairs(CHAT_EVENTS) do
        ChatFrame_AddMessageEventFilter(event, Link.urlFilter)
    end

    Link:EnableHyperlink()
end

function Link:OnDisable()
    for _, event in ipairs(CHAT_EVENTS) do
        ChatFrame_RemoveMessageEventFilter(event, Link.urlFilter)
    end

    ItemRefTooltip.SetHyperlink = Link.SetHyperlink
end
