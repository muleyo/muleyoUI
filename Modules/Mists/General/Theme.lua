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
        Theme:SecureHook("BuffFrame_UpdateAllBuffAnchors", function()
            Theme:UpdatePlayerBuffs()
        end)

        Theme:SecureHook("DebuffButton_UpdateAnchors", function(button, index)
            Theme:UpdatePlayerDebuffs(button, index)
        end)

        Theme:SecureHook("TargetFrame_UpdateAuras", function(frame)
            Theme:UpdateUnitframeAuras(frame)
        end)

        Theme:SecureHook("TargetFrame_UpdateAuraPositions",
            function(aura, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
                Theme:UpdateUnitframeAuraPositions(aura, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX,
                    mirrorAurasVertically)
            end)
    end

    -- Castbar Icon Skins
    Theme:InitCastbarIcons()

    -- Update Tooltips
    Theme:SecureHook("SharedTooltip_SetBackdropStyle", function(frame)
        Theme:StyleTooltip(frame)
    end)

    -- Update ActionButtons (re-skin after Blizzard resets visuals)
    Theme:Actionbars()
    Theme:SecureHook("ActionButton_OnUpdate", function(button)
        Theme:StyleButton(button, "Actionbar")
    end)

    -- Mirror Timer
    Theme:SecureHookScript(MirrorTimer1, "OnEvent", function(frame)
        mUI:Skin(frame)
    end)

    Theme:SecureHookScript(GameMenuFrame, "OnShow", function(frame)
        Theme:GameMenu()
    end)

    -- Remove Buff Blinking Animation
    BUFF_MIN_ALPHA = 1

    -- Timer Tracker
    Theme:SecureHookScript(TimerTracker, "OnEvent", function(frame)
        for i = 1, #frame.timerList do
            _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end)

    Theme.addons:RegisterEvent("ADDON_LOADED")
    Theme:SecureHookScript(Theme.addons, "OnEvent", function(_, _, addon)
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
        elseif (addon == "Blizzard_TalentUI" or addon == "Blizzard_GlyphUI") then
            Theme:Talents()
        elseif (addon == "Blizzard_TimeManager") then
            Theme:TimeManager()
        elseif (addon == "Blizzard_TradeSkillUI") then
            Theme:Professions()
        elseif (addon == "Blizzard_WeeklyRewards") then
            Theme:Rewards()
        elseif (addon == "Blizzard_ItemUpgradeUI") then
            Theme:ItemUpgrade()
        elseif (addon == "Blizzard_ReforgingUI") then
            Theme:Reforging()
        end
    end)
end

function Theme:OnDisable()
    -- Update Theme
    Theme:Update()

    -- Unhook Frames
    Theme:UnhookAll()
end
