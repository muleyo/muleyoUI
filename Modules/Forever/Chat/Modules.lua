local Modules = mUI:NewModule("mUI.Modules.Chat")

function Modules:OnInitialize()
    -- Get Modules
    Modules.Style = mUI:GetModule("mUI.Modules.Chat.Style")
    Modules.Link = mUI:GetModule("mUI.Modules.Chat.Link")
    Modules.Copy = mUI:GetModule("mUI.Modules.Chat.Copy")
    Modules.WhisperAlert = mUI:GetModule("mUI.Modules.Chat.WhisperAlert")
    Modules.Profile = mUI:GetModule("mUI.Modules.Chat.Profile")
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
    if Modules.db.whisperalert then
        Modules.WhisperAlert:Enable()
    end
    if Modules.db.sync then
        Modules.Profile:Enable()
    end
end

function Modules:OnDisable()
    -- Disable Modules
    Modules.Style:Disable()
    Modules.Link:Disable()
    Modules.Copy:Disable()
    Modules.WhisperAlert:Disable()
    Modules.Profile:Disable()
end
