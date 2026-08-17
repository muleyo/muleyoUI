local Cvars = mUI:NewModule("mUI.Modules.Nameplates.Cvars", "AceEvent-3.0")

function Cvars:OnInitialize()
    -- Load Database
    Cvars.db = mUI.db.profile.nameplates

    local function SetBit(mask, enabled, bitIndex)
        if enabled then
            return bit.bor(mask, bit.lshift(1, bitIndex - 1))
        end
        return mask
    end

    function Cvars:GetStackingMask()
        local stacking = Cvars.db.cvars.stacking
        local mask = 0
        mask = SetBit(mask, stacking.enemy, Enum.NamePlateStackType.Enemy)
        mask = SetBit(mask, stacking.friendly, Enum.NamePlateStackType.Friendly)
        return mask
    end

    function Cvars:GetSimplifiedMask()
        local simplify = Cvars.db.cvars.simplify
        local mask = 0
        mask = SetBit(mask, simplify.minions, Enum.NamePlateSimplifiedType.Minion)
        mask = SetBit(mask, simplify.minor, Enum.NamePlateSimplifiedType.MinusMob)
        mask = SetBit(mask, simplify.friendlyPlayers, Enum.NamePlateSimplifiedType.FriendlyPlayer)
        mask = SetBit(mask, simplify.friendlyNpcs, Enum.NamePlateSimplifiedType.FriendlyNpc)
        return mask
    end

    function Cvars:Apply()
        -- Some nameplate cvars are protected and blocked in combat lockdown,
        -- same as Style:ApplyScale. Defer until combat ends.
        if InCombatLockdown() then
            Cvars.pending = true
            return
        end

        Cvars.pending = nil

        local config = Cvars.db.cvars

        C_CVar.SetCVar("nameplateShowOnlyNameForFriendlyPlayerUnits", config.onlyShowNames and "1" or "0")
        C_CVar.SetCVar("nameplateUseClassColorForFriendlyPlayerUnitNames", Cvars.db.friendly.classcolor and "1" or "0")
        C_CVar.SetCVar("nameplateShowFriendlyRealmName", config.realmName and "1" or "0")
        C_CVar.SetCVar("nameplateShowFriendlyNpcs", config.friendlyNpcs and "1" or "0")
        C_CVar.SetCVar("nameplateShowOffscreen", config.offscreen and "1" or "0")

        CVarCallbackRegistry:SetCVarBitfieldMask("nameplateStackingTypes", Cvars:GetStackingMask())
        CVarCallbackRegistry:SetCVarBitfieldMask("nameplateSimplifiedTypes", Cvars:GetSimplifiedMask())
        CVarCallbackRegistry:SetCVarBitfieldMask("nameplateInfoDisplay", 0)
        CVarCallbackRegistry:SetCVarBitfieldMask("nameplateCastBarDisplay",
            bit.bor(bit.lshift(1, Enum.NamePlateCastBarDisplay.SpellName - 1), bit.lshift(1, Enum.NamePlateCastBarDisplay.SpellIcon - 1),
                bit.lshift(1, Enum.NamePlateCastBarDisplay.SpellTarget - 1), bit.lshift(1, Enum.NamePlateCastBarDisplay.HighlightImportantCasts - 1),
                bit.lshift(1, Enum.NamePlateCastBarDisplay.HighlightWhenCastTarget - 1)))
    end

    function Cvars:OnRegenEnabled()
        if Cvars.pending then
            Cvars:Apply()
        end
    end

    function Cvars:Update()
        Cvars:Apply()
    end
end

function Cvars:OnEnable()
    Cvars.db = mUI.db.profile.nameplates

    Cvars:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRegenEnabled")
    Cvars:Apply()
end

function Cvars:OnDisable()
    Cvars:UnregisterAllEvents()
end
