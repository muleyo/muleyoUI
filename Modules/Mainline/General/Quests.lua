local Quests = mUI:NewModule("mUI.Modules.General.Quests", "AceHook-3.0")

function Quests:OnInitialize()
    function Quests:Accept()
        QuestFrameAcceptButton:Click()
    end
end

function Quests:OnEnable()
    Quests:SecureHookScript(QuestFrameAcceptButton, "OnShow", Quests.Accept)
end

function Quests:OnDisable()
    Quests:UnhookAll()
end
