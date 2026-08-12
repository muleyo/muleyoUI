local mGUI = mUI.mGUI

local ROW_HEIGHT = 28
local BOTTOM_PAD = 6

local function CreateTabButton(bar)
    local button = CreateFrame("Button", nil, bar)
    button:SetHeight(ROW_HEIGHT)

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
    bar:SetHeight(ROW_HEIGHT + BOTTOM_PAD)
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

        -- Wrap onto additional rows instead of running off the edge of the
        -- panel -- the number of feature sections keeps growing and a fixed
        -- single-row bar silently clips whatever doesn't fit.
        local maxWidth = self:GetWidth()
        local x, row = 0, 0
        for i, name in ipairs(names) do
            local button = self.buttons[i] or CreateTabButton(self)
            self.buttons[i] = button
            button.sectionName = name
            button.sectionIndex = i
            button.active = i == activeIndex

            mGUI:SetFont(button.label, 13)
            button.label:SetText(name)

            local width = button.label:GetStringWidth() + 28
            if maxWidth and maxWidth > 0 and x > 0 and x + width > maxWidth then
                x, row = 0, row + 1
            end

            button:SetWidth(width)
            button.underline:ClearAllPoints()
            button.underline:SetPoint("BOTTOMLEFT", x == 0 and 0 or 6, 0)
            button.underline:SetPoint("BOTTOMRIGHT", -6, 0)
            if button.active then
                button.label:SetTextColor(unpack(mGUI.Colors.accent))
                button.underline:Show()
            else
                button.label:SetTextColor(unpack(mGUI.Colors.textDim))
                button.underline:Hide()
            end

            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", self, "TOPLEFT", x, -row * ROW_HEIGHT)
            button:Show()
            x = x + width
        end
        for i = #names + 1, #self.buttons do
            self.buttons[i]:Hide()
        end

        self:SetHeight((row + 1) * ROW_HEIGHT + BOTTOM_PAD)
    end

    return bar
end
