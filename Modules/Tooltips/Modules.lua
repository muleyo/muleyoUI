local Module = mUI:NewModule("mUI.Modules.Tooltips")

function Module:OnInitialize()
    -- Get Modules
    self.Style = mUI:GetModule("mUI.Tooltips.Style")
    self.Combat = mUI:GetModule("mUI.Tooltips.Combat")
    self.Anchor = mUI:GetModule("mUI.Tooltips.Anchor")
end

function Module:OnEnable()
    -- Load Database
    self.db = mUI.db.profile.tooltips

    if self.db.style == "mUI" then
        self.Style:Enable()
    end
    if self.db.combat then
        self.Combat:Enable()
    end
    if self.db.mouseanchor then
        self.Anchor:Enable()
    end
end

function Module:OnDisable()
    -- Disable Modules
    self.Style:Disable()
    self.Combat:Disable()
    self.Anchor:Disable()
end
