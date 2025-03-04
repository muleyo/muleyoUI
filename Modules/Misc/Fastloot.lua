local Fastloot = mUI:NewModule("mUI.Modules.Misc.Fastloot", "AceHook-3.0")

function Fastloot:OnInitialize()
    -- Create Frame
    Fastloot.frame = CreateFrame("Frame")

    local epoch = 0

    function Fastloot:Loot()
        if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
            if (GetTime() - epoch) >= 0.3 then
                for i = GetNumLootItems(), 1, -1 do
                    LootSlot(i)
                end
                epoch = GetTime()
            end
        end
    end
end

function Fastloot:OnEnable()
    Fastloot.frame:RegisterEvent("LOOT_READY")
    Fastloot:HookScript(Fastloot.frame, "OnEvent", Fastloot.Loot)
end

function Fastloot:OnDisable()
    Fastloot.frame:UnregisterEvent("LOOT_READY")
    Fastloot:UnhookAll()
end
