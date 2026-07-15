local mGUI = mUI.mGUI

local FONT_SIZES = {
    small = 11,
    medium = 12,
    large = 14
}

function mGUI.Widgets.Label(parent)
    local label = CreateFrame("Frame", nil, parent)
    label:SetHeight(20)

    local image = label:CreateTexture(nil, "ARTWORK")
    image:SetPoint("TOPLEFT")
    image:Hide()
    label.image = image

    local text = label:CreateFontString(nil, "OVERLAY")
    text:SetPoint("TOPLEFT")
    text:SetJustifyH("LEFT")
    text:SetJustifyV("TOP")
    text:SetTextColor(unpack(mGUI.Colors.textDim))
    label.text = text

    function label:SetLabel(value, fontSize)
        mGUI:SetFont(self.text, FONT_SIZES[fontSize] or FONT_SIZES.medium)
        self.text:SetText(value or "")
    end

    function label:SetImage(path, width, height)
        if path then
            self.image:SetTexture(path)
            self.image:SetSize(width or 32, height or 32)
            self.image:Show()
            self.text:ClearAllPoints()
            self.text:SetPoint("LEFT", self.image, "RIGHT", 8, 0)
        else
            self.image:Hide()
            self.text:ClearAllPoints()
            self.text:SetPoint("TOPLEFT")
        end
    end

    -- Called by the renderer after the flow layout fixed our width
    function label:UpdateHeight(width)
        self.text:SetWidth(width - (self.image:IsShown() and (self.image:GetWidth() + 8) or 0))
        local textHeight = self.text:GetStringHeight()
        local imageHeight = self.image:IsShown() and self.image:GetHeight() or 0
        self:SetHeight(math.max(textHeight, imageHeight) + 4)
    end

    return label
end
