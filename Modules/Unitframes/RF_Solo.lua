local RF_Solo = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Solo", "AceHook-3.0")

function RF_Solo:OnInitialize()
    -- Create Frames
    RF_Solo.frame = CreateFrame("Frame")

    -- Functions
    function RF_Solo:Update()
        if IsInGroup() then return end
        if InCombatLockdown() then
            RF_Solo.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        else
            RF_Solo.frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end

        CompactPartyFrame:SetShown(true)
    end
end

function RF_Solo:OnEnable()
    RF_Solo:SecureHook(CompactPartyFrame, "UpdateVisibility", RF_Solo.Update)
    RF_Solo:Update()
    RF_Solo:HookScript(RF_Solo.frame, "OnEvent", RF_Solo.Update)
end

function RF_Solo:OnDisable()
    if IsInGroup() then return end
    RF_Solo.frame:UnregisterAllEvents()
    RF_Solo:UnhookAll()
    CompactPartyFrame:SetShown(false)
end
