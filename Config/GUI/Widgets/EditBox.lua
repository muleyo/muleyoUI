local mGUI = mUI.mGUI

function mGUI.Widgets.EditBox(parent)
    local container = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    container:SetSize(230, 46)

    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT")
    title:SetTextColor(unpack(mGUI.Colors.text))
    container.title = title

    local boxFrame = CreateFrame("Frame", nil, container, "BackdropTemplate")
    boxFrame:SetPoint("BOTTOMLEFT")
    boxFrame:SetPoint("BOTTOMRIGHT")
    PixelUtil.SetHeight(boxFrame, 24)
    mGUI:ApplyBackdrop(boxFrame, "bgWidget", "border")

    local box = CreateFrame("EditBox", nil, boxFrame)
    box:SetPoint("TOPLEFT", 6, 0)
    box:SetPoint("BOTTOMRIGHT", -6, 0)
    box:SetAutoFocus(false)
    box:SetTextColor(unpack(mGUI.Colors.text))
    container.box = box

    box:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        if container.OnValueChanged then
            container:OnValueChanged(self:GetText())
        end
    end)
    box:SetScript("OnEscapePressed", function(self)
        self:SetText(container.lastValue or "")
        self:ClearFocus()
    end)

    function container:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        mGUI:SetFont(self.box, 12)
        self.title:SetText(text or "")
    end

    function container:SetValue(text)
        self.lastValue = text or ""
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
