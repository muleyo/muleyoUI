local Modules = mUI:NewModule("mUI.Modules.Unitframes")

function Modules:OnInitialize()
    -- Modules
    Modules.RF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Textures")
    Modules.RF_Health = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Health")
    Modules.RF_Name = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Name")
    Modules.RF_HideNames = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_HideNames")
    Modules.RF_RoleIcons = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_RoleIcons")
    Modules.RF_Solo = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Solo")
    Modules.RF_Mouseover = mUI:GetModule("mUI.Modules.Unitframes.Raidframes_Mouseover")
    Modules.UF_Textures = mUI:GetModule("mUI.Modules.Unitframes.Unitframes_Textures")
    Modules.Color = mUI:GetModule("mUI.Modules.Unitframes.Color")
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
    Modules.Smooth = mUI:GetModule("mUI.Modules.Unitframes.SmoothHealth")
    Modules.Overshields = mUI:GetModule("mUI.Modules.Unitframes.Overshields")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.unitframes

    -- Unitframe modules
    if Modules.db.enabled then
        if Modules.db.textures.unitframes ~= "None" then
            Modules.UF_Textures:Enable()
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
        if Modules.db.elitecolor then
            Modules.Elitecolor:Enable()
        end
        if Modules.db.overshields then
            Modules.Overshields:Enable()
        end
    end

    -- Raidframe modules
    if Modules.db.raidframes.enabled then
        if Modules.db.textures.raidframes ~= "None" then
            Modules.RF_Textures:Enable()
        end
        if Modules.db.raidframes.roleicons then
            Modules.RF_RoleIcons:Enable()
        end
        if Modules.db.raidframes.health or (Modules.db.raidframes.partyStatusColorMode and Modules.db.raidframes.partyStatusColorMode ~= "default") then
            Modules.RF_Health:Enable()
        end
        if Modules.db.raidframes.names or Modules.db.raidframes.hidenames or Modules.db.raidframes.partyNameCentered then
            Modules.RF_Name:Enable()
        end
        if Modules.db.raidframes.hidenames then
            Modules.RF_HideNames:Enable()
        end
        if Modules.db.raidframes.solo then
            Modules.RF_Solo:Enable()
        end
        if Modules.db.raidframes.mouseoverHighlight then
            Modules.RF_Mouseover:Enable()
        end
        if Modules.db.smooth then
            Modules.Smooth:Enable()
        end
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Color:Disable()
    Modules.Combatindicator:Disable()
    Modules.Cornericon:Disable()
    Modules.Hitindicator:Disable()
    Modules.Pvpbadge:Disable()
    Modules.UF_Textures:Disable()
    Modules.RF_Textures:Disable()
    Modules.Totemicons:Disable()
    Modules.Name:Disable()
    Modules.Level:Disable()
    Modules.Reputationcolor:Disable()
    Modules.Restingtextures:Disable()
    Modules.Elitecolor:Disable()
    Modules.RF_RoleIcons:Disable()
    Modules.RF_Health:Disable()
    Modules.RF_Name:Disable()
    Modules.RF_HideNames:Disable()
    Modules.RF_Solo:Disable()
    Modules.RF_Mouseover:Disable()
    Modules.Smooth:Disable()
    Modules.Overshields:Disable()
end
