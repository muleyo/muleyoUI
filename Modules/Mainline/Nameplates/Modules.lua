local Modules = mUI:NewModule("mUI.Modules.Nameplates")

function Modules:OnInitialize()
    -- Modules
    Modules.Core = mUI:GetModule("mUI.Modules.Nameplates.Core")
    Modules.Units = mUI:GetModule("mUI.Modules.Nameplates.Units")
    Modules.Health = mUI:GetModule("mUI.Modules.Nameplates.Health")
    Modules.Castbar = mUI:GetModule("mUI.Modules.Nameplates.Castbar")
    Modules.Style = mUI:GetModule("mUI.Modules.Nameplates.Style")
    Modules.Cvars = mUI:GetModule("mUI.Modules.Nameplates.Cvars")
    Modules.PersonalResourceBar = mUI:GetModule("mUI.Modules.Nameplates.PersonalResourceBar")
    Modules.ClassIcon = mUI:GetModule("mUI.Modules.Nameplates.ClassIcon")
    Modules.Healer = mUI:GetModule("mUI.Modules.Nameplates.Healer")
    Modules.TargetIndicator = mUI:GetModule("mUI.Modules.Nameplates.TargetIndicator")
    Modules.RaidMarker = mUI:GetModule("mUI.Modules.Nameplates.RaidMarker")
    Modules.Auras = mUI:GetModule("mUI.Modules.Nameplates.Auras")
    Modules.Totem = mUI:GetModule("mUI.Modules.Nameplates.Totem")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.nameplates

    -- Core, Units and the plate itself are not optional
    Modules.Core:Enable()
    Modules.Units:Enable()
    Modules.Health:Enable()
    Modules.Castbar:Enable()
    Modules.Style:Enable()
    Modules.Cvars:Enable()

    -- Enable Modules
    if Modules.db.personalresource.enabled then
        Modules.PersonalResourceBar:Enable()
    end

    if Modules.db.classicons.enabled then
        Modules.ClassIcon:Enable()
    end

    if Modules.db.healer.enabled then
        Modules.Healer:Enable()
    end

    if Modules.db.target.enabled then
        Modules.TargetIndicator:Enable()
    end

    if Modules.db.raidmarker.enabled then
        Modules.RaidMarker:Enable()
    end

    if Modules.db.auras.enabled then
        Modules.Auras:Enable()
    end

    if Modules.db.totem.enabled then
        Modules.Totem:Enable()
    end
end

function Modules:OnDisable()
    Modules.ClassIcon:Disable()
    Modules.Healer:Disable()
    Modules.TargetIndicator:Disable()
    Modules.RaidMarker:Disable()
    Modules.Auras:Disable()
    Modules.Totem:Disable()
    Modules.PersonalResourceBar:Disable()
    Modules.Cvars:Disable()
    Modules.Style:Disable()
    Modules.Castbar:Disable()
    Modules.Health:Disable()
    Modules.Units:Disable()
    Modules.Core:Disable()
end
