local mGUI = mUI.mGUI

function mGUI.Widgets.MultiLineEditBox(parent)
    local container = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    container:SetSize(500, 220)

    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT")
    title:SetTextColor(unpack(mGUI.Colors.text))
    container.title = title

    local boxFrame = CreateFrame("Frame", nil, container, "BackdropTemplate")
    PixelUtil.SetPoint(boxFrame, "TOPLEFT", container, "TOPLEFT", 0, -18)
    boxFrame:SetPoint("BOTTOMRIGHT")
    mGUI:ApplyBackdrop(boxFrame, "bgWidget", "border")

    local scroll = CreateFrame("ScrollFrame", nil, boxFrame, "ScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 8, -8)
    scroll:SetPoint("BOTTOMRIGHT", -26, 8)

    if scroll.ScrollBar then
        scroll.ScrollBar:Hide()
        scroll.ScrollBar:ClearAllPoints()
    end
    local scrollBar = CreateFrame("EventFrame", nil, scroll, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 6, 2)
    scrollBar:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 6, 5)
    scroll.ScrollBar = scrollBar
    ScrollUtil.InitScrollFrameWithScrollBar(scroll, scrollBar)
    scrollBar:Show()
    scrollBar:Update()
    scrollBar:SetHideIfUnscrollable(true)
    scrollBar:SetHideTrackIfThumbExceedsTrack(true)

    local box = CreateFrame("EditBox", nil, scroll)
    box:SetMultiLine(true)
    box:SetAutoFocus(false)
    box:SetWidth(scroll:GetWidth())
    box:SetTextColor(unpack(mGUI.Colors.text))
    scroll:SetScrollChild(box)
    container.box = box

    scroll:HookScript("OnSizeChanged", function(self)
        box:SetWidth(self:GetWidth())
    end)

    -- Click anywhere in the empty area focuses the editbox
    boxFrame:EnableMouse(true)
    boxFrame:SetScript("OnMouseDown", function()
        box:SetFocus()
    end)

    box:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    box:SetScript("OnTextChanged", function(self, userInput)
        if userInput and container.OnValueChanged then
            container:OnValueChanged(self:GetText())
        end
    end)
    box:SetScript("OnEditFocusGained", function(self)
        if container.selectAllOnFocus then
            self:HighlightText()
        end
    end)

    function container:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        mGUI:SetFont(self.box, 11)
        self.title:SetText(text or "")
    end

    function container:SetValue(text)
        self.box:SetText(text or "")
        self.box:SetCursorPosition(0)
    end

    function container:GetValue()
        return self.box:GetText()
    end

    function container:SetWidgetEnabled(enabled)
        self.box:SetEnabled(enabled)
        self.title:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
    end

    return container
end
