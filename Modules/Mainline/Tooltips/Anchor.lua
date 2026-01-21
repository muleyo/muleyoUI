local Anchor = mUI:NewModule("mUI.Tooltips.Anchor", "AceHook-3.0")

function Anchor:OnEnable()
    Anchor:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end)
end

function Anchor:OnDisable()
    Anchor:Unhook("GameTooltip_SetDefaultAnchor")
end
