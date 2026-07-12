local Modules = mUI:NewModule("mUI.Modules.Tooltips")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Style = mUI:GetModule("mUI.Tooltips.Style")
    Modules.Combat = mUI:GetModule("mUI.Tooltips.Combat")
    Modules.Anchor = mUI:GetModule("mUI.Tooltips.Anchor")
    Modules.MythicPlus = mUI:GetModule("mUI.Tooltips.MythicPlus")
    Modules.PvPRating = mUI:GetModule("mUI.Tooltips.PvPRating")
    Modules.LFGTooltips = mUI:GetModule("mUI.Tooltips.LFGTooltips")
end

function Modules:OnEnable()
    -- Load Database
    Modules.db = mUI.db.profile.tooltips

    if Modules.db.style == "mUI" then
        Modules.Style:Enable()
    end
    if Modules.db.combat then
        Modules.Combat:Enable()
    end
    if Modules.db.mouseanchor then
        Modules.Anchor:Enable()
    end
    if Modules.db.mythicplus then
        Modules.MythicPlus:Enable()
    end
    if Modules.db.pvprating then
        Modules.PvPRating:Enable()
    end
    if Modules.db.lfgtooltips then
        Modules.LFGTooltips:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Style:Disable()
    Modules.Combat:Disable()
    Modules.Anchor:Disable()
    Modules.MythicPlus:Disable()
    Modules.PvPRating:Disable()
    Modules.LFGTooltips:Disable()
end
