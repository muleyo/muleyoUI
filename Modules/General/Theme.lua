local Theme = mUI:NewModule("mUI.Modules.General.Theme", "AceHook-3.0")

function Theme:OnInitialize()
    -- Load Database
    Theme.db = mUI.db.profile.general

    -- Create Frames
    Theme.dragonriding = CreateFrame("Frame")
    Theme.auras = CreateFrame("Frame")
end

function Theme:OnEnable()
    -- Prevent Errors from other AddOns
    INSPECTED_UNIT = "player"

    -- Load AddOns
    C_AddOns.LoadAddOn("Blizzard_InspectUI")
    C_AddOns.LoadAddOn("Blizzard_AchievementUI")
    C_AddOns.LoadAddOn("Blizzard_ProfessionsCustomerOrders")
    C_AddOns.LoadAddOn("Blizzard_AuctionHouseUI")
    C_AddOns.LoadAddOn("Blizzard_AlliedRacesUI")
    C_AddOns.LoadAddOn("Blizzard_ArchaeologyUI")
    C_AddOns.LoadAddOn("Blizzard_Calendar")
    C_AddOns.LoadAddOn("Blizzard_ChallengesUI")
    C_AddOns.LoadAddOn("Blizzard_ItemSocketingUI")
    C_AddOns.LoadAddOn("Blizzard_TrainerUI")
    C_AddOns.LoadAddOn("Blizzard_Collections")
    C_AddOns.LoadAddOn("Blizzard_EncounterJournal")
    C_AddOns.LoadAddOn("Blizzard_FlightMap")
    C_AddOns.LoadAddOn("Blizzard_GarrisonUI")
    C_AddOns.LoadAddOn("Blizzard_GuildBankUI")
    C_AddOns.LoadAddOn("Blizzard_Professions")
    C_AddOns.LoadAddOn("Blizzard_IslandsQueueUI")
    C_AddOns.LoadAddOn("Blizzard_PVPUI")
    C_AddOns.LoadAddOn("Blizzard_MacroUI")
    C_AddOns.LoadAddOn("Blizzard_ScrappingMachineUI")
    C_AddOns.LoadAddOn("Blizzard_ProfessionsBook")
    C_AddOns.LoadAddOn("Blizzard_PlayerSpells")
    C_AddOns.LoadAddOn("Blizzard_TimeManager")
    C_AddOns.LoadAddOn("Blizzard_TradeSkillUI")
    C_AddOns.LoadAddOn("Blizzard_Wardrobe")
    C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
    C_AddOns.LoadAddOn("Blizzard_ItemUpgradeUI")

    --local factiongroup = UnitFactionGroup("player")

    -- Load Blacklist
    Theme:ForbiddenFrames()

    -- Update Theme
    Theme:Update()

    -- Buffs & Debuffs
    if not C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then
        Theme:SecureHook(AuraFrameMixin, "Update", Theme.AuraPositions)
        Theme:HookDurationUpdates(BuffFrame.auraFrames)
        Theme:HookDurationUpdates(DebuffFrame.auraFrames)

        Theme.auras:RegisterEvent("PLAYER_ENTERING_WORLD")
        Theme.auras:RegisterEvent("PLAYER_TARGET_CHANGED")
        Theme.auras:RegisterEvent("PLAYER_FOCUS_CHANGED")
        Theme.auras:RegisterEvent("WEAPON_ENCHANT_CHANGED")
        Theme.auras:RegisterUnitEvent("UNIT_AURA", "player", "target", "focus")
        Theme:HookScript(Theme.auras, "OnEvent", function()
            -- Player Auras
            Theme:UpdatePlayerBuffs()
            Theme:UpdatePlayerDebuffs()

            -- Target Auras
            for aura in TargetFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                Theme:UpdateUnitframeAuras(aura)
            end
            for aura in TargetFrame.auraPools:GetPool("TargetDebuffFrameTemplate"):EnumerateActive() do
                Theme:UpdateUnitframeAuras(aura, true, "target")
            end

            -- Focus Auras
            for aura in FocusFrame.auraPools:GetPool("TargetBuffFrameTemplate"):EnumerateActive() do
                Theme:UpdateUnitframeAuras(aura)
            end
            for aura in FocusFrame.auraPools:GetPool("TargetDebuffFrameTemplate"):EnumerateActive() do
                Theme:UpdateUnitframeAuras(aura, true, "focus")
            end
        end)
    end

    -- Castbar Icon Skins
    Theme:InitCastbarIcons()

    -- Update Tooltips
    Theme:SecureHook("SharedTooltip_SetBackdropStyle", function(frame)
        Theme:StyleTooltip(frame)
    end)

    -- Dragonriding
    Theme.dragonriding:RegisterEvent("UPDATE_UI_WIDGET")
    Theme:HookScript(Theme.dragonriding, "OnEvent", Theme.StyleDragonriding)

    -- Update Spellbok Text Colors
    Theme:SecureHook(SpellBookItemMixin, "UpdateVisuals", function(frame)
        if Theme.db.theme == "Disabled" then
            frame.Name:SetTextColor(0.1803921610117, 0.10588236153126, 0.05882353335619)
            frame.SubName:SetTextColor(0.1803921610117, 0.10588236153126, 0.05882353335619)
            frame.Button.Border:SetVertexColor(1, 1, 1)
            frame.Button.Border:SetDesaturated(false)
        else
            frame.Name:SetTextColor(0.8, 0.8, 0.8)
            frame.SubName:SetTextColor(0.8, 0.8, 0.8)
            frame.Button.Border:SetVertexColor(0.5, 0.5, 0.5)
            frame.Button.Border:SetDesaturated(true)
        end
    end)

    -- TImer Tracker
    TimerTracker:HookScript("OnEvent", function(self)
        for i = 1, #self.timerList do
            _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end)
end

function Theme:OnDisable()
    -- Update Theme
    Theme:Update()

    -- Unhook Frames
    Theme:UnhookAll()
end
