local Duel = mUI:NewModule("mUI.Modules.General.Duel")

function Duel:OnInitialize()
    self.duel = CreateFrame("Frame")
    self.duel:SetScript("OnEvent", function(_, event)
        if event == "DUEL_REQUESTED" then
            CancelDuel()
            StaticPopup_Hide("DUEL_REQUESTED")
        elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
            C_PetBattles.CancelPVPDuel()
            StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
        end
    end)
end

function Duel:OnEnable()
    self.duel:RegisterEvent("DUEL_REQUESTED")
    self.duel:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
end

function Duel:OnDisable()
    self.duel:UnregisterAllEvents()
end
