local RF_Scale = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Scale", "AceHook-3.0")

function RF_Scale:OnInitialize()
    RF_Scale.frame = CreateFrame("Frame")

    function RF_Scale:Update()
        if InCombatLockdown() then
            RF_Scale.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        else
            RF_Scale.frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end

        local scale = (mUI.db.profile.unitframes.raidframes.partyScale or 100) / 100
        CompactPartyFrame:SetScale(scale)
    end
end

function RF_Scale:OnEnable()
    RF_Scale:SecureHookScript(RF_Scale.frame, "OnEvent", RF_Scale.Update)
    RF_Scale:Update()
end

function RF_Scale:OnDisable()
    RF_Scale.frame:UnregisterAllEvents()
    RF_Scale:UnhookAll()
    if not InCombatLockdown() then
        CompactPartyFrame:SetScale(1)
    end
end
