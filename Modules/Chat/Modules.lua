local Modules = mUI:NewModule("mUI.Modules.Chat")

function Modules:OnInitialize()
    -- Get Modules
    self.Style = mUI:GetModule("mUI.Modules.Chat.Style")
end

function Modules:OnEnable()
    self.db = mUI.db.profile.chat

    self.Style:Enable()

    if self.db.style == "mUI" then
        --self.Style:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    --self.Style:Disable()
end
