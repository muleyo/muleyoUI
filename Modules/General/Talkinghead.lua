local TalkingHead = mUI:NewModule("mUI.Modules.General.TalkingHead")

function TalkingHead:OnInitialize()
    TalkingHead.talkinghead = CreateFrame("Frame")

    function TalkingHead:Update()
        if not event == "TALKINGHEAD_REQUESTED" then return end
        TalkingHeadFrame:CloseImmediately()
    end
end

function TalkingHead:OnEnable()
    TalkingHead.talkinghead:RegisterEvent("TALKINGHEAD_REQUESTED")
    TalkingHead:HookScript(TalkingHead.talkinghead, "OnEvent", function(_, event)
        TalkingHead:Update(event)
    end)
end

function TalkingHead:OnDisable()
    TalkingHead.talkinhead:UnregisterEvent("TALKINGHEAD_REQUESTED")
    TalkingHead:UnhookAll()
end
