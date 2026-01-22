local Type, Version = "mUI_MultiLineEditBox", 33
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then
    return
end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local GetCursorInfo, ClearCursor = GetCursorInfo, ClearCursor
local CreateFrame, UIParent = CreateFrame, UIParent
local _G = _G

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

if not AceGUIMultiLineEditBoxInsertLink then
    -- upgradeable hook
    hooksecurefunc("ChatEdit_InsertLink", function(...)
        return _G.AceGUIMultiLineEditBoxInsertLink(...)
    end)
end

function _G.AceGUIMultiLineEditBoxInsertLink(text)
    for i = 1, AceGUI:GetWidgetCount(Type) do
        local editbox = _G[("MultiLineEditBox%uEdit"):format(i)]
        if editbox and editbox:IsVisible() and editbox:HasFocus() then
            editbox:Insert(text)
            return true
        end
    end
end

local function Layout(self)
    self:SetHeight(self.numlines * 14 + (self.disablebutton and 19 or 41) + self.labelHeight)

    if self.labelHeight == 0 then
        self.scrollBar:SetPoint("TOP", self.frame, "TOP", 0, -23)
        self.scrollBG:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0)
    else
        self.scrollBar:SetPoint("TOP", self.label, "BOTTOM", 0, -19)
        self.scrollBG:SetPoint("TOPLEFT", self.label, "BOTTOMLEFT", 0, -5)
    end

    if self.disablebutton then
        self.scrollBar:SetPoint("BOTTOM", self.frame, "BOTTOM", 0, 21)
        self.scrollBG:SetPoint("BOTTOMLEFT", 0, 4)
    else
        self.scrollBar:SetPoint("BOTTOM", self.button, "TOP", 0, 18)
        self.scrollBG:SetPoint("BOTTOMLEFT", self.button, "TOPLEFT")
    end
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function OnClick(self) -- Button
    self = self.obj
    self.editBox:ClearFocus()
    if not self:Fire("OnEnterPressed", self.editBox:GetText()) then
        self.button:Disable()
    end
end

local function OnCursorChanged(self, _, y, _, cursorHeight) -- EditBox
    self, y = self.obj.scrollFrame, -y
    local offset = self:GetVerticalScroll()
    if y < offset then
        self:SetVerticalScroll(y)
    else
        y = y + cursorHeight - self:GetHeight()
        if y > offset then
            self:SetVerticalScroll(y)
        end
    end
end

local function OnEditFocusLost(self) -- EditBox
    self:HighlightText(0, 0)
    self.obj:Fire("OnEditFocusLost")
end

local function OnEnter(self) -- EditBox / ScrollFrame
    self = self.obj
    if not self.entered then
        self.entered = true
        self:Fire("OnEnter")
    end
end

local function OnLeave(self) -- EditBox / ScrollFrame
    self = self.obj
    if self.entered then
        self.entered = nil
        self:Fire("OnLeave")
    end
end

local function OnMouseUp(self) -- ScrollFrame
    self = self.obj.editBox
    self:SetFocus()
    self:SetCursorPosition(self:GetNumLetters())
end

local function OnReceiveDrag(self) -- EditBox / ScrollFrame
    local type, id, info, extra = GetCursorInfo()
    if type == "spell" then
        if C_Spell and C_Spell.GetSpellName then
            info = C_Spell.GetSpellName(extra)
        else
            info = GetSpellInfo(id, info)
        end
    elseif type ~= "item" then
        return
    end
    ClearCursor()
    self = self.obj
    local editBox = self.editBox
    if not editBox:HasFocus() then
        editBox:SetFocus()
        editBox:SetCursorPosition(editBox:GetNumLetters())
    end
    editBox:Insert(info)
    self.button:Enable()
end

local function OnSizeChanged(self, width, height) -- ScrollFrame
    self.obj.editBox:SetWidth(width)
end

local function OnTextChanged(self, userInput) -- EditBox
    if userInput then
        self = self.obj
        self:Fire("OnTextChanged", self.editBox:GetText())
        self.button:Enable()
    end
end

local function OnTextSet(self) -- EditBox
    self:HighlightText(0, 0)
    self:SetCursorPosition(self:GetNumLetters())
    self:SetCursorPosition(0)
    self.obj.button:Disable()
end

local function OnVerticalScroll(self, offset) -- ScrollFrame
    local editBox = self.obj.editBox
    editBox:SetHitRectInsets(0, 0, offset, editBox:GetHeight() - offset - self:GetHeight())
end

local function OnScrollRangeChanged(self, xrange, yrange)
    if yrange == 0 then
        self.obj.editBox:SetHitRectInsets(0, 0, 0, 0)
    else
        OnVerticalScroll(self, self:GetVerticalScroll())
    end
end

local function OnShowFocus(frame)
    frame.obj.editBox:SetFocus()
    frame:SetScript("OnShow", nil)
end

local function OnEditFocusGained(frame)
    AceGUI:SetFocus(frame.obj)
    frame.obj:Fire("OnEditFocusGained")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
    ["OnAcquire"] = function(self)
        self.editBox:SetText("")
        self:SetDisabled(false)
        self:SetWidth(200)
        self:DisableButton(false)
        self:SetNumLines()
        self.entered = nil
        self:SetMaxLetters(0)
    end,

    ["OnRelease"] = function(self)
        self:ClearFocus()
    end,

    ["SetDisabled"] = function(self, disabled)
        local editBox = self.editBox
        if disabled then
            editBox:ClearFocus()
            editBox:EnableMouse(false)
            editBox:SetTextColor(0.5, 0.5, 0.5)
            self.label:SetTextColor(0.5, 0.5, 0.5)
            self.scrollFrame:EnableMouse(false)
            self.button:Disable()
        else
            editBox:EnableMouse(true)
            editBox:SetTextColor(1, 1, 1)
            self.label:SetTextColor(1, 0.82, 0)
            self.scrollFrame:EnableMouse(true)
        end
    end,

    ["SetLabel"] = function(self, text)
        if text and text ~= "" then
            self.label:SetText(text)
            if self.labelHeight ~= 10 then
                self.labelHeight = 10
                self.label:Show()
            end
        elseif self.labelHeight ~= 0 then
            self.labelHeight = 0
            self.label:Hide()
        end
        Layout(self)
    end,

    ["SetNumLines"] = function(self, value)
        if not value or value < 4 then
            value = 4
        end
        self.numlines = value
        Layout(self)
    end,

    ["SetText"] = function(self, text)
        self.editBox:SetText(text)
    end,

    ["GetText"] = function(self)
        return self.editBox:GetText()
    end,

    ["SetMaxLetters"] = function(self, num)
        self.editBox:SetMaxLetters(num or 0)
    end,

    ["DisableButton"] = function(self, disabled)
        self.disablebutton = disabled
        if disabled then
            self.button:Hide()
        else
            self.button:Show()
        end
        Layout(self)
    end,

    ["ClearFocus"] = function(self)
        self.editBox:ClearFocus()
        self.frame:SetScript("OnShow", nil)
    end,

    ["SetFocus"] = function(self)
        self.editBox:SetFocus()
        if not self.frame:IsShown() then
            self.frame:SetScript("OnShow", OnShowFocus)
        end
    end,

    ["HighlightText"] = function(self, from, to)
        self.editBox:HighlightText(from, to)
    end,

    ["GetCursorPosition"] = function(self)
        return self.editBox:GetCursorPosition()
    end,

    ["SetCursorPosition"] = function(self, ...)
        return self.editBox:SetCursorPosition(...)
    end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local pixel = 1 / UIParent:GetEffectiveScale()

local backdrop = {
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeSize = pixel,
    insets = {
        left = pixel,
        right = pixel,
        top = pixel,
        bottom = pixel
    }
}

local function Constructor()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:Hide()

    local widgetNum = AceGUI:GetNextWidgetNum(Type)

    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -4)
    label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -4)
    label:SetJustifyH("LEFT")
    label:SetText(ACCEPT)
    label:SetHeight(10)

    local button = CreateFrame("Button", ("%s%dButton"):format(Type, widgetNum), frame, "UIPanelButtonTemplate")
    button:SetPoint("BOTTOMLEFT", 0, 6)
    button:SetHeight(22)
    button:SetWidth(label:GetStringWidth() + 24)
    button:SetText(ACCEPT)
    button:SetScript("OnClick", OnClick)
    button:Disable()

    button:SetNormalTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_normal.png")
    button:SetHighlightTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_highlight.png")
    button:SetPushedTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_pressed.png")
    button:SetDisabledTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_disabled.png")

    button.Left:Hide()
    button.Middle:Hide()
    button.Right:Hide()

    local text = button:GetFontString()
    text:ClearAllPoints()
    text:SetPoint("TOPLEFT", button, "TOPLEFT", 5, -5)
    text:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -5, 1)
    text:SetJustifyV("MIDDLE")

    local scrollBG = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    scrollBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    scrollBG:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 0)
    scrollBG:SetBackdrop(backdrop)
    scrollBG:SetBackdropBorderColor(0, 0.6, 1, 1)
    scrollBG:SetFrameLevel(frame:GetFrameLevel() + 1)

    local scrollFrame = CreateFrame("ScrollFrame", ("%s%dScrollFrame"):format(Type, widgetNum), frame,
        "UIPanelScrollFrameTemplate")
    scrollFrame:SetFrameLevel(scrollBG:GetFrameLevel() + 1)

    local scrollBar = _G[scrollFrame:GetName() .. "ScrollBar"]
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOPLEFT", scrollBG, "TOPRIGHT", 2, -3)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBG, "BOTTOMRIGHT", 2, 3)

    local thumbTexture = scrollBar:GetThumbTexture()
    scrollBar:SetThumbTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\slider_thumb.png")
    thumbTexture:SetWidth(8)
    scrollBar:SetWidth(8)

    if not scrollBar.border then
        scrollBar.border = CreateFrame("Frame", nil, scrollBar, "BackdropTemplate")
        scrollBar.border:SetBackdrop({
            edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeSize = 1
        })

        scrollBar.border:ClearAllPoints()
        scrollBar.border:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", 0, -0.5)
        scrollBar.border:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMRIGHT", 0, 0)
        scrollBar.border:SetBackdropBorderColor(0, 0.6, 1, 1)
    end

    local scrollUp = scrollBar.ScrollUpButton
    local scrollUpNormal = scrollUp:GetNormalTexture()
    local scrollUpPushed = scrollUp:GetPushedTexture()
    local scrollUpHighlight = scrollUp:GetHighlightTexture()
    local scrollUpDisabled = scrollUp:GetDisabledTexture()

    local scrollDown = scrollBar.ScrollDownButton
    local scrollDownNormal = scrollDown:GetNormalTexture()
    local scrollDownPushed = scrollDown:GetPushedTexture()
    local scrollDownHighlight = scrollDown:GetHighlightTexture()
    local scrollDownDisabled = scrollDown:GetDisabledTexture()

    scrollUpNormal:SetAtlas("glues-characterSelect-icon-arrowUp")
    scrollUpNormal:SetDesaturated(true)
    scrollUpNormal:SetVertexColor(0, 0.6, 1)

    scrollUpPushed:SetAtlas("glues-characterSelect-icon-arrowUp-pressed")
    scrollUpPushed:SetDesaturated(true)
    scrollUpPushed:SetVertexColor(0, 0.2, 1)

    scrollUpHighlight:SetAtlas("glues-characterSelect-icon-arrowUp-hover")
    scrollUpHighlight:SetDesaturated(true)
    scrollUpHighlight:SetVertexColor(0, 0.8, 1)

    scrollUpDisabled:SetAtlas("glues-characterSelect-icon-arrowDown-disabled")
    scrollUpDisabled:SetRotation(math.pi)

    scrollDownNormal:SetAtlas("glues-characterSelect-icon-arrowDown")
    scrollDownNormal:SetDesaturated(true)
    scrollDownNormal:SetVertexColor(0, 0.6, 1)

    scrollDownPushed:SetAtlas("glues-characterSelect-icon-arrowDown-pressed")
    scrollDownPushed:SetDesaturated(true)
    scrollDownPushed:SetVertexColor(0, 0.2, 1)

    scrollDownHighlight:SetAtlas("glues-characterSelect-icon-arrowDown-hover")
    scrollDownHighlight:SetDesaturated(true)
    scrollDownHighlight:SetVertexColor(0, 0.8, 1)

    scrollDownDisabled:SetAtlas("glues-characterSelect-icon-arrowDown-disabled")

    scrollFrame:SetPoint("TOPLEFT", scrollBG, "TOPLEFT", 5, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", scrollBG, "BOTTOMRIGHT", -4, 4)
    scrollFrame:SetScript("OnEnter", OnEnter)
    scrollFrame:SetScript("OnLeave", OnLeave)
    scrollFrame:SetScript("OnMouseUp", OnMouseUp)
    scrollFrame:SetScript("OnReceiveDrag", OnReceiveDrag)
    scrollFrame:SetScript("OnSizeChanged", OnSizeChanged)
    scrollFrame:HookScript("OnVerticalScroll", OnVerticalScroll)
    scrollFrame:HookScript("OnScrollRangeChanged", OnScrollRangeChanged)

    local editBox = CreateFrame("EditBox", ("%s%dEdit"):format(Type, widgetNum), scrollFrame)
    editBox:SetAllPoints()
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetMultiLine(true)
    editBox:EnableMouse(true)
    editBox:SetAutoFocus(false)
    editBox:SetCountInvisibleLetters(false)
    editBox:SetScript("OnCursorChanged", OnCursorChanged)
    editBox:SetScript("OnEditFocusLost", OnEditFocusLost)
    editBox:SetScript("OnEnter", OnEnter)
    editBox:SetScript("OnEscapePressed", editBox.ClearFocus)
    editBox:SetScript("OnLeave", OnLeave)
    editBox:SetScript("OnMouseDown", OnReceiveDrag)
    editBox:SetScript("OnReceiveDrag", OnReceiveDrag)
    editBox:SetScript("OnTextChanged", OnTextChanged)
    editBox:SetScript("OnTextSet", OnTextSet)
    editBox:SetScript("OnEditFocusGained", OnEditFocusGained)

    scrollFrame:SetScrollChild(editBox)

    local widget = {
        button = button,
        editBox = editBox,
        frame = frame,
        label = label,
        labelHeight = 10,
        numlines = 4,
        scrollBar = scrollBar,
        scrollBG = scrollBG,
        scrollFrame = scrollFrame,
        type = Type
    }
    for method, func in pairs(methods) do
        widget[method] = func
    end
    button.obj, editBox.obj, scrollFrame.obj = widget, widget, widget

    return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
