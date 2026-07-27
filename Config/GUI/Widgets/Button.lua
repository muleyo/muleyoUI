local mGUI = mUI.mGUI

function mGUI.Widgets.Button(parent)
    local buttonTemplate = mUI:GameVersion()["Vanilla"] and "UIPanelButtonTemplate" or "MainMenuFrameButtonTemplate"
    local button = CreateFrame("Button", nil, parent, buttonTemplate)
    button:SetSize(140, 28)
    button:SetNormalFontObject(GameFontHighlight)
    button:SetHighlightFontObject(GameFontHighlight)
    button:SetDisabledFontObject(GameFontDisable)
    mGUI:TintThreeSlice(button)

    button:SetScript("OnClick", function(self)
        if self.OnClick then
            self:OnClick()
        end
    end)

    function button:SetLabel(text)
        self:SetText(text or "")
        local width = self:GetFontString():GetStringWidth() + 40
        self:SetWidth(math.max(width, 140))
    end

    function button:SetWidgetEnabled(enabled)
        self:SetEnabled(enabled)
        if self.UpdateButton then
            self:UpdateButton()
        end
    end

    return button
end
