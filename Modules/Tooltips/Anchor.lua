local Anchor = mUI:NewModule("mUI.Tooltips.Anchor", "AceHook-3.0")

function Anchor:OnEnable()
    if mUI:IsClassic() then
        local EditMode = mUI:GetModule("mUI.EditMode", true)
        EditMode:Unhook("GameTooltip_SetDefaultAnchor")
    end

    Anchor:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end)
end

function Anchor:OnDisable()
    Anchor:Unhook("GameTooltip_SetDefaultAnchor")

    if mUI:IsClassic() then
        local EditMode = mUI:GetModule("mUI.EditMode", true)
        EditMode:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
            tooltip:SetOwner(parent, "ANCHOR_NONE")
            tooltip:ClearAllPoints()
            tooltip:SetPoint("BOTTOMRIGHT", mUITooltipFrame, "BOTTOMRIGHT")
        end)
    end
end
