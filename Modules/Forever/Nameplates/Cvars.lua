local Cvars = mUI:NewModule("mUI.Modules.Nameplates.Cvars", "AceEvent-3.0")

-- The CVars of the nameplates stay as mUI sets them, they are the CVars of the game. What the user had is kept in the database
-- (once, right before mUI changes it for the first time) and given back when the nameplates, or the part that changed them, are
-- turned off. Style and PersonalResourceBar set theirs the same way.
Cvars.NAMES = {"nameplateShowOnlyNameForFriendlyPlayerUnits", "nameplateUseClassColorForFriendlyPlayerUnitNames",
               "nameplateShowFriendlyRealmName", "nameplateShowFriendlyNpcs", "nameplateShowOffscreen", "nameplateStackingTypes",
               "nameplateSimplifiedTypes", "nameplateInfoDisplay", "nameplateCastBarDisplay"}

-- Before backups were kept, this one was given back as the default
local DEFAULT_WITHOUT_BACKUP = {
    nameplateInfoDisplay = true
}

function Cvars:OnInitialize()
    -- Load Database
    Cvars.db = mUI.db.profile.nameplates

    -- ========================================================================
    -- What the user had
    -- ========================================================================
    local function Backups()
        return mUI.db.global.nameplateCvars
    end

    -- "1" and "1.000000" are the same value. Bitfields are strings that aren't numbers, those have to be the same string.
    local function Same(a, b)
        if a == b then
            return true
        end

        local numberA, numberB = tonumber(a), tonumber(b)
        return numberA ~= nil and numberB ~= nil and math.abs(numberA - numberB) < 0.00001
    end

    -- CVars that have to wait for the combat to end before they can be given back
    local waiting = {}
    local waitFrame = CreateFrame("Frame")
    waitFrame:SetScript("OnEvent", function(frame)
        frame:UnregisterEvent("PLAYER_REGEN_ENABLED")

        local names = {}
        for name in pairs(waiting) do
            names[#names + 1] = name
            waiting[name] = nil
        end
        Cvars:Restore(names)
    end)

    -- Keeps what the CVar was before, if the change made a difference and nothing is kept yet
    local function Keep(name, before)
        waiting[name] = nil

        local backups = Backups()
        if before == nil or backups[name] ~= nil then
            return
        end

        if not Same(before, C_CVar.GetCVar(name)) then
            backups[name] = before
        end
    end

    function Cvars:Set(name, value)
        local before = C_CVar.GetCVar(name)
        C_CVar.SetCVar(name, value)
        Keep(name, before)
    end

    function Cvars:SetMask(name, mask)
        local before = C_CVar.GetCVar(name)
        CVarCallbackRegistry:SetCVarBitfieldMask(name, mask)
        Keep(name, before)
    end

    -- Gives the CVars back to the user. Some of them can't be set in combat, those wait.
    function Cvars:Restore(names)
        if InCombatLockdown() then
            for _, name in ipairs(names) do
                waiting[name] = true
            end
            waitFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
            return
        end

        local backups = Backups()
        for _, name in ipairs(names) do
            local value = backups[name]
            if value == nil and DEFAULT_WITHOUT_BACKUP[name] then
                value = C_CVar.GetCVarDefault(name)
            end

            if value ~= nil then
                C_CVar.SetCVar(name, value)
            end
            backups[name] = nil
        end
    end

    -- ========================================================================
    -- What mUI sets
    -- ========================================================================
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

        Cvars:Set("nameplateShowOnlyNameForFriendlyPlayerUnits", config.onlyShowNames and "1" or "0")
        Cvars:Set("nameplateUseClassColorForFriendlyPlayerUnitNames", Cvars.db.friendly.classcolor and "1" or "0")
        Cvars:Set("nameplateShowFriendlyRealmName", config.realmName and "1" or "0")
        Cvars:Set("nameplateShowFriendlyNpcs", config.friendlyNpcs and "1" or "0")
        Cvars:Set("nameplateShowOffscreen", config.offscreen and "1" or "0")

        Cvars:SetMask("nameplateStackingTypes", Cvars:GetStackingMask())
        Cvars:SetMask("nameplateSimplifiedTypes", Cvars:GetSimplifiedMask())
        Cvars:SetMask("nameplateInfoDisplay", 0)
        Cvars:SetMask("nameplateCastBarDisplay",
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
    Cvars.pending = nil

    -- The default nameplates get the CVars of the user back, not the ones of mUI. Apply() zeroes the info display (Blizzard's health
    -- text and elite/rarity icon) and can simplify nameplates, which also takes their auras away.
    Cvars:Restore(Cvars.NAMES)
end
