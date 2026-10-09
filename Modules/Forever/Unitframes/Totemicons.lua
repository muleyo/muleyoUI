local Totemicons = mUI:NewModule("mUI.Modules.Unitframes.Totemicons", "AceHook-3.0")

Totemicons.active = {}

function Totemicons:OnEnable()
    Totemicons:SecureHook(TotemFrame, "Update", function()
        for totem, _ in TotemFrame.totemPool:EnumerateActive() do
            Totemicons.active[totem] = true
            totem:Hide()
        end
    end)
end

function Totemicons:OnDisable()
    Totemicons:UnhookAll()
    for totem in pairs(Totemicons.active) do
        totem:Show()
    end
end
