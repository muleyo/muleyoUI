local Anchor = mUI:NewModule("mUI.Tooltips.Anchor", "AceHook-3.0")

function Anchor:OnEnable()
    local EditMode = mUI:GetModule("mUI.EditMode", true)
    EditMode:Unhook("GameTooltip_SetDefaultAnchor")

    Anchor:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end)
end

function Anchor:OnDisable()
    Anchor:UnhookAll()

    local EditMode = mUI:GetModule("mUI.EditMode", true)
    if not EditMode:IsHooked("GameTooltip_SetDefaultAnchor") then
        EditMode:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("BOTTOMRIGHT", mUIGameTooltip, "BOTTOMRIGHT")
        end)
    end
end
