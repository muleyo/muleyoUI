local Quests = mUI:NewModule("mUI.Modules.General.Quests", "AceHook-3.0")

function Quests:OnInitialize()
    function Quests:Accept()
        if IsModifierKeyDown() then
            return
        end
        QuestFrameAcceptButton:Click()
    end

    function Quests:Complete()
        if IsModifierKeyDown() then
            return
        end
        QuestFrameCompleteButton:Click()
        if GetNumQuestChoices() <= 1 then
            QuestFrameCompleteQuestButton:Click()
        end
    end
end

function Quests:OnEnable()
    Quests:SecureHookScript(QuestFrameAcceptButton, "OnShow", Quests.Accept)
    Quests:SecureHookScript(QuestFrameCompleteQuestButton, "OnShow", Quests.Complete)
    Quests:SecureHookScript(QuestFrameCompleteButton, "OnShow", Quests.Complete)
end

function Quests:OnDisable()
    Quests:UnhookAll()
end
