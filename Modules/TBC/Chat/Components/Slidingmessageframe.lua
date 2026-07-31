local Style = mUI:GetModule("mUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)
local m_ceil = _G.math.ceil
local m_max = _G.math.max
local m_min = _G.math.min
local next = _G.next
local pcall = _G.pcall
local t_wipe = _G.table.wipe

-- Mine
local CHAT_FADE_OUT_DURATION = 0.6
local DOCK_FADE_IN_DURATION = 0.1
local DOCK_FADE_OUT_DURATION = 0.6
local DOCK_FADE_OUT_DELAY = 4

do
    local map = {}

    function Style:GetSlidingFrameForChatFrame(chatFrame)
        return map[chatFrame]
    end

    function Style:SetSlidingFrameForChatFrame(chatFrame, slidingFrame)
        map[chatFrame] = slidingFrame
    end
end

--------------
-- SMOOTHER --
--------------

local setSmoothScroll

do
    local SCROLL_DURATION = 0.15
    local POST_SCROLL_DELAY = 0.1

    local activeFrames = {}

    local smoother = CreateFrame("Frame")

    local function clamp(v)
        if v > SCROLL_DURATION then
            return SCROLL_DURATION
        elseif v < 0 then
            return 0
        end

        return v
    end

    -- out cubic
    local function smoothFunc(t, b, c)
        t = t / SCROLL_DURATION - 1
        return c * (t ^ 3 + 1) + b
    end

    local function onUpdate(_, elapsed)
        for frame, data in next, activeFrames do
            data[2] = data[2] + elapsed
            data[1](smoothFunc(clamp(data[2]), data[3], data[4]))

            if data[2] >= SCROLL_DURATION + POST_SCROLL_DELAY then
                if data[5] then
                    data[5]()
                end

                activeFrames[frame] = nil
            end
        end

        if not next(activeFrames) then
            smoother:SetScript("OnUpdate", nil)
        end
    end

    function setSmoothScroll(frame, func, change, callback)
        -- func, time, start, change, callback
        activeFrames[frame] = {func, 0, frame:GetVerticalScroll(), change, callback}

        if not smoother:GetScript("OnUpdate") then
            smoother:SetScript("OnUpdate", onUpdate)
        end

        return true
    end
end

----------------
-- BLIZZ CHAT --
----------------

local function chatFrame_OnSizeChanged(self, width, height)
    local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
    if slidingFrame then
        width, height = Style:Round(width), Style:Round(height)

        slidingFrame:SetSize(width, height)
        slidingFrame.ScrollChild:SetSize(width, height)

        slidingFrame.isLayoutDirty = true
        slidingFrame.isDisplayDirty = true

        -- don't use StopMovingOrSizing, OnSizeChanged can fire for a multitude of reasons, but only one ends with
        -- StopMovingOrSizing
        if slidingFrame.refreshTimer then
            slidingFrame.refreshTimer:Cancel()
        end

        slidingFrame.refreshTimer = C_Timer.NewTimer(0.5, slidingFrame.funcCache.refreshDisplay)
    end
end

local function chatFrame_SetShownHook(self, isShown)
    if isShown then
        self.FontStringContainer:Hide()

        local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
        if slidingFrame then
            -- FCF indiscriminately calls :SetShown(true) when adding new tabs, I don't need to do anything when that happens
            if not slidingFrame:IsShown() then
                slidingFrame:Show()
            end
        end
    else
        local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
        if slidingFrame then
            slidingFrame:Hide()
        end
    end
end

local function chatFrame_HideHook(self)
    local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
    if slidingFrame then
        slidingFrame:Hide()
    end
end

local function chatFrame_RefreshMessagesInPlace(self)
    local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
    if slidingFrame then
        slidingFrame.isLayoutDirty = true
        slidingFrame.isDisplayDirty = true

        if slidingFrame:IsShown() then
            slidingFrame:OnShow()
        end
    end
end

local function chatFrame_OnHyperlinkEnterHook(self, link, text, fontString)
    if Style.db.tooltips then
        local linkType = LinkUtil.SplitLinkData(link)
        if linkType ~= "trade" then
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 4, 2)

            local isOK = pcall(GameTooltip.SetHyperlink, GameTooltip, link)
            if not isOK then
                GameTooltip:Hide()
            else
                GameTooltip:Show()
            end
        end
    end

    local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
    if slidingFrame then
        slidingFrame.mouseOverHyperlinkMessageLine = fontString:GetParent()
    end
end

local function chatFrame_OnHyperlinkLeaveHook(self)
    GameTooltip:Hide()

    local slidingFrame = Style:GetSlidingFrameForChatFrame(self)
    if slidingFrame and slidingFrame:IsShown() then
        slidingFrame.mouseOverHyperlinkMessageLine = nil
    end
end

local alertingFrames = {}

local function isAnyChatAlerting()
    return not not next(alertingFrames)
end

---------------------------
-- SLIDING MESSAGE FRAME --
---------------------------

local hookedChatFrames = {}

local CHAT_FRAME_TEXTURES = {"Background", "TopLeftTexture", "TopRightTexture", "BottomLeftTexture", "BottomRightTexture", "TopTexture",
                             "BottomTexture", "LeftTexture", "RightTexture", "ButtonFrameBackground", "ButtonFrameTopLeftTexture",
                             "ButtonFrameTopRightTexture", "ButtonFrameBottomLeftTexture", "ButtonFrameBottomRightTexture", "ButtonFrameTopTexture",
                             "ButtonFrameBottomTexture", "ButtonFrameLeftTexture", "ButtonFrameRightTexture"}

local object_proto = {
    firstActiveMessageIndex = 0,
    isAtBottom = true,
    isAtTop = true,
    isScrolling = false,
    isLayoutDirty = true,
    isDisplayDirty = true,
    canProcessIncoming = true,
    numIncomingMessages = 0,
    numIncomingMessagesWhileScrolling = 0,
    overrideFadeTimestamp = 0,
    pendingAutoScroll = false
}

function object_proto:CaptureChatFrame(chatFrame)
    self:ReleaseAllMessageLines()

    self.ChatFrame = chatFrame
    self.ChatTab = _G[chatFrame:GetName() .. "Tab"]
    self.EditBox = _G[chatFrame:GetName() .. "EditBox"]
    self.ButtonFrame = chatFrame.buttonFrame
    self.historyBuffer = chatFrame.historyBuffer
    self:SetParent(chatFrame)

    Style:SetSlidingFrameForChatFrame(chatFrame, self)

    chatFrame:SetClampedToScreen(false)
    chatFrame:SetClampRectInsets(0, 0, 0, 0)
    chatFrame:SetResizeBounds(176, 64)
    chatFrame:EnableMouse(false)
    chatFrame:SetScript("OnUpdate", nil)

    Style:ForceHide(chatFrame.ScrollBar)
    Style:ForceHide(chatFrame.ScrollToBottomButton)
    Style:ForceHide(chatFrame.buttonFrame.upButton)
    Style:ForceHide(chatFrame.buttonFrame.downButton)
    Style:ForceHide(chatFrame.buttonFrame.bottomButton)

    for _, texture in next, CHAT_FRAME_TEXTURES do
        local obj = _G[chatFrame:GetName() .. texture]
        if obj then
            obj:SetTexture(0)
        end
    end

    local width, height = chatFrame:GetSize()
    width, height = Style:Round(width), Style:Round(height)

    self:SetPoint("TOPLEFT", chatFrame)
    self:SetSize(width, height)

    self.ScrollChild:SetSize(width, height)

    -- ! it's safer to hide the string container than the chat frame itself
    chatFrame.FontStringContainer:Hide()

    if not hookedChatFrames[chatFrame] then
        Style:SecureHookScript(chatFrame, "OnSizeChanged", chatFrame_OnSizeChanged)
        Style:SecureHook(chatFrame, "SetShown", chatFrame_SetShownHook)
        Style:SecureHook(chatFrame, "Hide", chatFrame_HideHook)

        -- some addon devs tend to hook AddMessage to add filtering, so do it the hard way
        Style:SecureHook(chatFrame.historyBuffer, "PushFront", function()
            local slidingFrame = Style:GetSlidingFrameForChatFrame(chatFrame)
            if slidingFrame then
                slidingFrame:NewIncomingMessage()
            end
        end)

        -- redraw the frame if visible
        Style:SecureHook(chatFrame, "RemoveMessagesByPredicate", chatFrame_RefreshMessagesInPlace)
        Style:SecureHook(chatFrame, "TransformMessages", chatFrame_RefreshMessagesInPlace)

        Style:SecureHookScript(chatFrame, "OnHyperlinkEnter", chatFrame_OnHyperlinkEnterHook)
        Style:SecureHookScript(chatFrame, "OnHyperlinkLeave", chatFrame_OnHyperlinkLeaveHook)

        hookedChatFrames[chatFrame] = true
    end

    if chatFrame:GetNumMessages() > 0 then
        self:SetFirstVisibleMessageID(1)
    end

    self:SetShown(chatFrame:IsShown())
end

function object_proto:ReleaseChatFrame()
    if self.ChatFrame then
        Style:SetSlidingFrameForChatFrame(self.ChatFrame, nil)

        self.ChatFrame = nil
        self.ChatTab = nil
        self.EditBox = nil
        self.ButtonFrame = nil
        self.historyBuffer = nil
        t_wipe(self.activeMessages)
        t_wipe(self.backfillMessages)

        self:ReleaseAllMessageLines()
        self:SetParent(UIParent)
        self:Hide()
    end
end

function object_proto:OnShow()
    -- happens when additional docked chat frames were resized while hidden OnSizeChanged will fire first followed by
    -- OnShow
    self:ResetFadingTimer()
    self:RefreshIfNecessary()
    self:ResetState()
end

function object_proto:OnHide()
    self.isLayoutDirty = true
    self.isDisplayDirty = true
    self.numIncomingMessages = 0
    self.mouseOverHyperlinkMessageLine = nil
    -- self.numIncomingMessagesWhileScrolling = 0
end

function object_proto:CanShowMessages()
    return self:GetBottom() and self:IsShown() and self.ScrollChild:GetHeight() ~= 0
end

function object_proto:UpdateLayout()
    self.isLayoutDirty = false

    t_wipe(self.activeMessages)
    t_wipe(self.backfillMessages)

    if self.messageFramePool then
        self.messageFramePool:ReleaseAll()
        self.messageFramePool:UpdateWidth()
        self.messageFramePool:UpdateHeight()
    end
end

function object_proto:UpdateDisplay()
    self.isDisplayDirty = false

    self:RefreshActive(self:GetFirstVisibleMessageID())
end

function object_proto:RefreshIfNecessary()
    if self.isLayoutDirty then
        self:UpdateLayout()
    end

    if self.isDisplayDirty then
        self:UpdateDisplay()
    end
end

function object_proto:GetNumHistoryElements()
    return self.historyBuffer:GetNumElements()
end

function object_proto:GetHistoryEntryAtIndex(index)
    return self.historyBuffer:GetEntryAtIndex(index)
end

function object_proto:SetAtBottom(state)
    self.isAtBottom = state
end

function object_proto:IsAtBottom()
    return self.isAtBottom
end

function object_proto:SetAtTop(state)
    self.isAtTop = state
end

function object_proto:IsAtTop()
    return self.isAtTop
end

-- TODO: Remove
function object_proto:GetNumActiveMessageLines()
    if self.messageFramePool then
        return self.messageFramePool:GetNumActive()
    end

    return 0
end

function object_proto:AcquireMessageLine()
    if not self.messageFramePool then
        self.messageFramePool = Style:CreateMessageLinePool(self.ScrollChild, self:GetID())
    end

    return self.messageFramePool:Acquire()
end

-- TODO: Remove
function object_proto:ReleaseMessageLine(messageLine)
    if self.messageFramePool and messageLine then
        self.messageFramePool:Release(messageLine)
    end
end

function object_proto:ReleaseAllMessageLines()
    if self.messageFramePool then
        self.messageFramePool:ReleaseAll()
    end
end

function object_proto:GetMaxNumVisibleLines()
    return m_ceil(self:GetHeight() / self:GetMessageLineHeight())
end

function object_proto:GetMessageLineHeight()
    return Style.db.chat.font.size + Style.db.chat.y_padding * 2
end

function object_proto:IsDocked()
    return self.ChatFrame.isDocked
end

function object_proto:IsScrolling()
    return self.isScrolling
end

function object_proto:SetScrolling(state)
    self.isScrolling = state
end

function object_proto:SetSmoothScroll(func, change, callback)
    if Style.db.smooth then
        setSmoothScroll(self, func, change, callback)

        self.numIncomingMessagesWhileScrolling = 0
        self:SetScrolling(true)
    else
        func(self:GetVerticalScroll() + change)

        if callback then
            callback()
        end
    end
end

function object_proto:UpdateFirstVisibleMessageInfo()
    for i = 1, #self.backfillMessages do
        local messageLine = self.backfillMessages[i]

        if messageLine:GetID() == 0 then
            break
        end
        if messageLine:GetTop() < self:GetBottom() then
            break
        end

        -- ideally, it should be messageLine:GetBottom() <= self:GetBottom() in here, but since I'm dealing with floats I can
        -- forget about having equal values, instead subtract 0.01 to account for any rounding bs
        if messageLine:GetBottom() - 0.01 < self:GetBottom() and messageLine:GetTop() > self:GetBottom() then
            self:SetFirstVisibleMessageInfo(messageLine:GetID(), messageLine:GetBottom() - self:GetBottom())

            break
        end
    end

    for i = 1, #self.activeMessages do
        local messageLine = self.activeMessages[i]

        if messageLine:GetID() == 0 then
            break
        end

        -- ideally, it should be messageLine:GetBottom() <= self:GetBottom() in here, but since I'm dealing with floats I can
        -- forget about having equal values, instead subtract 0.01 to account for any rounding bs
        if messageLine:GetBottom() - 0.01 < self:GetBottom() and messageLine:GetTop() > self:GetBottom() then
            self:SetFirstVisibleMessageInfo(messageLine:GetID(), messageLine:GetBottom() - self:GetBottom())

            break
        end
    end
end

function object_proto:ResetState(doNotRefresh)
    self:UpdateFirstVisibleMessageInfo()

    local offset = self:GetFirstVisibleMessageOffset()
    if offset < 1 and offset > -1 then
        offset = 0
    end

    self:SetVerticalScroll(offset)

    local id = self:GetFirstVisibleMessageID() + self.numIncomingMessagesWhileScrolling
    self.numIncomingMessagesWhileScrolling = 0

    if id == 0 and self:GetNumHistoryElements() > 0 then
        id = 1
    end

    if not doNotRefresh then
        self:RefreshActive(id)
        self:RefreshBackfill(0)
    end

    self:SetFirstActiveMessageID(id)

    self:SetAtBottom(id == 0 or (id == 1 and offset == 0))
    self:SetAtTop(id == self:GetNumHistoryElements() and self:GetLastActiveMessageOffset() < self:GetMessageLineHeight())

    if not doNotRefresh then
        self:UpdateFading()
    end

    self:SetScrolling(false)
end

function object_proto:EnableIncomingProcessing(state)
    self.canProcessIncoming = state
end

function object_proto:CanProcessIncoming()
    return self.canProcessIncoming
end

function object_proto:ResetStateAfterUserScroll()
    self:ResetState()
    self:EnableIncomingProcessing(self:IsAtBottom())
end

function object_proto:SetFirstVisibleMessageID(id)
    self.firstVisibleMessageID = id
end

function object_proto:SetFirstVisibleMessageInfo(id, offset)
    self.firstVisibleMessageID = id
    self.firstVisibleMessageOffset = offset
end

function object_proto:GetFirstVisibleMessageID()
    return self.firstVisibleMessageID or 0
end

function object_proto:GetFirstVisibleMessageOffset()
    return self.firstVisibleMessageOffset or 0
end

function object_proto:SetLastActiveMessageInfo(id, offset)
    self.lastActiveMessageID = id
    self.lastActiveMessageOffset = m_max(offset, 0)
end

-- TODO: Remove
function object_proto:GetLastActiveMessageID()
    return self.lastActiveMessageID or 0
end

function object_proto:GetLastActiveMessageOffset()
    return self.lastActiveMessageOffset or 0
end

function object_proto:SetLastBackfillMessageInfo(id, offset)
    self.lastBackfillMessageID = id
    self.lastBackfillMessageOffset = offset
end

-- TODO: Remove
function object_proto:GetLastBackfillMessageID()
    return self.lastBackfillMessageID or 0
end

function object_proto:GetLastBackfillMessageOffset()
    return self.lastBackfillMessageOffset or 0
end

function object_proto:RefreshBackfill(startIndex, maxLines, maxPixels)
    if not self:CanShowMessages() then
        return
    end

    local checkLines = maxLines ~= false
    maxLines = maxLines or 6
    maxPixels = maxPixels or self:GetBottom()

    self:SetLastBackfillMessageInfo(0, 0)

    local lineIndex = 0
    local messageID, messageInfo, messageLine

    local isFull = false
    while not isFull do
        lineIndex = lineIndex + 1
        messageID = startIndex - lineIndex + 1

        messageInfo = self:GetHistoryEntryAtIndex(messageID)
        if not messageInfo then
            lineIndex = lineIndex - 1

            break
        end

        messageLine = self.backfillMessages[lineIndex]
        if not messageLine then
            messageLine = self:AcquireMessageLine()
            self.backfillMessages[lineIndex] = messageLine

            messageLine:ClearAllPoints()

            if lineIndex == 1 then
                messageLine:SetPoint("TOPLEFT", self.ScrollChild, "BOTTOMLEFT", 0, 0)
            else
                messageLine:SetPoint("TOPLEFT", self.backfillMessages[lineIndex - 1], "BOTTOMLEFT", 0, 0)
            end
        end

        messageLine:SetMessage(messageID, messageInfo.timestamp, messageInfo.message, messageInfo.r, messageInfo.g, messageInfo.b)
        messageLine:StopFading(1)

        if checkLines then
            isFull = lineIndex == maxLines
        else
            isFull = messageLine:GetBottom() - 1 <= maxPixels
        end
    end

    if lineIndex > 0 then
        -- I want it to be a positive value, so flip it around instead of doing messageLine:GetBottom() - self:GetBottom()
        self:SetLastBackfillMessageInfo(messageID, self:GetBottom() - self.backfillMessages[lineIndex]:GetBottom())
    end

    -- just hide the excess, releasing and removing them here is expensive, they'll be taken care of when the frame gets
    -- hidden
    for i = lineIndex + 1, #self.backfillMessages do
        if self.backfillMessages[i]:GetID() ~= 0 then
            self.backfillMessages[i]:ClearMessage()
        end
    end
end

function object_proto:SetFirstActiveMessageID(id)
    self.firstActiveMessageID = id
end

function object_proto:GetFirstActiveMessageID()
    return self.firstActiveMessageID or 0
end

function object_proto:GetNegativeVerticalOffset()
    return m_max(self:GetBottom() - self.ScrollChild:GetBottom(), self:GetLastBackfillMessageOffset())
end

function object_proto:ResetFadingTimer()
    self.overrideFadeTimestamp = GetTime()
end

function object_proto:CanFade()
    return Style.db.fade.enabled and self:IsAtBottom()
end

function object_proto:CalculateAlphaFromTimestampDelta(delta)
    local config = Style.db.fade

    if delta <= config.out_delay then
        return 1
    end

    delta = delta - config.out_delay
    if delta >= CHAT_FADE_OUT_DURATION then
        return 0
    end

    return 1 - delta / CHAT_FADE_OUT_DURATION
end

function object_proto:UpdateFading()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 or not self:CanFade() then
        return
    end

    local now = GetTime()

    for i = 1, #self.activeMessages do
        local messageLine = self.activeMessages[i]

        if messageLine:GetID() == 0 then
            return
        end

        local timeDelta = now - m_max(messageLine:GetTimestamp(), self.overrideFadeTimestamp)
        local alpha = self:CalculateAlphaFromTimestampDelta(timeDelta)

        messageLine:SetAlpha(alpha)

        if alpha < 1 then
            messageLine:FadeOut(0, CHAT_FADE_OUT_DURATION * alpha)
        else
            messageLine:FadeOut(Style.db.fade.out_delay - timeDelta, CHAT_FADE_OUT_DURATION)
        end
    end
end

function object_proto:ShouldShowMessage(delta)
    if not Style.db.fade.enabled then
        return true
    end

    delta = delta - Style.db.fade.out_delay
    if delta >= CHAT_FADE_OUT_DURATION then
        return false
    end

    return true
end

function object_proto:RefreshActive(startIndex, maxPixels)
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 then
        return
    end

    maxPixels = maxPixels or self:GetTop()

    self:SetLastActiveMessageInfo(0, 0)

    local now = GetTime()
    local lineIndex = 0
    local messageID, messageInfo, messageLine

    local isFull = false
    while not isFull do
        lineIndex = lineIndex + 1
        messageID = startIndex + lineIndex - 1

        messageInfo = self:GetHistoryEntryAtIndex(messageID)
        if not messageInfo then
            lineIndex = lineIndex - 1

            break
        end

        if not self:ShouldShowMessage(now - m_max(messageInfo.timestamp, self.overrideFadeTimestamp)) then
            lineIndex = lineIndex - 1

            break
        end

        messageLine = self.activeMessages[lineIndex]
        if not messageLine then
            messageLine = self:AcquireMessageLine()
            self.activeMessages[lineIndex] = messageLine

            messageLine:ClearAllPoints()

            if lineIndex == 1 then
                messageLine:SetPoint("BOTTOMLEFT", self.ScrollChild, "BOTTOMLEFT", 0, 0)
            else
                messageLine:SetPoint("BOTTOMLEFT", self.activeMessages[lineIndex - 1], "TOPLEFT", 0, 0)
            end
        end

        -- Apply Battle.net friend class coloring if applicable
        --[[local coloredMessage = Style:getBNetFriendClassColor(messageInfo.message)
        if coloredMessage then
            messageLine:SetMessage(messageID, messageInfo.timestamp, coloredMessage, messageInfo.r, messageInfo.g,
                messageInfo.b)
        else]]
        messageLine:SetMessage(messageID, messageInfo.timestamp, messageInfo.message, messageInfo.r, messageInfo.g, messageInfo.b)
        -- end
        messageLine:StopFading(1)

        -- if :GetTop() is nil, then it means that the line is already hidden
        if not messageLine:GetTop() then
            lineIndex = lineIndex - 1

            break
        end

        isFull = messageLine:GetTop() + 1 >= maxPixels
    end

    if lineIndex > 0 then
        -- 2 is kinda arbitrary, I just want to make sure that only the first line of the last message is visible at the top
        self:SetLastActiveMessageInfo(messageID, self.activeMessages[lineIndex]:GetTop() - self:GetBottom() - self:GetMessageLineHeight() + 2)
    end

    -- just hide the excess, releasing and removing them here is expensive, they'll be taken care of when the frame gets
    -- hidden
    for i = lineIndex + 1, #self.activeMessages do
        if self.activeMessages[i]:GetID() ~= 0 then
            self.activeMessages[i]:ClearMessage()
        end
    end
end

function object_proto:FadeInMessages()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 then
        return
    end

    self:ResetFadingTimer()
    self:RefreshActive(self:GetFirstActiveMessageID())
    self:UpdateFading()
end

function object_proto:FastForward()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 then
        return
    end

    self:ResetFadingTimer()

    if self:GetNumHistoryElements() > 0 then
        self.numIncomingMessages = 0

        local id = m_min(self:GetNumHistoryElements(), self:GetMaxNumVisibleLines(), self:GetFirstActiveMessageID())
        if id >= 1 then
            self:RefreshActive(id)
            self:RefreshBackfill(id - 1, id - 1)
            self:EnableIncomingProcessing(true)
            self:SetSmoothScroll(self.funcCache.baseScroll, self:GetNegativeVerticalOffset(), self.funcCache.baseScrollCallback)
        else
            local offset = self:GetNegativeVerticalOffset()
            if offset > 0 then
                self:EnableIncomingProcessing(true)
                self:SetSmoothScroll(self.funcCache.baseScroll, offset, self.funcCache.baseScrollCallback)
            else
                self:ResetStateAfterUserScroll()
            end
        end
    end
end

function object_proto:ToggleScrollButtons()
    self.ScrollDownButton:SetShown(Style.db.buttons.up_and_down)
    self.ScrollUpButton:SetShown(Style.db.buttons.up_and_down)
end

local DOWN = 1
local UP = -1

local MAX_SCROLL = 8
local MED_SCROLL = 4
local MIN_SCROLL = 1

function object_proto:OnMouseWheel(delta)
    if self:GetNumHistoryElements() == 0 then
        return self:SetFirstActiveMessageID(0)
    end

    self:ResetFadingTimer()

    if delta == UP and self:IsAtBottom() then
        self:RefreshActive(self:GetFirstActiveMessageID())
        self:UpdateFading()

        return
    end

    if delta == DOWN and self:IsAtTop() then
        self:RefreshActive(self:GetFirstActiveMessageID())

        return
    end

    self:ResetState(true)

    local offset = (IsShiftKeyDown() and MAX_SCROLL or IsControlKeyDown() and MIN_SCROLL or MED_SCROLL) * self:GetMessageLineHeight()

    if delta == UP then
        self:RefreshActive(self:GetFirstActiveMessageID())
        self:RefreshBackfill(self:GetFirstActiveMessageID() - 1, false, self:GetBottom() - offset)

        offset = m_min(offset, self:GetNegativeVerticalOffset())
    else
        self:RefreshActive(self:GetFirstActiveMessageID(), self:GetTop() + offset)
        self:RefreshBackfill(0)

        offset = m_min(offset, self:GetLastActiveMessageOffset())
    end

    self:SetSmoothScroll(self.funcCache.baseScroll, -delta * offset, self.funcCache.userScrollCallback)
end

function object_proto:HasIncomingMessages()
    return self.numIncomingMessages ~= 0
end

function object_proto:NewIncomingMessage()
    if self:IsShown() then
        if self:IsScrolling() or not self:CanProcessIncoming() then
            self.numIncomingMessagesWhileScrolling = self.numIncomingMessagesWhileScrolling + 1
        end

        -- Always count new messages for processing
        if self:CanProcessIncoming() then
            self.numIncomingMessages = self.numIncomingMessages + 1
        end

        -- Update scroll to bottom button state
        if not self:IsAtBottom() then
            self.ScrollToBottomButton:SetState(2)
        end
    else
        -- Handle messages when frame is hidden
        if not self:IsAtBottom() then
            self:SetFirstVisibleMessageID(self:GetFirstVisibleMessageID() + 1)
        end
    end
end

function object_proto:IsMouseOverHyperlink()
    return self.mouseOverHyperlinkMessageLine and self.mouseOverHyperlinkMessageLine:IsShown()
end

function object_proto:OnFrame()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 or self:IsScrolling() then
        return
    end

    if self:HasIncomingMessages() and self:CanProcessIncoming() then
        self:ProcessIncoming(self.numIncomingMessages)
        self.numIncomingMessages = 0
    end

    self:UpdateChatWidgetFading()
end

function object_proto:FadeInChatWidgets()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 then
        return
    end

    self.isMouseOver = nil

    Style:StopFading(self.ChatTab, 1)
    Style:StopFading(self.ButtonFrame, 1)
    Style:StopFading(self.ScrollDownButton, 1)
    Style:StopFading(self.ScrollUpButton, 1)

    -- there's only one visible docked frame at a time
    if self:IsDocked() then
        Style:StopFading(GeneralDockManager, 1)
    end

    self:UpdateChatWidgetFading()
end

function object_proto:UpdateChatWidgetFading()
    if not self:IsShown() or self.ScrollChild:GetHeight() == 0 then
        return
    end
    if not Style.db.dock.fade.enabled then
        return
    end

    local isMouseOver = self:IsMouseOver(26, -36, -36, 0)
    if isMouseOver ~= self.isMouseOver then
        self.isMouseOver = isMouseOver

        -- ! DO NOT SHOW/HIDE tabs or gdm, it'll taint EVERYTHING, just adjust its alpha
        if isMouseOver then
            if self:IsDocked() then
                Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION, function()
                    if self.isMouseOver then
                        Style:StopFading(GeneralDockManager, 1)
                    elseif not isAnyChatAlerting() then
                        Style:FadeOut(GeneralDockManager, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                    end
                end)
            end

            if not self.ChatFrame.isDocked then
                Style:FadeIn(self.ChatTab, DOCK_FADE_IN_DURATION, function()
                    if self.isMouseOver then
                        Style:StopFading(self.ChatTab, 1)
                    else
                        Style:FadeOut(self.ChatTab, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                    end
                end)
            end

            Style:FadeIn(self.ButtonFrame, DOCK_FADE_IN_DURATION, function()
                if self.isMouseOver then
                    Style:StopFading(self.ButtonFrame, 1)
                else
                    Style:FadeOut(self.ButtonFrame, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                end
            end)

            if Style.db.buttons.up_and_down then
                Style:FadeIn(self.ScrollDownButton, DOCK_FADE_IN_DURATION, function()
                    if self.isMouseOver then
                        Style:StopFading(self.ScrollDownButton, 1)
                    else
                        Style:FadeOut(self.ScrollDownButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                    end
                end)

                Style:FadeIn(self.ScrollUpButton, DOCK_FADE_IN_DURATION, function()
                    if self.isMouseOver then
                        Style:StopFading(self.ScrollUpButton, 1)
                    else
                        Style:FadeOut(self.ScrollUpButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                    end
                end)
            end
        else
            if self:IsDocked() then
                if not isAnyChatAlerting() then
                    Style:FadeOut(GeneralDockManager, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                end
            end

            if not self.ChatFrame.isDocked then
                if not self.isDragging then
                    Style:FadeOut(self.ChatTab, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                else
                    Style:StopFading(self.ChatTab, 1)
                end
            end

            Style:FadeOut(self.ButtonFrame, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)

            if Style.db.buttons.up_and_down then
                Style:FadeOut(self.ScrollDownButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
                Style:FadeOut(self.ScrollUpButton, DOCK_FADE_OUT_DELAY, DOCK_FADE_OUT_DURATION)
            end
        end
    end
end

function object_proto:ProcessIncoming(num)
    self:RefreshBackfill(num, num)
    self:SetSmoothScroll(self.funcCache.baseScroll, self:GetLastBackfillMessageOffset(), self.funcCache.baseScrollCallback)
end

function object_proto:Release()
    self.pool:Release(self)
end

do
    local frames = {}
    local curID = nil

    local slidingMessageFramePool = CreateUnsecuredObjectPool(function(pool)
        local frame = Mixin(CreateFrame("ScrollFrame", "mUIFrame" .. curID, UIParent, "mUIHyperlinkPropagator"), object_proto)
        frame:EnableMouse(false)
        frame:Hide()

        -- local dbg = frame:CreateTexture("ARTWORK")
        -- dbg:SetAllPoints()
        -- dbg:SetColorTexture(0.1, 0.1, 0.1, 0.4)

        frame.activeMessages = {}
        frame.backfillMessages = {}
        frame.pool = pool

        local scrollChild = CreateFrame("Frame", nil, frame, "mUIHyperlinkPropagator")
        frame:SetFrameLevel(frame:GetFrameLevel() + 1)
        frame:SetScrollChild(scrollChild)
        frame.ScrollChild = scrollChild

        -- local dbg = scrollChild:CreateTexture("ARTWORK")
        -- dbg:SetAllPoints()
        -- dbg:SetColorTexture(0, 0.4, 0, 0.4)

        frame:SetScript("OnHide", frame.OnHide)
        frame:SetScript("OnShow", frame.OnShow)
        frame:SetScript("OnMouseWheel", frame.OnMouseWheel)
        frame:SetScript("OnUpdate", frame.OnFrame)

        local scrollToBottomButton = Style:CreateScrollToBottomButton(frame)
        scrollToBottomButton:SetPoint("BOTTOMRIGHT", -4, 4)
        scrollToBottomButton:SetFrameLevel(frame:GetFrameLevel() + 2)
        frame.ScrollToBottomButton = scrollToBottomButton

        local scrollDownButton = Style:CreateScrollButton(frame, 3)
        scrollDownButton:SetPoint("BOTTOMRIGHT", scrollToBottomButton, "TOPRIGHT", 0, 2)
        scrollDownButton:SetShown(Style.db.buttons.up_and_down)
        scrollDownButton:SetFrameLevel(frame:GetFrameLevel() + 2)
        frame.ScrollDownButton = scrollDownButton

        local scrollUpButton = Style:CreateScrollButton(frame, 4)
        scrollUpButton:SetPoint("BOTTOMRIGHT", scrollDownButton, "TOPRIGHT", 0, 2)
        scrollUpButton:SetShown(Style.db.buttons.up_and_down)
        scrollUpButton:SetFrameLevel(frame:GetFrameLevel() + 2)
        frame.ScrollUpButton = scrollUpButton

        -- these functions are always the same, so just cache them
        frame.funcCache = {
            baseScroll = function(n)
                frame:SetVerticalScroll(n)
            end,
            baseScrollCallback = function()
                frame:ResetState()
            end,
            userScrollCallback = function()
                frame:ResetStateAfterUserScroll()

                if not frame:IsAtBottom() then
                    frame.ScrollToBottomButton:Show()

                    if frame:HasIncomingMessages() then
                        frame.ScrollToBottomButton:SetState(2, true)
                    else
                        frame.ScrollToBottomButton:SetState(1, true)
                    end

                    Style:FadeIn(frame.ScrollToBottomButton, 0.1)
                else
                    Style:FadeOut(frame.ScrollToBottomButton, 0, 0.1, function()
                        frame.ScrollToBottomButton:SetState(1, true)
                        frame.ScrollToBottomButton:Hide()
                    end)
                end
            end,
            refreshDisplay = function()
                frame:RefreshIfNecessary()

                frame.refreshTimer = nil
            end
        }

        -- local backdrop = Style:CreateBackdrop(frame, 0, -4)
        -- frame.Backdrop = backdrop

        -- backdrop:SetBackdropColor(0, 0, 0, 0.4)
        -- backdrop:SetBackdropBorderColor(0, 0, 0, 0.4)

        frames[curID] = frame

        return frame
    end, function(_, frame, isNew)
        if isNew then
            return
        end

        frame:ReleaseChatFrame()
    end)

    function Style:HandleChatFrame(chatFrame, id)
        if chatFrame ~= ChatFrame2 then
            -- for the sake of matching names, otherwise it breaks my brain
            curID = chatFrame:GetID()

            local frame = slidingMessageFramePool:Acquire()
            frame:SetID(id)
            frame:CaptureChatFrame(chatFrame)

            return frame
        end
    end

    function Style:ForChatFrame(id, method, ...)
        local frame = frames[id]
        if frame and frame[method] then
            frame[method](frame, ...)
        end
    end
end

function Style:EnableAlerts()
    Style:SecureHook("FCF_StartAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = true

        Style:FadeIn(GeneralDockManager, DOCK_FADE_IN_DURATION)
    end)

    Style:SecureHook("FCF_StopAlertFlash", function(chatFrame)
        alertingFrames[chatFrame] = nil
    end)
end

-----------------------
-- BNET CLASS COLORS --
-----------------------

function Style:getBNetFriendClassColor(message)
    -- Check if this is a Battle.net whisper
    if not message then
        return nil
    end

    local senderName = nil
    local fullPattern = nil

    -- Pattern for sent whispers: [AccountName] whispers:
    fullPattern = message:match("^(%[.-%] whispers:)")
    if fullPattern then
        senderName = fullPattern:match("^%[(.-)%] whispers:")
    end

    -- Pattern for received whispers: |HBNplayer:...|h[AccountName]|h
    if not senderName then
        fullPattern = message:match("(|HBNplayer:.-|h%[.-%]|h)")
        if fullPattern then
            senderName = fullPattern:match("|HBNplayer:.-|h%[(.-)%]|h")
        end
    end

    if not senderName or not fullPattern then
        return nil
    end
    -- Cache to avoid repeated lookups
    if not Style.bnetCache then
        Style.bnetCache = {}
    end

    -- Check cache first
    if Style.bnetCache[senderName] then
        local cachedColor = Style.bnetCache[senderName]
        if cachedColor == false then
            return nil
        else
            -- Apply cached class color
            local colorCode = string.format("|cff%02x%02x%02x", cachedColor.r * 255, cachedColor.g * 255, cachedColor.b * 255)
            local coloredMessage = nil
            if fullPattern:match("^%[.-%] whispers:") then
                coloredMessage = message:gsub("(%[)(.-)(%] whispers:)", "%1" .. colorCode .. "%2|r%3", 1)
            elseif fullPattern:match("|HBNplayer:.-|h%[.-%]|h") then
                coloredMessage = message:gsub("(|HBNplayer:.-|h%[)(.-)(%]|h)", "%1" .. colorCode .. "%2|r%3", 1)
            end
            return coloredMessage
        end
    end

    -- Get all Battle.net friends and find the one with matching account name
    local numBNetFriends = BNGetNumFriends()
    for i = 1, numBNetFriends do
        local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
        if accountInfo and accountInfo.accountName == senderName then
            -- Check all game accounts for WoW character info
            local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(i)
            for j = 1, numGameAccounts do
                local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(i, j)
                if gameAccountInfo and gameAccountInfo.clientProgram == BNET_CLIENT_WOW and gameAccountInfo.className then
                    -- Convert localized class name to English class name
                    local englishClassName = nil
                    for engClass, localizedClass in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
                        if localizedClass == gameAccountInfo.className then
                            englishClassName = engClass
                            break
                        end
                    end
                    if not englishClassName then
                        for engClass, localizedClass in pairs(LOCALIZED_CLASS_NAMES_MALE) do
                            if localizedClass == gameAccountInfo.className then
                                englishClassName = engClass
                                break
                            end
                        end
                    end

                    -- Cache and return class color if found
                    if englishClassName and RAID_CLASS_COLORS[englishClassName] then
                        local classColor = RAID_CLASS_COLORS[englishClassName]
                        Style.bnetCache[senderName] = classColor

                        -- Apply class color to message
                        local colorCode = string.format("|cff%02x%02x%02x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
                        local coloredMessage = nil
                        if fullPattern:match("^%[.-%] whispers:") then
                            coloredMessage = message:gsub("(%[)(.-)(%] whispers:)", "%1" .. colorCode .. "%2|r%3", 1)
                        elseif fullPattern:match("|HBNplayer:.-|h%[.-%]|h") then
                            coloredMessage = message:gsub("(|HBNplayer:.-|h%[)(.-)(%]|h)", "%1" .. colorCode .. "%2|r%3", 1)
                        end
                        return coloredMessage
                    end
                end
            end
        end
    end

    -- Cache negative result to avoid repeated lookups
    Style.bnetCache[senderName] = false
    return nil
end

-- Clear the BNet friend cache when friend status changes
local bnetCacheFrame = CreateFrame("Frame")
bnetCacheFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bnetCacheFrame:RegisterEvent("BN_FRIEND_INFO_CHANGED")
bnetCacheFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
bnetCacheFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
bnetCacheFrame:SetScript("OnEvent", function()
    if Style.bnetCache then
        Style.bnetCache = {}
    end
end)
