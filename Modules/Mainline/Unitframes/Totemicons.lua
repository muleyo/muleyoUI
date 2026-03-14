local Totemicons = mUI:NewModule("mUI.Modules.Unitframes.Totemicons", "AceHook-3.0")

local function HideFrame(frame)
    frame:Hide()
end

function Totemicons:OnEnable()
    TotemFrame:Hide()
    if not Totemicons:IsHooked(TotemFrame, "Show") then
        Totemicons:SecureHook(TotemFrame, "Show", HideFrame)
    end
end

function Totemicons:OnDisable()
    Totemicons:UnhookAll()
    TotemFrame:Show()
end
