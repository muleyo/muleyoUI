local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")

Theme.bagsbackup = MainMenuBarBackpackButtonNormalTexture.SetVertexColor

function Theme:Achievements()
    -- Achievements Frame
    if AchievementFrame then
        -- Blacklist Frames
        Theme.blacklist["AchievementFrameHeaderShield"] = true

        -- Skin frames
        mUI:Skin(AchievementFrame)
        mUI:Skin(AchievementFrameHeader)
        mUI:Skin(AchievementFrameSummary)
        mUI:Skin(AchievementFrameTab1)
        mUI:Skin(AchievementFrameTab2)
        mUI:Skin(AchievementFrameTab3)
        AchievementFrameHeaderPointBorder:SetAlpha(0)
    end
end

function Theme:AuctionHouse()
    -- Auction House
    if AuctionHouseFrame then
        mUI:Skin(AuctionHouseFrame)
        mUI:Skin(AuctionHouseFrameBuyTab)
        mUI:Skin(AuctionHouseFrameSellTab)
        mUI:Skin(AuctionHouseFrameAuctionsTab)
        mUI:Skin(AuctionHouseFrame.CategoriesList)
        mUI:Skin(AuctionHouseFrame.CategoriesList.NineSlice)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList.NineSlice)
        mUI:Skin(AuctionHouseFrame.CategoriesList.ScrollBar)
        mUI:Skin(AuctionHouseFrame.CategoriesList.ScrollBar.Background)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBar)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBar.Background)
        mUI:Skin(AuctionHouseFrame.MoneyFrameInset)
        mUI:Skin(AuctionHouseFrame.MoneyFrameBorder)
    end
end

function Theme:Archaeology()
    -- Archaeology Frame
    if ArchaeologyFrame then
        -- Blacklist Frames
        Theme.blacklist["ArchaeologyFrameBgLeft"] = true
        Theme.blacklist["ArchaeologyFrameBgRight"] = true

        mUI:Skin(ArchaeologyFrame)
        mUI:Skin(ArchaeologyFrame.NineSlice)
    end
end

function Theme:Calendar()
    -- Calendar
    if CalendarFrame then
        -- Blacklist frames
        Theme.blacklist[select(3, CalendarClassButton1:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton2:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton3:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton4:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton5:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton6:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton7:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton8:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton9:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton10:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton11:GetRegions())] = true

        -- Skin frames
        mUI:Skin(CalendarFrame)
        mUI:Skin(CalendarCreateEventFrame)
        mUI:Skin(CalendarCreateEventFrame.Header)
        mUI:Skin(CalendarCreateEventFrame.Border)
        mUI:Skin(CalendarViewHolidayFrame)
        mUI:Skin(CalendarViewHolidayFrame.Header)
        mUI:Skin(CalendarViewHolidayFrame.Border)
        mUI:Skin(CalendarClassButton1)
        mUI:Skin(CalendarClassButton2)
        mUI:Skin(CalendarClassButton3)
        mUI:Skin(CalendarClassButton4)
        mUI:Skin(CalendarClassButton5)
        mUI:Skin(CalendarClassButton6)
        mUI:Skin(CalendarClassButton7)
        mUI:Skin(CalendarClassButton8)
        mUI:Skin(CalendarClassButton9)
        mUI:Skin(CalendarClassButton10)
        mUI:Skin(CalendarClassButton11)
        mUI:Skin(CalendarClassButton12)
        mUI:Skin(CalendarClassButton13)
        mUI:Skin(CalendarClassTotalsButton)
        mUI:Skin({CalendarCreateEventDivider, CalendarCreateEventFrameButtonBackground,
                  CalendarCreateEventMassInviteButtonBorder, CalendarCreateEventCreateButtonBorder}, true)
    end
end

function Theme:Challenges()
    -- Challenges Frame
    if ChallengesFrame then
        mUI:Skin(ChallengesFrameInset.NineSlice)
    end

    if ChallengesKeystoneFrame then
        mUI:Skin(ChallengesKeystoneFrame)
    end
end

function Theme:Socketing()
    -- Socketing Frame
    if ItemSocketingFrame then
        mUI:Skin(ItemSocketingFrame)
        mUI:Skin(ItemSocketingFrame.NineSlice)
        mUI:Skin(ItemSocketingScrollFrame.ScrollBar)
        mUI:Skin(ItemSocketingScrollFrame.ScrollBar.Background)
    end
end

function Theme:Trainer()
    -- Profession/Class Trainer
    if ClassTrainerFrame then
        -- Blacklist Frames
        Theme.blacklist["ClassTrainerFramePortrait"] = true

        mUI:Skin(ClassTrainerFrame)
        mUI:Skin(ClassTrainerFrame.NineSlice)
        mUI:Skin({select(1, ClassTrainerListScrollFrame:GetRegions()):Hide(),
                  select(2, ClassTrainerListScrollFrame:GetRegions()):Hide()}, true)
    end
end

function Theme:Collections()
    if CollectionsJournal then
        -- Blacklist frames
        Theme.blacklist[select(3, CollectionsJournal:GetRegions())] = true

        -- Skin frames
        -- Collections Frame
        mUI:Skin(CollectionsJournal)
        mUI:Skin(CollectionsJournal.NineSlice)

        -- Mount Journal
        mUI:Skin(MountJournal)
        mUI:Skin(MountJournal.MountDisplay)
        mUI:Skin(MountJournal.LeftInset.NineSlice)
        mUI:Skin(MountJournal.RightInset.NineSlice)
        mUI:Skin(MountJournal.ScrollBar.Background)
        MountJournalMountButton_RightSeparator:Hide()

        -- ToyBox
        mUI:Skin(ToyBox)
        mUI:Skin(ToyBox.iconsFrame)
        mUI:Skin(ToyBox.iconsFrame.NineSlice)

        -- Heirlooms Journal
        mUI:Skin(HeirloomsJournal)
        mUI:Skin(HeirloomsJournal.iconsFrame)
        mUI:Skin(HeirloomsJournal.iconsFrame.NineSlice)

        -- Pet Journal
        mUI:Skin(PetJournalLeftInset)
        mUI:Skin(PetJournalLeftInset.NineSlice)
        mUI:Skin(PetJournalPetCardInset)
        mUI:Skin(PetJournalPetCardInset.NineSlice)
        mUI:Skin(PetJournalPetCard)
        mUI:Skin(PetJournalLoadoutPet1)
        mUI:Skin(PetJournalLoadoutPet2)
        mUI:Skin(PetJournalLoadoutPet3)
        mUI:Skin(PetJournalLoadoutBorder)
        mUI:Skin(PetJournalRightInset.NineSlice)
        mUI:Skin({PetJournalSummonRandomFavoritePetButtonBorder, PetJournalHealPetButtonBorder}, true)
        PetJournalSummonButton_RightSeparator:Hide()

        -- Wardrobe
        mUI:Skin(WardrobeCollectionFrame)
        mUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame)
        mUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice)
        mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame)
        mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset)
        mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice)
        mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset)
        mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice)
        mUI:Skin(WardrobeCollectionFrame.SetsTransmogFrame)
        mUI:Skin(WardrobeFrame)
        mUI:Skin(WardrobeFrame.NineSlice)
        mUI:Skin(WardrobeTransmogFrame)
        mUI:Skin(WardrobeTransmogFrame.Inset)
        mUI:Skin(WardrobeTransmogFrame.Inset.NineSlice)
        WardrobeTransmogFrame.Inset.BG:SetVertexColor(1, 1, 1) -- Reset Background Color
        mUI:Skin({WardrobeCollectionFrameScrollFrameScrollBarBottom, WardrobeCollectionFrameScrollFrameScrollBarMiddle,
                  WardrobeCollectionFrameScrollFrameScrollBarTop,
                  WardrobeCollectionFrameScrollFrameScrollBarThumbTexture}, true)

        -- Specific Frames
        mUI:Skin({CollectionsJournalBg, MountJournalListScrollFrameScrollBarThumbTexture,
                  MountJournalListScrollFrameScrollBarTop, MountJournalListScrollFrameScrollBarMiddle,
                  MountJournalListScrollFrameScrollBarBottom, PetJournalListScrollFrameScrollBarThumbTexture,
                  PetJournalListScrollFrameScrollBarTop, PetJournalListScrollFrameScrollBarMiddle,
                  PetJournalListScrollFrameScrollBarBottom}, true)

        -- Tabs
        mUI:Skin(CollectionsJournalTab1)
        mUI:Skin(CollectionsJournalTab2)
        mUI:Skin(CollectionsJournalTab3)
        mUI:Skin(CollectionsJournalTab4)
        mUI:Skin(CollectionsJournalTab5)
        mUI:Skin(CollectionsJournalTab6)
        mUI:Skin(WardrobeCollectionFrameTab1)
        mUI:Skin(WardrobeCollectionFrameTab2)
    end
end

function Theme:EncounterJournal()
    -- Encounter Journal
    if EncounterJournal then
        mUI:Skin(EncounterJournal)
        mUI:Skin(EncounterJournal.NineSlice)
        mUI:Skin(EncounterJournalInset)
        mUI:Skin(EncounterJournalInset.NineSlice)
        mUI:Skin(EncounterJournalNavBar)
        mUI:Skin(EncounterJournalNavBar.overlay)
        mUI:Skin(EncounterJournalMonthlyActivitiesTab)
        mUI:Skin(EncounterJournalSuggestTab)
        mUI:Skin(EncounterJournalDungeonTab)
        mUI:Skin(EncounterJournalRaidTab)
        mUI:Skin(EncounterJournalLootJournalTab)
        mUI:Skin(EncounterJournalMonthlyActivitiesFrame.ThemeContainer)
    end
end

function Theme:FlightMap()
    -- Flightmap
    if TaxiFrame then
        mUI:Skin(TaxiFrame)
    end
end

function Theme:Garrison()
    -- Garrison
    if GarrisonCapacitiveDisplayFrame then
        mUI:Skin(GarrisonCapacitiveDisplayFrame)
        mUI:Skin(GarrisonCapacitiveDisplayFrame.NineSlice)
        mUI:Skin(GarrisonCapacitiveDisplayFrameInset)
        mUI:Skin(GarrisonCapacitiveDisplayFrameInset.NineSlice)
    end
end

function Theme:Inspect()
    -- Inspect Frame
    if InspectFrame then
        mUI:Skin(InspectFrame)
        mUI:Skin(InspectFrame.NineSlice)
        mUI:Skin(InspectFrameInset)
        mUI:Skin(InspectFrameInset.NineSlice)
        mUI:Skin(InspectPaperDollItemsFrame)
        mUI:Skin(InspectPaperDollItemsFrame.InspectTalents)
        mUI:Skin(InspectPVPFrame)
        mUI:Skin({InspectModelFrameBorderLeft, InspectModelFrameBorderRight, InspectModelFrameBorderTop,
                  InspectModelFrameBorderTopLeft, InspectModelFrameBorderTopRight, InspectModelFrameBorderBottom,
                  InspectModelFrameBorderBottomLeft, InspectModelFrameBorderBottomRight, InspectModelFrameBorderBottom2,
                  InspectFeetSlotFrame, InspectHandsSlotFrame, InspectWaistSlotFrame, InspectLegsSlotFrame,
                  InspectFinger0SlotFrame, InspectFinger1SlotFrame, InspectTrinket0SlotFrame, InspectTrinket1SlotFrame,
                  InspectWristSlotFrame, InspectTabardSlotFrame, InspectShirtSlotFrame, InspectChestSlotFrame,
                  InspectBackSlotFrame, InspectShoulderSlotFrame, InspectNeckSlotFrame, InspectHeadSlotFrame,
                  InspectSecondaryHandSlotFrame}, true)
        mUI:Skin(InspectFrameTab1)
        mUI:Skin(InspectFrameTab2)
        mUI:Skin(InspectFrameTab3)
        mUI:Skin(InspectFrameTab4)
        InspectMainHandSlotFrame:Hide()
        InspectSecondaryHandSlotFrame:Hide()
        InspectRangedSlot:Hide()
        _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
        _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()
    end
end

function Theme:GuildBank()
    -- Guild Bank
    if GuildBankFrame then
        mUI:Skin(GuildBankFrameTab1)
        mUI:Skin(GuildBankFrameTab2)
        mUI:Skin(GuildBankFrameTab3)
        mUI:Skin(GuildBankFrameTab4)
        mUI:Skin(GuildBankFrame)
        mUI:Skin({GuildBankFrameLeft, GuildBankFrameMiddle, GuildBankFrameRight,
                  select(1, GuildBankInfoScrollFrame:GetRegions()), select(2, GuildBankInfoScrollFrame:GetRegions())},
            true)

        mUI:Skin(GuildBankTab1)
        mUI:Skin(GuildBankTab2)
        mUI:Skin(GuildBankTab3)
        mUI:Skin(GuildBankTab4)
        mUI:Skin(GuildBankTab5)
        mUI:Skin(GuildBankTab6)
        mUI:Skin(GuildBankTab7)
        mUI:Skin(GuildBankTab8)
        mUI:Skin(GuildBankFrame.MoneyFrameBG)
        mUI:Skin(GuildBankFrame.Column1)
        mUI:Skin(GuildBankFrame.Column2)
        mUI:Skin(GuildBankFrame.Column3)
        mUI:Skin(GuildBankFrame.Column4)
        mUI:Skin(GuildBankFrame.Column5)
        mUI:Skin(GuildBankFrame.Column6)
        mUI:Skin(GuildBankFrame.Column7)
    end
end

function Theme:Professions()
    -- Professions
    if TradeSkillFrame then
        -- Blacklist Frames
        Theme.blacklist["TradeSkillFramePortrait"] = true
        mUI:Skin(TradeSkillFrame)
        mUI:Skin({select(1, TradeSkillListScrollFrame:GetRegions()), select(2, TradeSkillListScrollFrame:GetRegions())},
            true)
    end
end

function Theme:Islands()
    -- Islands
    if IslandsQueueFrame then
        mUI:Skin(IslandsQueueFrame)
        mUI:Skin(IslandsQueueFrame.NineSlice)
        mUI:Skin(IslandsQueueFrame.ArtOverlayFrame)
    end
end

function Theme:PVP()
    -- PVP UI
    if HonorFrame then
        mUI:Skin(HonorFrame)
        mUI:Skin(WorldStateScoreFrame)
        mUI:Skin(WorldStateScoreScrollFrame)
        mUI:Skin(WorldStateScoreFrameTab1)
        mUI:Skin(WorldStateScoreFrameTab2)
        mUI:Skin(WorldStateScoreFrameTab3)
    end

    if HonorQueueFrame then
        mUI:Skin(HonorQueueFrame.Inset)
        mUI:Skin(HonorQueueFrame.Inset.NineSlice)
        mUI:Skin(HonorQueueFrame.RoleInset)
        mUI:Skin(HonorQueueFrame.RoleInset.NineSlice)
        mUI:Skin(WarGamesQueueFrame)
        mUI:Skin(WarGamesQueueFrame.RightInset)
        mUI:Skin(WarGamesQueueFrame.RightInset.NineSlice)
        mUI:Skin(WarGamesQueueFrame.HorizontalBar)
        mUI:Skin(WarGamesQueueFrameInfoScrollFrame.ScrollBar.Background)
        mUI:Skin({WarGamesQueueFrameScrollFrameScrollBarTop, WarGamesQueueFrameScrollFrameScrollBarMiddle,
                  WarGamesQueueFrameScrollFrameScrollBarBottom}, true)
        HonorQueueFrameGroupQueueButton_LeftSeparator:Hide()
        HonorQueueFrameSoloQueueButton_RightSeparator:Hide()
        WarGameStartButton_LeftSeparator:Hide()
        WarGameStartButton_RightSeparator:Hide()
    end

    if ConquestQueueFrame then
        mUI:Skin(ConquestQueueFrame)
        mUI:Skin(ConquestQueueFrame.Inset)
        mUI:Skin(ConquestQueueFrame.Inset.NineSlice)
        ConquestJoinButton_LeftSeparator:Hide()
        ConquestJoinButton_RightSeparator:Hide()
    end
end

function Theme:Macros()
    -- Macros
    if MacroFrame then
        -- Blacklist frames
        Theme.blacklist[select(9, MacroFrameTextBackground.NineSlice:GetRegions())] = true
        Theme.blacklist[select(18, MacroFrame:GetRegions())] = true

        -- Skin frames
        mUI:Skin(MacroFrame)
        mUI:Skin(MacroFrame.NineSlice)
        mUI:Skin(MacroFrameInset)
        mUI:Skin(MacroFrameInset.NineSlice)
        mUI:Skin(MacroFrameTextBackground)
        mUI:Skin(MacroFrameTextBackground.NineSlice)
        mUI:Skin(MacroFrame.MacroSelector.ScrollBar.Background)
        mUI:Skin(MacroPopupFrame)
        mUI:Skin(MacroPopupFrame.BorderBox)
        mUI:Skin(MacroFrameTab1)
        mUI:Skin(MacroFrameTab2)
        mUI:Skin({MacroButtonScrollFrameTop, MacroButtonScrollFrameMiddle, MacroButtonScrollFrameBottom,
                  MacroButtonScrollFrameScrollBarThumbTexture}, true)
    end
end

function Theme:Scrapping()
    -- Scrapping Machine
    if ScrappingMachineFrame then
        mUI:Skin(ScrappingMachineFrame)
        mUI:Skin(ScrappingMachineFrame.NineSlice)
    end
end

function Theme:Talents()
    if PlayerTalentFrame then
        -- Blacklist Frames
        Theme.blacklist["PlayerTalentFramePortrait"] = true
        Theme.blacklist["PlayerTalentFrameBackgroundTopLeft"] = true
        Theme.blacklist["PlayerTalentFrameBackgroundTopRight"] = true
        Theme.blacklist["PlayerTalentFrameBackgroundBottomLeft"] = true
        Theme.blacklist["PlayerTalentFrameBackgroundBottomRight"] = true

        mUI:Skin(PlayerTalentFrame)
        mUI:Skin(PlayerTalentFrameScrollFrame)
        mUI:Skin(PlayerTalentFramePointsBar)
        mUI:Skin(PlayerTalentFrameTalents)
        mUI:Skin(PlayerTalentFrameTab1)
        mUI:Skin(PlayerTalentFrameTab2)
        mUI:Skin(PlayerTalentFrameTab3)
        mUI:Skin(PlayerTalentFrameTab4)
        mUI:Skin(PlayerSpecTab1)
        mUI:Skin(PlayerSpecTab2)
    end
end

function Theme:Spellbook()
    -- Spellbook
    if SpellBookFrame then
        SpellBookFrame:Show()
        SpellBookFrame:Hide()
        mUI:Skin(SpellBookFrame)
        mUI:Skin(SpellBookFrame.NineSlice)
        mUI:Skin({ProfessionsBookPage1, ProfessionsBookPage2, select(1, SpellBookSkillLineTab1:GetRegions()),
                  select(1, SpellBookSkillLineTab2:GetRegions()), select(1, SpellBookSkillLineTab3:GetRegions()),
                  select(1, SpellBookSkillLineTab4:GetRegions()), select(1, SpellBookSkillLineTab5:GetRegions())}, true)
        mUI:Skin(SpellBookFrameTabButton1)
        mUI:Skin(SpellBookFrameTabButton2)
        mUI:Skin(SpellBookFrameTabButton3)
        mUI:Skin(SpellBookFrameTabButton4)
        mUI:Skin(SpellBookFrameTabButton5)

        -- Reset Icon Colors
        select(2, SpellBookSkillLineTab1:GetRegions()):SetVertexColor(1, 1, 1)
        select(2, SpellBookSkillLineTab2:GetRegions()):SetVertexColor(1, 1, 1)
        select(2, SpellBookSkillLineTab3:GetRegions()):SetVertexColor(1, 1, 1)
        select(2, SpellBookSkillLineTab4:GetRegions()):SetVertexColor(1, 1, 1)
        select(2, SpellBookSkillLineTab5:GetRegions()):SetVertexColor(1, 1, 1)
    end
end

function Theme:TimeManager()
    -- Time Manager
    if TimeManagerFrame then
        -- Blacklist Frames
        Theme.blacklist[select(18, TimeManagerFrame:GetRegions())] = true

        mUI:Skin(TimeManagerFrame)
        mUI:Skin(TimeManagerFrame.NineSlice)
        mUI:Skin(TimeManagerFrameInset)
        mUI:Skin(TimeManagerFrameInset.NineSlice)
        mUI:Skin(TimeManagerClockButton)
        mUI:Skin({StopwatchFrameBackgroundLeft, select(2, StopwatchFrame:GetRegions())}, true)
    end
end

function Theme:Actionbars()
    -- Actionbars
    mUI:Skin(MainMenuBarArtFrame)
    mUI:Skin(ActionBarUpButton)
    mUI:Skin(ActionBarDownButton)
    mUI:Skin(OverrideActionBarPitchFrame)
    mUI:Skin(OverrideActionBarExpBar)
    mUI:Skin(StanceBarFrame)
    mUI:Skin(PetActionBarFrame)
    mUI:Skin({OverrideActionBarHealthBarOverlay, OverrideActionBarPowerBarOverlay, MainMenuXPBarTexture0,
              MainMenuXPBarTexture1, MainMenuXPBarTexture2, MainMenuXPBarTexture3, ExhaustionTickNormal,
              ExhaustionTickHighlight}, true)
    mUI:Skin(OverrideActionBar)
    mUI:Skin({OverrideActionBarLeaveFrameDivider3}, true)
    mUI:Skin({MainStatusTrackingBarContainer.MainMenuBarFrameTexture1,
              MainStatusTrackingBarContainer.MainMenuBarFrameTexture2,
              MainStatusTrackingBarContainer.MainMenuBarFrameTexture3,
              MainStatusTrackingBarContainer.MainMenuBarFrameTexture4,
              MainStatusTrackingBarContainer.MainMenuBarFrameTexture5,
              MainStatusTrackingBarContainer.StandaloneFrameTexture1,
              MainStatusTrackingBarContainer.StandaloneFrameTexture2,
              MainStatusTrackingBarContainer.StandaloneFrameTexture3,
              MainStatusTrackingBarContainer.StandaloneFrameTexture4,
              MainStatusTrackingBarContainer.StandaloneFrameTexture5}, true)

    -- Actionbars
    for j = 1, #Theme.Bars do
        local Bar = Theme.Bars[j]
        local Num
        if Bar then
            Num = 12
            Theme:StyleAction(Bar, Num)
        end
    end

    for i = 1, 12 do
        local Button = _G["ActionButton" .. i]

        if C_AddOns.IsAddOnLoaded("Masque") and C_AddOns.IsAddOnLoaded("MasqueBlizzBars") then
            return
        end
        Theme:StyleButton(Button, "Actionbar")
    end

    for i = 1, 10 do
        local StanceButton = _G["StanceButton" .. i]
        local PetButton = _G["PetActionButton" .. i]

        Theme:StyleButton(StanceButton, "StanceOrPet")
        Theme:StyleButton(PetButton, "StanceOrPet")
    end

    if C_AddOns.IsAddOnLoaded("Dominos") then
        if C_AddOns.IsAddOnLoaded("Masque") then
            return
        end
        for i = 1, 140 do
            local ActionButton = _G["DominosActionButton" .. i]
            if ActionButton then
                Theme:StyleButton(ActionButton)
            end
        end

        for i = 1, 10 do
            local PetButton = _G["DominosPetActionButton" .. i]
            local StanceButton = _G["DominosStanceButton" .. i]

            if PetButton then
                Theme:StyleButton(PetButton)
            end

            if StanceButton then
                Theme:StyleButton(StanceButton)
            end
        end
    end

    if C_AddOns.IsAddOnLoaded("Bartender4") then
        if C_AddOns.IsAddOnLoaded("Masque") then
            return
        end
        for i = 1, 180 do
            local ActionButton = _G["BT4Button" .. i]
            if ActionButton then
                Theme:StyleButton(ActionButton)
            end
        end

        for i = 1, 10 do
            local PetButton = _G["BT4PetButton" .. i]
            local StanceButton = _G["BT4StanceButton" .. i]

            if PetButton then
                Theme:StyleButton(PetButton, "StanceOrPet")
            end

            if StanceButton then
                Theme:StyleButton(StanceButton, "StanceOrPet")
            end
        end
    end
end

function Theme:AddonList()
    -- AddOn List
    mUI:Skin(AddonList.NineSlice)
    mUI:Skin(AddonList)
    mUI:Skin(AddonListInset)
    mUI:Skin(AddonListInset.NineSlice)
    mUI:Skin({AddonListBg, AddonListScrollFrameScrollBarTop, AddonListScrollFrameScrollBarMiddle,
              AddonListScrollFrameScrollBarBottom}, true)
end

function Theme:Bags()
    -- Bags
    mUI:Skin(BackpackTokenFrame)
    mUI:Skin({ContainerFrame1BackgroundBottom}, true)
    mUI:Skin(ContainerFrame1)
    mUI:Skin(ContainerFrame2)
    mUI:Skin(ContainerFrame3)
    mUI:Skin(ContainerFrame4)
    mUI:Skin(ContainerFrame5)
    mUI:Skin(ContainerFrame6)
    mUI:Skin(ContainerFrame7)
    mUI:Skin(ContainerFrame8)
    mUI:Skin(ContainerFrame9)
    mUI:Skin(ContainerFrame10)
    mUI:Skin(ContainerFrame11)
    mUI:Skin(ContainerFrame12)
    mUI:Skin(ContainerFrame13)

    MainMenuBarBackpackButtonNormalTexture.SetVertexColor = Theme.bagsbackup
    CharacterBag0SlotNormalTexture.SetVertexColor = Theme.bagsbackup
    CharacterBag1SlotNormalTexture.SetVertexColor = Theme.bagsbackup
    CharacterBag2SlotNormalTexture.SetVertexColor = Theme.bagsbackup
    CharacterBag3SlotNormalTexture.SetVertexColor = Theme.bagsbackup

    mUI:Skin({MainMenuBarBackpackButtonNormalTexture, CharacterBag0SlotNormalTexture, CharacterBag1SlotNormalTexture,
              CharacterBag2SlotNormalTexture, CharacterBag3SlotNormalTexture}, true)

    MainMenuBarBackpackButtonNormalTexture.SetVertexColor = function()
    end
    CharacterBag0SlotNormalTexture.SetVertexColor = function()
    end
    CharacterBag1SlotNormalTexture.SetVertexColor = function()
    end
    CharacterBag2SlotNormalTexture.SetVertexColor = function()
    end
    CharacterBag3SlotNormalTexture.SetVertexColor = function()
    end

    C_Timer.After(0.1, function()
        MainMenuBarBackpackButtonCount:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    end)
end

function Theme:Bank()
    -- Bank
    -- Blacklist Frames
    Theme.blacklist["BankPortraitTexture"] = true
    mUI:Skin(BankFrame)
    mUI:Skin(BankFrame.NineSlice)
    mUI:Skin(BankSlotsFrame.NineSlice)
    mUI:Skin(BankFrameMoneyFrameBorder)
end

function Theme:Character()
    -- Character Frame
    mUI:Skin(PaperDollFrame)
    mUI:Skin(PetPaperDollFrame)
    mUI:Skin(CharacterFrame.NineSlice)
    mUI:Skin(TokenFramePopup)
    mUI:Skin(TokenFramePopup.Border)
    mUI:Skin(CharacterStatsPane)
    mUI:Skin(ReputationFrame)
    mUI:Skin(ReputationListScrollFrame)
    mUI:Skin(ReputationDetailFrame)
    mUI:Skin(ReputationDetailFrame.Border)
    mUI:Skin(SkillFrame)
    mUI:Skin(SkillListScrollFrame)
    mUI:Skin(SkillDetailScrollFrame)
    mUI:Skin({PetPaperDollXPBar1, select(2, PetPaperDollFrameExpBar:GetRegions())}, true)
    mUI:Skin(CharacterFrameTab1)
    mUI:Skin(CharacterFrameTab2)
    mUI:Skin(CharacterFrameTab3)
    mUI:Skin(CharacterFrameTab4)
    mUI:Skin(CharacterFrameTab5)
    mUI:Skin(PVPFrame)

    mUI:Skin({CharacterFeetSlotFrame, CharacterHandsSlotFrame, CharacterWaistSlotFrame, CharacterLegsSlotFrame,
              CharacterFinger0SlotFrame, CharacterFinger1SlotFrame, CharacterTrinket0SlotFrame,
              CharacterTrinket1SlotFrame, CharacterWristSlotFrame, CharacterTabardSlotFrame, CharacterShirtSlotFrame,
              CharacterChestSlotFrame, CharacterBackSlotFrame, CharacterShoulderSlotFrame, CharacterNeckSlotFrame,
              CharacterHeadSlotFrame, CharacterMainHandSlotFrame, CharacterSecondaryHandSlotFrame,
              _G.select(CharacterMainHandSlot:GetNumRegions(), CharacterMainHandSlot:GetRegions()),
              _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions()),
              PaperDollInnerBorderLeft, PaperDollInnerBorderRight, PaperDollInnerBorderTop, PaperDollInnerBorderTopLeft,
              PaperDollInnerBorderTopRight, PaperDollInnerBorderBottom, PaperDollInnerBorderBottomLeft,
              PaperDollInnerBorderBottomRight, PaperDollInnerBorderBottom2}, true)

    C_Timer.After(0.1, function()
        select(4, PetPaperDollFrameExpBar:GetRegions()):SetVertexColor(0.58, 0, 0.55) -- Reset Background Color
        select(4, PetPaperDollFrameExpBar:GetRegions()):SetDesaturated(false)
    end)

end

function Theme:Chat()
    -- Chat
    mUI:Skin(ChatFrame1EditBox)
    mUI:Skin(ChatFrame2EditBox)
    mUI:Skin(ChatFrame3EditBox)
    mUI:Skin(ChatFrame4EditBox)
    mUI:Skin(ChatFrame5EditBox)
    mUI:Skin(ChatFrame6EditBox)
    mUI:Skin(ChatFrame7EditBox)
    mUI:Skin(ChannelFrame)
    mUI:Skin(ChannelFrame.NineSlice)
    mUI:Skin(ChannelFrame.LeftInset.NineSlice)
    mUI:Skin(ChannelFrame.RightInset.NineSlice)
    mUI:Skin(ChannelFrameInset.NineSlice)
    mUI:Skin(ChatConfigFrame)
    mUI:Skin(ChatConfigFrame.Header)
    mUI:Skin(ChatConfigFrame.Border)
    mUI:Skin(ChatConfigBackgroundFrame)
    mUI:Skin(ChatConfigBackgroundFrame.NineSlice)
    mUI:Skin(ChatConfigCategoryFrame)
    mUI:Skin(ChatConfigCategoryFrame.NineSlice)
end

function Theme:Communities()
    -- Community Frame
    mUI:Skin(CommunitiesFrame)
    mUI:Skin(CommunitiesFrame.GuildMemberDetailFrame)
    mUI:Skin(CommunitiesFrame.GuildMemberDetailFrame.Border)
    mUI:Skin(CommunitiesFrame.ChatEditBox)
    mUI:Skin(CommunitiesFrame.Chat.InsetFrame)
    mUI:Skin(CommunitiesFrame.Chat.InsetFrame.NineSlice)
    mUI:Skin(CommunitiesFrame.MemberList.InsetFrame)
    mUI:Skin(CommunitiesFrame.MemberList.InsetFrame.NineSlice)
    mUI:Skin(CommunitiesFrame.NineSlice)
    mUI:Skin(CommunitiesFrame.MemberList.ColumnDisplay)
    mUI:Skin(CommunitiesFrame.ChatTab)
    mUI:Skin(CommunitiesFrame.RosterTab)
    mUI:Skin(CommunitiesFrame.GuildBenefitsTab)
    mUI:Skin(CommunitiesFrame.GuildInfoTab)
    mUI:Skin(CommunitiesFrameInset)
    mUI:Skin(CommunitiesFrameInset.NineSlice)
    mUI:Skin(CommunitiesFrameCommunitiesList)
    mUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame)
    mUI:Skin(CommunitiesFrameCommunitiesList.InsetFrame.NineSlice)
    mUI:Skin(CommunitiesFrameGuildDetailsFrame)
    mUI:Skin(CommunitiesFrameGuildDetailsFrameInfo)
    mUI:Skin(CommunitiesFrameGuildDetailsFrameNews)
    mUI:Skin(CommunitiesFrame.GuildBenefitsFrame.Perks)
    mUI:Skin(CommunitiesFrame.GuildBenefitsFrame.Rewards)
    mUI:Skin(CommunitiesFrame.GuildBenefitsFrame)
    mUI:Skin(CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar)
    mUI:Skin(CommunitiesFrame.RecruitmentDialog.BG)
    mUI:Skin(CommunitiesGuildLogFrame)
    mUI:Skin(CommunitiesGuildLogFrame.Container.NineSlice)
    mUI:Skin(ClubFinderGuildFinderFrame.InsetFrame)
    mUI:Skin(ClubFinderGuildFinderFrame.InsetFrame.NineSlice)
    mUI:Skin(ClubFinderGuildFinderFrame.ClubFinderSearchTab)
    mUI:Skin(ClubFinderGuildFinderFrame.ClubFinderPendingTab)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame.NineSlice)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.ClubFinderSearchTab)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab)
    mUI:Skin({CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
              CommunitiesFrameCommunitiesListListScrollFrameTop, CommunitiesFrameCommunitiesListListScrollFrameMiddle,
              CommunitiesFrameCommunitiesListListScrollFrameBottom}, true)
end

function Theme:DressUp()
    -- Dressup Frame
    mUI:Skin(DressUpFrame)
    mUI:Skin(DressUpFrame.NineSlice)
    mUI:Skin(DressUpFrame.OutfitDetailsPanel)
    mUI:Skin(DressUpFrameInset)
    mUI:Skin(DressUpFrameInset.NineSlice)
end

function Theme:Friendlist()
    -- Friendlist
    mUI:Skin(AddFriendEntryFrame)
    mUI:Skin(AddFriendFrame.Border)
    mUI:Skin(FriendsFrame)
    mUI:Skin(FriendsFrame.NineSlice)
    mUI:Skin(FriendsFrameInset)
    mUI:Skin(FriendsFrameInset.NineSlice)
    mUI:Skin(FriendsFriendsFrame)
    mUI:Skin(FriendsFriendsFrame.Border)
    mUI:Skin(FriendsFrameFriendsScrollFrame)
    mUI:Skin(WhoListScrollFrame)
    mUI:Skin(WhoFrameListInset)
    mUI:Skin(WhoFrameListInset.NineSlice)
    mUI:Skin(WhoFrameColumnHeader1)
    mUI:Skin(WhoFrameColumnHeader3)
    mUI:Skin(WhoFrameColumnHeader4)
    mUI:Skin(FriendsFrameBattlenetFrame.BroadcastFrame)
    mUI:Skin(FriendsFrameBattlenetFrame.BroadcastFrame.Border)
    mUI:Skin(FriendsTabHeaderTab1)
    mUI:Skin(FriendsTabHeaderTab2)
    mUI:Skin(FriendsTabHeaderTab3)
    mUI:Skin(FriendsFrameTab1)
    mUI:Skin(FriendsFrameTab2)
    mUI:Skin(FriendsFrameTab3)
    mUI:Skin(FriendsFrameTab4)
    mUI:Skin(RaidInfoFrame)
    mUI:Skin(RaidInfoFrame.Header)
    mUI:Skin(RaidInfoFrame.Border)
    mUI:Skin(FriendsTooltip.NineSlice)
end

function Theme:Guild()
    -- Guild
    mUI:Skin(GuildRegistrarFrame)
    mUI:Skin(GuildRegistrarFrame.NineSlice)
    mUI:Skin(GuildRegistrarFrameInset)
    mUI:Skin(GuildRegistrarFrameInset.NineSlice)
    mUI:Skin(TabardFrame)
    mUI:Skin(TabardFrame.NineSlice)
    mUI:Skin(TabardFrameInset)
    mUI:Skin(TabardFrameInset.NineSlice)
    mUI:Skin(TabardFrameMoneyBg)
    mUI:Skin(TabardFrameMoneyInset)
    mUI:Skin(TabardFrameMoneyInset.NineSlice)

    select(3, GuildRegistrarButton1:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(3, GuildRegistrarButton2:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(1, GuildRegistrarGreetingFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(1, GuildRegistrarPurchaseFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
end

function Theme:Gossip()
    -- Gossip
    mUI:Skin(GossipFrame)
    mUI:Skin(GossipFrame.NineSlice)
    mUI:Skin(GossipFrameInset)
    mUI:Skin(GossipFrameInset.NineSlice)
    mUI:Skin(GossipFrame.GreetingPanel.ScrollBar.Background)
end

function Theme:Item()
    -- Item
    mUI:Skin(ItemTextFrame)
    mUI:Skin(ItemTextFrame.NineSlice)
    mUI:Skin(ItemTextScrollFrame)
    mUI:Skin(ItemTextFrameInset)
    mUI:Skin(ItemTextFrameInset.NineSlice)
end

function Theme:Loot()
    -- Loot
    mUI:Skin(LootFrame)
    mUI:Skin(LootFrame.NineSlice)
    mUI:Skin(LootFrameInset)
    mUI:Skin(LootFrameInset.NineSlice)
    mUI:Skin(GroupLootFrame1)
    mUI:Skin(GroupLootFrame2)
    mUI:Skin(GroupLootFrame3)
    mUI:Skin(GroupLootFrame4)

    if not Theme:IsHooked("LootFrame_OnShow") then
        Theme:SecureHook("LootFrame_OnShow", function(frame)
            GroupLootFrame1:SetBackdropColor(unpack(mUI:Color(0.15)))
            GroupLootFrame1:SetBackdropBorderColor(unpack(mUI:Color(0.15)))

            GroupLootFrame2:SetBackdropColor(unpack(mUI:Color(0.15)))
            GroupLootFrame2:SetBackdropBorderColor(unpack(mUI:Color(0.15)))

            GroupLootFrame3:SetBackdropColor(unpack(mUI:Color(0.15)))
            GroupLootFrame3:SetBackdropBorderColor(unpack(mUI:Color(0.15)))

            GroupLootFrame4:SetBackdropColor(unpack(mUI:Color(0.15)))
            GroupLootFrame4:SetBackdropBorderColor(unpack(mUI:Color(0.15)))
        end)
    end
end

function Theme:Mail()
    -- Mail
    mUI:Skin(MailFrame)
    mUI:Skin(MailFrame.NineSlice)
    mUI:Skin(OpenMailFrame)
    mUI:Skin(OpenMailFrame.NineSlice)
    mUI:Skin(MailFrameInset)
    mUI:Skin(MailFrameInset.NineSlice)
    mUI:Skin(MailEditBoxScrollBar.Background)
    mUI:Skin(OpenMailScrollFrame)
    mUI:Skin(OpenMailFrameInset)
    mUI:Skin(OpenMailFrameInset.NineSlice)
    mUI:Skin(SendMailMoneyInset)
    mUI:Skin(SendMailMoneyInset.NineSlice)
    mUI:Skin(SendMailMoneyBg)
    mUI:Skin(SendMailFrame)
    mUI:Skin(MailFrameTab1)
    mUI:Skin(MailFrameTab2)
end

function Theme:Merchant()
    -- Merchant
    mUI:Skin(MerchantFrame)
    mUI:Skin(MerchantFrame.NineSlice)
    mUI:Skin(MerchantFrameInset)
    mUI:Skin(MerchantFrameInset.NineSlice)
    mUI:Skin(StackSplitFrame)
    mUI:Skin(MerchantMoneyBg)
    mUI:Skin(MerchantMoneyInset)
    mUI:Skin(MerchantMoneyInset.NineSlice)
    mUI:Skin(MerchantFrameTab1)
    mUI:Skin(MerchantFrameTab2)
    mUI:Skin(MerchantGuildBankRepairButton)
    mUI:Skin(MerchantSellAllJunkButton)
    mUI:Skin({MerchantBuyBackItemSlotTexture}, true)
end

function Theme:Map()
    -- Map
    mUI:Skin(WorldMapFrame)
    mUI:Skin(WorldMapFrame.MiniBorderFrame)
    mUI:Skin(MinimapZoomIn)
    mUI:Skin(MinimapZoomOut)

    -- Minimap
    mUI:Skin({MinimapBorder, MiniMapTrackingButtonBorder, MiniMapMailBorder, MiniMapLFGFrameBorder}, true)
end

function Theme:Reforging()
    -- Reforging
    if ReforgingFrame then
        mUI:Skin(ReforgingFrame)
        mUI:Skin(ReforgingFrame.NineSlice)
        mUI:Skin(ReforgingFrameButtonFrame)

        ReforgingFrameRestoreButton_LeftSeparator:Hide()
        ReforgingFrameRestoreButton_RightSeparator:Hide()
    end
end

function Theme:ItemUpgrade()
    -- Item Upgrade
    if ItemUpgradeFrame then
        mUI:Skin(ItemUpgradeFrame)
        mUI:Skin(ItemUpgradeFrame.NineSlice)
        mUI:Skin(ItemUpgradeFramePlayerCurrenciesBorder)
        mUI:Skin(ItemUpgradeFrameLeftItemPreviewFrame.NineSlice)
        mUI:Skin(ItemUpgradeFrameRightItemPreviewFrame.NineSlice)
        mUI:Skin({ItemUpgradeFrame.UpgradeItemButton.ButtonFrame}, true)
    end
end

function Theme:Petition()
    -- Petition
    mUI:Skin(PetitionFrame)
    mUI:Skin(PetitionFrame.NineSlice)
    mUI:Skin(PetitionFrameInset)
    mUI:Skin(PetitionFrameInset.NineSlice)
    PetitionFrameCharterTitle:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameCharterName:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMasterTitle:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMasterName:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMemberTitle:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMemberName1:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMemberName2:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMemberName3:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameMemberName4:SetTextColor(0.9, 0.9, 0.9)
    PetitionFrameInstructions:SetTextColor(0.9, 0.9, 0.9)
end

function Theme:Quest()
    -- Quest
    mUI:Skin(QuestFrame)
    mUI:Skin(QuestFrame.NineSlice)
    mUI:Skin(QuestFrameInset)
    mUI:Skin(QuestFrameInset.NineSlice)
    mUI:Skin(QuestLogFrame)
    mUI:Skin(QuestLogFrame.NineSlice)
    mUI:Skin(QuestLogListScrollFrame)
    mUI:Skin(QuestRewardScrollFrame)
    mUI:Skin(QuestDetailScrollFrame)
    mUI:Skin(QuestProgressScrollFrame)
    mUI:Skin(QuestModelScene)
    mUI:Skin({QuestNPCModelTopBorder, QuestNPCModelRightBorder, QuestNPCModelTopRightCorner,
              QuestNPCModelBottomRightCorner, QuestNPCModelBottomBorder, QuestNPCModelBottomLeftCorner,
              QuestNPCModelLeftBorder, QuestNPCModelTopLeftCorner, QuestNPCModelTextTopBorder,
              QuestNPCModelTextRightBorder, QuestNPCModelTextTopRightCorner, QuestNPCModelTextBottomRightCorner,
              QuestNPCModelTextBottomBorder, QuestNPCModelTextBottomLeftCorner, QuestNPCModelTextLeftBorder,
              QuestNPCModelTextTopLeftCorner}, true)

    QuestLogQuestTitle:SetTextColor(1, 0.875, 0.25)
    QuestLogDescriptionTitle:SetTextColor(1, 0.875, 0.25)
    QuestLogObjectivesText:SetTextColor(0.8, 0.8, 0.8)
    QuestLogQuestDescription:SetTextColor(0.8, 0.8, 0.8)
    QuestLogRequiredMoneyText:SetTextColor(0.8, 0.8, 0.8)
    QuestLogRewardTitleText:SetTextColor(0.8, 0.8, 0.8, 1)
    QuestLogSpellLearnText:SetTextColor(0.8, 0.8, 0.8)
    QuestLogTimerText:SetTextColor(0.8, 0.8, 0.8)

    QuestLogItemChooseText.STC = QuestLogItemChooseText.SetTextColor
    QuestLogItemChooseText.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(0.8, 0.8, 0.8)
        end
    end

    QuestLogRewardTitleText.STC = QuestLogRewardTitleText.SetTextColor
    QuestLogRewardTitleText.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.875, 0.25)
        end
    end

    QuestLogItemReceiveText.STC = QuestLogItemReceiveText.SetTextColor
    QuestLogItemReceiveText.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(0.8, 0.8, 0.8)
        end
    end

    QuestLogObjective1.STC = QuestLogObjective1.SetTextColor
    QuestLogObjective1.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective2.STC = QuestLogObjective2.SetTextColor
    QuestLogObjective2.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective3.STC = QuestLogObjective3.SetTextColor
    QuestLogObjective3.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective4.STC = QuestLogObjective4.SetTextColor
    QuestLogObjective4.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective5.STC = QuestLogObjective5.SetTextColor
    QuestLogObjective5.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective6.STC = QuestLogObjective6.SetTextColor
    QuestLogObjective6.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective7.STC = QuestLogObjective7.SetTextColor
    QuestLogObjective7.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective8.STC = QuestLogObjective8.SetTextColor
    QuestLogObjective8.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective9.STC = QuestLogObjective9.SetTextColor
    QuestLogObjective9.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end

    QuestLogObjective10.STC = QuestLogObjective10.SetTextColor
    QuestLogObjective10.SetTextColor = function(self)
        if not self.STCUpdated then
            self.STCUpdated = true
            self:STC(1, 0.95, 0.75)
        end
    end
end

function Theme:Settings()
    -- Settings Panel
    mUI:Skin(SettingsPanel)
    mUI:Skin(SettingsPanel.Bg)
    mUI:Skin(SettingsPanel.NineSlice)
    mUI:Skin(SettingsPanel.GameTab)
    mUI:Skin(SettingsPanel.AddOnsTab)
end

function Theme:Raidframe()
    -- Raidframe
    mUI:Skin(CompactRaidFrameManager)
    mUI:Skin(CompactPartyFrameBorderFrame)
    mUI:Skin(CompactRaidFrameContainerBorderFrame)

    for i = 1, 40 do
        mUI:Skin({_G["CompactRaidFrame" .. i .. "HorizDivider"], _G["CompactPartyFrameMember" .. i .. "HorizDivider"]},
            true)
    end
end

function Theme:Trade()
    -- Trade
    mUI:Skin(TradeFrame)
    mUI:Skin(TradeFrame.NineSlice)
    mUI:Skin(TradeFrame.RecipientOverlay)
    mUI:Skin(TradeFrameInset.NineSlice)
    mUI:Skin(TradePlayerEnchantInset)
    mUI:Skin(TradePlayerEnchantInset.NineSlice)
    mUI:Skin(TradePlayerItemsInset.NineSlice)
    mUI:Skin(TradeRecipientItemsInset.NineSlice)
    mUI:Skin(TradeRecipientMoneyBg)
    mUI:Skin(TradeRecipientMoneyInset.NineSlice)
    mUI:Skin(TradeRecipientEnchantInset)
    mUI:Skin(TradeRecipientEnchantInset.NineSlice)
end

function Theme:Rewards()
    -- Weekly Rewards
    if WeeklyRewardsFrame then
        mUI:Skin(WeeklyRewardsFrame)
        mUI:Skin(WeeklyRewardsFrame.BorderContainer)
    end
end

function Theme:ClassBars()
    -- Class Bars
    if (playerClass == "WARLOCK") then
        Theme:ClassBar()
    elseif (playerClass == "MONK") then
        Theme:ClassBar()
    elseif (playerClass == "DEATHKNIGHT") then
        if (not Theme:IsHooked(RuneFrame, "OnUpdate")) then
            Theme:SecureHookScript(RuneFrame, "OnUpdate", Theme.ClassBar)
        end
    elseif (playerClass == "PALADIN") then
        Theme:ClassBar()
    elseif (playerClass == "PRIEST") then
        Theme:ClassBar()
    end

    if (playerClass == "SHAMAN" or playerClass == "PALADIN") or playerClass == "DRUID" then
        -- Totem Bar
        if (not Theme:IsHooked(TotemFrame, "OnUpdate")) then
            Theme:SecureHookScript(TotemFrame, "OnUpdate", function(frame)
                local borderFrame1 = select(2, TotemFrameTotem1:GetChildren())
                local borderFrame2 = select(2, TotemFrameTotem2:GetChildren())
                local borderFrame3 = select(2, TotemFrameTotem3:GetChildren())

                mUI:Skin(borderFrame1)
                mUI:Skin(borderFrame2)
                mUI:Skin(borderFrame3)
            end)
        end

        Theme:ClassBar()
    end
end

function Theme:Unitframes()
    -- Unitframes
    mUI:Skin({PlayerFrameTexture, PlayerFrameVehicleTexture, PetFrameTexture, TargetFrameTextureFrameTexture,
              FocusFrameTextureFrameTexture, Boss1TargetFrameTextureFrameTexture, Boss2TargetFrameTextureFrameTexture,
              Boss3TargetFrameTextureFrameTexture, Boss4TargetFrameTextureFrameTexture,
              Boss5TargetFrameTextureFrameTexture, TargetFrameToTTextureFrameTexture, FocusFrameToTTextureFrameTexture},
        true)
    mUI:Skin({PartyFrame.MemberFrame1.PartyMemberOverlay.Texture, PartyFrame.MemberFrame2.PartyMemberOverlay.Texture,
              PartyFrame.MemberFrame3.PartyMemberOverlay.Texture, PartyFrame.MemberFrame4.PartyMemberOverlay.Texture},
        true)
    mUI:Skin(PlayerFrameAlternateManaBar)
    mUI:Skin(PlayerFrameGroupIndicator)
end

function Theme:Castbars()
    -- Castbars
    mUI:Skin({PlayerCastingBarFrame.Border, TargetFrameSpellBar.Border, TargetFrameSpellBar.BorderShield,
              FocusFrameSpellBar.Border, FocusFrameSpellBar.BorderShield, Boss1TargetFrameSpellBar.Border,
              Boss1TargetFrameSpellBar.BorderShield, Boss2TargetFrameSpellBar.Border,
              Boss2TargetFrameSpellBar.BorderShield, Boss3TargetFrameSpellBar.Border,
              Boss3TargetFrameSpellBar.BorderShield, Boss4TargetFrameSpellBar.Border,
              Boss4TargetFrameSpellBar.BorderShield, Boss5TargetFrameSpellBar.Border,
              Boss5TargetFrameSpellBar.BorderShield}, true)

    -- Castbar Icon Skinning
    for castbar in pairs(Theme.castbarIcons) do
        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.15)))
    end
end

function Theme:Auras()
    -- Aura Skinning
    for button, type in pairs(Theme.aurabuttons) do
        if type == "playerbuff" or type == "unitframebuff" then
            button.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
        end
    end
end

function Theme:ExpansionLandingPage()
    if not Theme:IsHooked(ExpansionLandingPage, "OnShow") then
        Theme:SecureHookScript(ExpansionLandingPage, "OnShow", function()
            if ExpansionLandingPage.Overlay.WarWithinLandingOverlay then
                mUI:Skin(ExpansionLandingPage.Overlay.WarWithinLandingOverlay.Border)
                mUI:Skin(ExpansionLandingPage.Overlay.WarWithinLandingOverlay.ScrollFadeOverlay)
                mUI:Skin(ExpansionLandingPage.Overlay.WarWithinLandingOverlay)
            end
        end)
    end
end

function Theme:GameMenu(frame)
    C_Timer.After(0, function()
        for _, button in pairs(frame:GetLayoutChildren()) do
            if mUI.db.profile.misc.skinmenu then
                button.Left:SetDesaturated(true)
                button.Middle:SetDesaturated(true)
                button.Right:SetDesaturated(true)
                button.Left:SetVertexColor(unpack(mUI:Color(0.15)))
                button.Middle:SetVertexColor(unpack(mUI:Color(0.15)))
                button.Right:SetVertexColor(unpack(mUI:Color(0.15)))
            else
                button.Left:SetDesaturated(false)
                button.Middle:SetDesaturated(false)
                button.Right:SetDesaturated(false)
                button.Left:SetVertexColor(1, 1, 1, 1)
                button.Middle:SetVertexColor(1, 1, 1, 1)
                button.Right:SetVertexColor(1, 1, 1, 1)
            end
        end
    end)
end

function Theme:Frames()
    -- Bnet Toast
    Theme.blacklist["BNToastFrameIconTexture"] = true
    mUI:Skin(BNToastFrame)

    -- Game Menu
    mUI:Skin(GameMenuFrame)
    mUI:Skin(GameMenuFrame.Header)
    mUI:Skin(GameMenuFrame.Border)

    -- StaticPopups
    mUI:Skin(StaticPopup1.BG)
    mUI:Skin(StaticPopup2.BG)
    mUI:Skin(StaticPopup3.BG)
    mUI:Skin(StaticPopup1EditBox.NineSlice)
    mUI:Skin(StaticPopup2EditBox.NineSlice)
    mUI:Skin(StaticPopup3EditBox.NineSlice)

    -- Vehicle Seat
    mUI:Skin(VehicleSeatIndicator)

    -- ReportFrame
    mUI:Skin(ReportFrame)
    mUI:Skin(ReportFrame.Border)

    -- LFG Ready/Invite Dialogs
    mUI:Skin(QueueStatusFrame)
    mUI:Skin(QueueStatusFrame.NineSlice)

    -- ReadyCheck
    mUI:Skin(ReadyCheckListenerFrame)
    mUI:Skin(ReadyCheckListenerFrame.NineSlice)

    -- Battletag Add Frame
    mUI:Skin(BattleTagInviteFrame)
    mUI:Skin(BattleTagInviteFrame.Border)

    -- EditMode
    mUI:Skin(EditModeManagerFrame)
    mUI:Skin(EditModeManagerFrame.Border)
    mUI:Skin(EditModeSystemSettingsDialog)
    mUI:Skin(EditModeSystemSettingsDialog.Border)

    -- DropDowns
    function MenuStyle1Mixin:Generate()
        local background = self:AttachTexture()
        background:SetAtlas("common-dropdown-classic-bg")
        background:SetPoint("TOPLEFT", -3, 3)
        background:SetPoint("BOTTOMRIGHT", 3, -4)
        background:SetVertexColor(unpack(mUI:Color(0.15)))

        local background2 = self:AttachTexture()
        background2:SetColorTexture(0, 0, 0, .8)
        background2:SetPoint("TOPLEFT", background, "TOPLEFT", 6, -6)
        background2:SetPoint("BOTTOMRIGHT", background, "BOTTOMRIGHT", -6, 6)
        local layer, subLevel = background:GetDrawLayer()
        background2:SetDrawLayer(layer, subLevel - 1)
    end

    function MenuStyle2Mixin:Generate()
        local background = self:AttachTexture()
        background:SetAtlas("common-dropdown-classic-b-bg")
        background:SetPoint("TOPLEFT", -3, 1)
        background:SetPoint("BOTTOMRIGHT", 3, -4)
        background:SetVertexColor(unpack(mUI:Color(0.15)))

        local background2 = self:AttachTexture()
        background2:SetColorTexture(0, 0, 0, .8)
        background2:SetPoint("TOPLEFT", background, "TOPLEFT", 7, -4)
        background2:SetPoint("BOTTOMRIGHT", background, "BOTTOMRIGHT", -8, 8)
        local layer, subLevel = background:GetDrawLayer()
        background2:SetDrawLayer(layer, subLevel - 1)
    end
end

function Theme:Update()
    Theme:Achievements()
    Theme:AuctionHouse()
    Theme:Archaeology()
    Theme:Calendar()
    Theme:Challenges()
    Theme:Socketing()
    Theme:Trainer()
    Theme:Collections()
    Theme:EncounterJournal()
    Theme:FlightMap()
    Theme:Garrison()
    Theme:Inspect()
    Theme:GuildBank()
    Theme:Professions()
    Theme:Islands()
    Theme:PVP()
    Theme:Macros()
    Theme:Scrapping()
    Theme:Spellbook()
    Theme:TimeManager()
    Theme:Actionbars()
    Theme:AddonList()
    Theme:Bags()
    Theme:Bank()
    Theme:Character()
    Theme:Chat()
    Theme:Communities()
    Theme:DressUp()
    Theme:Friendlist()
    Theme:Guild()
    Theme:Gossip()
    Theme:Item()
    Theme:Loot()
    Theme:Mail()
    Theme:Merchant()
    Theme:Map()
    Theme:Reforging()
    Theme:ItemUpgrade()
    Theme:Petition()
    Theme:Quest()
    Theme:Settings()
    Theme:Raidframe()
    Theme:Trade()
    Theme:Rewards()
    Theme:Unitframes()
    Theme:Castbars()
    Theme:Auras()
    Theme:Frames()

    -- Tooltips
    for _, tooltip in next, Theme.tooltips do
        Theme:StyleTooltip(tooltip)
    end
end
