local Totemicons = mUI:NewModule("mUI.Modules.Unitframes.Totemicons")

function Totemicons:OnInitialize()
    Totemicons.totemicons = TotemFrame.Show
end

function Totemicons:OnEnable()
    TotemFrame:Hide()
    TotemFrame.Show = function() end
end

function Totemicons:OnDisable()
    TotemFrame.Show = Totemicons.totemicons
    TotemFrame:Show()
end
