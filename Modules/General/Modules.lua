local Modules = mUI:NewModule("mUI.Modules.General")

function Modules:OnInitialize()
    -- Modules
    self.Theme = mUI:GetModule("mUI.Modules.General.Theme")
    self.Font = mUI:GetModule("mUI.Modules.General.Font")
    self.Repair = mUI:GetModule("mUI.Modules.General.Repair")
    self.Sell = mUI:GetModule("mUI.Modules.General.Sell")
    self.Delete = mUI:GetModule("mUI.Modules.General.Delete")
    self.Duel = mUI:GetModule("mUI.Modules.General.Duel")
    self.Release = mUI:GetModule("mUI.Modules.General.Release")
    self.Resurrection = mUI:GetModule("mUI.Modules.General.Resurrection")
    self.Invite = mUI:GetModule("mUI.Modules.General.Invite")
    self.Cinematic = mUI:GetModule("mUI.Modules.General.Cinematic")
    self.TalkingHead = mUI:GetModule("mUI.Modules.General.TalkingHead")
    self.ItemInfo = mUI:GetModule("mUI.Modules.General.ItemInfo")
    self.Stats = mUI:GetModule("mUI.Modules.General.Stats")
    self.ErrorMessages = mUI:GetModule("mUI.Modules.General.ErrorMessages")
    self.Friendlist = mUI:GetModule("mUI.Modules.General.Friendlist")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.general

    -- Enable Modules
    if self.db.theme ~= "Disabled" then
        self.Theme:Enable()
    end
    if self.db.font ~= "Default" then
        self.Font:Enable()
    end
    if self.db.automation.repair ~= "Disabled" then
        self.Repair:Enable()
    end
    if self.db.automation.sell then
        self.Sell:Enable()
    end
    if self.db.automation.delete then
        self.Delete:Enable()
    end
    if self.db.automation.duel then
        self.Duel:Enable()
    end
    if self.db.automation.release then
        self.Release:Enable()
    end
    if self.db.automation.resurrection then
        self.Resurrection:Enable()
    end
    if self.db.automation.invite then
        self.Invite:Enable()
    end
    if self.db.automation.cinematic then
        self.Cinematic:Enable()
    end
    if self.db.automation.talkingHead then
        self.TalkingHead:Enable()
    end
    if self.db.display.iteminfo then
        self.ItemInfo:Enable()
    end
    if self.db.display.stats then
        self.Stats:Enable()
    end
    if self.db.display.errormessages then
        self.ErrorMessages:Enable()
    end
    if self.db.display.friendlist then
        self.Friendlist:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    self.Theme:Disable()
    self.Font:Disable()
    self.Repair:Disable()
    self.Sell:Disable()
    self.Delete:Disable()
    self.Duel:Disable()
    self.Release:Disable()
    self.Resurrection:Disable()
    self.Invite:Disable()
    self.Cinematic:Disable()
    self.TalkingHead:Disable()
    self.ItemInfo:Disable()
    self.Stats:Disable()
    self.ErrorMessages:Disable()
    self.Friendlist:Disable()
end
