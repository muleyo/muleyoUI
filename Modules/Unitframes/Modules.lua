local Modules = mUI:NewModule("mUI.Modules.Unitframes")

function Modules:OnInitialize()
    -- Modules
    Modules.BuffsDebuffs = mUI:GetModule("mUI.Modules.Unitframes.BuffsDebuffs")
    Modules.Classbar = mUI:GetModule("mUI.Modules.Unitframes.Classbar")
    Modules.Color = mUI:GetModule("mUI.Modules.Unitframes.Color")
    Modules.Reputationcolor = mUI:GetModule("mUI.Modules.Unitframes.Reputationcolor")
    Modules.Combatindicator = mUI:GetModule("mUI.Modules.Unitframes.Combatindicator")
    Modules.Cornericon = mUI:GetModule("mUI.Modules.Unitframes.Cornericon")
    Modules.Hitindicator = mUI:GetModule("mUI.Modules.Unitframes.Hitindicator")
    Modules.Pvpbadge = mUI:GetModule("mUI.Modules.Unitframes.Pvpbadge")
    Modules.Unitframes_Textures = mUI:GetModule("mUI.Modules.Unitframes.Unitframes_Textures")
    Modules.Raidframes_Textures = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Textures")
    Modules.Totemicons = mUI:GetModule("mUI.Modules.Unitframes.Totemicons")
    Modules.Name = mUI:GetModule("mUI.Modules.Unitframes.Name")
    Modules.Level = mUI:GetModule("mUI.Modules.Unitframes.Level")
    Modules.Restingtextures = mUI:GetModule("mUI.Modules.Unitframes.Restingtextures")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.unitframes

    -- Enable Modules
    if Modules.db.textures.unitframes ~= "None" then
        Modules.Unitframes_Textures:Enable()
    end
    if Modules.db.textures.raidframes ~= "None" then
        Modules.Raidframes_Textures:Enable()
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
end
