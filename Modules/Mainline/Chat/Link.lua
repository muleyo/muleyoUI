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
    if canaccessvalue and not canaccessvalue(msg) then
        return msg
    end
    for _, pattern in pairs(Link.patterns) do
        msg = string.gsub(msg, pattern, "|cff0394ff|Hurl:%1|h[%1]|h|r")
    end
    return msg
end

function Link:HookChatFrame(chatFrame)
    if not chatFrame or self:IsHooked(chatFrame, "AddMessage") then
        return
    end
    self:SecureHook(chatFrame, "AddMessage", function(frame, msg)
        if type(msg) ~= "string" then
            return
        end
        if canaccessvalue and not canaccessvalue(msg) then
            return
        end

        local hasURL = false
        for _, pattern in pairs(Link.patterns) do
            if msg:find(pattern) then
                hasURL = true
                break
            end
        end
        if not hasURL then
            return
        end

        -- Find the bottom-most visible FontString (just added) and linkify it
        local container = frame.FontStringContainer
        if not container then
            return
        end
        local regions = {container:GetRegions()}
        for i = #regions, 1, -1 do
            local region = regions[i]
            if region and region:GetObjectType() == "FontString" and region:IsShown() then
                local text = region:GetText()
                if text and text ~= "" then
                    if canaccessvalue and not canaccessvalue(text) then
                        return
                    end
                    local linkified = Link:LinkifyURLs(text)
                    if linkified ~= text then
                        region:SetText(linkified)
                    end
                    return
                end
            end
        end
    end)
end

function Link:OnEnable()
    -- SecureHook AddMessage on all static chat frames for URL linkification.
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
