local Copy = mUI:NewModule("mUI.Modules.Chat.Copy", "AceHook-3.0")

local TAB_HEIGHT = 22
local TAB_PADDING = 6
local TAB_GAP = 2

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
    Copy:RawHookScript(scrollbar, "OnEnter", function(self)
        thumb:SetColorTexture(1, 1, 1, 0.35)
    end, true)
    Copy:RawHookScript(scrollbar, "OnLeave", function(self)
        thumb:SetColorTexture(1, 1, 1, 0.15)
    end, true)

    Copy:RawHookScript(scrollbar, "OnValueChanged", function(self, value)
        scrollFrame:SetVerticalScroll(value)
    end, true)

    Copy:RawHookScript(scrollFrame, "OnScrollRangeChanged", function(self, xrange, yrange)
        yrange = math.max(yrange or 0, 0)
        scrollbar:SetMinMaxValues(0, yrange)
        scrollbar:SetValue(math.min(self:GetVerticalScroll(), yrange))
        scrollbar:SetShown(yrange > 0)
    end, true)

    scrollFrame:EnableMouseWheel(true)

    Copy:RawHookScript(scrollFrame, "OnMouseWheel", function(self, delta)
        local current = scrollbar:GetValue()
        local _, maxVal = scrollbar:GetMinMaxValues()
        if maxVal > 0 then
            local step = math.max(maxVal / 15, 20)
            scrollbar:SetValue(current - delta * step)
        end
    end, true)

    return scrollbar
end

-- Collect messages from a chat frame by temporarily shrinking the font
-- so all messages fit as visible FontStrings, then reading their text.
local function GetChatText(chatFrame)
    if not chatFrame then
        return ""
    end

    local fontFile, fontSize, fontFlags = chatFrame:GetFont()
    if not fontFile or not fontSize then
        return ""
    end

    -- Shrink font so the C++ engine renders all history as FontStrings
    chatFrame:SetFont(fontFile, 0.01, fontFlags)

    local lines = {}

    -- Read from FontStringContainer (modern retail) or frame regions
    local container = chatFrame.FontStringContainer
    local regions
    if container then
        regions = {container:GetRegions()}
    else
        regions = {chatFrame:GetRegions()}
    end

    -- Iterate in reverse so messages are in chronological order (oldest first)
    for i = #regions, 1, -1 do
        local region = regions[i]
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText()
            if text and text ~= "" then
                lines[#lines + 1] = text
            end
        end
    end

    -- Restore original font
    chatFrame:SetFont(fontFile, fontSize, fontFlags)

    return table.concat(lines, "\n")
end

-- Populate the editbox with text and fix sizing
local function PopulateEditbox(text)
    C_Timer.After(0, function()
        local scrollWidth = Copy.scroll:GetWidth()
        if scrollWidth > 0 then
            Copy.editbox:SetWidth(scrollWidth)
        end

        Copy.editbox:SetText(text)
        Copy.editbox:SetCursorPosition(0)

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
    Copy:RawHookScript(frame, "OnDragStart", frame.StartMoving)
    Copy:RawHookScript(frame, "OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    Copy.frame = frame

    -- Header separator
    local headerSep = frame:CreateTexture(nil, "OVERLAY")
    headerSep:SetHeight(1)
    headerSep:SetPoint("TOPLEFT", 1, -28)
    headerSep:SetPoint("TOPRIGHT", -1, -28)
    headerSep:SetColorTexture(0.15, 0.15, 0.15, 1)

    -- Title
    Copy.title = frame:CreateFontString(nil, "OVERLAY")
    Copy.title:SetFont(STANDARD_TEXT_FONT, 12, "")
    Copy.title:SetPoint("TOP", 0, -8)
    Copy.title:SetTextColor(1, 1, 1, 0.9)
    Copy.title:SetShadowOffset(1, -1)
    Copy.title:SetText("Copy Chat Log")

    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetPoint("TOPRIGHT", -4, -4)
    Copy:RawHookScript(closeBtn, "OnClick", function()
        frame:Hide()
    end)
    local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY")
    closeTxt:SetFont(STANDARD_TEXT_FONT, 16, "")
    closeTxt:SetPoint("CENTER", 0, 0)
    closeTxt:SetText("x")
    closeTxt:SetTextColor(1, 1, 1, 0.4)
    Copy:RawHookScript(closeBtn, "OnEnter", function()
        closeTxt:SetTextColor(1, 0.3, 0.3, 1)
    end)
    Copy:RawHookScript(closeBtn, "OnLeave", function()
        closeTxt:SetTextColor(1, 1, 1, 0.4)
    end)

    -- Tab container (between header and scroll area)
    local tabContainer = CreateFrame("Frame", nil, frame)
    tabContainer:SetPoint("TOPLEFT", 6, -30)
    tabContainer:SetPoint("TOPRIGHT", -6, -30)
    tabContainer:SetHeight(TAB_HEIGHT + 4)
    Copy.tabContainer = tabContainer

    -- Tab separator (below tab row)
    local tabSep = frame:CreateTexture(nil, "OVERLAY")
    tabSep:SetHeight(1)
    tabSep:SetPoint("TOPLEFT", 1, -(30 + TAB_HEIGHT + 4))
    tabSep:SetPoint("TOPRIGHT", -1, -(30 + TAB_HEIGHT + 4))
    tabSep:SetColorTexture(0.15, 0.15, 0.15, 1)

    -- Scroll frame (below tab row + separator)
    local scroll = CreateFrame("ScrollFrame", nil, frame)
    scroll:SetPoint("TOPLEFT", 12, -(30 + TAB_HEIGHT + 8))
    scroll:SetPoint("BOTTOMRIGHT", -22, 12)
    Copy.scroll = scroll

    -- Editbox
    local editbox = CreateFrame("EditBox", nil, scroll)
    editbox:SetMultiLine(true)
    editbox:SetFontObject("ChatFontNormal")
    editbox:SetAutoFocus(false)
    editbox:EnableMouse(true)
    editbox:SetWidth(560)
    editbox:SetHeight(400)
    Copy:RawHookScript(editbox, "OnEscapePressed", function()
        frame:Hide()
    end)
    Copy:RawHookScript(editbox, "OnEditFocusGained", function(self)
        self:HighlightText()
    end)
    Copy:RawHookScript(editbox, "OnCursorChanged", function(self, x, y, w, h)
        ScrollingEdit_OnCursorChanged(self, x, y, w, h)
    end)
    Copy:RawHookScript(editbox, "OnUpdate", function(self, elapsed)
        ScrollingEdit_OnUpdate(self, elapsed, scroll)
    end)
    editbox:EnableMouseWheel(true)
    Copy:RawHookScript(editbox, "OnMouseWheel", function(self, delta)
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
    Copy:RawHookScript(frame, "OnShow", function()
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
    Copy:RawHookScript(Copy.button, "OnEnter", function()
        GameTooltip:SetOwner(Copy.button, "ANCHOR_TOP")
        GameTooltip:SetText("Copy Chat Log")
        GameTooltip:Show()
    end)
    Copy:RawHookScript(Copy.button, "OnLeave", function()
        GameTooltip:Hide()
    end)
    Copy.button:Hide()

    -- Tab button pool
    Copy.tabs = {}
    Copy.selectedTab = nil
end

-- Create or reuse a tab button at the given index
local function GetOrCreateTab(index)
    if Copy.tabs[index] then
        return Copy.tabs[index]
    end

    local btn = CreateFrame("Button", nil, Copy.tabContainer)
    btn:SetHeight(TAB_HEIGHT)

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(1, 1, 1, 0.05)
    btn.bg = bg

    local text = btn:CreateFontString(nil, "OVERLAY")
    text:SetFont(STANDARD_TEXT_FONT, 11, "")
    text:SetPoint("CENTER", 0, 0)
    text:SetTextColor(1, 1, 1, 0.6)
    text:SetShadowOffset(1, -1)
    btn.text = text

    Copy:RawHookScript(btn, "OnEnter", function(self)
        if self ~= Copy.selectedTab then
            self.bg:SetColorTexture(1, 1, 1, 0.1)
            self.text:SetTextColor(1, 1, 1, 0.8)
        end
    end)
    Copy:RawHookScript(btn, "OnLeave", function(self)
        if self ~= Copy.selectedTab then
            self.bg:SetColorTexture(1, 1, 1, 0.05)
            self.text:SetTextColor(1, 1, 1, 0.6)
        end
    end)

    Copy.tabs[index] = btn
    return btn
end

-- Style a tab as selected or unselected
local function SetTabSelected(btn, selected)
    if selected then
        btn.bg:SetColorTexture(1, 1, 1, 0.15)
        btn.text:SetTextColor(1, 1, 1, 1)
    else
        btn.bg:SetColorTexture(1, 1, 1, 0.05)
        btn.text:SetTextColor(1, 1, 1, 0.6)
    end
end

-- Select a tab and load its messages
function Copy:SelectTab(chatFrame)
    if not chatFrame then
        return
    end
    Copy.activeChatFrame = chatFrame

    -- Update tab highlight
    for _, tab in pairs(Copy.tabs) do
        if tab:IsShown() then
            SetTabSelected(tab, tab.chatFrame == chatFrame)
            if tab.chatFrame == chatFrame then
                Copy.selectedTab = tab
            end
        end
    end

    PopulateEditbox(GetChatText(chatFrame))
end

-- Build or refresh the tab bar from all active chat windows
function Copy:RefreshTabs()
    -- Hide all existing tabs
    for _, tab in pairs(Copy.tabs) do
        tab:Hide()
    end

    local visibleFrames = {}

    -- Gather all active chat frames (docked + undocked)
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local cf = _G["ChatFrame" .. i]
        local bt = _G["ChatFrame" .. i .. "Tab"]
        if cf and bt and bt:IsShown() then
            visibleFrames[#visibleFrames + 1] = cf
        end
    end

    -- Also check temporary windows
    for i = Constants.ChatFrameConstants.MaxChatWindows + 1, Constants.ChatFrameConstants.MaxChatWindows + 10 do
        local cf = _G["ChatFrame" .. i]
        local bt = _G["ChatFrame" .. i .. "Tab"]
        if cf and bt and bt:IsShown() then
            visibleFrames[#visibleFrames + 1] = cf
        end
    end

    if #visibleFrames == 0 then
        return
    end

    -- Calculate tab widths to fill the container
    local containerWidth = Copy.tabContainer:GetWidth()
    if containerWidth <= 0 then
        containerWidth = 580
    end -- fallback before layout
    local totalGap = TAB_GAP * math.max(#visibleFrames - 1, 0)
    local tabWidth = math.floor((containerWidth - totalGap) / #visibleFrames)

    local xOffset = 0
    for idx, cf in ipairs(visibleFrames) do
        local tab = GetOrCreateTab(idx)
        tab.chatFrame = cf
        tab.text:SetText(cf.name or ("Chat " .. idx))
        tab:SetWidth(tabWidth)
        tab:ClearAllPoints()
        tab:SetPoint("TOPLEFT", Copy.tabContainer, "TOPLEFT", xOffset, -2)
        Copy:RawHookScript(tab, "OnClick", function()
            Copy:SelectTab(cf)
        end)
        tab:Show()
        xOffset = xOffset + tabWidth + TAB_GAP
    end

    return visibleFrames
end

function Copy:Chatlog()
    Copy.frame:Show()

    -- Defer so the frame has valid dimensions
    C_Timer.After(0, function()
        local visibleFrames = Copy:RefreshTabs()
        if not visibleFrames or #visibleFrames == 0 then
            return
        end

        -- Default to the currently selected chat frame, or first available
        local defaultFrame = SELECTED_CHAT_FRAME or ChatFrame1
        local found = false
        for _, cf in ipairs(visibleFrames) do
            if cf == defaultFrame then
                found = true
                break
            end
        end
        if not found then
            defaultFrame = visibleFrames[1]
        end

        Copy:SelectTab(defaultFrame)
    end)
end

function Copy:OnEnable()
    Copy.button:Show()
    Copy:RawHookScript(Copy.button, "OnClick", function()
        Copy:Chatlog()
    end)
end

function Copy:OnDisable()
    Copy:UnhookAll()
    Copy.frame:Hide()
    Copy.button:Hide()
end
