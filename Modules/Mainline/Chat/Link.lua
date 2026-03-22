local Link = mUI:NewModule("mUI.Modules.Chat.Link", "AceHook-3.0")

function Link:OnInitialize()
    -- URL patterns – [^|%s] excludes WoW escape-code pipes so we never
    -- match across |H…|h boundaries in the already-formatted AddMessage text.
    Link.URL_PATTERNS = {"(https://[^|%s]+%.[^|%s]+)", "(http://[^|%s]+%.[^|%s]+)", "(www%.[^|%s]+%.[^|%s]+)", "(%d+%.%d+%.%d+%.%d+:?%d*/?[^|%s]*)"}
    Link.URL_REPLACEMENT = "|cff0394ff|Hurl:%1|h[%1]|h|r"

    function Link.AddMessageHook(self, msg, ...)
        if msg then
            msg = Link:TransformURLs(msg)
        end
        return Link.hooks[self].AddMessage(self, msg, ...)
    end

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
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            Link:RawHook(chatFrame, "AddMessage", Link.AddMessageHook, true)
        end
    end

    -- Cover temporary chat windows (whisper pop-outs, pet battles, etc.)
    Link:SecureHook("FCF_SetTemporaryWindowType", function(chatFrame)
        if chatFrame and not Link:IsHooked(chatFrame, "AddMessage") then
            Link:RawHook(chatFrame, "AddMessage", Link.AddMessageHook, true)
        end
    end)

    Link:EnableHyperlink()
end

function Link:OnDisable()
    ItemRefTooltip.SetHyperlink = Link.SetHyperlink
    Link:UnhookAll()
end
