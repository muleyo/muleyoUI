local mGUI = mUI.mGUI

function mGUI.Widgets.Header(parent)
    local header = CreateFrame("Frame", nil, parent)
    header:SetHeight(30)

    local label = header:CreateFontString(nil, "OVERLAY")
    label:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 0, 6)
    mGUI:SetFont(label, 14)
    label:SetTextColor(unpack(mGUI.Colors.accent))
    header.label = label

    local line = header:CreateTexture(nil, "ARTWORK")
    line:SetPoint("BOTTOMLEFT", label, "BOTTOMRIGHT", 8, 2)
    line:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 8)
    line:SetHeight(1)
    line:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    line:SetVertexColor(mGUI.Colors.border[1], mGUI.Colors.border[2], mGUI.Colors.border[3], 0.7)
    mUI:DisablePixelSnap(line)
    header.line = line

    function header:SetLabel(text)
        self.label:SetText(text or "")
        self.line:SetShown(text and text ~= "")
    end

    return header
end
