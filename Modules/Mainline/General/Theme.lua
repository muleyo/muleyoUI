local Theme = mUI:NewModule("mUI.Modules.General.Theme", "AceHook-3.0")

function Theme:OnInitialize()
    -- Load Database
    Theme.db = mUI.db.profile.general

    -- Create Frames
    Theme.auras = CreateFrame("Frame")
    Theme.events = CreateFrame("Frame")

    -- ============================================================================
    -- Icon Border Styles (aura + castbar icons)
    -- ============================================================================
    Theme.BorderStyles = {
        Style1 = {
            border = [[Interface\AddOns\mUI\Media\Textures\Core\atlas.png]],
            borderCoord = {0.95263671875, 0.99365234375, 0.17919921875, 0.22021484375},
            mask = [[Interface\AddOns\mUI\Media\Textures\Core\mask.png]],
            auraInsetRatio = 6 / 30,
            castbarInset = 4.5,
            castbarInsetSmall = 3.5,
            nameplateIcons = 4.25,
            totemIcon = 4
        },
        Style2 = {
            border = [[Interface\AddOns\mUI\Media\Textures\Core\atlas_v2.png]],
            borderCoord = {0.001953125, 0.142578125, 0.451171875, 0.591796875},
            mask = [[Interface\AddOns\mUI\Media\Textures\Core\mask_v2.png]],
            auraInsetRatio = 12.5 / 30,
            castbarInset = 8,
            castbarInsetSmall = 7,
            nameplateIcons = 6.75,
            totemIcon = 14
        }
    }

    -- Records of border textures created by aura/castbar skinning, so a style swap
    -- can re-apply textures to already-created frames.
    Theme.borderRegistry = {}

    function Theme:GetBorderStyle()
        local key = (mUI.db and mUI.db.profile.general.borderStyle) or "Style1"
        return Theme.BorderStyles[key] or Theme.BorderStyles.Style1
    end

    -- Re-skins a single registered record. rec fields:
    function Theme:SkinBorderRecord(rec, style)
        style = style or Theme:GetBorderStyle()

        if rec.border then
            rec.border:SetTexture(style.border)
            if rec.coord then
                rec.border:SetTexCoord(unpack(style.borderCoord))
            end
        end

        if rec.extra then
            for _, tex in ipairs(rec.extra) do
                tex:SetTexture(style.border)
                if rec.coord then
                    tex:SetTexCoord(unpack(style.borderCoord))
                end
            end
        end

        if rec.mask then
            rec.mask:SetTexture(style.mask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        end

        if rec.swipe then
            rec.swipe:SetSwipeTexture(style.mask)
        end

        -- Re-position the border for this style's artwork thickness
        if rec.applyGeometry then
            rec.applyGeometry(style)
        end
    end

    -- Registers and immediately skins a border record with the active style.
    function Theme:RegisterBorder(rec)
        Theme.borderRegistry[#Theme.borderRegistry + 1] = rec
        Theme:SkinBorderRecord(rec)
        return rec
    end

    -- Re-applies the active border style to every registered aura/castbar border.
    function Theme:ApplyBorderStyle()
        local style = Theme:GetBorderStyle()
        for _, rec in ipairs(Theme.borderRegistry) do
            Theme:SkinBorderRecord(rec, style)
        end
    end
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
        ["Blizzard_DebugTools"] = Theme.Framestack,
        ["Blizzard_HouseList"] = Theme.Housing
    }

    -- Player Auras
    Theme:InitPlayerAuraContainers()

    if mUI.db.profile.unitframes.enabled then
        if mUI.db.profile.unitframes.buffsdebuffs.enabled then
            Theme:CreateUnitAuraContainer(TargetFrame, "target")
            Theme:CreateUnitAuraContainer(FocusFrame, "focus")
        else
            Theme:DisableDefaultUnitAuraContainer(TargetFrame)
            Theme:DisableDefaultUnitAuraContainer(FocusFrame)
        end
    end

    if mUI.db.profile.unitframes.raidframes.enabled and mUI.db.profile.unitframes.raidframes.customAuras then
        -- Raidframe Auras
        Theme:DisableDefaultRaidAuras(true)
        local function RefreshRaidFrameAuras(frame)
            if not frame or (frame and frame:IsForbidden()) or (frame and not frame.unit) then
                return
            end

            local name = frame:GetName()

            if not name or not (name:match("^CompactParty") or name:match("^CompactRaid")) then
                return
            end

            local data = Theme:EnsureContainers(frame)
            Theme:PositionAnchors(frame, data)

            local unit = frame.displayedUnit or frame.unit
            if not unit or unit:match("target") then
                return
            end

            -- Truly unreachable (disconnected/phased/not visible): hide everything
            local unreachable = (UnitPhaseReason and UnitPhaseReason(unit) ~= nil) or (UnitIsVisible and not UnitIsVisible(unit))
            local notAssistable = UnitCanAssist and not UnitCanAssist("player", unit)

            local buffSize, debuffSize = Theme:GetSizes(frame)
            local frameH = frame:GetHeight()
            if not frameH or frameH < 1 then
                frameH = 36
            end

            local defensiveSize = math.floor(frameH * (Theme:GetDefensiveSize() / 100) + 0.5)
            local defPoint, defX, defY = Theme:GetDefensivePosition()

            Theme:UpdateRaidAuraContainers(frame, data, unit, unreachable, notAssistable, buffSize, debuffSize, defensiveSize, defPoint, defX, defY)
        end

        Theme:SecureHook("CompactUnitFrame_SetUnit", RefreshRaidFrameAuras)

        if Theme.raidAuraVisibilityTicker then
            Theme.raidAuraVisibilityTicker:Cancel()
        end
        Theme.raidAuraVisibilityTicker = C_Timer.NewTicker(1, function()
            for frame in pairs(Theme.raidAuraFrames or {}) do
                RefreshRaidFrameAuras(frame)
            end
        end)
    else
        Theme:DisableDefaultRaidAuras(false)
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
