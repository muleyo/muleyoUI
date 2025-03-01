local Theme = mUI:NewModule("mUI.Modules.General.Theme", "AceHook-3.0")

function Theme:OnInitialize()
    -- Load Database
    Theme.db = mUI.db.profile.general

    -- Create Frames
    Theme.dragonriding = CreateFrame("Frame")
    Theme.auras = CreateFrame("Frame")
    Theme.addons = CreateFrame("Frame")
end

function Theme:OnEnable()
    -- Load Blacklist
    Theme:Blacklist()

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
    Theme:StyleDragonriding()
    Theme.dragonriding:RegisterEvent("UPDATE_UI_WIDGET")
    Theme:HookScript(Theme.dragonriding, "OnEvent", Theme.StyleDragonriding)


    -- TImer Tracker
    TimerTracker:HookScript("OnEvent", function(self)
        for i = 1, #self.timerList do
            _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end)

    Theme.addons:RegisterEvent("ADDON_LOADED")
    Theme:HookScript(Theme.addons, "OnEvent", function(_, _, addon)
        if (addon == "Blizzard_InspectUI") then
            Theme:Inspect()
        elseif (addon == "Blizzard_AchievementUI") then
            Theme:Achievements()
        elseif (addon == "Blizzard_ProfessionsCustomerOrders") then
            Theme:CraftingOrders()
        elseif (addon == "Blizzard_AuctionHouseUI") then
            Theme:AuctionHouse()
        elseif (addon == "Blizzard_AlliedRacesUI") then
            Theme:AlliedRaces()
        elseif (addon == "Blizzard_ArchaeologyUI") then
            Theme:Archaeology()
        elseif (addon == "Blizzard_Calendar") then
            Theme:Calendar()
        elseif (addon == "Blizzard_ChallengesUI") then
            Theme:Challenges()
        elseif (addon == "Blizzard_ItemSocketingUI") then
            Theme:Socketing()
        elseif (addon == "Blizzard_TrainerUI") then
            Theme:Trainer()
        elseif (addon == "Blizzard_Collections") then
            Theme:Collections()
        elseif (addon == "Blizzard_EncounterJournal") then
            Theme:EncounterJournal()
        elseif (addon == "Blizzard_FlightMap") then
            Theme:FlightMap()
        elseif (addon == "Blizzard_GarrisonUI") then
            Theme:Garrison()
        elseif (addon == "Blizzard_GuildBankUI") then
            Theme:GuildBank()
        elseif (addon == "Blizzard_Professions") then
            Theme:Professions()
        elseif (addon == "Blizzard_IslandsQueueUI") then
            Theme:Islands()
        elseif (addon == "Blizzard_PVPUI") then
            Theme:PVP()
        elseif (addon == "Blizzard_MacroUI") then
            Theme:Macros()
        elseif (addon == "Blizzard_ScrappingMachineUI") then
            Theme:Scrapping()
        elseif (addon == "Blizzard_ProfessionsBook") then
            Theme:ProfessionsBook()
        elseif (addon == "Blizzard_PlayerSpells") then
            Theme:PlayerSpells()
        elseif (addon == "Blizzard_TimeManager") then
            Theme:TimeManager()
        elseif (addon == "Blizzard_TradeSkillUI") then
            Theme:TradeSkill()
        elseif (addon == "Blizzard_WeeklyRewards") then
            Theme:Rewards()
        elseif (addon == "Blizzard_ItemUpgradeUI") then
            Theme:ItemUpgrade()
        end
    end)
end

function Theme:OnDisable()
    -- Update Theme
    Theme:Update()

    Theme:StyleDragonriding()

    -- Unhook Frames
    Theme:UnhookAll()
end
