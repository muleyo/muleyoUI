local Modules = mUI:NewModule("mUI.Modules.General")

function Modules:OnInitialize()
    -- Modules
    Modules.Theme = mUI:GetModule("mUI.Modules.General.Theme")
    Modules.Font = mUI:GetModule("mUI.Modules.General.Font")
    Modules.Repair = mUI:GetModule("mUI.Modules.General.Repair")
    Modules.Sell = mUI:GetModule("mUI.Modules.General.Sell")
    Modules.Delete = mUI:GetModule("mUI.Modules.General.Delete")
    Modules.Duel = mUI:GetModule("mUI.Modules.General.Duel")
    Modules.Release = mUI:GetModule("mUI.Modules.General.Release")
    Modules.Resurrection = mUI:GetModule("mUI.Modules.General.Resurrection")
    Modules.Invite = mUI:GetModule("mUI.Modules.General.Invite")
    Modules.Cinematic = mUI:GetModule("mUI.Modules.General.Cinematic")
    Modules.TalkingHead = mUI:GetModule("mUI.Modules.General.TalkingHead")
    Modules.RoleCheck = mUI:GetModule("mUI.Modules.General.RoleCheck")
    Modules.Quests = mUI:GetModule("mUI.Modules.General.Quests")
    Modules.Gossip = mUI:GetModule("mUI.Modules.General.Gossip")
    Modules.ItemInfo = mUI:GetModule("mUI.Modules.General.ItemInfo")
    Modules.Stats = mUI:GetModule("mUI.Modules.General.Stats")
    Modules.ErrorMessages = mUI:GetModule("mUI.Modules.General.ErrorMessages")
    Modules.Friendlist = mUI:GetModule("mUI.Modules.General.Friendlist")
    Modules.MouseCursor = mUI:GetModule("mUI.Modules.General.MouseCursor")
end

function Modules:OnEnable()
    -- Load Database
    Modules.db = mUI.db.profile.general

    -- Enable Modules
    Modules.Theme:Enable()
    if Modules.db.font ~= "None" then
        Modules.Font:Enable()
    end
    if Modules.db.automation.repair ~= "Disabled" then
        Modules.Repair:Enable()
    end
    if Modules.db.automation.sell then
        Modules.Sell:Enable()
    end
    if Modules.db.automation.delete then
        Modules.Delete:Enable()
    end
    if Modules.db.automation.duel then
        Modules.Duel:Enable()
    end
    if Modules.db.automation.release then
        Modules.Release:Enable()
    end
    if Modules.db.automation.resurrection then
        Modules.Resurrection:Enable()
    end
    if Modules.db.automation.invite then
        Modules.Invite:Enable()
    end
    if Modules.db.automation.cinematic then
        Modules.Cinematic:Enable()
    end
    if Modules.db.automation.talkinghead then
        Modules.TalkingHead:Enable()
    end
    if Modules.db.automation.rolecheck then
        Modules.RoleCheck:Enable()
    end
    if Modules.db.automation.quests then
        Modules.Quests:Enable()
    end
    if Modules.db.automation.gossip then
        Modules.Gossip:Enable()
    end
    if Modules.db.display.iteminfo then
        Modules.ItemInfo:Enable()
    end
    if Modules.db.display.stats then
        Modules.Stats:Enable()
    end
    if Modules.db.display.errormessages then
        Modules.ErrorMessages:Enable()
    end
    if Modules.db.display.friendlist then
        Modules.Friendlist:Enable()
    end
    if Modules.db.display.mousecursor then
        Modules.MouseCursor:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Font:Disable()
    Modules.Repair:Disable()
    Modules.Sell:Disable()
    Modules.Delete:Disable()
    Modules.Duel:Disable()
    Modules.Release:Disable()
    Modules.Resurrection:Disable()
    Modules.Invite:Disable()
    Modules.Cinematic:Disable()
    Modules.TalkingHead:Disable()
    Modules.RoleCheck:Disable()
    Modules.Quests:Disable()
    Modules.Gossip:Disable()
    Modules.ItemInfo:Disable()
    Modules.Stats:Disable()
    Modules.ErrorMessages:Disable()
    Modules.Friendlist:Disable()
    Modules.MouseCursor:Disable()
end
