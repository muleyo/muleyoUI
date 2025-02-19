local TalkingHead = mUI:NewModule("mUI.Modules.General.TalkingHead")

function TalkingHead:OnInitialize()
    self.talkinghead = CreateFrame("Frame")
    self.talkinghead:HookScript("OnEvent", function(_, event)
        if not event == "TALKINGHEAD_REQUESTED" then return end
        TalkingHeadFrame:CloseImmediately()
    end)
end

function TalkingHead:OnEnable()
    self.talkinghead:RegisterEvent("TALKINGHEAD_REQUESTED")
end

function TalkingHead:OnDisable()
    self.talkinhead:UnregisterEvent("TALKINGHEAD_REQUESTED")
end
