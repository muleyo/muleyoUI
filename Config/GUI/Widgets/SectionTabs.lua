local mGUI = mUI.mGUI

local function CreateTabButton(bar)
    local button = CreateFrame("Button", nil, bar)
    button:SetHeight(28)

    local label = button:CreateFontString(nil, "OVERLAY")
    label:SetPoint("CENTER", 0, 2)
    button.label = label

    local underline = button:CreateTexture(nil, "ARTWORK")
    underline:SetPoint("BOTTOMRIGHT", -6, 0)
    underline:SetHeight(2)
    underline:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    underline:SetVertexColor(unpack(mGUI.Colors.accent))
    mUI:DisablePixelSnap(underline)
    button.underline = underline

    button:SetScript("OnEnter", function(self)
        if not self.active then
            self.label:SetTextColor(1, 1, 1)
        end
    end)
    button:SetScript("OnLeave", function(self)
        if not self.active then
            self.label:SetTextColor(unpack(mGUI.Colors.textDim))
        end
    end)
    button:SetScript("OnClick", function(self)
        if not self.active and bar.callback then
            bar.callback(self.sectionName, self.sectionIndex)
        end
    end)

    return button
end

function mGUI.Widgets.SectionTabs(parent)
    local bar = CreateFrame("Frame", nil, parent)
    bar:SetHeight(34)
    bar.buttons = {}

    local line = bar:CreateTexture(nil, "BACKGROUND")
    line:SetPoint("BOTTOMLEFT")
    line:SetPoint("BOTTOMRIGHT")
    line:SetHeight(1)
    line:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    line:SetVertexColor(mGUI.Colors.border[1], mGUI.Colors.border[2], mGUI.Colors.border[3], 0.4)
    mUI:DisablePixelSnap(line)

    function bar:SetTabs(names, activeIndex, callback)
        self.callback = callback
        local x = 0
        for i, name in ipairs(names) do
            local button = self.buttons[i] or CreateTabButton(self)
            self.buttons[i] = button
            button.sectionName = name
            button.sectionIndex = i
            button.active = i == activeIndex

            mGUI:SetFont(button.label, 13)
            button.label:SetText(name)
            button.underline:ClearAllPoints()
            button.underline:SetPoint("BOTTOMLEFT", i == 1 and 0 or 6, 0)
            button.underline:SetPoint("BOTTOMRIGHT", -6, 0)
            if button.active then
                button.label:SetTextColor(unpack(mGUI.Colors.accent))
                button.underline:Show()
            else
                button.label:SetTextColor(unpack(mGUI.Colors.textDim))
                button.underline:Hide()
            end

            button:SetWidth(button.label:GetStringWidth() + 28)
            button:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", x, 0)
            button:Show()
            x = x + button:GetWidth()
        end
        for i = #names + 1, #self.buttons do
            self.buttons[i]:Hide()
        end
    end

    return bar
end
