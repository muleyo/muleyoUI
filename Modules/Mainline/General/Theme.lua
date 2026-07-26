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
        ["Blizzard_ItemInteractionUI"] = Theme.Catalyst,
        ["Blizzard_DebugTools"] = Theme.Framestack
    }

    -- Buffs & Debuffs
    if not C_AddOns.IsAddOnLoaded("BlizzBuffsFacade") then
        if select(4, GetBuildInfo()) >= 120100 then
            -- Player Auras
            Theme:InitPlayerAuraContainers()

            if mUI.db.profile.unitframes.enabled then
                -- Target/Focus Auras
                Theme:CreateUnitAuraContainer(TargetFrame, "target")
                Theme:CreateUnitAuraContainer(FocusFrame, "focus")
            end

            if mUI.db.profile.unitframes.raidframes.enabled then
                -- Raidframe Auras
                Theme:DisableDefaultRaidAuras(true)
                Theme:SecureHook("CompactUnitFrame_UpdateStatusText", function(frame)
                    if not frame or frame:IsForbidden() or not frame.unit then
                        return
                    end

                    local name = frame:GetName()

                    if not name or not name:match("^Compact") then
                        return
                    end

                    local data = Theme:EnsureContainers(frame)
                    Theme:PositionAnchors(frame, data)

                    local unit = frame.displayedUnit or frame.unit
                    if not unit or unit:match("target") then
                        return
                    end

                    local unreachable = (UnitIsConnected and not UnitIsConnected(unit)) or (UnitPhaseReason and UnitPhaseReason(unit) ~= nil) or
                                            (UnitIsVisible and not UnitIsVisible(unit))

                    local buffSize, debuffSize = Theme:GetSizes(frame)
                    local frameH = frame:GetHeight()
                    if not frameH or frameH < 1 then
                        frameH = 36
                    end

                    local defensiveSize = math.floor(frameH * (Theme:GetDefensiveSize() / 100) + 0.5)
                    local defPoint, defX, defY = Theme:GetDefensivePosition()

                    Theme:UpdateRaidAuraContainers(frame, data, unit, unreachable, buffSize, debuffSize, defensiveSize, defPoint, defX, defY)
                end)
            else
                Theme:DisableDefaultRaidAuras(false)
            end
        else
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

            -- Only the legacy path uses Blizzard's aura buttons, so this is the
            -- only path that needs their text repositioned.
            Theme:SecureHook(AuraFrameMixin, "UpdateAuraButtons", Theme.AuraPositions)
        end
    end

    -- Castbar Icon Skins
    Theme:InitCastbarIcons()

    -- Update Tooltips
    Theme:SecureHook("SharedTooltip_SetBackdropStyle", function(frame)
        Theme:StyleTooltip(frame)
        Theme:StyleAuraTooltip()
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
