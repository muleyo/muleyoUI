local Totemicons = mUI:NewModule("mUI.Modules.Unitframes.Totemicons", "AceHook-3.0")

Totemicons.active = {}

function Totemicons:OnEnable()
    for totem, _ in TotemFrame.totemPool:EnumerateActive() do
        Totemicons.active[totem] = true
        totem:SetAlpha(0)
        totem:EnableMouse(false)
    end
end

function Totemicons:OnDisable()
    for totem in pairs(Totemicons.active) do
        totem:SetAlpha(1)
        totem:EnableMouse(true)
    end
end
