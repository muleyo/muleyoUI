local Duel = mUI:NewModule("mUI.Modules.General.Duel", "AceHook-3.0")

function Duel:OnInitialize()
    Duel.duel = CreateFrame("Frame")
    function Duel:Update()
        if event == "DUEL_REQUESTED" then
            CancelDuel()
            StaticPopup_Hide("DUEL_REQUESTED")
        elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
            C_PetBattles.CancelPVPDuel()
            StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
        end
    end
end

function Duel:OnEnable()
    Duel.duel:RegisterEvent("DUEL_REQUESTED")
    Duel.duel:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
    Duel:HookScript(Duel.duel, "OnEvent", function(_, event)
        Duel:Update(event)
    end)
end

function Duel:OnDisable()
    Duel.duel:UnregisterAllEvents()
    Duel:UnhookAll()
end
