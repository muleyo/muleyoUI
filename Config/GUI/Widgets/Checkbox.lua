local mGUI = mUI.mGUI

function mGUI.Widgets.Checkbox(parent)
    local check = CreateFrame("CheckButton", nil, parent)
    check:SetSize(24, 24)

    check:SetNormalAtlas("checkbox-minimal")
    check:SetPushedAtlas("checkbox-minimal")

    local checked = check:CreateTexture(nil, "ARTWORK")
    checked:SetAtlas("checkmark-minimal", true)
    checked:SetPoint("CENTER")
    -- Blue tick instead of the default gold one
    checked:SetDesaturated(true)
    checked:SetVertexColor(unpack(mGUI.Colors.accent))
    check:SetCheckedTexture(checked)

    local disabledChecked = check:CreateTexture(nil, "ARTWORK")
    disabledChecked:SetAtlas("checkmark-minimal-disabled", true)
    disabledChecked:SetPoint("CENTER")
    check:SetDisabledCheckedTexture(disabledChecked)

    local label = check:CreateFontString(nil, "OVERLAY")
    label:SetPoint("LEFT", check, "RIGHT", 6, 0)
    label:SetTextColor(unpack(mGUI.Colors.text))
    check.label = label

    check:SetHighlightAtlas("checkbox-minimal", "ADD")
    local hoverGlow = check:GetHighlightTexture()
    hoverGlow:SetVertexColor(mGUI.Colors.accent[1], mGUI.Colors.accent[2], mGUI.Colors.accent[3])
    hoverGlow:SetAlpha(0.9)
    check:SetScript("OnClick", function(self)
        if self.OnValueChanged then
            self:OnValueChanged(self:GetChecked())
        end
    end)

    function check:SetLabel(text, size)
        mGUI:SetFont(self.label, size or 12)
        self.label:SetText(text or "")
        self:SetHitRectInsets(0, -(self.label:GetStringWidth() + 8), 0, 0)
    end

    function check:SetWidgetEnabled(enabled)
        self:SetEnabled(enabled)
        self:GetNormalTexture():SetDesaturated(not enabled)
        self.label:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
    end

    return check
end
