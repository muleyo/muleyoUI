local Theme = mUI:NewModule("mUI.Modules.General.Theme", "AceHook-3.0")

function Theme:OnInitialize()
    -- Load Database
    Theme.db = mUI.db.profile.general

    -- Create Frames
    Theme.auras = CreateFrame("Frame")
    Theme.events = CreateFrame("Frame")
end

function Theme:OnEnable()
    -- Load Blacklist
    Theme:Blacklist()

    -- Blizzard AddOns
    Theme.addons = {
        ["Blizzard_InspectUI"] = Theme.Inspect,
        ["Blizzard_AchievementUI"] = Theme.Achievements,
        ["Blizzard_ProfessionsCustomerOrders"] = Theme.CraftingOrders,
        ["Blizzard_AuctionHouseUI"] = Theme.AuctionHouse,
        ["Blizzard_AlliedRacesUI"] = Theme.AlliedRaces,
        ["Blizzard_ArchaeologyUI"] = Theme.Archaeology,
        ["Blizzard_Calendar"] = Theme.Calendar,
        ["Blizzard_ChallengesUI"] = Theme.Challenges,
        ["Blizzard_ItemSocketingUI"] = Theme.Socketing,
        ["Blizzard_TrainerUI"] = Theme.Trainer,
        ["Blizzard_Collections"] = Theme.Collections,
        ["Blizzard_EncounterJournal"] = Theme.EncounterJournal,
        ["Blizzard_FlightMap"] = Theme.FlightMap,
        ["Blizzard_GarrisonUI"] = Theme.Garrison,
        ["Blizzard_GuildBankUI"] = Theme.GuildBank,
        ["Blizzard_Professions"] = Theme.Professions,
        ["Blizzard_IslandsQueueUI"] = Theme.Islands,
        ["Blizzard_PVPUI"] = Theme.PVP,
        ["Blizzard_MacroUI"] = Theme.Macros,
        ["Blizzard_ScrappingMachineUI"] = Theme.Scrapping,
        ["Blizzard_ProfessionsBook"] = Theme.ProfessionsBook,
        ["Blizzard_PlayerSpells"] = Theme.PlayerSpells,
        ["Blizzard_TalentUI"] = Theme.Talents,
        ["Blizzard_GlyphUI"] = Theme.Talents,
        ["Blizzard_TimeManager"] = Theme.TimeManager,
        ["Blizzard_WeeklyRewards"] = Theme.Rewards,
        ["Blizzard_ItemUpgradeUI"] = Theme.ItemUpgrade,
        ["Blizzard_ReforgingUI"] = Theme.Reforging,
        ["Blizzard_Transmog"] = Theme.Transmog,
        ["Blizzard_HousingDashboard"] = Theme.Housing,
        ["Blizzard_HousingModelPreview"] = Theme.Housing,
        ["Blizzard_PrivateAurasUI"] = Theme.PrivateAuras,
        ["Blizzard_ItemInteractionUI"] = Theme.Catalyst
    }

    -- Buffs & Debuffs
    if not C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then
        -- not working as of now
        -- Theme:HookDurationUpdates(BuffFrame.auraFrames)
        -- Theme:HookDurationUpdates(DebuffFrame.auraFrames)

        Theme.auras:RegisterEvent("PLAYER_ENTERING_WORLD")
        Theme.auras:RegisterEvent("PLAYER_TARGET_CHANGED")
        Theme.auras:RegisterEvent("PLAYER_FOCUS_CHANGED")
        Theme.auras:RegisterEvent("WEAPON_ENCHANT_CHANGED")
        Theme.auras:RegisterUnitEvent("UNIT_AURA", "player", "target", "focus")
        Theme:SecureHookScript(Theme.auras, "OnEvent", function()
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

        if mUI.db.profile.unitframes.raidframes.skinicons then
            Theme:SecureHook("CompactUnitFrame_UpdateAuras", function(frame)
                if not frame or frame:IsForbidden() then
                    return
                end

                -- Check if frame is Raid/Party
                local name = frame:GetName()
                if name and name:match("^Compact") then
                    if frame.CenterDefensiveBuff then
                        Theme:UpdateRaidframeAuras(frame.CenterDefensiveBuff)
                    end
                    if frame.debuffFrames then
                        for i = 1, #frame.debuffFrames do
                            Theme:UpdateRaidframeAuras(frame.debuffFrames[i])
                        end
                    end

                    if frame.buffFrames then
                        for i = 1, #frame.buffFrames do
                            Theme:UpdateRaidframeAuras(frame.buffFrames[i])
                        end
                    end
                end
            end)
        end

        Theme:SecureHook(AuraFrameMixin, "UpdateAuraButtons", Theme.AuraPositions)
    end

    -- Castbar Icon Skins
    Theme:InitCastbarIcons()

    -- Update Tooltips
    Theme:SecureHook("SharedTooltip_SetBackdropStyle", function(frame)
        Theme:StyleTooltip(frame)
    end)

    -- Game Menu
    Theme:SecureHook(GameMenuFrame, "InitButtons", function(frame)
        Theme:GameMenu(frame)
    end)

    -- Timer Tracker
    Theme:SecureHookScript(TimerTracker, "OnEvent", function(frame)
        for i = 1, #frame.timerList do
            _G['TimerTrackerTimer' .. i .. 'StatusBarBorder']:SetVertexColor(unpack(mUI:Color(0.15)))
        end
    end)

    Theme:SecureHookScript(MirrorTimerContainer, "OnEvent", function(frame)
        for i = 1, #frame.mirrorTimers do
            local frame = frame.mirrorTimers[i]
            if frame then
                frame:SetSize(209, 18)
                frame.TextBorder:Hide()
                frame.Border:Hide()
                frame.Text:ClearAllPoints()
                frame.Text:SetPoint("CENTER", frame, "CENTER", 0, 0)
                frame.Text:SetFont(Theme.LSM:Fetch('font', mUI.db.profile.general.font), 12, "OUTLINE")
            end
        end
    end)

    -- Skin Blizzard AddOns when they are loaded
    Theme.events:RegisterEvent("ADDON_LOADED")
    Theme:SecureHookScript(Theme.events, "OnEvent", function(_, _, addon)
        if Theme.addons[addon] then
            Theme.addons[addon]()
        end
    end)

    -- Update Theme
    C_Timer.After(0, Theme.Update)
end

function Theme:OnDisable()
    -- Update Theme
    Theme:Update()

    -- Unhook Frames
    Theme:UnhookAll()
end
