local Style = mUI:NewModule("mUI.Modules.Chat.Style", "AceHook-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

function Style:OnInitialize()
    -- Load Database
    Style.db = mUI.db.profile.chat.settings
end

----------------------
-- HIDE SCROLLBAR --
----------------------

function Style:HideDefaultScrollbar(chatFrame)
    if not chatFrame then
        return
    end

    -- Force hide ScrollBar (modern WoW)
    if chatFrame.ScrollBar then
        Style:ForceHide(chatFrame.ScrollBar)
    end

    -- Force hide ScrollToBottomButton on the chatFrame itself
    if chatFrame.ScrollToBottomButton then
        Style:ForceHide(chatFrame.ScrollToBottomButton)
    end

    if chatFrame.ScrollToTopButton then
        Style:ForceHide(chatFrame.ScrollToTopButton)
    end

    -- Force hide buttonFrame elements (retail WoW structure)
    if chatFrame.buttonFrame then
        if chatFrame.buttonFrame.ScrollToBottomButton then
            Style:ForceHide(chatFrame.buttonFrame.ScrollToBottomButton)
        end
        if chatFrame.buttonFrame.ScrollToTopButton then
            Style:ForceHide(chatFrame.buttonFrame.ScrollToTopButton)
        end
        if chatFrame.buttonFrame.upButton then
            Style:ForceHide(chatFrame.buttonFrame.upButton)
        end
        if chatFrame.buttonFrame.downButton then
            Style:ForceHide(chatFrame.buttonFrame.downButton)
        end
        if chatFrame.buttonFrame.bottomButton then
            Style:ForceHide(chatFrame.buttonFrame.bottomButton)
        end
    end

    -- Force hide ResizeButton (also commonly visible)
    if chatFrame.ResizeButton then
        Style:ForceHide(chatFrame.ResizeButton)
    end
end

-------------------------------
-- HIDE CHATFRAME BACKGROUND --
-------------------------------

function Style:HideChatFrameBackground(chatFrame)
    if not chatFrame then
        return
    end

    -- Hide the default background texture
    for i = 1, chatFrame:GetNumRegions() do
        local region = select(i, chatFrame:GetRegions())
        if region and region:GetObjectType() == "Texture" then
            region:SetTexture(nil)
            region:Hide()
        end
    end

    -- Hide buttonFrame background and all its textures
    if chatFrame.buttonFrame then
        if chatFrame.buttonFrame.SetBackdrop then
            chatFrame.buttonFrame:SetBackdrop(nil)
        end
        for i = 1, chatFrame.buttonFrame:GetNumRegions() do
            local region = select(i, chatFrame.buttonFrame:GetRegions())
            if region and region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
                region:Hide()
            end
        end
    end

    -- Clear SetBackdrop if it exists to remove borders
    if chatFrame.SetBackdrop then
        chatFrame:SetBackdrop(nil)
    end

    -- Hide all backdrop textures (Center, edges, corners)
    if chatFrame.Center then
        chatFrame.Center:SetTexture(nil)
        chatFrame.Center:Hide()
    end
    if chatFrame.TopEdge then
        chatFrame.TopEdge:SetTexture(nil)
        chatFrame.TopEdge:Hide()
    end
    if chatFrame.BottomEdge then
        chatFrame.BottomEdge:SetTexture(nil)
        chatFrame.BottomEdge:Hide()
    end
    if chatFrame.LeftEdge then
        chatFrame.LeftEdge:SetTexture(nil)
        chatFrame.LeftEdge:Hide()
    end
    if chatFrame.RightEdge then
        chatFrame.RightEdge:SetTexture(nil)
        chatFrame.RightEdge:Hide()
    end
    if chatFrame.TopLeftCorner then
        chatFrame.TopLeftCorner:SetTexture(nil)
        chatFrame.TopLeftCorner:Hide()
    end
    if chatFrame.TopRightCorner then
        chatFrame.TopRightCorner:SetTexture(nil)
        chatFrame.TopRightCorner:Hide()
    end
    if chatFrame.BottomLeftCorner then
        chatFrame.BottomLeftCorner:SetTexture(nil)
        chatFrame.BottomLeftCorner:Hide()
    end
    if chatFrame.BottomRightCorner then
        chatFrame.BottomRightCorner:SetTexture(nil)
        chatFrame.BottomRightCorner:Hide()
    end
end

-----------------------------
-- ADD CHATFRAME BACKGROUND --
-----------------------------

function Style:AddChatFrameBackground(chatFrame)
    if not chatFrame then
        return
    end

    -- Create a custom backdrop for the chat frame with insets to create padding
    if not chatFrame.mUIBackdrop then
        chatFrame.mUIBackdrop = Style:CreateBackdrop(chatFrame, Style.db.chat.alpha, -4, -4)
    end
end

function Style:UpdateChatBackgroundAlpha()
    local alpha = Style.db.chat.alpha

    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame and chatFrame.mUIBackdrop then
            chatFrame.mUIBackdrop:UpdateAlpha(alpha)
        end
    end
end

------------------------------
-- SETUP SCROLL BUTTONS --
------------------------------

function Style:SetupScrollButtons(chatFrame)
    if not chatFrame or chatFrame.mUIScrollButtonsSetup then
        return
    end

    -- Create scroll up button (state 4)
    -- Create scroll to bottom button (state 1) - positioned at bottom with small padding
    chatFrame.mUIScrollToBottomButton = Style:CreateScrollToBottomButton(chatFrame)
    chatFrame.mUIScrollToBottomButton:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", -4, 4)
    chatFrame.mUIScrollToBottomButton:SetParent(chatFrame)
    chatFrame.mUIScrollToBottomButton:SetFrameLevel(chatFrame:GetFrameLevel() + 10)
    chatFrame.mUIScrollToBottomButton:Hide()

    -- Create scroll down button (state 3) - positioned above scroll to bottom button
    chatFrame.mUIScrollDownButton = Style:CreateScrollButton(chatFrame, 3)
    chatFrame.mUIScrollDownButton:SetPoint("BOTTOMRIGHT", chatFrame.mUIScrollToBottomButton, "TOPRIGHT", 0, 4)
    chatFrame.mUIScrollDownButton:SetParent(chatFrame)
    chatFrame.mUIScrollDownButton:SetFrameLevel(chatFrame:GetFrameLevel() + 10)

    -- Create scroll up button (state 4) - positioned above scroll down button
    chatFrame.mUIScrollUpButton = Style:CreateScrollButton(chatFrame, 4)
    chatFrame.mUIScrollUpButton:SetPoint("BOTTOMRIGHT", chatFrame.mUIScrollDownButton, "TOPRIGHT", 0, 4)
    chatFrame.mUIScrollUpButton:SetParent(chatFrame)
    chatFrame.mUIScrollUpButton:SetFrameLevel(chatFrame:GetFrameLevel() + 10)

    -- Hook scroll events to show/hide ScrollToBottom button
    chatFrame:HookScript("OnMouseWheel", function(self)
        if self.mUIScrollToBottomButton and self:AtBottom() then
            self.mUIScrollToBottomButton:Hide()
        elseif self.mUIScrollToBottomButton and not self:AtBottom() then
            Style:FadeIn(self.mUIScrollToBottomButton, 0.2)
            self.mUIScrollToBottomButton:Show()
        end
    end)

    -- Override mousewheel to scroll line by line (use SetScript to replace default behavior)
    if not chatFrame.mUIMouseWheelHooked then
        chatFrame:SetScript("OnMouseWheel", function(self, delta)
            if delta > 0 then
                self:ScrollUp()
            else
                self:ScrollDown()
            end

            -- Update ScrollToBottom button visibility - always show when not at bottom
            if self.mUIScrollToBottomButton then
                if self:AtBottom() then
                    Style:FadeOut(self.mUIScrollToBottomButton, 0, 0.2, function()
                        self.mUIScrollToBottomButton:Hide()
                    end)
                else
                    if not self.mUIScrollToBottomButton:IsShown() then
                        self.mUIScrollToBottomButton:SetAlpha(0)
                        self.mUIScrollToBottomButton:Show()
                        Style:FadeIn(self.mUIScrollToBottomButton, 0.2)
                    end
                end
            end
        end)
        chatFrame.mUIMouseWheelHooked = true
    end

    -- Add ToggleScrollButtons method to the chat frame
    chatFrame.ToggleScrollButtons = function(self)
        local shouldShow = Style.db.buttons.up_and_down
        if self.mUIScrollUpButton then
            self.mUIScrollUpButton:SetShown(shouldShow)
        end
        if self.mUIScrollDownButton then
            self.mUIScrollDownButton:SetShown(shouldShow)
        end
        if self.mUIScrollToBottomButton then
            if not shouldShow then
                self.mUIScrollToBottomButton:Hide()
            end
        end
    end

    -- Show or hide based on current setting
    chatFrame:ToggleScrollButtons()

    chatFrame.mUIScrollButtonsSetup = true
end

---------------------------------
-- UPDATE MESSAGE FONTS --
---------------------------------

function Style:UpdateEditBoxFont()
    -- Apply to all chat editboxes
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox then
            Style:ApplyEditBoxFont(editBox)
        end
    end
end

function Style:ApplyEditBoxFont(editBox)
    if not editBox then
        return
    end

    -- Get font settings
    local fontPath = LSM:Fetch("font", mUI.db.profile.general.font)
    local fontSize = Style.db.edit.font.size or 12
    local fontOutline = Style.db.edit.font.outline and "OUTLINE" or ""

    -- Validate font
    if not fontPath then
        fontPath = "Fonts\\FRIZQT__.TTF"
    end

    -- Apply to main edit box
    if editBox.SetFont then
        editBox:SetFont(fontPath, fontSize, fontOutline)
    end
    if editBox.SetShadowOffset then
        if Style.db.edit.font.shadow then
            editBox:SetShadowOffset(1, -1)
            editBox:SetShadowColor(0, 0, 0, 1)
        else
            editBox:SetShadowOffset(0, 0)
        end
    end

    -- Apply to header elements
    local headerElements = {editBox.header, editBox.headerSuffix, editBox.prompt, editBox.NewcomerHint}
    for _, element in ipairs(headerElements) do
        if element then
            if element.SetFont then
                element:SetFont(fontPath, fontSize, fontOutline)
            end
            if element.SetShadowOffset then
                if Style.db.edit.font.shadow then
                    element:SetShadowOffset(1, -1)
                    element:SetShadowColor(0, 0, 0, 1)
                else
                    element:SetShadowOffset(0, 0)
                end
            end
        end
    end
end

function Style:ApplyChatFrameFont(chatFrame)
    if not chatFrame then
        return
    end

    -- Get font settings
    local fontPath = LSM:Fetch("font", mUI.db.profile.general.font)
    local fontSize = Style.db.chat.font.size or 12
    local fontOutline = Style.db.chat.font.outline and "OUTLINE" or ""

    -- Validate font
    if not fontPath then
        fontPath = "Fonts\\FRIZQT__.TTF"
    end

    local fontObject = chatFrame:GetFontObject()
    if fontObject then
        fontObject:SetFont(fontPath, fontSize, fontOutline)
        if fontObject.SetShadowOffset then
            if Style.db.chat.font.shadow then
                fontObject:SetShadowOffset(1, -1)
                fontObject:SetShadowColor(0, 0, 0, 1)
            else
                fontObject:SetShadowOffset(0, 0)
            end
        end
    end

    -- Also update existing font strings to apply immediately
    if chatFrame.fontStringPool then
        for fontString in chatFrame.fontStringPool:EnumerateActive() do
            if fontString.SetFont then
                fontString:SetFont(fontPath, fontSize, fontOutline)
            end
            if fontString.SetShadowOffset then
                if Style.db.chat.font.shadow then
                    fontString:SetShadowOffset(1, -1)
                    fontString:SetShadowColor(0, 0, 0, 1)
                else
                    fontString:SetShadowOffset(0, 0)
                end
            end
        end
    end
end

function Style:UpdateMessageFonts()
    -- Update the font objects used by chat frames
    for i = 1, Constants.ChatFrameConstants.MaxChatWindows do
        local chatFrame = _G["ChatFrame" .. i]
        if chatFrame then
            Style:ApplyChatFrameFont(chatFrame)
        end
    end
end

function Style:ForMessageLinePool(id, method, ...)
    local chatFrame = _G["ChatFrame" .. id]
    if chatFrame and chatFrame.fontStringPool then
        for fontString in chatFrame.fontStringPool:EnumerateActive() do
            if fontString[method] then
                fontString[method](fontString, ...)
            end
        end
    end
end

-- Lua
local _G = getfenv(0)
local error = _G.error
local ipairs = _G.ipairs
local m_floor = _G.math.floor
local next = _G.next
local pcall = _G.pcall
local s_format = _G.string.format
local t_insert = _G.table.insert
local type = _G.type
local strsub = _G.string.sub
local strupper = _G.string.upper
local strlen = _G.string.len
local format = _G.string.format
local issecretvalue = canaccessvalue and function(v)
    return not canaccessvalue(v)
end or function()
    return false
end

------------
-- EVENTS --
------------

do
    local listeners = {}

    function Style:Subscribe(messageType, listener)
        if not listeners[messageType] then
            listeners[messageType] = {}
        end

        t_insert(listeners[messageType], listener)
    end

    function Style:Dispatch(messageType, payload)
        if not listeners[messageType] then
            return
        end

        for _, listener in ipairs(listeners[messageType]) do
            listener(payload)
        end
    end
end

do
    Style.oneTimeEvents = {
        ADDON_LOADED = false,
        PLAYER_LOGIN = false
    }
    Style.registeredEvents = {}

    Style.dispatcher = CreateFrame("Frame", "mUIEventFrame")

    function Style:RegisterEvent(event, func)
        if Style.oneTimeEvents[event] then
            error(s_format("Failed to register for '%s' event, already fired!", event), 3)
        end

        if not func or type(func) ~= "function" then
            error(s_format("Failed to register for '%s' event, no handler!", event), 3)
        end

        if not Style.registeredEvents[event] then
            Style.registeredEvents[event] = {}

            Style.dispatcher:RegisterEvent(event)
        end

        Style.registeredEvents[event][func] = true
    end

    function Style:UnregisterEvent(event, func)
        local funcs = Style.registeredEvents[event]

        if funcs and funcs[func] then
            funcs[func] = nil

            if not next(funcs) then
                Style.registeredEvents[event] = nil

                Style.dispatcher:UnregisterEvent(event)
            end
        end
    end

    function Style:EnableDispatcher()
        Style:SecureHookScript(Style.dispatcher, "OnEvent", function(_, event, ...)
            for func in next, Style.registeredEvents[event] do
                func(...)
            end

            if Style.oneTimeEvents[event] == false then
                Style.oneTimeEvents[event] = true
            end
        end)
    end
end

-----------
-- UTILS --
-----------

do
    local hidden = CreateFrame("Frame", nil, UIParent)
    hidden:Hide()

    function Style:ForceHide(object, skipEvents)
        if not object then
            return
        end

        object:Hide(true)
        object:SetParent(hidden)

        if object.EnableMouse then
            object:EnableMouse(false)
        end

        if object.UnregisterAllEvents then
            if not skipEvents then
                object:UnregisterAllEvents()
            end

            if object:GetName() then
                object.ignoreFramePositionManager = true
                object:SetAttribute("ignoreFramePositionManager", true)
            end

            object:SetAttribute("statehidden", true)
        end

        if object.SetUserPlaced then
            pcall(object.SetUserPlaced, object, true)
            pcall(object.SetDontSavePosition, object, true)
        end
    end
end

-----------
-- FADER --
-----------

do
    local function clamp(v)
        if v > 1 then
            return 1
        elseif v < 0 then
            return 0
        end

        return v
    end

    local function outCubic(t, b, c, d)
        t = t / d - 1
        return clamp(c * (t ^ 3 + 1) + b)
    end

    local FADE_IN = 1
    local FADE_OUT = -1

    local objects = {}
    local add, remove

    local updater = CreateFrame("Frame", "mUIFader")

    local function updater_OnUpdate(_, elapsed)
        for object, data in next, objects do
            data.fadeTimer = data.fadeTimer + elapsed
            if data.fadeTimer > 0 then
                data.initAlpha = data.initAlpha or object:GetAlpha()

                object:SetAlpha(outCubic(data.fadeTimer, data.initAlpha, data.finalAlpha - data.initAlpha, data.duration))

                if data.fadeTimer >= data.duration then
                    remove(object)

                    if data.callback then
                        data.callback(object)
                        data.callback = nil
                    end

                    object:SetAlpha(data.finalAlpha)
                end
            end
        end
    end

    function add(mode, object, delay, duration, callback)
        local initAlpha = object:GetAlpha()
        local finalAlpha = mode == FADE_IN and 1 or 0

        if delay == 0 and (duration == 0 or initAlpha == finalAlpha) then
            return callback and callback(object)
        end

        objects[object] = {
            mode = mode,
            fadeTimer = -delay,
            -- initAlpha = initAlpha,
            finalAlpha = finalAlpha,
            duration = duration,
            callback = callback
        }

        if not updater:GetScript("OnUpdate") then
            updater:SetScript("OnUpdate", updater_OnUpdate)
        end
    end

    function remove(object)
        objects[object] = nil

        if not next(objects) then
            updater:SetScript("OnUpdate", nil)
        end
    end

    function Style:FadeIn(object, duration, callback, delay)
        if not object then
            return
        end

        add(FADE_IN, object, delay or 0, duration * (1 - object:GetAlpha()), callback)
    end

    function Style:FadeOut(object, ...)
        if not object then
            return
        end

        add(FADE_OUT, object, ...)
    end

    function Style:StopFading(object, alpha)
        if not object then
            return
        end

        remove(object)

        object:SetAlpha(alpha or object:GetAlpha())
    end

    function Style:IsFading(object)
        local data = objects[object]
        if data then
            return data.mode
        end
    end
end

-------------
-- COLOURS --
-------------

do
    local color_proto = {}

    function color_proto:GetHex()
        return self.hex
    end

    -- override ColorMixin:GetRGBA
    function color_proto:GetRGBA(a)
        return self.r, self.g, self.b, a or self.a
    end

    -- override ColorMixin:SetRGBA
    function color_proto:SetRGBA(r, g, b, a)
        if r > 1 or g > 1 or b > 1 then
            r, g, b = r / 255, g / 255, b / 255
        end

        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.hex = s_format('ff%02x%02x%02x', self:GetRGBAsBytes())
    end

    -- override ColorMixin:WrapTextInColorCode
    function color_proto:WrapTextInColorCode(text)
        return "|c" .. self.hex .. text .. "|r"
    end

    function Style:CreateColor(r, g, b, a)
        local color = Mixin({}, ColorMixin, color_proto)
        color:SetRGBA(r, g, b, a)

        return color
    end
end

-----------
-- MATHS --
-----------

function Style:Round(v)
    return m_floor(v + 0.5)
end
