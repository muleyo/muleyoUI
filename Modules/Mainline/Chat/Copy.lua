local Copy = mUI:NewModule("mUI.Modules.Chat.Copy", "AceHook-3.0")

local function CreateThinScrollBar(scrollFrame)
    local scrollbar = CreateFrame("Slider", nil, scrollFrame:GetParent())
    scrollbar:SetWidth(4)
    scrollbar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 10, 0)
    scrollbar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 10, 0)
    scrollbar:SetValueStep(1)
    scrollbar:SetObeyStepOnDrag(true)
    scrollbar:SetMinMaxValues(0, 1)
    scrollbar:SetValue(0)

    local track = scrollbar:CreateTexture(nil, "BACKGROUND")
    track:SetAllPoints()
    track:SetColorTexture(1, 1, 1, 0.03)

    local thumb = scrollbar:CreateTexture(nil, "OVERLAY")
    thumb:SetSize(4, 50)
    thumb:SetColorTexture(1, 1, 1, 0.15)
    scrollbar:SetThumbTexture(thumb)

    scrollbar:EnableMouse(true)
    scrollbar:SetScript("OnEnter", function()
        thumb:SetColorTexture(1, 1, 1, 0.35)
    end)
    scrollbar:SetScript("OnLeave", function()
        thumb:SetColorTexture(1, 1, 1, 0.15)
    end)

    scrollbar:SetScript("OnValueChanged", function(_, value)
        scrollFrame:SetVerticalScroll(value)
    end)

    scrollFrame:SetScript("OnScrollRangeChanged", function(self, _, yrange)
        yrange = math.max(yrange or 0, 0)
        scrollbar:SetMinMaxValues(0, yrange)
        scrollbar:SetValue(math.min(self:GetVerticalScroll(), yrange))
        scrollbar:SetShown(yrange > 0)
    end)

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(_, delta)
        local current = scrollbar:GetValue()
        local _, maxVal = scrollbar:GetMinMaxValues()
        if maxVal > 0 then
            local step = math.max(maxVal / 15, 20)
            scrollbar:SetValue(current - delta * step)
        end
    end)

    return scrollbar
end

function Copy:OnInitialize()
    -- Main frame
    local frame = CreateFrame("Frame", "mUI_ChatCopyContainer", UIParent, "BackdropTemplate")
    frame:SetSize(600, 400)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    mUI:SetPixelBorders(frame, {0, 0, 0, 0.75}, {0.15, 0.15, 0.15, 1})
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    Copy.frame = frame

    -- Header separator
    local sep = frame:CreateTexture(nil, "OVERLAY")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 1, -28)
    sep:SetPoint("TOPRIGHT", -1, -28)
    sep:SetColorTexture(0.15, 0.15, 0.15, 1)

    -- Title
    Copy.title = frame:CreateFontString(nil, "OVERLAY")
    Copy.title:SetFont(STANDARD_TEXT_FONT, 12, "")
    Copy.title:SetPoint("TOP", 0, -8)
    Copy.title:SetTextColor(1, 1, 1, 0.9)
    Copy.title:SetShadowOffset(1, -1)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function()
        frame:Hide()
    end)
    local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY")
    closeTxt:SetFont(STANDARD_TEXT_FONT, 16, "")
    closeTxt:SetPoint("CENTER", 0, 0)
    closeTxt:SetText("x")
    closeTxt:SetTextColor(1, 1, 1, 0.4)
    closeBtn:SetScript("OnEnter", function()
        closeTxt:SetTextColor(1, 0.3, 0.3, 1)
    end)
    closeBtn:SetScript("OnLeave", function()
        closeTxt:SetTextColor(1, 1, 1, 0.4)
    end)

    -- Scroll frame (no legacy template)
    local scroll = CreateFrame("ScrollFrame", nil, frame)
    scroll:SetPoint("TOPLEFT", 12, -34)
    scroll:SetPoint("BOTTOMRIGHT", -22, 12)
    Copy.scroll = scroll

    -- Editbox
    local editbox = CreateFrame("EditBox", nil, scroll)
    editbox:SetMultiLine(true)
    editbox:SetFontObject("ChatFontNormal")
    editbox:SetAutoFocus(false)
    editbox:SetWidth(560)
    editbox:SetHeight(400)
    editbox:SetScript("OnEscapePressed", function()
        frame:Hide()
    end)
    editbox:SetScript("OnCursorChanged", function(self, _, y, _, h)
        local needed = math.abs(y) + h + 20
        if needed > self:GetHeight() then
            self:SetHeight(needed)
        end
    end)
    editbox:EnableMouseWheel(true)
    editbox:SetScript("OnMouseWheel", function(_, delta)
        local handler = scroll:GetScript("OnMouseWheel")
        if handler then
            handler(scroll, delta)
        end
    end)
    scroll:SetScrollChild(editbox)
    Copy.editbox = editbox

    -- Thin scrollbar
    Copy.scrollbar = CreateThinScrollBar(scroll)

    -- Update editbox width on show
    frame:SetScript("OnShow", function()
        editbox:SetWidth(scroll:GetWidth())
    end)

    -- Copy button
    Copy.button = CreateFrame("Button", nil, UIParent)
    Copy.button:SetPoint("TOPLEFT", ChatFrame1, -27.5, 27.5)
    Copy.button:SetSize(20, 20)
    Copy.button:SetNormalTexture([[Interface\AddOns\mUI\Media\Textures\Chat\copynormal.png]])
    Copy.button:GetNormalTexture():SetSize(20, 20)
    Copy.button:SetHighlightTexture([[Interface\AddOns\mUI\Media\Textures\Chat\copyhighlight.png]])
    Copy.button:GetHighlightTexture():SetAllPoints(Copy.button:GetNormalTexture())
    Copy.button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(Copy.button, "ANCHOR_TOP")
        GameTooltip:SetText("Copy Chat Log")
        GameTooltip:Show()
    end)
    Copy.button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    Copy.button:Hide()
end

function Copy:Chatlog()
    local chatFrame = SELECTED_CHAT_FRAME or ChatFrame1
    if not chatFrame then
        return
    end

    local lines = {}
    for i = 1, chatFrame:GetNumMessages() do
        local message = chatFrame:GetMessageInfo(i)
        if message then
            lines[#lines + 1] = message
        end
    end

    local text = table.concat(lines, "\n")

    Copy.title:SetText(chatFrame.name or "Chat")
    Copy.frame:Show()

    -- Defer text population so scroll frame has valid dimensions after Show()
    C_Timer.After(0, function()
        local scrollWidth = Copy.scroll:GetWidth()
        if scrollWidth > 0 then
            Copy.editbox:SetWidth(scrollWidth)
        end

        Copy.editbox:SetText(text)
        Copy.editbox:SetCursorPosition(0)

        -- Let the editbox compute its own content height after text is set
        C_Timer.After(0, function()
            local scrollHeight = Copy.scroll:GetHeight()
            local _, fontHeight = Copy.editbox:GetFont()
            local numLines = Copy.editbox:GetNumLetters() > 0 and select(2, Copy.editbox:GetText():gsub("\n", "\n")) + 1 or 1
            local contentHeight = numLines * (fontHeight + 2) + 20
            Copy.editbox:SetHeight(math.max(contentHeight, scrollHeight, 1))
            Copy.scroll:SetVerticalScroll(0)
        end)
    end)
end

function Copy:OnEnable()
    Copy.button:Show()
    Copy.button:SetScript("OnClick", function()
        Copy:Chatlog()
    end)
end

function Copy:OnDisable()
    Copy:UnhookAll()
    Copy.frame:Hide()
    Copy.button:Hide()
end
