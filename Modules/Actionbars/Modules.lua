local Modules = mUI:NewModule("mUI.Modules.Actionbars")

function Modules:OnInitialize()
    -- Modules
    Modules.Flash = mUI:GetModule("mUI.Modules.Actionbars.Flash")
    Modules.Hotkey = mUI:GetModule("mUI.Modules.Actionbars.Hotkey")
    Modules.Macro = mUI:GetModule("mUI.Modules.Actionbars.Macro")
    Modules.Mouseover = mUI:GetModule("mUI.Modules.Actionbars.Mouseover")
    Modules.Range = mUI:GetModule("mUI.Modules.Actionbars.Range")
    Modules.Fontsize = mUI:GetModule("mUI.Modules.Actionbars.Fontsize")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.actionbars

    -- Enable Modules
    if Modules.db.flash then
        Modules.Flash:Enable()
    end
    if Modules.db.hotkey then
        Modules.Hotkey:Enable()
    end
    if Modules.db.macro then
        Modules.Macro:Enable()
    end
    if Modules.db.mouseover.enabled then
        Modules.Mouseover:Enable()
    end
    if Modules.db.range then
        Modules.Range:Enable()
    end
    if Modules.db.fontsize > 12 or Modules.db.fontsize < 12 then
        Modules.Fontsize:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Flash:Disable()
    Modules.Hotkey:Disable()
    Modules.Macro:Disable()
    Modules.Mouseover:Disable()
    Modules.Range:Disable()
end
