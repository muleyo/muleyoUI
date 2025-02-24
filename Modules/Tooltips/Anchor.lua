local Anchor = mUI:NewModule("mUI.Tooltips.Anchor")

function Anchor:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.tooltips
end

function Anchor:OnEnable()
    mUI:SecureHook("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    end)
end

function Anchor:OnDisable()
    mUI:Unhook("GameTooltip_SetDefaultAnchor")
end
