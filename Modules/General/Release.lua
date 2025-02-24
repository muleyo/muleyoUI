local Release = mUI:NewModule("mUI.Modules.General.Release", "AceHook-3.0")

function Release:OnInitialize()
    Release.release = CreateFrame("Frame")
    function Release:Update(event)
        if not event == "PLAYER_DEAD" then return end
        RepopMe()
    end
end

function Release:OnEnable()
    Release.release:RegisterEvent("PLAYER_DEAD")
    Release:HookScript(Release.release, "OnEvent", function(_, event)
        Release:Update(event)
    end)
end

function Release:OnDisable()
    Release.release:UnregisterEvent("PLAYER_DEAD")
    Release:UnhookAll()
end
