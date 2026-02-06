local Modules = mUI:NewModule("mUI.Modules.Profiles")

function Modules:OnInitialize()
    -- Modules
    Modules.Import = mUI:GetModule("mUI.Modules.Profiles.Import")
    Modules.Export = mUI:GetModule("mUI.Modules.Profiles.Export")
end
