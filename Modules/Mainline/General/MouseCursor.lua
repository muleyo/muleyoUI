local MouseCursor = mUI:NewModule("mUI.Modules.General.MouseCursor", "AceHook-3.0")

function MouseCursor:OnInitialize()
    MouseCursor.frame = CreateFrame("Frame", "mUI_MouseCursor", UIParent)
    MouseCursor.frame:SetSize(26, 26)
    MouseCursor.frame:SetFrameStrata("TOOLTIP")
    MouseCursor.frame:SetFrameLevel(9999)
    MouseCursor.frame:EnableMouse(false)
    MouseCursor.frame:SetIgnoreParentAlpha(true)

    -- Create the circle using the built-in soft glow particle
    MouseCursor.circle = MouseCursor.frame:CreateTexture(nil, "OVERLAY")
    MouseCursor.circle:SetAllPoints()
    MouseCursor.circle:SetAtlas("dragonflight-landingbutton-circleglow")
    MouseCursor.circle:SetBlendMode("ADD")
end

function MouseCursor:OnEnable()
    MouseCursor:SecureHookScript(MouseCursor.frame, "OnUpdate", function(self)
        InputUtil.AnchorRegionToCursor(self, "CENTER")
    end)

    MouseCursor.frame:Show()
end

function MouseCursor:OnDisable()
    MouseCursor.frame:Hide()
    MouseCursor:UnhookAll()
end
