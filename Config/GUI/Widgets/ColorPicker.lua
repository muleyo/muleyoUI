local mGUI = mUI.mGUI

function mGUI.Widgets.ColorPicker(parent)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(20, 46)
    container:EnableMouse(true) -- lets the generic tooltip hook fire on hover
    container.mGUICompact = true

    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT")
    title:SetTextColor(unpack(mGUI.Colors.text))
    container.title = title

    local swatch = CreateFrame("Button", nil, container, "BackdropTemplate")
    PixelUtil.SetSize(swatch, 20, 20)
    PixelUtil.SetPoint(swatch, "BOTTOMLEFT", container, "BOTTOMLEFT", 0, 3)
    mGUI:ApplyBackdrop(swatch, "bgWidget", "border")
    container.swatch = swatch
    container.mGUITooltipFrame = swatch
    container.mGUITooltipFrameOnly = true

    local color = swatch:CreateTexture(nil, "ARTWORK")
    color:SetPoint("TOPLEFT", 2, -2)
    color:SetPoint("BOTTOMRIGHT", -2, 2)
    color:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    swatch.color = color

    local function Apply(r, g, b, a)
        container.r, container.g, container.b, container.a = r, g, b, a
        color:SetVertexColor(r, g, b, a or 1)
        if container.OnValueChanged then
            container:OnValueChanged(r, g, b, a or 1)
        end
    end

    swatch:SetScript("OnClick", function()
        local prevR, prevG, prevB, prevA = container.r, container.g, container.b, container.a
        ColorPickerFrame:SetupColorPickerAndShow({
            r = prevR,
            g = prevG,
            b = prevB,
            opacity = prevA,
            hasOpacity = container.hasAlpha,
            swatchFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                local a = container.hasAlpha and ColorPickerFrame:GetColorAlpha() or 1
                Apply(r, g, b, a)
            end,
            opacityFunc = function()
                local r, g, b = ColorPickerFrame:GetColorRGB()
                Apply(r, g, b, ColorPickerFrame:GetColorAlpha())
            end,
            cancelFunc = function()
                Apply(prevR, prevG, prevB, prevA)
            end
        })
    end)

    function container:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        self.title:SetText(text or "")
        self:SetWidth(math.max(20, self.title:GetStringWidth()))
    end

    function container:SetColor(r, g, b, a)
        self.r, self.g, self.b, self.a = r, g, b, a or 1
        self.swatch.color:SetVertexColor(r, g, b, a or 1)
    end

    function container:SetWidgetEnabled(enabled)
        self.swatch:SetEnabled(enabled)
        self.swatch.color:SetDesaturated(not enabled)
        self.title:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
    end

    return container
end
