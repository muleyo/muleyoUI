local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
-- Theme Function
function Theme:Update()
    -- Aura Skinning
    for button, type in pairs(Theme.aurabuttons) do
        if Theme.db.theme == "Disabled" then
            button.mUIBorder:Hide()
            if button.DebuffBorder then
                button.DebuffBorder:SetAlpha(1)
            end
            if button.Border then
                button.Border:SetAlpha(1)
            end
        else
            button.mUIBorder:Show()

            if type == "playerbuff" or type == "unitframebuff" then
                button.mUIBorder.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.15)))
            end

            if button.DebuffBorder then
                button.DebuffBorder:SetAlpha(0)
            end
            if button.Border then
                button.Border:SetAlpha(0)
            end
        end
    end

    -- Castbar Icon Skinning
    for castbar in pairs(Theme.castbarIcons) do
        if Theme.db.theme == "Disabled" then
            castbar.mUIBorder:Hide()
        else
            castbar.mUIBorder:Show()
            castbar.mUIBorder.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.15)))
        end
    end

    -- Achievements Frame
    mUI:Skin(AchievementFrame)
    mUI:Skin(AchievementFrame.Header)
    mUI:Skin(AchievementFrame.Searchbox)
    mUI:Skin(AchievementFrameSummary)
    mUI:Skin(AchievementFrameTab1)
    mUI:Skin(AchievementFrameTab2)
    mUI:Skin(AchievementFrameTab3)
    AchievementFrame.Header.PointBorder:SetAlpha(0)

    -- Crafting Orders
    mUI:Skin(ProfessionsCustomerOrdersFrame)
    mUI:Skin(ProfessionsCustomerOrdersFrame.NineSlice)
    mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList.NineSlice)
    mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.RecipeList.NineSlice)
    mUI:Skin(ProfessionsCustomerOrdersFrame.MyOrdersPage.OrderList.NineSlice)
    mUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameBorder)
    mUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameInset.NineSlice)
    mUI:Skin(ProfessionsCustomerOrdersFrameBrowseTab)
    mUI:Skin(ProfessionsCustomerOrdersFrameOrdersTab)

    -- Auction House
    mUI:Skin(AuctionHouseFrame)
    mUI:Skin(AuctionHouseFrame.NineSlice)
    mUI:Skin(AuctionHouseFrame.NineSlice)
    mUI:Skin(AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice)
    mUI:Skin(AuctionHouseFrame.BuyDialog)
    mUI:Skin(AuctionHouseFrame.BuyDialog.Border)
    mUI:Skin(AuctionHouseFrame.MoneyFrameBorder)
    mUI:Skin(AuctionHouseFrame.MoneyFrameInset.NineSlice)
    mUI:Skin(AuctionHouseFrame.CategoriesList)
    mUI:Skin(AuctionHouseFrame.SearchBar.FilterButton)
    mUI:Skin(AuctionHouseFrameBuyTab)
    mUI:Skin(AuctionHouseFrameSellTab)
    mUI:Skin(AuctionHouseFrameAuctionsTab)
    mUI:Skin(AuctionHouseFrameAuctionsFrameAuctionsTab)
    mUI:Skin(AuctionHouseFrameAuctionsFrameBidsTab)

    -- Allied Races
    mUI:Skin(AlliedRacesFrame)
    mUI:Skin(AlliedRacesFrame.NineSlice)
    mUI:Skin(AlliedRacesFrameInset.NineSlice)

    -- Archaeology Frame
    mUI:Skin(ArchaeologyFrame.NineSlice)

    -- Calendar
    mUI:Skin(CalendarFrame)
    mUI:Skin(CalendarFrame.FilterButton)
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
    mUI:Skin({
        CalendarCreateEventDivider,
        CalendarCreateEventFrameButtonBackground,
        CalendarCreateEventMassInviteButtonBorder,
        CalendarCreateEventCreateButtonBorder
    }, true)

    -- Challenges Frame
    mUI:Skin(ChallengesFrameInset.NineSlice)

    -- Socketing Frame
    mUI:Skin(ItemSocketingFrame)
    mUI:Skin(ItemSocketingFrame.NineSlice)

    -- Profession/Class Trainer
    mUI:Skin(ClassTrainerFrame)
    mUI:Skin(ClassTrainerFrame.NineSlice)
    mUI:Skin(ClassTrainerFrameBottomInset.NineSlice)
    mUI:Skin(ClassTrainerFrameInset.NineSlice)

    -- Collections Frame
    mUI:Skin(CollectionsJournal)
    mUI:Skin(CollectionsJournal.NineSlice)

    -- Mount Journal
    mUI:Skin(MountJournal)
    mUI:Skin(MountJournal.MountDisplay)
    mUI:Skin(MountJournal.LeftInset.NineSlice)
    mUI:Skin(MountJournal.BottomLeftInset)
    mUI:Skin(MountJournal.BottomLeftInset.NineSlice)
    mUI:Skin(MountJournal.RightInset.NineSlice)
    mUI:Skin(MountJournal.BottomLeftInset.SlotButton)
    mUI:Skin({
        MountJournal.ToggleDynamicFlightFlyoutButton.Border,
        MountJournalSummonRandomFavoriteButtonBorder
    }, true)

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
    mUI:Skin({
        PetJournalSummonRandomFavoritePetButtonBorder,
        PetJournalHealPetButtonBorder
    }, true)

    -- Wardrobe
    mUI:Skin(WardrobeCollectionFrame)
    mUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame)
    mUI:Skin(WardrobeCollectionFrame.ItemsCollectionFrame.NineSlice)
    mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame)
    mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset)
    mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.LeftInset.NineSlice)
    mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset)
    mUI:Skin(WardrobeCollectionFrame.SetsCollectionFrame.RightInset.NineSlice)
    mUI:Skin(WardrobeCollectionFrame.FilterButton)
    mUI:Skin(WardrobeCollectionFrame.SetsTransmogFrame)
    mUI:Skin(WardrobeFrame)
    mUI:Skin(WardrobeFrame.NineSlice)
    mUI:Skin(WardrobeTransmogFrame)
    mUI:Skin(WardrobeTransmogFrame.Inset)
    mUI:Skin(WardrobeTransmogFrame.Inset.NineSlice)
    WardrobeTransmogFrame.Inset.BG:SetVertexColor(1, 1, 1) -- Reset Background Color
    mUI:Skin({
        WardrobeCollectionFrameScrollFrameScrollBarBottom,
        WardrobeCollectionFrameScrollFrameScrollBarMiddle,
        WardrobeCollectionFrameScrollFrameScrollBarTop,
        WardrobeCollectionFrameScrollFrameScrollBarThumbTexture
    }, true)

    -- Specific Frames
    mUI:Skin({
        CollectionsJournalBg,
        MountJournalListScrollFrameScrollBarThumbTexture,
        MountJournalListScrollFrameScrollBarTop,
        MountJournalListScrollFrameScrollBarMiddle,
        MountJournalListScrollFrameScrollBarBottom,
        PetJournalListScrollFrameScrollBarThumbTexture,
        PetJournalListScrollFrameScrollBarTop,
        PetJournalListScrollFrameScrollBarMiddle,
        PetJournalListScrollFrameScrollBarBottom
    }, true)

    -- Tabs
    mUI:Skin(CollectionsJournalTab1)
    mUI:Skin(CollectionsJournalTab2)
    mUI:Skin(CollectionsJournalTab3)
    mUI:Skin(CollectionsJournalTab4)
    mUI:Skin(CollectionsJournalTab5)
    mUI:Skin(WardrobeCollectionFrameTab1)
    mUI:Skin(WardrobeCollectionFrameTab2)

    -- Encounter Journal
    mUI:Skin(EncounterJournal)
    mUI:Skin(EncounterJournal.NineSlice)
    mUI:Skin(EncounterJournalInset)
    mUI:Skin(EncounterJournalInset.NineSlice)
    mUI:Skin(EncounterJournalNavBar)
    mUI:Skin(EncounterJournalNavBar.overlay)
    mUI:Skin(EncounterJournalEncounterFrameInfo.LootContainer.filter)
    mUI:Skin(EncounterJournalEncounterFrameInfo.LootContainer.slotFilter)
    mUI:Skin(EncounterJournalEncounterFrameInfoDifficulty)
    mUI:Skin(EncounterJournalMonthlyActivitiesTab)
    mUI:Skin(EncounterJournalSuggestTab)
    mUI:Skin(EncounterJournalDungeonTab)
    mUI:Skin(EncounterJournalRaidTab)
    mUI:Skin(EncounterJournalLootJournalTab)

    -- Flightmap
    mUI:Skin(FlightMapFrame)
    mUI:Skin(FlightMapFrame.BorderFrame)
    mUI:Skin(FlightMapFrame.BorderFrame.NineSlice)

    -- Garrison
    mUI:Skin(GarrisonCapacitiveDisplayFrame)
    mUI:Skin(GarrisonCapacitiveDisplayFrame.NineSlice)
    mUI:Skin(GarrisonCapacitiveDisplayFrameInset)
    mUI:Skin(GarrisonCapacitiveDisplayFrameInset.NineSlice)

    -- Guild Bank
    mUI:Skin(GuildBankFrameTab1)
    mUI:Skin(GuildBankFrameTab2)
    mUI:Skin(GuildBankFrameTab3)
    mUI:Skin(GuildBankFrameTab4)
    mUI:Skin(GuildBankFrame)
    mUI:Skin({
        GuildBankFrameLeft,
        GuildBankFrameMiddle,
        GuildBankFrameRight
    }, true)
    mUI:Skin(GuildBankFrame.MoneyFrameBG)
    mUI:Skin(GuildBankFrame.Column1)
    mUI:Skin(GuildBankFrame.Column2)
    mUI:Skin(GuildBankFrame.Column3)
    mUI:Skin(GuildBankFrame.Column4)
    mUI:Skin(GuildBankFrame.Column5)
    mUI:Skin(GuildBankFrame.Column6)
    mUI:Skin(GuildBankFrame.Column7)

    -- Inspect Frame
    mUI:Skin(InspectFrame)
    mUI:Skin(InspectFrame.NineSlice)
    mUI:Skin(InspectFrameInset)
    mUI:Skin(InspectFrameInset.NineSlice)
    mUI:Skin(InspectPaperDollItemsFrame)
    mUI:Skin(InspectPaperDollItemsFrame.InspectTalents)
    mUI:Skin(InspectPVPFrame)
    mUI:Skin({
        InspectModelFrameBorderLeft,
        InspectModelFrameBorderRight,
        InspectModelFrameBorderTop,
        InspectModelFrameBorderTopLeft,
        InspectModelFrameBorderTopRight,
        InspectModelFrameBorderBottom,
        InspectModelFrameBorderBottomLeft,
        InspectModelFrameBorderBottomRight,
        InspectModelFrameBorderBottom2,
        InspectFeetSlotFrame,
        InspectHandsSlotFrame,
        InspectWaistSlotFrame,
        InspectLegsSlotFrame,
        InspectFinger0SlotFrame,
        InspectFinger1SlotFrame,
        InspectTrinket0SlotFrame,
        InspectTrinket1SlotFrame,
        InspectWristSlotFrame,
        InspectTabardSlotFrame,
        InspectShirtSlotFrame,
        InspectChestSlotFrame,
        InspectBackSlotFrame,
        InspectShoulderSlotFrame,
        InspectNeckSlotFrame,
        InspectHeadSlotFrame,
        InspectSecondaryHandSlotFrame,
    }, true)
    mUI:Skin(InspectFrameTab1)
    mUI:Skin(InspectFrameTab2)
    mUI:Skin(InspectFrameTab3)
    InspectMainHandSlotFrame:Hide()
    _G.select(InspectMainHandSlot:GetNumRegions(), InspectMainHandSlot:GetRegions()):Hide()
    _G.select(InspectSecondaryHandSlot:GetNumRegions(), InspectSecondaryHandSlot:GetRegions()):Hide()

    -- Professions
    mUI:Skin(InspectRecipeFrame)
    mUI:Skin(InspectRecipeFrame.NineSlice)
    mUI:Skin(ProfessionsFrame)
    mUI:Skin(ProfessionsFrame.NineSlice)
    mUI:Skin(ProfessionsFrame.SpecPage.PanelFooter)
    mUI:Skin(ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice)
    mUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.NineSlice)
    mUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.Details)
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.NineSlice)
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.BackgroundNineSlice)
    mUI:Skin({
        ProfessionsFrame.CraftingPage.RankBar.Border
    }, true)

    -- Tabs
    mUI:Skin(ProfessionsFrame.TabSystem.tabs[1])
    mUI:Skin(ProfessionsFrame.TabSystem.tabs[2])
    mUI:Skin(ProfessionsFrame.TabSystem.tabs[3])
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton)
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.GuildOrdersButton)
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton)
    mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton)

    -- Islands
    mUI:Skin(IslandsQueueFrame)
    mUI:Skin(IslandsQueueFrame.NineSlice)
    mUI:Skin(IslandsQueueFrame.ArtOverlayFrame)

    -- PVP UI
    mUI:Skin(PlunderstormFrame.Inset)
    mUI:Skin(PlunderstormFrame.Inset.NineSlice)
    mUI:Skin(HonorFrame)
    mUI:Skin(HonorFrame.ConquestFrame)
    mUI:Skin(HonorFrame.Inset)
    mUI:Skin(HonorFrame.Inset.NineSlice)
    mUI:Skin(HonorFrame.BonusFrame)
    mUI:Skin(ConquestFrame)
    mUI:Skin(ConquestFrame.ConquestBar)
    mUI:Skin(ConquestFrame.Inset)
    mUI:Skin(ConquestFrame.Inset.NineSlice)
    mUI:Skin(PVPQueueFrame)
    mUI:Skin(PVPQueueFrame.HonorInset)
    mUI:Skin(PVPQueueFrame.HonorInset.NineSlice)
    PVPQueueFrame.HonorInset:Hide()

    -- Macros
    mUI:Skin(MacroFrame)
    mUI:Skin(MacroFrame.NineSlice)
    mUI:Skin(MacroFrameInset)
    mUI:Skin(MacroFrameInset.NineSlice)
    mUI:Skin(MacroFrameTextBackground)
    mUI:Skin(MacroFrameTextBackground.NineSlice)
    mUI:Skin(MacroPopupFrame)
    mUI:Skin(MacroPopupFrame.BorderBox)
    mUI:Skin(MacroFrameTab1)
    mUI:Skin(MacroFrameTab2)
    mUI:Skin({
        MacroButtonScrollFrameTop,
        MacroButtonScrollFrameMiddle,
        MacroButtonScrollFrameBottom,
        MacroButtonScrollFrameScrollBarThumbTexture
    }, true)

    -- Scrapping Machine
    mUI:Skin(ScrappingMachineFrame)
    mUI:Skin(ScrappingMachineFrame.NineSlice)

    -- Professions Book
    mUI:Skin(ProfessionsBookFrame)
    mUI:Skin(ProfessionsBookFrame.NineSlice)
    mUI:Skin(ProfessionsBookFrameInset)
    mUI:Skin(ProfessionsBookFrameInset.NineSlice)
    mUI:Skin({
        ProfessionsBookPage1,
        ProfessionsBookPage2
    }, true)
    for i, v in pairs({
        SecondaryProfession1Missing,
        SecondaryProfession1.missingText,
        SecondaryProfession2Missing,
        SecondaryProfession2.missingText,
        SecondaryProfession3Missing,
        SecondaryProfession3.missingText,
    }) do
        v:SetVertexColor(0.8, 0.8, 0.8)
    end

    -- Spellbook / Talent Frame
    mUI:Skin(PlayerSpellsFrame)
    mUI:Skin(PlayerSpellsFrame.SpellBookFrame)
    mUI:Skin(PlayerSpellsFrame.NineSlice)

    -- Tabs
    mUI:Skin(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[1])
    mUI:Skin(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[2])
    mUI:Skin(PlayerSpellsFrame.SpellBookFrame.CategoryTabSystem.tabs[3])
    PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls.PageText:SetVertexColor(0.8, 0.8, 0.8)
    mUI:Skin(PlayerSpellsFrame)
    mUI:Skin(PlayerSpellsFrame.TalentsFrame)
    mUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer)
    mUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton)
    mUI:Skin(PlayerSpellsFrame.TalentsFrame.SearchBox)
    mUI:Skin(PlayerSpellsFrame.TalentsFrame.LoadSystem)
    mUI:Skin(HeroTalentsSelectionDialog)
    mUI:Skin(HeroTalentsSelectionDialog.NineSlice)
    mUI:Skin(PlayerSpellsFrame.TabSystem.tabs[1])
    mUI:Skin(PlayerSpellsFrame.TabSystem.tabs[2])
    mUI:Skin(PlayerSpellsFrame.TabSystem.tabs[3])
    mUI:Skin({
        ClassTalentFrameTitleBg,
        ClassTalentFrameBg,
        ClassTalentFrameTalentsPvpTalentFrameTalentListBg
    }, true)

    -- Time Manager
    mUI:Skin(TimeManagerFrame)
    mUI:Skin(TimeManagerFrame.NineSlice)
    mUI:Skin(TimeManagerFrameInset)
    mUI:Skin(TimeManagerFrameInset.NineSlice)
    mUI:Skin({ StopwatchFrameBackgroundLeft }, true)

    -- Actionbars
    mUI:Skin(MainMenuBar)
    mUI:Skin(MainMenuBar.EndCaps)
    mUI:Skin(MainMenuBar.ActionBarPageNumber.UpButton)
    mUI:Skin(MainMenuBar.ActionBarPageNumber.DownButton)
    MainMenuBar.ActionBarPageNumber.Text:SetVertexColor(unpack(mUI:Color(0.15)))
    mUI:Skin(StatusTrackingBarManager)
    mUI:Skin(StatusTrackingBarManager.BottomBarFrameTexture)
    mUI:Skin(StatusTrackingBarManager.MainStatusTrackingBarContainer)
    mUI:Skin(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer)

    -- AddOn List
    mUI:Skin(AddonList.NineSlice)
    mUI:Skin(AddonList)
    mUI:Skin(AddonListInset.NineSlice)
    mUI:Skin({ AddonListBg }, true)

    -- Bags
    mUI:Skin(ContainerFrameCombinedBags.NineSlice)
    mUI:Skin(ContainerFrameCombinedBags.Bg)
    mUI:Skin(ContainerFrameCombinedBags.MoneyFrame.Border)
    mUI:Skin(ContainerFrame1MoneyFrame.Border)
    mUI:Skin(BackpackTokenFrame.Border)
    mUI:Skin(ContainerFrame1.NineSlice)
    mUI:Skin(ContainerFrame1.Bg)
    mUI:Skin(ContainerFrame2.NineSlice)
    mUI:Skin(ContainerFrame2.Bg)
    mUI:Skin(ContainerFrame3.NineSlice)
    mUI:Skin(ContainerFrame3.Bg)
    mUI:Skin(ContainerFrame4.NineSlice)
    mUI:Skin(ContainerFrame4.Bg)
    mUI:Skin(ContainerFrame5.NineSlice)
    mUI:Skin(ContainerFrame5.Bg)
    mUI:Skin(ContainerFrame6.NineSlice)
    mUI:Skin(ContainerFrame6.Bg)
    mUI:Skin(ContainerFrame7.NineSlice)
    mUI:Skin(ContainerFrame7.Bg)
    mUI:Skin(ContainerFrame8.NineSlice)
    mUI:Skin(ContainerFrame8.Bg)
    mUI:Skin(ContainerFrame9.NineSlice)
    mUI:Skin(ContainerFrame9.Bg)
    mUI:Skin(ContainerFrame10.NineSlice)
    mUI:Skin(ContainerFrame10.Bg)
    mUI:Skin(ContainerFrame11.NineSlice)
    mUI:Skin(ContainerFrame11.Bg)
    mUI:Skin(ContainerFrame12.NineSlice)
    mUI:Skin(ContainerFrame12.Bg)
    mUI:Skin(ContainerFrame13.NineSlice)
    mUI:Skin(ContainerFrame13.Bg)

    -- Bank
    mUI:Skin(BankFrame)
    mUI:Skin(BankFrame.NineSlice)
    mUI:Skin(BankSlotsFrame.NineSlice)
    mUI:Skin(BankFrameMoneyFrameBorder)
    mUI:Skin(AccountBankPanel.NineSlice)
    mUI:Skin(AccountBankPanel.MoneyFrame.Border)
    mUI:Skin(ReagentBankFrame.NineSlice)
    mUI:Skin(BankFrameTab1)
    mUI:Skin(BankFrameTab2)
    mUI:Skin(BankFrameTab3)

    -- Character Frame
    mUI:Skin(CharacterFrame)
    mUI:Skin(CharacterFrame.NineSlice)
    mUI:Skin(CharacterFrameInset)
    mUI:Skin(CharacterFrameInset.NineSlice)
    mUI:Skin(CharacterFrameInsetRight)
    mUI:Skin(CharacterFrameInsetRight.NineSlice)
    mUI:Skin(TokenFramePopup)
    mUI:Skin(TokenFramePopup.Border)
    mUI:Skin(CharacterStatsPane)
    mUI:Skin(ReputationFrame.ReputationDetailFrame)
    mUI:Skin(ReputationFrame.ReputationDetailFrame.Border)
    mUI:Skin(CurrencyTransferLog)
    mUI:Skin(CurrencyTransferLog.TitleContainer)
    mUI:Skin(CurrencyTransferLog.NineSlice)
    mUI:Skin(CurrencyTransferLogInset.NineSlice)
    mUI:Skin(GearManagerPopupFrame)
    mUI:Skin(GearManagerPopupFrame.BorderBox)
    mUI:Skin(CharacterFrameTab1)
    mUI:Skin(CharacterFrameTab2)
    mUI:Skin(CharacterFrameTab3)
    mUI:Skin({
        CharacterFeetSlotFrame,
        CharacterHandsSlotFrame,
        CharacterWaistSlotFrame,
        CharacterLegsSlotFrame,
        CharacterFinger0SlotFrame,
        CharacterFinger1SlotFrame,
        CharacterTrinket0SlotFrame,
        CharacterTrinket1SlotFrame,
        CharacterWristSlotFrame,
        CharacterTabardSlotFrame,
        CharacterShirtSlotFrame,
        CharacterChestSlotFrame,
        CharacterBackSlotFrame,
        CharacterShoulderSlotFrame,
        CharacterNeckSlotFrame,
        CharacterHeadSlotFrame,
        CharacterMainHandSlotFrame,
        CharacterSecondaryHandSlotFrame,
        _G.select(CharacterMainHandSlot:GetNumRegions(), CharacterMainHandSlot:GetRegions()),
        _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions()),
        PaperDollInnerBorderLeft,
        PaperDollInnerBorderRight,
        PaperDollInnerBorderTop,
        PaperDollInnerBorderTopLeft,
        PaperDollInnerBorderTopRight,
        PaperDollInnerBorderBottom,
        PaperDollInnerBorderBottomLeft,
        PaperDollInnerBorderBottomRight,
        PaperDollInnerBorderBottom2
    }, true)

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
    mUI:Skin({
        CommunitiesFrameCommunitiesListListScrollFrameThumbTexture,
        CommunitiesFrameCommunitiesListListScrollFrameTop,
        CommunitiesFrameCommunitiesListListScrollFrameMiddle,
        CommunitiesFrameCommunitiesListListScrollFrameBottom,
    }, true)

    -- Dressup Frame
    mUI:Skin(DressUpFrame)
    mUI:Skin(DressUpFrame.NineSlice)
    mUI:Skin(DressUpFrame.OutfitDetailsPanel)
    mUI:Skin(DressUpFrameInset)
    mUI:Skin(DressUpFrameInset.NineSlice)

    -- Frames
    mUI:Skin(GameMenuFrame)
    mUI:Skin(GameMenuFrame.Header)
    mUI:Skin(GameMenuFrame.Border)
    mUI:Skin(StaticPopup1)
    mUI:Skin(StaticPopup1.Border)
    mUI:Skin(StaticPopup2)
    mUI:Skin(StaticPopup2.Border)
    mUI:Skin(StaticPopup3)
    mUI:Skin(StaticPopup3.Border)
    mUI:Skin({
        StaticPopup1EditBoxLeft,
        StaticPopup1EditBoxMid,
        StaticPopup1EditBoxRight,
        StaticPopup2EditBoxLeft,
        StaticPopup2EditBoxMid,
        StaticPopup2EditBoxRight,
        StaticPopup3EditBoxLeft,
        StaticPopup3EditBoxMid,
        StaticPopup3EditBoxRight,
    }, true)
    mUI:Skin(EditModeManagerFrame)
    mUI:Skin(EditModeManagerFrame.Border)
    mUI:Skin(VehicleSeatIndicator)
    mUI:Skin(ReportFrame)
    mUI:Skin(ReportFrame.Border)
    mUI:Skin(ReadyStatus.Border)
    mUI:Skin(LFGDungeonReadyStatus.Border)
    mUI:Skin(LFGDungeonReadyDialog)
    mUI:Skin(LFGDungeonReadyDialog.Border)
    mUI:Skin(PVPMatchScoreboard.Content)
    mUI:Skin(QueueStatusFrame)
    mUI:Skin(QueueStatusFrame.NineSlice)
    mUI:Skin(LFGListInviteDialog)
    mUI:Skin(LFGListInviteDialog.Border)
    mUI:Skin(PVPScoreboardTab1)
    mUI:Skin(PVPScoreboardTab2)
    mUI:Skin(PVPScoreboardTab3)

    -- Friendlist
    mUI:Skin(AddFriendEntryFrame)
    mUI:Skin(AddFriendFrame.Border)
    mUI:Skin(FriendsFrame)
    mUI:Skin(FriendsFrame.NineSlice)
    mUI:Skin(FriendsFrameInset)
    mUI:Skin(FriendsFrameInset.NineSlice)
    mUI:Skin(FriendsFriendsFrame)
    mUI:Skin(FriendsFriendsFrame.Border)
    mUI:Skin(RecruitAFriendFrame)
    mUI:Skin(RecruitAFriendFrame.RecruitList)
    mUI:Skin(RecruitAFriendFrame.RecruitList.Header)
    mUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset)
    mUI:Skin(RecruitAFriendFrame.RecruitList.ScrollFrameInset.NineSlice)
    mUI:Skin(RecruitAFriendFrame.RewardClaiming)
    mUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset)
    mUI:Skin(RecruitAFriendFrame.RewardClaiming.Inset.NineSlice)
    mUI:Skin(RecruitAFriendRecruitmentFrame)
    mUI:Skin(RecruitAFriendRecruitmentFrame.Border)
    mUI:Skin(WhoFrameListInset)
    mUI:Skin(WhoFrameListInset.NineSlice)
    mUI:Skin(WhoFrameEditBoxInset)
    mUI:Skin(WhoFrameEditBoxInset.NineSlice)
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

    -- Gossip
    mUI:Skin(GossipFrame)
    mUI:Skin(GossipFrame.NineSlice)
    mUI:Skin(GossipFrameInset)
    mUI:Skin(GossipFrameInset.NineSlice)

    -- Guild
    mUI:Skin(GuildRegistrarFrame)
    mUI:Skin(GuildRegistrarFrame.NineSlice)
    mUI:Skin(TabardFrame)
    mUI:Skin(TabardFrame.NineSlice)

    -- Item
    mUI:Skin(ItemTextFrame)
    mUI:Skin(ItemTextFrame.NineSlice)

    -- LFG
    mUI:Skin(PVEFrame)
    mUI:Skin(PVEFrame.shadows)
    mUI:Skin(PVEFrame.NineSlice)
    mUI:Skin(LFGListFrame.SearchPanel.ResultsInset)
    mUI:Skin(LFGListFrame.SearchPanel.ResultsInset.NineSlice)
    mUI:Skin(LFGListFrame.SearchPanel.FilterButton)
    mUI:Skin(PVEFrameLeftInset)
    mUI:Skin(PVEFrameLeftInset.NineSlice)
    mUI:Skin(LFDParentFrameInset)
    mUI:Skin(LFDParentFrameInset.NineSlice)
    mUI:Skin(RaidFinderFrameRoleInset)
    mUI:Skin(RaidFinderFrameRoleInset.NineSlice)
    mUI:Skin(RaidFinderFrameBottomInset)
    mUI:Skin(RaidFinderFrameBottomInset.NineSlice)
    mUI:Skin(LFGListFrame)
    mUI:Skin(LFGListFrame.CategorySelection)
    mUI:Skin(LFGListFrame.CategorySelection.Inset)
    mUI:Skin(LFGListFrame.CategorySelection.Inset.NineSlice)
    mUI:Skin(LFGListFrame.ApplicationViewer)
    mUI:Skin(LFGListFrame.ApplicationViewer.Inset)
    mUI:Skin(LFGListFrame.ApplicationViewer.Inset.NineSlice)
    mUI:Skin(LFGListFrame.EntryCreation)
    mUI:Skin(LFGListFrame.EntryCreation.Inset)
    mUI:Skin(LFGListFrame.EntryCreation.Inset.NineSlice)
    mUI:Skin(LFGListFrame.ApplicationViewer.NameColumnHeader)
    mUI:Skin(LFGListFrame.ApplicationViewer.RoleColumnHeader)
    mUI:Skin(LFGListFrame.ApplicationViewer.ItemLevelColumnHeader)
    mUI:Skin(LFGApplicationViewerRatingColumnHeader)
    mUI:Skin(LFDRoleCheckPopup)
    mUI:Skin(LFDRoleCheckPopup.Border)
    mUI:Skin(PVPReadyDialog)
    mUI:Skin(PVPReadyDialog.Border)
    mUI:Skin(PVEFrameTab1)
    mUI:Skin(PVEFrameTab2)
    mUI:Skin(PVEFrameTab3)
    mUI:Skin(PVEFrameTab4)
    mUI:Skin({
        LFDQueueFrameBackground,
        LFDParentFrameRoleBackground,
        PVEFrameTopFiligree,
        PVEFrameBottomFiligree,
        PVEFrameBlueBg,
    }, true)

    -- Loot
    mUI:Skin(LootFrame)
    mUI:Skin(LootFrame.NineSlice)

    -- Mail
    mUI:Skin(MailFrame)
    mUI:Skin(MailFrame.NineSlice)
    mUI:Skin(OpenMailFrame)
    mUI:Skin(OpenMailFrame.NineSlice)
    mUI:Skin(MailFrameInset)
    mUI:Skin(MailFrameInset.NineSlice)
    mUI:Skin(OpenMailFrameInset)
    mUI:Skin(OpenMailFrameInset.NineSlice)
    mUI:Skin(SendMailMoneyInset)
    mUI:Skin(SendMailMoneyInset.NineSlice)
    mUI:Skin(SendMailMoneyBg)
    mUI:Skin(SendMailFrame)
    mUI:Skin(MailFrameTab1)
    mUI:Skin(MailFrameTab2)

    -- Map
    mUI:Skin(WorldMapFrame)
    mUI:Skin(WorldMapFrame.BorderFrame)
    mUI:Skin(WorldMapFrame.BorderFrame.NineSlice)
    mUI:Skin(WorldMapFrame.NavBar)
    mUI:Skin(WorldMapFrame.NavBar.overlay)

    -- Merchant
    mUI:Skin(MerchantFrame)
    mUI:Skin(MerchantFrame.NineSlice)
    mUI:Skin(MerchantFrameInset)
    mUI:Skin(MerchantFrameInset.NineSlice)
    mUI:Skin(StackSplitFrame)
    mUI:Skin(MerchantMoneyBg)
    mUI:Skin(MerchantMoneyInset)
    mUI:Skin(MerchantMoneyInset.NineSlice)
    mUI:Skin(MerchantExtraCurrencyBg)
    mUI:Skin(MerchantExtraCurrencyInset.NineSlice)
    mUI:Skin(MerchantFrameTab1)
    mUI:Skin(MerchantFrameTab2)
    mUI:Skin({
        MerchantBuyBackItemSlotTexture,
        select(1, select(1, MerchantRepairItemButton:GetRegions())),
        select(1, select(1, MerchantRepairAllButton:GetRegions())),
        select(1, select(1, MerchantGuildBankRepairButton:GetRegions())),
        select(1, select(1, MerchantSellAllJunkButton:GetRegions()))
    }, true)

    -- Item Upgrade
    mUI:Skin(ItemUpgradeFrame)
    mUI:Skin(ItemUpgradeFrame.NineSlice)
    mUI:Skin(ItemUpgradeFramePlayerCurrenciesBorder)
    mUI:Skin(ItemUpgradeFrameLeftItemPreviewFrame.NineSlice)
    mUI:Skin(ItemUpgradeFrameRightItemPreviewFrame.NineSlice)
    mUI:Skin({
        ItemUpgradeFrame.UpgradeItemButton.ButtonFrame
    }, true)

    -- Minimap
    mUI:Skin({
        MinimapCompassTexture
    }, true)

    -- Petition
    mUI:Skin(PetitionFrame)
    mUI:Skin(PetitionFrame.NineSlice)
    mUI:Skin(PetitionFrameInset)

    -- Quest
    mUI:Skin(QuestFrame)
    mUI:Skin(QuestFrame.NineSlice)
    mUI:Skin(QuestFrameInset)
    mUI:Skin(QuestFrameInset.NineSlice)
    mUI:Skin(QuestLogPopupDetailFrame)
    mUI:Skin(QuestLogPopupDetailFrame.NineSlice)
    mUI:Skin(ObjectiveTrackerFrame)
    mUI:Skin(ObjectiveTrackerFrame.Header)
    mUI:Skin(CampaignQuestObjectiveTracker)
    mUI:Skin(CampaignQuestObjectiveTracker.Header)
    mUI:Skin(QuestObjectiveTracker)
    mUI:Skin(QuestObjectiveTracker.Header)
    mUI:Skin(ProfessionsRecipeTracker)
    mUI:Skin(ProfessionsRecipeTracker.Header)
    mUI:Skin(ScenarioObjectiveTracker)
    mUI:Skin(ScenarioObjectiveTracker.Header)
    mUI:Skin({
        QuestNPCModelTopBorder,
        QuestNPCModelRightBorder,
        QuestNPCModelTopRightCorner,
        QuestNPCModelBottomRightCorner,
        QuestNPCModelBottomBorder,
        QuestNPCModelBottomLeftCorner,
        QuestNPCModelLeftBorder,
        QuestNPCModelTopLeftCorner,
        QuestNPCModelTextTopBorder,
        QuestNPCModelTextRightBorder,
        QuestNPCModelTextTopRightCorner,
        QuestNPCModelTextBottomRightCorner,
        QuestNPCModelTextBottomBorder,
        QuestNPCModelTextBottomLeftCorner,
        QuestNPCModelTextLeftBorder,
        QuestNPCModelTextTopLeftCorner
    }, true)

    -- Raidframe
    mUI:Skin(CompactRaidFrameManager)
    mUI:Skin(CompactPartyFrameBorderFrame)

    -- Settings Panel
    mUI:Skin(SettingsPanel)
    mUI:Skin(SettingsPanel.Bg)
    mUI:Skin(SettingsPanel.NineSlice)

    -- TimerTracker
    mUI:Skin({
        _G["TimerTrackerTimer1StatusBarBorder"]
    }, true)

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

    -- Weekly Rewards
    mUI:Skin(WeeklyRewardsFrame)
    mUI:Skin(WeeklyRewardsFrame.BorderContainer)

    -- Unitframes
    mUI:Skin(PlayerFrame.PlayerFrameContainer)
    mUI:Skin(TargetFrame.TargetFrameContainer)
    mUI:Skin(FocusFrame.TargetFrameContainer)
    mUI:Skin(Boss1TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss2TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss3TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss4TargetFrame.TargetFrameContainer)
    mUI:Skin({
        PetFrameTexture,
        TargetFrameToT.FrameTexture,
        FocusFrameToT.FrameTexture,
        PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon
    }, true)

    -- Castbars
    mUI:Skin({
        PlayerCastingBarFrame.Background,
        TargetFrameSpellBar.Background,
        TargetFrameSpellBar.Border,
        FocusFrameSpellBar.Background,
        FocusFrameSpellBar.Border,
        Boss1TargetFrameSpellBar.Background,
        Boss1TargetFrameSpellBar.Border,
        Boss2TargetFrameSpellBar.Background,
        Boss2TargetFrameSpellBar.Border,
        Boss3TargetFrameSpellBar.Background,
        Boss3TargetFrameSpellBar.Border,
        Boss4TargetFrameSpellBar.Background,
        Boss4TargetFrameSpellBar.Border,
        Boss5TargetFrameSpellBar.Background,
        Boss5TargetFrameSpellBar.Border
    }, true)

    -- Actionbars
    for j = 1, #Theme.Bars do
        local Bar = Theme.Bars[j]
        if Bar then
            local Num = Bar.numButtonsShowable
            Theme:StyleAction(Bar, Num)
        end
    end

    local DefaultActionBarShowable = _G["MainMenuBar"].numButtonsShowable

    for i = 1, DefaultActionBarShowable do
        local Button = _G["ActionButton" .. i]

        if C_AddOns.IsAddOnLoaded("Masque") and C_AddOns.IsAddOnLoaded("MasqueBlizzBars") then return end
        Theme:StyleButton(Button, "Actionbar")
    end

    for i = 1, 10 do
        local StanceButton = _G["StanceButton" .. i]
        local PetButton = _G["PetActionButton" .. i]

        Theme:StyleButton(StanceButton, "StanceOrPet")
        Theme:StyleButton(PetButton, "StanceOrPet")
    end

    if C_AddOns.IsAddOnLoaded("Dominos") then
        if C_AddOns.IsAddOnLoaded("Masque") then return end
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
        if C_AddOns.IsAddOnLoaded("Masque") then return end
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

    -- Class Bars
    if (playerClass == "ROGUE") then
        if not Theme:IsHooked(RogueComboPointBarFrame, "OnUpdate") then
            Theme:HookScript(RogueComboPointBarFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "MAGE") then
        if not Theme:IsHooked(MageArcaneChargesFrame, "OnUpdate") then
            Theme:HookScript(MageArcaneChargesFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "WARLOCK") then
        if not Theme:IsHooked(WarlockPowerFrame, "OnUpdate") then
            Theme:HookScript(WarlockPowerFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "DRUID") then
        if not Theme:IsHooked(DruidComboPointBarFrame, "OnUpdate") then
            Theme:HookScript(DruidComboPointBarFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "MONK") then
        if not Theme:IsHooked(MonkHarmonyBarFrame, "OnUpdate") then
            Theme:HookScript(MonkHarmonyBarFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "DEATHKNIGHT") then
        if not Theme:IsHooked(RuneFrame, "OnUpdate") then
            Theme:HookScript(RuneFrame, "OnUpdate", OnUpdate)
        end
    elseif (playerClass == "EVOKER") then
        if not Theme:IsHooked(EssencePlayerFrame, "OnUpdate") then
            Theme:HookScript(EssencePlayerFrame, "OnUpdate", Theme.ClassBar)
        end

        Theme:ClassBar()
    elseif (playerClass == "PALADIN") then
        Theme:ClassBar()
    elseif (playerClass == "SHAMAN") then
        -- Totem Bar
        if not Theme:IsHooked(TotemFrame, "OnUpdate") then
            Theme:HookScript(TotemFrame, "OnUpdate", function(frame)
                for totem, _ in frame.totemPool:EnumerateActive() do
                    mUI:Skin({ totem.Border }, true)
                end
            end)
        end

        Theme:ClassBar()
    end

    -- Tooltips
    for i, tooltip in next, Theme.tooltips do
        Theme:StyleTooltip(tooltip)
    end
end
