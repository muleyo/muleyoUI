local Modules = mUI:NewModule("mUI.Modules.Chat")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Style = mUI:GetModule("mUI.Modules.Chat.Style")
    Modules.Link = mUI:GetModule("mUI.Modules.Chat.Link")
    Modules.Copy = mUI:GetModule("mUI.Modules.Chat.Copy")
end

function Modules:OnEnable()
    Modules.db = mUI.db.profile.chat

    if Modules.db.style == "mUI" then
        Modules.Style:Enable()
    end
    if Modules.db.link then
        Modules.Link:Enable()
    end
    if Modules.db.copy then
        Modules.Copy:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Style:Disable()
    Modules.Link:Disable()
    Modules.Copy:Disable()
end
