local mGUI = mUI.mGUI

local ROW_HEIGHT = 22

local function CreateRadioButton(group)
    local radio = CreateFrame("CheckButton", nil, group)
    radio:SetSize(16, 16)

    radio:SetNormalAtlas("common-radiobutton-circle")
    radio:SetHighlightAtlas("common-radiobutton-circle", "ADD")
    radio:GetHighlightTexture():SetAlpha(0.2)

    local dot = radio:CreateTexture(nil, "ARTWORK")
    dot:SetAtlas("common-radiobutton-dot")
    dot:SetAllPoints(radio)
    dot:SetDesaturated(true)
    dot:SetVertexColor(unpack(mGUI.Colors.accent))
    radio:SetCheckedTexture(dot)

    local label = radio:CreateFontString(nil, "OVERLAY")
    label:SetPoint("LEFT", radio, "RIGHT", 6, 0)
    label:SetTextColor(unpack(mGUI.Colors.text))
    radio.label = label

    radio:SetScript("OnClick", function(self)
        group:SetSelected(self.value)
        if group.OnValueChanged then
            group:OnValueChanged(self.value)
        end
    end)

    return radio
end

function mGUI.Widgets.RadioGroup(parent)
    local group = CreateFrame("Frame", nil, parent)
    group:SetSize(160, ROW_HEIGHT)
    group.buttons = {}
    group.titleOffset = 0

    local title = group:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT")
    title:SetTextColor(unpack(mGUI.Colors.text))
    group.title = title

    -- Call before SetOptions — the row offset depends on whether a title is set
    function group:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        self.title:SetText(text or "")
        self.titleOffset = (text and text ~= "") and 20 or 0
    end

    -- values: key -> display text, sorting: optional array of keys
    function group:SetOptions(values, sorting)
        local order = sorting
        if not order then
            order = {}
            for key in pairs(values) do
                order[#order + 1] = key
            end
            table.sort(order, function(a, b)
                return tostring(values[a]) < tostring(values[b])
            end)
        end

        local maxWidth = self.title:GetStringWidth()
        for i, key in ipairs(order) do
            local radio = self.buttons[i] or CreateRadioButton(self)
            self.buttons[i] = radio
            radio.value = key
            mGUI:SetFont(radio.label, 12)
            radio.label:SetText(tostring(values[key]))
            radio:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -self.titleOffset - (i - 1) * ROW_HEIGHT)
            radio:SetHitRectInsets(0, -(radio.label:GetStringWidth() + 8), 0, 0)
            radio:Show()
            maxWidth = math.max(maxWidth, radio.label:GetStringWidth() + 24)
        end
        for i = #order + 1, #self.buttons do
            self.buttons[i]:Hide()
        end

        self:SetSize(maxWidth, self.titleOffset + #order * ROW_HEIGHT)
    end

    function group:SetSelected(value)
        self.selected = value
        for _, radio in ipairs(self.buttons) do
            radio:SetChecked(radio.value == value)
        end
    end

    function group:SetWidgetEnabled(enabled)
        for _, radio in ipairs(self.buttons) do
            radio:SetEnabled(enabled)
            radio:GetNormalTexture():SetDesaturated(not enabled)
            radio.label:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
        end
    end

    return group
end
