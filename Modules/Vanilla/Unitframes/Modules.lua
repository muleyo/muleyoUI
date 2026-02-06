local Modules = mUI:NewModule("mUI.Modules.Unitframes")

function Modules:OnInitialize()
    -- Modules
    Modules.RF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Textures")
    Modules.RF_Size = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Size")
    Modules.RF_Colors = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Colors")
    Modules.RF_Health = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Health")
    Modules.RF_Name = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Name")
    Modules.RF_RoleIcons = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_RoleIcons")
    Modules.UF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Unitframes_Textures")
    Modules.Color = mUI:GetModule("mUI.Modules.Unitframes.Color")
    Modules.BuffsDebuffs = mUI:GetModule("mUI.Modules.Unitframes.BuffsDebuffs")
    Modules.Combatindicator = mUI:GetModule("mUI.Modules.Unitframes.Combatindicator")
    Modules.Hitindicator = mUI:GetModule("mUI.Modules.Unitframes.Hitindicator")
    Modules.Pvpbadge = mUI:GetModule("mUI.Modules.Unitframes.Pvpbadge")
    Modules.Name = mUI:GetModule("mUI.Modules.Unitframes.Name")
    Modules.Restingtextures = mUI:GetModule("mUI.Modules.Unitframes.Restingtextures")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.unitframes

    -- Enable Modules
    if Modules.db.textures.unitframes ~= "None" then
        Modules.UF_Textures:Enable()
    end
    if Modules.db.textures.raidframes ~= "None" then
        Modules.RF_Textures:Enable()
    end
    if Modules.db.color then
        Modules.Color:Enable()
    end
    if Modules.db.combatindicator then
        Modules.Combatindicator:Enable()
    end
    if Modules.db.pvpbadge then
        Modules.Pvpbadge:Enable()
    end
    if Modules.db.hitindicator then
        Modules.Hitindicator:Enable()
    end
    if Modules.db.restingtextures then
        Modules.Restingtextures:Enable()
    end
    if Modules.db.name then
        Modules.Name:Enable()
    end
    if Modules.db.buffsdebuffs.enabled then
        Modules.BuffsDebuffs:Enable()
    end
    if Modules.db.raidframes.size.enabled then
        Modules.RF_Size:Enable()
    end
    if Modules.db.raidframes.roleicons then
        Modules.RF_RoleIcons:Enable()
    end
    if Modules.db.raidframes.darkmode then
        Modules.RF_Colors:Enable()
    end
    if Modules.db.raidframes.health or Modules.db.raidframes.healthcolor then
        Modules.RF_Health:Enable()
    end
    if Modules.db.raidframes.names then
        Modules.RF_Name:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.BuffsDebuffs:Disable()
    Modules.Color:Disable()
    Modules.Combatindicator:Disable()
    Modules.Hitindicator:Disable()
    Modules.Pvpbadge:Disable()
    Modules.UF_Textures:Disable()
    Modules.RF_Textures:Disable()
    Modules.Name:Disable()
    Modules.Restingtextures:Disable()
    Modules.RF_Size:Disable()
    Modules.RF_RoleIcons:Disable()
    Modules.RF_Colors:Disable()
    Modules.RF_Health:Disable()
    Modules.RF_Name:Disable()
end
