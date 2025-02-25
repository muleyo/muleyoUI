local Interrupt = mUI:NewModule("mUI.Modules.Misc.Interrupt", "AceHook-3.0")

function Interrupt:OnInitialize()
    -- Create Frame
    Interrupt.frame = CreateFrame("Frame")

    function Interrupt:Announce()
        -- Get Event Data
        local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
        if not (event == "SPELL_INTERRUPT" and sourceGUID == UnitGUID("player")) then return end

        if IsInGroup() then
            SendChatMessage("Interrupted " .. C_Spell.GetSpellLink(spellID) .. "!", "PARTY")
        elseif IsInRaid() then
            SendChatMessage("Interrupted " .. C_Spell.GetSpellLink(spellID) .. "!", "RAID")
        elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            SendChatMessage("Interrupted " .. C_Spell.GetSpellLink(spellID) .. "!", "INSTANCE_CHAT")
        end
    end
end

function Interrupt:OnEnable()
    Interrupt.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Interrupt:HookScript(Interrupt.frame, "OnEvent", Interrupt.Announce)
end

function Interrupt:OnDisable()
    Interrupt.frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    Interrupt:UnhookAll()
end
