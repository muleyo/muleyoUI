local Resurrection = mUI:NewModule("mUI.Modules.General.Resurrection", "AceHook-3.0")

function Resurrection:OnInitialize()
    Resurrection.resurrection = CreateFrame("Frame")

    function Resurrection:Update(event, name)
        if not event == "RESURRECT_REQUEST" then return end
        if not UnitAffectingCombat(name) then
            AcceptResurrect()
            StaticPopup_Hide("RESURRECT_NO_TIMER")
        end
    end
end

function Resurrection:OnEnable()
    Resurrection.resurrection:RegisterEvent("RESURRECT_REQUEST")
    Resurrection:HookScript(Resurrection.resurrection, "OnEvent", function(_, event, name)
        Resurrection:Update(event, name)
    end)
end

function Resurrection:OnDisable()
    Resurrection.resurrection:UnregisterEvent("RESURRECT_REQUEST")
    Resurrection:UnhookAll()
end
