local Modules = mUI:NewModule("mUI.Modules.Nameplates")

function Modules:OnInitialize()
    -- Modules
    Modules.Textures = mUI:GetModule("mUI.Modules.Nameplates.Textures")
    Modules.Names = mUI:GetModule("mUI.Modules.Nameplates.Names")
    Modules.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")
    Modules.Options = mUI:GetModule("mUI.Modules.Nameplates.Options")
    Modules.Casttime = mUI:GetModule("mUI.Modules.Nameplates.Casttime")
    Modules.Debuffs = mUI:GetModule("mUI.Modules.Nameplates.Debuffs")
    Modules.Totemicons = mUI:GetModule("mUI.Modules.Nameplates.Totemicons")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.nameplates

    -- Enable Modules
    if Modules.db.texture ~= "None" then
        Modules.Textures:Enable()
    end
    if Modules.db.classcolor or Modules.db.servername then
        Modules.Names:Enable()
    end
    if Modules.db.healthtext or Modules.db.colors then
        Modules.Health:Enable()
    end
    if Modules.db.casttime then
        Modules.Casttime:Enable()
    end
    if Modules.db.debuffs then
        Modules.Debuffs:Enable()
    end
    if Modules.db.totem then
        Modules.Totemicons:Enable()
    end
    Modules.Options:Enable()
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Textures:Disable()
    Modules.Names:Disable()
    Modules.Health:Disable()
    Modules.Casttime:Disable()
    Modules.Options:Disable()
    Modules.Debuffs:Disable()
    Modules.Totemicons:Disable()
end
