local Totemicons = mUI:NewModule("mUI.Modules.Unitframes.Totemicons")

function Totemicons:OnInitialize()
    self.totemicons = TotemFrame.Show
end

function Totemicons:OnEnable()
    TotemFrame:Hide()
    TotemFrame.Show = function() end
end

function Totemicons:OnDisable()
    TotemFrame.Show = self.totemicons
    TotemFrame:Show()
end
