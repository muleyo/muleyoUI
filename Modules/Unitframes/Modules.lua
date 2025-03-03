local Modules = mUI:NewModule("mUI.Modules.Unitframes")

function Modules:OnInitialize()
    -- Modules
    Modules.RF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Textures")
    Modules.RF_Size = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Size")
    Modules.RF_Colors = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Colors")
    Modules.RF_Health = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Health")
    Modules.RF_Name = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Name")
    Modules.RF_RoleIcons = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_RoleIcons")
    Modules.RF_Solo = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Solo")
    Modules.UF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Unitframes_Textures")
    Modules.Color = mUI:GetModule("mUI.Modules.Unitframes.Color")
    Modules.BuffsDebuffs = mUI:GetModule("mUI.Modules.Unitframes.BuffsDebuffs")
    Modules.Classbar = mUI:GetModule("mUI.Modules.Unitframes.Classbar")
    Modules.Reputationcolor = mUI:GetModule("mUI.Modules.Unitframes.Reputationcolor")
    Modules.Combatindicator = mUI:GetModule("mUI.Modules.Unitframes.Combatindicator")
    Modules.Cornericon = mUI:GetModule("mUI.Modules.Unitframes.Cornericon")
    Modules.Hitindicator = mUI:GetModule("mUI.Modules.Unitframes.Hitindicator")
    Modules.Pvpbadge = mUI:GetModule("mUI.Modules.Unitframes.Pvpbadge")
    Modules.Totemicons = mUI:GetModule("mUI.Modules.Unitframes.Totemicons")
    Modules.Name = mUI:GetModule("mUI.Modules.Unitframes.Name")
    Modules.Level = mUI:GetModule("mUI.Modules.Unitframes.Level")
    Modules.Restingtextures = mUI:GetModule("mUI.Modules.Unitframes.Restingtextures")
    Modules.Elitecolor = mUI:GetModule("mUI.Modules.Unitframes.Elitecolor")
    Modules.Overshields = mUI:GetModule("mUI.Modules.Unitframes.Overshields")
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
    if Modules.db.playerrepcolor then
        Modules.Reputationcolor:Enable()
    elseif Modules.db.reputationcolor then
        Modules.Reputationcolor:Enable()
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
    if Modules.db.totemicons then
        Modules.Totemicons:Enable()
    end
    if Modules.db.classbar then
        Modules.Classbar:Enable()
    end
    if Modules.db.cornericon then
        Modules.Cornericon:Enable()
    end
    if Modules.db.restingtextures then
        Modules.Restingtextures:Enable()
    end
    if Modules.db.name then
        Modules.Name:Enable()
    end
    if Modules.db.level then
        Modules.Level:Enable()
    end
    if Modules.db.buffsdebuffs.enabled then
        Modules.BuffsDebuffs:Enable()
    end
    if Modules.db.elitecolor then
        Modules.Elitecolor:Enable()
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
    if Modules.db.raidframes.solo then
        Modules.RF_Solo:Enable()
    end
    if Modules.db.overshields then
        Modules.Overshields:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.BuffsDebuffs:Disable()
    Modules.Classbar:Disable()
    Modules.Color:Disable()
    Modules.Combatindicator:Disable()
    Modules.Cornericon:Disable()
    Modules.Hitindicator:Disable()
    Modules.Pvpbadge:Disable()
    Modules.Unitframes_Textures:Disable()
    Modules.Raidframes_Textures:Disable()
    Modules.Totemicons:Disable()
    Modules.Name:Disable()
    Modules.Level:Disable()
    Modules.Reputationcolor:Disable()
    Modules.Restingtextures:Disable()
    Modules.Elitecolor:Disable()
    Modules.Raidframes_Size:Disable()
    Modules.Raidframes_RoleIcons:Disable()
    Modules.Raidframes_Colors:Disable()
    Modules.Raidframes_Health:Disable()
    Modules.Raidframes_Name:Disable()
    Modules.Raidframes_Solo:Disable()
    Modules.Overshields:Disable()
end
