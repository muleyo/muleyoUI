local Modules = mUI:NewModule("mUI.Modules.Nameplates")

function Modules:OnInitialize()
    -- Modules
    Modules.Textures = mUI:GetModule("mUI.Modules.Nameplates.Textures")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.nameplates

    -- Enable Modules
    if Modules.db.texture ~= "None" then
        Modules.Textures:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Textures:Disable()
end
