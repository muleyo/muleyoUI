local Modules = mUI:NewModule("mUI.Modules.Castbars")

function Modules:OnInitialize()
    -- Modules
    Modules.Style = mUI:GetModule("mUI.Modules.Castbars.Style")
    Modules.Icon = mUI:GetModule("mUI.Modules.Castbars.Icon")
    Modules.Casttime = mUI:GetModule("mUI.Modules.Castbars.Casttime")
    Modules.Targetscale = mUI:GetModule("mUI.Modules.Castbars.Targetscale")
    Modules.Focusscale = mUI:GetModule("mUI.Modules.Castbars.Focusscale")
    Modules.Targetpos = mUI:GetModule("mUI.Modules.Castbars.Targetpos")
    Modules.Focuspos = mUI:GetModule("mUI.Modules.Castbars.Focuspos")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.castbars

    -- Enable Modules
    if Modules.db.style == "mUI" then
        Modules.Style:Enable()
    end
    if Modules.db.icon then
        Modules.Icon:Enable()
    end
    if Modules.db.casttime then
        Modules.Casttime:Enable()
    end
    if Modules.db.targetscale ~= 100 then
        Modules.Targetscale:Enable()
    end
    if Modules.db.focusscale ~= 100 then
        Modules.Focusscale:Enable()
    end
    if Modules.db.targetpos then
        Modules.Targetpos:Enable()
    end
    if Modules.db.focuspos then
        Modules.Focuspos:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Style:Disable()
    Modules.Icon:Disable()
end
