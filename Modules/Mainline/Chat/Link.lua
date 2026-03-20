local Link = mUI:NewModule("mUI.Modules.Chat.Link", "AceHook-3.0")

function Link:OnInitialize()
    Link.patterns = {"(https://%S+%.%S+)", "(http://%S+%.%S+)", "(www%.%S+%.%S+)", "(%d+%.%d+%.%d+%.%d+:?%d*/?%S*)"}

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

-- Apply URL patterns to a message string, converting plain-text URLs
-- into clickable |Hurl:...|h hyperlinks.
function Link:LinkifyURLs(msg)
    if type(msg) ~= "string" then
        return msg
    end
    for _, pattern in pairs(Link.patterns) do
        msg = string.gsub(msg, pattern, "|cff0394ff|Hurl:%1|h[%1]|h|r")
    end
    return msg
end

-- Hook AddMessage on a single ChatFrame so URLs in the formatted display
-- string are turned into clickable hyperlinks.  This runs AFTER Blizzard's
-- secure ChatHistory_GetAccessID processing, avoiding event-arg taint.
function Link:HookChatFrame(chatFrame)
    if not chatFrame or self:IsHooked(chatFrame, "AddMessage") then
        return
    end
    self:RawHook(chatFrame, "AddMessage", function(frame, msg, ...)
        return self.hooks[frame].AddMessage(frame, Link:LinkifyURLs(msg), ...)
    end, true)
end

function Link:OnEnable()
    -- Hook AddMessage on all static chat frames for URL linkification.
    -- Replaces the old ChatFrameUtil.AddMessageEventFilter approach which
    -- tainted event args and broke ChatHistory_GetToken (strlower on a
    -- secret/tainted string).
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            Link:HookChatFrame(chatFrame)
        end
    end

    -- Hook temporary chat frames as they are created
    Link:SecureHook("FCF_SetTemporaryWindowType", function(chatFrame)
        Link:HookChatFrame(chatFrame)
    end)

    Link:EnableHyperlink()
end

function Link:Disable()
    ItemRefTooltip.SetHyperlink = Link.SetHyperlink
    Link:UnhookAll()
end
