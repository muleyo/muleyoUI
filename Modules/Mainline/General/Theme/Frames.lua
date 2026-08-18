local Theme = mUI:GetModule("mUI.Modules.General.Theme")

local _, playerClass = UnitClass("player")
Theme.LSM = LibStub("LibSharedMedia-3.0")

function Theme:Achievements()
    -- Achievements Frame
    if AchievementFrame then
        -- Blacklist Frames
        if select(8, AchievementFrame.Header:GetRegions()) then
            Theme.blacklist[select(8, AchievementFrame.Header:GetRegions())] = true
        else
            Theme.blacklist[select(7, AchievementFrame.Header:GetRegions())] = true
        end

        -- Skin frames
        mUI:Skin(AchievementFrame)
        mUI:Skin(AchievementFrame.Header)
        mUI:Skin(AchievementFrame.Searchbox)
        mUI:Skin(AchievementFrameSummary)
        mUI:Skin(AchievementFrameTab1)
        mUI:Skin(AchievementFrameTab2)
        mUI:Skin(AchievementFrameTab3)
        if AchievementFrame.HeaderDetails then
            mUI:Skin({AchievementFrame.HeaderDetails.Filters.SearchBox.Left, AchievementFrame.HeaderDetails.Filters.SearchBox.Middle,
                      AchievementFrame.HeaderDetails.Filters.SearchBox.Right}, true)
        else
            mUI:Skin({AchievementFrame.SearchBox.Left, AchievementFrame.SearchBox.Middle, AchievementFrame.SearchBox.Right}, true)
        end
        AchievementFrame.Header.PointBorder:SetAlpha(0)
    end
end

function Theme:CraftingOrders()
    -- Crafting Orders
    if ProfessionsCustomerOrdersFrame then
        mUI:Skin(ProfessionsCustomerOrdersFrame)
        mUI:Skin(ProfessionsCustomerOrdersFrame.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList)
        mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.CategoryList.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.RecipeList)
        mUI:Skin(ProfessionsCustomerOrdersFrame.BrowseOrders.RecipeList.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.MyOrdersPage.OrderList)
        mUI:Skin(ProfessionsCustomerOrdersFrame.MyOrdersPage.OrderList.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.Form.LeftPanelBackground)
        mUI:Skin(ProfessionsCustomerOrdersFrame.Form.LeftPanelBackground.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.Form.RightPanelBackground)
        mUI:Skin(ProfessionsCustomerOrdersFrame.Form.RightPanelBackground.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameBorder)
        mUI:Skin(ProfessionsCustomerOrdersFrame.MoneyFrameInset.NineSlice)
        mUI:Skin(ProfessionsCustomerOrdersFrameBrowseTab)
        mUI:Skin(ProfessionsCustomerOrdersFrameOrdersTab)
        mUI:Skin({ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchBox.Left,
                  ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchBox.Middle,
                  ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchBox.Right,
                  ProfessionsCustomerOrdersFrame.Form.OrderRecipientTarget.Left, ProfessionsCustomerOrdersFrame.Form.OrderRecipientTarget.Middle,
                  ProfessionsCustomerOrdersFrame.Form.OrderRecipientTarget.Right,
                  ProfessionsCustomerOrdersFrame.Form.PaymentContainer.NoteEditBox.Border}, true)

    end
end

function Theme:AuctionHouse()
    -- Auction House
    if AuctionHouseFrame then

        mUI:Skin(AuctionHouseFrame)
        mUI:Skin(AuctionHouseFrame.NineSlice)
        mUI:Skin(AuctionHouseFrame.WoWTokenResults.GameTimeTutorial.NineSlice)
        mUI:Skin(AuctionHouseFrame.BuyDialog)
        mUI:Skin(AuctionHouseFrame.BuyDialog.Border)
        mUI:Skin(AuctionHouseFrame.MoneyFrameBorder)
        mUI:Skin(AuctionHouseFrame.MoneyFrameInset.NineSlice)
        mUI:Skin(AuctionHouseFrame.CategoriesList)
        mUI:Skin(AuctionHouseFrame.CategoriesList.NineSlice)
        mUI:Skin(AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay)
        mUI:Skin(AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.NineSlice)
        mUI:Skin(AuctionHouseFrame.CommoditiesBuyFrame.ItemList)
        mUI:Skin(AuctionHouseFrame.CommoditiesBuyFrame.ItemList.NineSlice)
        mUI:Skin(AuctionHouseFrame.ItemBuyFrame.ItemDisplay)
        mUI:Skin(AuctionHouseFrame.ItemBuyFrame.ItemDisplay.NineSlice)
        mUI:Skin(AuctionHouseFrame.ItemBuyFrame.ItemList)
        mUI:Skin(AuctionHouseFrame.ItemBuyFrame.ItemList.NineSlice)
        mUI:Skin(AuctionHouseFrameBuyTab)
        mUI:Skin(AuctionHouseFrameSellTab)
        mUI:Skin(AuctionHouseFrameAuctionsTab)
        mUI:Skin(AuctionHouseFrameAuctionsFrameAuctionsTab)
        mUI:Skin(AuctionHouseFrameAuctionsFrameBidsTab)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList.NineSlice)
        mUI:Skin(AuctionHouseFrame.BrowseResultsFrame.ItemList)
        mUI:Skin(AuctionHouseFrame.MoneyFrameInset.NineSlice)
        mUI:Skin(AuctionHouseFrame.ItemSellList)
        mUI:Skin(AuctionHouseFrame.ItemSellList.NineSlice)
        mUI:Skin(AuctionHouseFrame.ItemSellFrame)
        mUI:Skin(AuctionHouseFrame.ItemSellFrame.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.ItemDisplay)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.ItemDisplay.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.CommoditiesList)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.CommoditiesList.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.ItemList)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.ItemList.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.BidsList)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.BidsList.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.AllAuctionsList)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.AllAuctionsList.NineSlice)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.SummaryList)
        mUI:Skin(AuctionHouseFrameAuctionsFrame.SummaryList.NineSlice)
        mUI:Skin(AuctionHouseFrame.ItemSellFrame.ItemDisplay)
        mUI:Skin(AuctionHouseFrame.CommoditiesSellFrame.ItemDisplay)
        mUI:Skin(AuctionHouseFrame.CommoditiesSellFrame)
        mUI:Skin(AuctionHouseFrame.CommoditiesSellFrame.NineSlice)
        mUI:Skin(AuctionHouseFrame.CommoditiesSellList)
        mUI:Skin(AuctionHouseFrame.CommoditiesSellList.NineSlice)
        mUI:Skin({AuctionHouseFrame.SearchBar.SearchBox.Left, AuctionHouseFrame.SearchBar.SearchBox.Middle,
                  AuctionHouseFrame.SearchBar.SearchBox.Right}, true)

        if C_AddOns.IsAddOnLoaded("Auctionator") then
            C_Timer.After(0.2, function()
                -- Tabs
                mUI:Skin(_G["LibAHFrame-1.0-AuctionatorTabs_Shopping"])
                mUI:Skin(_G["LibAHFrame-1.0-AuctionatorTabs_Selling"])
                mUI:Skin(_G["LibAHFrame-1.0-AuctionatorTabs_Cancelling"])
                mUI:Skin(_G["LibAHFrame-1.0-AuctionatorTabs_Auctionator"])

                -- Shopping
                if AuctionatorShoppingFrame then
                    mUI:Skin(AuctionatorShoppingFrame.ShoppingResultsInset)
                    mUI:Skin(AuctionatorShoppingFrame.ListsContainer.Inset)
                    mUI:Skin(AuctionatorShoppingFrame.ListsContainer.Inset.NineSlice)
                    mUI:Skin(AuctionatorShoppingFrame.ShoppingResultsInset.NineSlice)
                    mUI:Skin(AuctionatorShoppingFrame.ListsContainer.ScrollBar.Background)
                    mUI:Skin(AuctionatorShoppingFrame.ResultsListing.ScrollArea.ScrollBar.Background)
                    mUI:Skin(AuctionatorShoppingFrame.ContainerTabs.ListsTab)
                    mUI:Skin(AuctionatorShoppingFrame.ContainerTabs.RecentsTab)

                    -- Selling
                    mUI:Skin(AuctionatorSellingFrame.HistoricalPriceInset)
                    mUI:Skin(AuctionatorSellingFrame.HistoricalPriceInset.NineSlice)
                    mUI:Skin(AuctionatorSellingFrame.BagInset)
                    mUI:Skin(AuctionatorSellingFrame.BagInset.NineSlice)
                    mUI:Skin(AuctionatorSellingFrame.BagListing.View.ScrollBar.Background)
                    mUI:Skin(AuctionatorSellingFrame.CurrentPricesListing.ScrollArea.ScrollBar.Background)
                    mUI:Skin(AuctionatorSellingFramePricesTab1)
                    mUI:Skin(AuctionatorSellingFramePricesTab2)
                    mUI:Skin(AuctionatorSellingFramePricesTab3)

                    -- Cancelling
                    mUI:Skin(AuctionatorCancellingFrame.HistoricalPriceInset)
                    mUI:Skin(AuctionatorCancellingFrame.HistoricalPriceInset.NineSlice)
                    mUI:Skin(AuctionatorCancellingFrame.ResultsListing.ScrollArea.ScrollBar.Background)

                    -- Auctionator
                    mUI:Skin(AuctionatorConfigFrame)
                    mUI:Skin(AuctionatorConfigFrame.NineSlice)
                end
            end)
        end
    end
end

function Theme:AlliedRaces()
    -- Allied Races
    if AlliedRacesFrame then
        mUI:Skin(AlliedRacesFrame)
        mUI:Skin(AlliedRacesFrame.NineSlice)
        mUI:Skin(AlliedRacesFrameInset.NineSlice)
    end
end

function Theme:Archaeology()
    -- Archaeology Frame
    if ArchaeologyFrame then
        mUI:Skin(ArchaeologyFrame.NineSlice)
        mUI:Skin(ArchAeologyFrameInset)
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
        Theme.blacklist[select(3, CalendarClassButton12:GetRegions())] = true
        Theme.blacklist[select(3, CalendarClassButton13:GetRegions())] = true

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
        mUI:Skin(CalendarCreateEventDescriptionContainer.NineSlice)
        mUI:Skin(CalendarCreateEventInviteList.NineSlice)
        mUI:Skin({CalendarCreateEventDivider, CalendarCreateEventFrameButtonBackground, CalendarCreateEventMassInviteButtonBorder,
                  CalendarCreateEventCreateButtonBorder, CalendarCreateEventTitleEdit.Left, CalendarCreateEventTitleEdit.Middle,
                  CalendarCreateEventTitleEdit.Right, CalendarCreateEventInviteEdit.Left, CalendarCreateEventInviteEdit.Middle,
                  CalendarCreateEventInviteEdit.Right}, true)
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
    end
end

function Theme:Trainer()
    -- Profession/Class Trainer
    if ClassTrainerFrame then
        mUI:Skin(ClassTrainerFrame)
        mUI:Skin(ClassTrainerFrame.NineSlice)
        mUI:Skin(ClassTrainerFrameBottomInset.NineSlice)
        mUI:Skin(ClassTrainerFrameInset.NineSlice)
    end
end

function Theme:Collections()
    if CollectionsJournal then
        -- Blacklist frames
        Theme.blacklist[select(2, MountJournal.BottomLeftInset.SlotButton:GetRegions())] = true

        -- Skin frames
        -- Collections Frame
        mUI:Skin(CollectionsJournal)
        mUI:Skin(CollectionsJournal.NineSlice)

        -- Mount Journal
        mUI:Skin(MountJournal)
        mUI:Skin(MountJournal.MountDisplay)
        mUI:Skin(MountJournal.LeftInset.NineSlice)
        mUI:Skin(MountJournal.RightInset.NineSlice)
        mUI:Skin(MountJournal.BottomLeftInset)
        mUI:Skin(MountJournal.BottomLeftInset.NineSlice)
        mUI:Skin(MountJournal.RightInset.NineSlice)
        mUI:Skin(MountJournal.BottomLeftInset.SlotButton)
        mUI:Skin(MountJournal.MountCount)
        mUI:Skin({MountJournal.ToggleDynamicFlightFlyoutButton.Border, MountJournal.SummonRandomFavoriteSpellFrame.Button.Border,
                  MountJournalSearchBox.Left, MountJournalSearchBox.Middle, MountJournalSearchBox.Right}, true)

        -- ToyBox
        mUI:Skin(ToyBox)
        mUI:Skin(ToyBox.iconsFrame)
        mUI:Skin(ToyBox.iconsFrame.NineSlice)
        mUI:Skin({ToyBox.searchBox.Left, ToyBox.searchBox.Middle, ToyBox.searchBox.Right, ToyBox.progressBar.border}, true)

        -- Heirlooms Journal
        mUI:Skin(HeirloomsJournal)
        mUI:Skin(HeirloomsJournal.iconsFrame)
        mUI:Skin(HeirloomsJournal.iconsFrame.NineSlice)
        mUI:Skin({HeirloomsJournalSearchBox.Left, HeirloomsJournalSearchBox.Middle, HeirloomsJournalSearchBox.Right,
                  HeirloomsJournal.progressBar.border}, true)

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
        mUI:Skin(PetJournal.PetCount)
        mUI:Skin({PetJournalSummonRandomFavoritePetButtonBorder, PetJournalHealPetButtonBorder, PetJournalSearchBox.Left, PetJournalSearchBox.Middle,
                  PetJournalSearchBox.Right}, true)

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
        mUI:Skin(WardrobeCollectionFrame)
        mUI:Skin(WardrobeCollectionFrame.NineSlice)
        mUI:Skin({WardrobeCollectionFrameScrollFrameScrollBarBottom, WardrobeCollectionFrameScrollFrameScrollBarMiddle,
                  WardrobeCollectionFrameScrollFrameScrollBarTop, WardrobeCollectionFrameScrollFrameScrollBarThumbTexture,
                  WardrobeCollectionFrameSearchBox.Left, WardrobeCollectionFrameSearchBox.Middle, WardrobeCollectionFrameSearchBox.Right,
                  WardrobeCollectionFrame.progressBar.border}, true)

        -- Campsites
        mUI:Skin(WarbandSceneJournal)
        mUI:Skin(WarbandSceneJournal.IconsFrame.NineSlice)

        -- Specific Frames
        mUI:Skin({CollectionsJournalBg, MountJournalListScrollFrameScrollBarThumbTexture, MountJournalListScrollFrameScrollBarTop,
                  MountJournalListScrollFrameScrollBarMiddle, MountJournalListScrollFrameScrollBarBottom,
                  PetJournalListScrollFrameScrollBarThumbTexture, PetJournalListScrollFrameScrollBarTop, PetJournalListScrollFrameScrollBarMiddle,
                  PetJournalListScrollFrameScrollBarBottom}, true)
        mUI:Skin({WarbandSceneJournal.IconsFrame.BackgroundTile}, true)

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

function Theme:Transmog()
    if TransmogFrame then
        mUI:Skin(TransmogFrame)
        mUI:Skin(TransmogFrame.NineSlice)
        mUI:Skin(TransmogFrame.WardrobeCollection)
        mUI:Skin(TransmogFrame.WardrobeCollection.TabContent)
        mUI:Skin(TransmogFrame.WardrobeCollection:GetTabButton(1))
        mUI:Skin(TransmogFrame.WardrobeCollection:GetTabButton(2))
        mUI:Skin(TransmogFrame.WardrobeCollection:GetTabButton(3))
        mUI:Skin(TransmogFrame.WardrobeCollection:GetTabButton(4))
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
        mUI:Skin(EncounterJournalJourneysTab)
        mUI:Skin(EncounterJournalMonthlyActivitiesTab)
        mUI:Skin(EncounterJournalSuggestTab)
        mUI:Skin(EncounterJournalDungeonTab)
        mUI:Skin(EncounterJournalRaidTab)
        mUI:Skin(EncounterJournalLootJournalTab)
        mUI:Skin(EncounterJournal.TutorialsTab)
        mUI:Skin(EncounterJournalMonthlyActivitiesFrame.ThemeContainer)
        mUI:Skin({EncounterJournalSearchBox.Left, EncounterJournalSearchBox.Middle, EncounterJournalSearchBox.Right}, true)
    end
end

function Theme:FlightMap()
    -- Flightmap
    if FlightMapFrame then
        mUI:Skin(FlightMapFrame)
        mUI:Skin(FlightMapFrame.BorderFrame)
        mUI:Skin(FlightMapFrame.BorderFrame.NineSlice)
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
        mUI:Skin({InspectModelFrameBorderLeft, InspectModelFrameBorderRight, InspectModelFrameBorderTop, InspectModelFrameBorderTopLeft,
                  InspectModelFrameBorderTopRight, InspectModelFrameBorderBottom, InspectModelFrameBorderBottomLeft,
                  InspectModelFrameBorderBottomRight, InspectModelFrameBorderBottom2, InspectFeetSlotFrame, InspectHandsSlotFrame,
                  InspectWaistSlotFrame, InspectLegsSlotFrame, InspectFinger0SlotFrame, InspectFinger1SlotFrame, InspectTrinket0SlotFrame,
                  InspectTrinket1SlotFrame, InspectWristSlotFrame, InspectTabardSlotFrame, InspectShirtSlotFrame, InspectChestSlotFrame,
                  InspectBackSlotFrame, InspectShoulderSlotFrame, InspectNeckSlotFrame, InspectHeadSlotFrame, InspectSecondaryHandSlotFrame}, true)
        mUI:Skin(InspectFrameTab1)
        mUI:Skin(InspectFrameTab2)
        mUI:Skin(InspectFrameTab3)
        mUI:Skin(InspectFrameTab4)
        InspectMainHandSlotFrame:Hide()
        InspectSecondaryHandSlotFrame:Hide()
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
        mUI:Skin({GuildBankFrameLeft, GuildBankFrameMiddle, GuildBankFrameRight, GuildItemSearchBox.Left, GuildItemSearchBox.Middle,
                  GuildItemSearchBox.Right}, true)
        mUI:Skin(GuildBankFrame.MoneyFrameBG)
        mUI:Skin(GuildBankFrame.Column1)
        mUI:Skin(GuildBankFrame.Column2)
        mUI:Skin(GuildBankFrame.Column3)
        mUI:Skin(GuildBankFrame.Column4)
        mUI:Skin(GuildBankFrame.Column5)
        mUI:Skin(GuildBankFrame.Column6)
        mUI:Skin(GuildBankFrame.Column7)

        -- Guild Bank Item Slots (static Column/Button frames)
        for c = 1, 7 do
            local column = GuildBankFrame["Column" .. c]
            if column then
                for b = 1, 14 do
                    local button = column["Button" .. b]
                    if button and button.NormalTexture then
                        mUI:Skin({button.NormalTexture}, true)
                    end
                end
            end
        end

        mUI:Skin({select(1, GuildBankTab1:GetRegions())}, true)
        mUI:Skin({select(1, GuildBankTab2:GetRegions())}, true)
        mUI:Skin({select(1, GuildBankTab3:GetRegions())}, true)
        mUI:Skin({select(1, GuildBankTab4:GetRegions())}, true)
        mUI:Skin({select(1, GuildBankTab5:GetRegions())}, true)
        mUI:Skin({select(1, GuildBankTab6:GetRegions())}, true)
    end
end

function Theme:Professions()
    -- Professions
    if ProfessionsFrame then
        mUI:Skin(InspectRecipeFrame)
        mUI:Skin(InspectRecipeFrame.NineSlice)
        mUI:Skin(ProfessionsFrame)
        mUI:Skin(ProfessionsFrame.NineSlice)
        mUI:Skin(ProfessionsFrame.SpecPage.PanelFooter)
        mUI:Skin(ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice)
        mUI:Skin({ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Left, ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Middle,
                  ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Right, ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.SearchBox.Left,
                  ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.SearchBox.Middle,
                  ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.SearchBox.Right,
                  ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.Background}, true)
        mUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.NineSlice)
        mUI:Skin(ProfessionsFrame.CraftingPage.SchematicForm.Details)
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.NineSlice)
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.BackgroundNineSlice)
        mUI:Skin(ProfessionsFrame.TabSystem.tabs[1])
        mUI:Skin(ProfessionsFrame.TabSystem.tabs[2])
        mUI:Skin(ProfessionsFrame.TabSystem.tabs[3])
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton)
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.GuildOrdersButton)
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton)
        mUI:Skin(ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton)
        mUI:Skin(ProfessionsFrame.CraftingPage.CraftingOutputLog)
        mUI:Skin(ProfessionsFrame.CraftingPage.CraftingOutputLog.TitleContainer)
        mUI:Skin(ProfessionsFrame.CraftingPage.CraftingOutputLog.NineSlice)
        mUI:Skin({ProfessionsFrame.CraftingPage.RankBar.Border}, true)
        mUI:Skin(ProfessionsFrame.OrdersPage.OrderView.OrderInfo.NineSlice)
        mUI:Skin(ProfessionsFrame.OrdersPage.OrderView.OrderDetails.NineSlice)

        C_Timer.After(0.1, function()
            for tab in ProfessionsFrame.SpecPage.tabsPool:EnumerateActive() do
                mUI:Skin(tab)
            end
        end)
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
        mUI:Skin(PlunderstormFrame.Inset)
        mUI:Skin(PlunderstormFrame.Inset.NineSlice)
        mUI:Skin(HonorFrame)
        mUI:Skin(HonorFrame.ConquestFrame)
        mUI:Skin(HonorFrame.Inset)
        mUI:Skin(HonorFrame.Inset.NineSlice)
        mUI:Skin(HonorFrame.BonusFrame)
        mUI:Skin(HonorFrame.ConquestBar)
        mUI:Skin(ConquestFrame)
        mUI:Skin({ConquestFrame.ConquestBar.Border, TrainingGroundsFrame.ConquestBar.Border}, true)
        mUI:Skin(ConquestFrame.Inset)
        mUI:Skin(ConquestFrame.Inset.NineSlice)
        mUI:Skin(PVPQueueFrame)
        mUI:Skin(PVPQueueFrame.HonorInset)
        mUI:Skin(PVPQueueFrame.HonorInset.NineSlice)
        PVPQueueFrame.HonorInset:Hide()
        Theme:StyleTooltip(ConquestTooltip)
    end

    if PVPFramePopup then
        mUI:Skin(PVPFramePopup.Border)
    end
end

function Theme:Macros()
    -- Macros
    if MacroFrame then
        -- Blacklist frames
        Theme.blacklist[select(9, MacroFrameTextBackground.NineSlice:GetRegions())] = true

        -- Skin frames
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
        mUI:Skin({MacroButtonScrollFrameTop, MacroButtonScrollFrameMiddle, MacroButtonScrollFrameBottom, MacroButtonScrollFrameScrollBarThumbTexture},
            true)
    end
end

function Theme:Scrapping()
    -- Scrapping Machine
    if ScrappingMachineFrame then
        mUI:Skin(ScrappingMachineFrame)
        mUI:Skin(ScrappingMachineFrame.NineSlice)
    end
end

function Theme:ProfessionsBook()
    -- Professions Book
    if ProfessionsBookFrame then
        mUI:Skin(ProfessionsBookFrame)
        mUI:Skin(ProfessionsBookFrame.NineSlice)
        mUI:Skin(ProfessionsBookFrameInset)
        mUI:Skin(ProfessionsBookFrameInset.NineSlice)
        mUI:Skin({PrimaryProfession1SpellButtonTopNameFrame, PrimaryProfession2SpellButtonTopNameFrame, PrimaryProfession1SpellButtonBottomNameFrame,
                  PrimaryProfession2SpellButtonBottomNameFrame, SecondaryProfession1SpellButtonLeftNameFrame,
                  SecondaryProfession1SpellButtonRightNameFrame, SecondaryProfession2SpellButtonLeftNameFrame,
                  SecondaryProfession2SpellButtonRightNameFrame, SecondaryProfession3SpellButtonLeftNameFrame,
                  SecondaryProfession3SpellButtonRightNameFrame}, true)

        mUI:Skin({ProfessionsBookPage1, ProfessionsBookPage2}, true)
        for i, v in pairs({PrimaryProfession1.missingText, PrimaryProfession2.missingText, SecondaryProfession1Missing,
                           SecondaryProfession1.missingText, SecondaryProfession2Missing, SecondaryProfession2.missingText,
                           SecondaryProfession3Missing, SecondaryProfession3.missingText}) do
            v:SetVertexColor(0.8, 0.8, 0.8)
        end
    end
end

function Theme:PlayerSpells()
    -- Spellbook / Talent Frame
    if PlayerSpellsFrame then
        -- Blacklist frames
        Theme.blacklist[select(4, PlayerSpellsFrame.TalentsFrame:GetRegions())] = true

        -- Skin frames
        mUI:Skin(PlayerSpellsFrame)
        mUI:Skin(PlayerSpellsFrame.SpecFrame)
        mUI:Skin(PlayerSpellsFrame.SpellBookFrame)
        mUI:Skin(PlayerSpellsFrame.NineSlice)
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
        mUI:Skin({ClassTalentFrameTitleBg, ClassTalentFrameBg, ClassTalentFrameTalentsPvpTalentFrameTalentListBg,
                  PlayerSpellsFrame.SpellBookFrame.SearchBox.Left, PlayerSpellsFrame.SpellBookFrame.SearchBox.Middle,
                  PlayerSpellsFrame.SpellBookFrame.SearchBox.Right}, true)

        if not Theme:IsHooked(SpellBookItemMixin, "UpdateVisuals") then
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
        end
    end
end

function Theme:Talents()
    if PlayerTalentFrame then
        -- Blacklist Frames
        Theme.blacklist[select(2, PlayerSpecTab1:GetRegions())] = true
        Theme.blacklist[select(2, PlayerSpecTab2:GetRegions())] = true

        mUI:Skin(PlayerTalentFrame)
        mUI:Skin(PlayerTalentFrameInset)
        mUI:Skin(PlayerTalentFrameInset.NineSlice)
        mUI:Skin(PlayerTalentFrameTalents)
        mUI:Skin(PlayerTalentFrameTab1)
        mUI:Skin(PlayerTalentFrameTab2)
        mUI:Skin(PlayerTalentFrameTab3)
        mUI:Skin(PlayerTalentFrameTab4)
        mUI:Skin(PlayerSpecTab1)
        mUI:Skin(PlayerSpecTab2)

        if GlyphFrame then
            mUI:Skin(GlyphFrameSideInset)
            mUI:Skin(GlyphFrameSideInset.NineSlice)
            mUI:Skin({GlyphFrameScrollFrameScrollBarTop, GlyphFrameScrollFrameScrollBarMiddle, GlyphFrameScrollFrameScrollBarBottom}, true)
        end

        PlayerTalentFrameSpecializationLearnButton_LeftSeparator:Hide()
        PlayerTalentFrameSpecializationLearnButton_RightSeparator:Hide()
        PlayerTalentFrameTalentsLearnButton_LeftSeparator:Hide()
        PlayerTalentFrameTalentsLearnButton_RightSeparator:Hide()
        PlayerTalentFramePetSpecializationLearnButton_LeftSeparator:Hide()
        PlayerTalentFramePetSpecializationLearnButton_RightSeparator:Hide()
    end
end

function Theme:Spellbook()
    -- Spellbook
    if SpellBookFrame then
        SpellBookFrame:Show()
        SpellBookFrame:Hide()

        mUI:Skin(SpellBookFrame)
        mUI:Skin(SpellBookFrame.NineSlice)
        mUI:Skin(SpellBookFrameInset)
        mUI:Skin(SpellBookFrameInset.NineSlice)
        mUI:Skin(SpellBookProfessionFrame)
        mUI:Skin(SpellBookProfessionFrame.NineSlice)
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
        mUI:Skin(TimeManagerFrame)
        mUI:Skin(TimeManagerFrame.NineSlice)
        mUI:Skin(TimeManagerFrameInset)
        mUI:Skin(TimeManagerFrameInset.NineSlice)
        mUI:Skin(TimeManagerClockButton)
        mUI:Skin({StopwatchFrameBackgroundLeft}, true)
    end
end

function Theme:Actionbars()
    -- Actionbars
    mUI:Skin(MainActionBar)
    mUI:Skin(MainActionBar.EndCaps)
    mUI:Skin(MainActionBar.ActionBarPageNumber.UpButton)
    mUI:Skin(MainActionBar.ActionBarPageNumber.DownButton)
    MainActionBar.ActionBarPageNumber.Text:SetVertexColor(unpack(mUI:Color(0.15)))
    mUI:Skin(StatusTrackingBarManager)
    mUI:Skin(StatusTrackingBarManager.BottomBarFrameTexture)
    mUI:Skin(StatusTrackingBarManager.MainStatusTrackingBarContainer)
    mUI:Skin(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer)

    if not Theme:IsHooked(SpellFlyout, "Toggle") then
        Theme:SecureHook(SpellFlyout, "Toggle", function(_, _, id)
            local _, _, numSlots = GetFlyoutInfo(id)

            for i = 1, numSlots do
                local button = _G["SpellFlyoutPopupButton" .. i .. "NormalTexture"]
                if button then
                    mUI:Skin({button}, true)
                end
            end

            mUI:Skin(SpellFlyout.Background)
        end)
    end
    mUI:Skin(OverrideActionBar)
    mUI:Skin({OverrideActionBarLeaveFrameDivider3}, true)

    -- Actionbars
    for j = 1, #Theme.Bars do
        local Bar = Theme.Bars[j]
        local Num
        if Bar then
            Num = Bar.numButtonsShowable
            Theme:StyleAction(Bar, Num)
        end
    end

    local DefaultActionBarShowable = _G["MainActionBar"].numButtonsShowable

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
    mUI:Skin({AddonListBg, AddonList.SearchBox.Left, AddonList.SearchBox.Middle, AddonList.SearchBox.Right}, true)
end

function Theme:Bags()
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
    mUI:Skin({BagItemSearchBox.Left, BagItemSearchBox.Middle, BagItemSearchBox.Right}, true)

    for i = 1, 13 do
        local container = _G["ContainerFrame" .. i]

        -- Only proceed if container exists
        if container then
            -- Bag Slots - only hook if Update method exists
            if container.Update then
                if not Theme:IsHooked(container, "Update") then
                    Theme:SecureHook(container, "Update", function(self)
                        if self.itemButtonPool then
                            for button, _ in self.itemButtonPool:EnumerateActive() do
                                if button.NormalTexture then
                                    button.NormalTexture:SetVertexColor(unpack(mUI:Color(0.15)))
                                end
                            end
                        end
                    end)
                end
            end
        end
    end

    if not Theme:IsHooked(ContainerFrameCombinedBags, "Update") then
        Theme:SecureHook(ContainerFrameCombinedBags, "Update", function(self)
            if self.itemButtonPool then
                for button, _ in self.itemButtonPool:EnumerateActive() do
                    if button.NormalTexture then
                        button.NormalTexture:SetVertexColor(unpack(mUI:Color(0.15)))
                    end
                end
            end
        end)
    end
end

function Theme:Bank()
    -- Bank
    mUI:Skin(BankFrame)
    mUI:Skin(BankFrame.NineSlice)

    -- Bank Tab Borders (purchased tabs are pooled/dynamically named, PurchaseTab is static)
    local function SkinBankTab(tab)
        if not tab then
            return
        end

        local border, icon = tab:GetRegions()
        if border then
            mUI:Skin({border}, true)
        end
        if icon then
            -- Keep the tab icon's original color, only tint the border
            icon:SetVertexColor(1, 1, 1)
        end
    end

    SkinBankTab(BankPanel.PurchaseTab)

    if BankPanel.bankTabPool then
        for tab, _ in BankPanel.bankTabPool:EnumerateActive() do
            SkinBankTab(tab)
        end
    end

    if not Theme:IsHooked(BankPanel, "RefreshBankTabs") then
        Theme:SecureHook(BankPanel, "RefreshBankTabs", function(self)
            SkinBankTab(self.PurchaseTab)
            if self.bankTabPool then
                for tab, _ in self.bankTabPool:EnumerateActive() do
                    SkinBankTab(tab)
                end
            end
        end)
    end

    -- Bank Item Slots (pooled/dynamically named)
    local function SkinBankItemButtons(self)
        if self.itemButtonPool then
            for button, _ in self.itemButtonPool:EnumerateActive() do
                if button.NormalTexture then
                    button.NormalTexture:SetVertexColor(unpack(mUI:Color(0.15)))
                end
            end
        end
    end

    SkinBankItemButtons(BankPanel)

    if not Theme:IsHooked(BankPanel, "GenerateItemSlotsForSelectedTab") then
        Theme:SecureHook(BankPanel, "GenerateItemSlotsForSelectedTab", SkinBankItemButtons)
    end

    if not Theme:IsHooked(BankPanel, "RefreshAllItemsForSelectedTab") then
        Theme:SecureHook(BankPanel, "RefreshAllItemsForSelectedTab", SkinBankItemButtons)
    end

    mUI:Skin(BankPanel)
    mUI:Skin(BankPanel.NineSlice)
    mUI:Skin(BankFrameMoneyFrameBorder)
    mUI:Skin(BankFrame.TabSystem.tabs[1])
    mUI:Skin(BankFrame.TabSystem.tabs[2])
    mUI:Skin(BankPanel.MoneyFrame.Border)
    mUI:Skin({BankItemSearchBox.Left, BankItemSearchBox.Middle, BankItemSearchBox.Right}, true)
end

function Theme:Character()
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
    mUI:Skin(CharacterStatsPane.ItemLevelCategory)
    mUI:Skin(CharacterStatsPane.ItemLevelFrame)
    mUI:Skin(CharacterStatsPane.AttributesCategory)
    mUI:Skin(CharacterStatsPane.EnhancementsCategory)
    mUI:Skin(GearManagerPopupFrame)
    mUI:Skin(GearManagerPopupFrame.BorderBox)
    mUI:Skin(CharacterFrameTab1)
    mUI:Skin(CharacterFrameTab2)
    mUI:Skin(CharacterFrameTab3)

    mUI:Skin({CharacterFeetSlotFrame, CharacterHandsSlotFrame, CharacterWaistSlotFrame, CharacterLegsSlotFrame, CharacterFinger0SlotFrame,
              CharacterFinger1SlotFrame, CharacterTrinket0SlotFrame, CharacterTrinket1SlotFrame, CharacterWristSlotFrame, CharacterTabardSlotFrame,
              CharacterShirtSlotFrame, CharacterChestSlotFrame, CharacterBackSlotFrame, CharacterShoulderSlotFrame, CharacterNeckSlotFrame,
              CharacterHeadSlotFrame, CharacterMainHandSlotFrame, CharacterSecondaryHandSlotFrame,
              _G.select(CharacterMainHandSlot:GetNumRegions(), CharacterMainHandSlot:GetRegions()),
              _G.select(CharacterSecondaryHandSlot:GetNumRegions(), CharacterSecondaryHandSlot:GetRegions()), PaperDollInnerBorderLeft,
              PaperDollInnerBorderRight, PaperDollInnerBorderTop, PaperDollInnerBorderTopLeft, PaperDollInnerBorderTopRight,
              PaperDollInnerBorderBottom, PaperDollInnerBorderBottomLeft, PaperDollInnerBorderBottomRight, PaperDollInnerBorderBottom2}, true)
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
    Theme:StyleTooltip(GeneralDockManagerOverflowButtonList)
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
    mUI:Skin({ClubFinderGuildFinderFrame.OptionsList.SearchBox.Left, ClubFinderGuildFinderFrame.OptionsList.SearchBox.Middle,
              ClubFinderGuildFinderFrame.OptionsList.SearchBox.Right}, true)
    mUI:Skin({ClubFinderCommunityAndGuildFinderFrame.OptionsList.SearchBox.Left, ClubFinderCommunityAndGuildFinderFrame.OptionsList.SearchBox.Middle,
              ClubFinderCommunityAndGuildFinderFrame.OptionsList.SearchBox.Right}, true)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.InsetFrame.NineSlice)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.ClubFinderSearchTab)
    mUI:Skin(ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab)
    mUI:Skin({CommunitiesFrameCommunitiesListListScrollFrameThumbTexture, CommunitiesFrameCommunitiesListListScrollFrameTop,
              CommunitiesFrameCommunitiesListListScrollFrameMiddle, CommunitiesFrameCommunitiesListListScrollFrameBottom}, true)
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
    mUI:Skin({AddFriendNameEditBoxLeft, AddFriendNameEditBoxMiddle, AddFriendNameEditBoxRight}, true)
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
    mUI:Skin(FriendsFrame.IgnoreListWindow)
    mUI:Skin(FriendsFrame.IgnoreListWindow.NineSlice)
    mUI:Skin(FriendsTabHeader:GetTabButton(1))
    mUI:Skin(FriendsTabHeader:GetTabButton(2))
    mUI:Skin(FriendsTabHeader:GetTabButton(3))
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

    if SocialUIFrame then
        mUI:Skin(SocialUIFrame)
        mUI:Skin(SocialUIFrame.NineSlice)
        mUI:Skin(SocialUIFrame.BattleNetBar)
        mUI:Skin(SocialUIFrame.BattleNetBroadcastFrame.Border)
        mUI:Skin(SocialUIFrame.IgnoreListFrame)
        mUI:Skin(SocialUIFrame.IgnoreListFrame.NineSlice)
        mUI:Skin(SocialUIFrameInset)
        mUI:Skin(SocialUIFrameInset.NineSlice)
        mUI:Skin({SocialUIFrame.BattleNetBroadcastFrame.EditBox.BottomBorder, SocialUIFrame.BattleNetBroadcastFrame.EditBox.BottomLeftBorder,
                  SocialUIFrame.BattleNetBroadcastFrame.EditBox.BottomRightBorder, SocialUIFrame.BattleNetBroadcastFrame.EditBox.TopBorder,
                  SocialUIFrame.BattleNetBroadcastFrame.EditBox.TopLeftBorder, SocialUIFrame.BattleNetBroadcastFrame.EditBox.TopRightBorder,
                  SocialUIFrame.BattleNetBroadcastFrame.EditBox.MiddleBorder, SocialUIFrame.BattleNetBroadcastFrame.EditBox.LeftBorder,
                  SocialUIFrame.BattleNetBroadcastFrame.EditBox.RightBorder}, true)

        -- Social Tabs (pooled/dynamically named)
        local function SkinSocialTab(tab)
            if tab and tab.Background then
                mUI:Skin({tab.Background}, true)
            end
        end

        if SocialUIFrame.socialTabPool then
            for tab, _ in SocialUIFrame.socialTabPool:EnumerateActive() do
                SkinSocialTab(tab)
            end
        end

        if not Theme:IsHooked(SocialUIFrame, "RefreshTabs") then
            Theme:SecureHook(SocialUIFrame, "RefreshTabs", function(self)
                if self.socialTabPool then
                    for tab, _ in self.socialTabPool:EnumerateActive() do
                        SkinSocialTab(tab)
                    end
                end
            end)
        end
    end
    Theme:StyleTooltip(FriendsTooltip)
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
end

function Theme:Item()
    -- Item
    mUI:Skin(ItemTextFrame)
    mUI:Skin(ItemTextFrame.NineSlice)
end

function Theme:LFG()
    -- LFG
    mUI:Skin(PVEFrame)
    mUI:Skin(PVEFrame.shadows)
    mUI:Skin(PVEFrame.NineSlice)
    mUI:Skin(LFGListFrame.SearchPanel.ResultsInset)
    mUI:Skin(LFGListFrame.SearchPanel.ResultsInset.NineSlice)
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
    mUI:Skin({LFGListFrame.SearchPanel.SearchBox.Left, LFGListFrame.SearchPanel.SearchBox.Middle, LFGListFrame.SearchPanel.SearchBox.Right,
              LFGListApplicationDialogDescription.BottomTex, LFGListApplicationDialogDescription.BottomLeftTex,
              LFGListApplicationDialogDescription.BottomRightTex, LFGListApplicationDialogDescription.TopTex,
              LFGListApplicationDialogDescription.TopLeftTex, LFGListApplicationDialogDescription.TopRightTex,
              LFGListApplicationDialogDescription.LeftTex, LFGListApplicationDialogDescription.MiddleTex, LFGListApplicationDialogDescription.RightTex},
        true)
    mUI:Skin(ScenarioFinderFrameInset)
    mUI:Skin(ScenarioFinderFrameInset.NineSlice)
    mUI:Skin(LFGApplicationViewerRatingColumnHeader)
    mUI:Skin(LFDRoleCheckPopup)
    mUI:Skin(LFDRoleCheckPopup.Border)
    mUI:Skin(PVPReadyDialog)
    mUI:Skin(PVPReadyDialog.Border)
    mUI:Skin(PVEFrameTab1)
    mUI:Skin(PVEFrameTab2)
    mUI:Skin(PVEFrameTab3)
    mUI:Skin(PVEFrameTab4)
    mUI:Skin({LFDQueueFrameBackground, LFDParentFrameRoleBackground, PVEFrameTopFiligree, PVEFrameBottomFiligree, PVEFrameBlueBg}, true)
end

function Theme:Loot()
    -- Loot
    mUI:Skin(LootFrame)
    mUI:Skin(LootFrame.NineSlice)
    mUI:Skin(GroupLootHistoryFrame)
    mUI:Skin(GroupLootHistoryFrameBg)
    mUI:Skin(GroupLootHistoryFrame.TitleContainer)
    mUI:Skin(GroupLootHistoryFrame.NineSlice)
end

function Theme:Mail()
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
    mUI:Skin(MerchantExtraCurrencyBg)
    mUI:Skin(MerchantExtraCurrencyInset.NineSlice)
    mUI:Skin(MerchantRepairItemButton)
    mUI:Skin(MerchantRepairAllButton)
    mUI:Skin(MerchantFrameTab1)
    mUI:Skin(MerchantFrameTab2)
    mUI:Skin(MerchantGuildBankRepairButton)
    mUI:Skin(MerchantSellAllJunkButton)
    mUI:Skin({MerchantBuyBackItemSlotTexture}, true)
end

function Theme:Map()
    -- Map

    mUI:Skin(WorldMapFrame)
    mUI:Skin(WorldMapFrame.BorderFrame)
    mUI:Skin(WorldMapFrame.BorderFrame.NineSlice)
    mUI:Skin(WorldMapFrame.NavBar)
    mUI:Skin(WorldMapFrame.NavBar.overlay)
    mUI:Skin(QuestMapFrame.QuestSessionManagement)
    mUI:Skin(QuestScrollFrame.BorderFrame)
    mUI:Skin(QuestScrollFrame)
    mUI:Skin(QuestMapFrame.EventsFrame.BorderFrame)
    mUI:Skin(QuestMapFrame.EventsFrame.ScrollBox)
    mUI:Skin(QuestMapFrame.MapLegend.BorderFrame)
    mUI:Skin(MapLegendScrollFrame)
    mUI:Skin(QuestMapFrame.QuestsFrame.DetailsFrame.BorderFrame)
    mUI:Skin(QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame)
    mUI:Skin(QuestMapFrame.QuestsFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame)
    mUI:Skin({QuestMapFrame.QuestsTab.Background, QuestMapFrame.EventsTab.Background, QuestMapFrame.MapLegendTab.Background,
              QuestScrollFrame.SearchBox.Left, QuestScrollFrame.SearchBox.Middle, QuestScrollFrame.SearchBox.Right}, true)

    -- Minimap
    mUI:Skin({MinimapCompassTexture}, true)
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

    select(5, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(6, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(7, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(8, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(9, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(9, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(10, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(11, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(12, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(13, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
    select(19, PetitionFrame:GetRegions()):SetTextColor(0.9, 0.9, 0.9)
end

function Theme:Quest()
    -- Quest
    mUI:Skin(QuestFrame)
    mUI:Skin(QuestFrame.NineSlice)
    mUI:Skin(QuestFrameInset)
    mUI:Skin(QuestFrameInset.NineSlice)
    mUI:Skin(QuestLogPopupDetailFrame)
    mUI:Skin(QuestLogPopupDetailFrame.NineSlice)
    mUI:Skin(ObjectiveTrackerFrame)
    mUI:Skin(ObjectiveTrackerFrame.Header)
    mUI:Skin(AchievementObjectiveTracker.Header)
    mUI:Skin(CampaignQuestObjectiveTracker)
    mUI:Skin(CampaignQuestObjectiveTracker.Header)
    mUI:Skin(QuestObjectiveTracker)
    mUI:Skin(QuestObjectiveTracker.Header)
    mUI:Skin(ProfessionsRecipeTracker)
    mUI:Skin(ProfessionsRecipeTracker.Header)
    mUI:Skin(ScenarioObjectiveTracker)
    mUI:Skin(ScenarioObjectiveTracker.Header)
    mUI:Skin(WorldQuestObjectiveTracker)
    mUI:Skin(WorldQuestObjectiveTracker.Header)
    mUI:Skin(InitiativeTasksObjectiveTracker)
    mUI:Skin(InitiativeTasksObjectiveTracker.Header)
    mUI:Skin({QuestNPCModelTopBorder, QuestNPCModelRightBorder, QuestNPCModelTopRightCorner, QuestNPCModelBottomRightCorner,
              QuestNPCModelBottomBorder, QuestNPCModelBottomLeftCorner, QuestNPCModelLeftBorder, QuestNPCModelTopLeftCorner,
              QuestNPCModelTextTopBorder, QuestNPCModelTextRightBorder, QuestNPCModelTextTopRightCorner, QuestNPCModelTextBottomRightCorner,
              QuestNPCModelTextBottomBorder, QuestNPCModelTextBottomLeftCorner, QuestNPCModelTextLeftBorder, QuestNPCModelTextTopLeftCorner}, true)
end

function Theme:DamageMeter()
    local function updateDamageMeter(frame)
        mUI:Skin({frame.StatusBar.BackgroundEdge, frame.StatusBar.Background}, true)

        local texture = mUI.db.profile.unitframes.textures.unitframes
        local defaultTexture

        if not defaultTexture then
            defaultTexture = frame:GetStatusBarTexture():GetTexture()
        end

        if texture ~= "None" then
            frame.StatusBar.Background:SetAlpha(0)
            frame.StatusBar.BackgroundEdge:Show()
            frame:GetStatusBarTexture():SetTexture(Theme.LSM:Fetch('statusbar', mUI.db.profile.unitframes.textures.unitframes))
            frame:GetStatusBarTexture():SetDrawLayer("BORDER")
        end
    end

    local function updateDamageWindows()
        for i = 1, 3 do
            local frame = _G["DamageMeterSessionWindow" .. i]
            if frame then
                mUI:Skin({frame.Header}, true)

                for _, bar in frame:EnumerateEntryFrames() do
                    updateDamageMeter(bar)
                end
            end
        end
    end

    if not Theme:IsHooked(DamageMeter, "GetSessionWindow") then
        Theme:SecureHook(DamageMeter, "GetSessionWindow", updateDamageWindows)
    end

    if not Theme:IsHooked(DamageMeterEntryMixin, "Init") then
        Theme:SecureHook(DamageMeterEntryMixin, "Init", updateDamageMeter)
    end

    -- Update Windows and Bars on Player Login
    updateDamageWindows()
end

function Theme:Settings()
    -- Settings Panel
    mUI:Skin(SettingsPanel)
    mUI:Skin(SettingsPanel.Bg)
    mUI:Skin(SettingsPanel.NineSlice)
    mUI:Skin(SettingsPanel.GameTab)
    mUI:Skin(SettingsPanel.AddOnsTab)
    mUI:Skin({SettingsPanel.SearchBox.Left, SettingsPanel.SearchBox.Middle, SettingsPanel.SearchBox.Right}, true)
    Theme:StyleTooltip(SettingsTooltip)
end

function Theme:Raidframe()
    -- Raidframe
    mUI:Skin(CompactRaidFrameManager)
    mUI:Skin(CompactPartyFrameBorderFrame)
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
    local classBarFrames = {
        ROGUE = {
            frame = RogueComboPointBarFrame,
            hook = "UpdatePower",
            hookType = "method"
        },
        MAGE = {
            frame = MageArcaneChargesFrame,
            hook = "UpdatePower",
            hookType = "method"
        },
        WARLOCK = {
            frame = WarlockPowerFrame,
            hook = "UpdatePower",
            hookType = "method"
        },
        DRUID = {
            frame = DruidComboPointBarFrame,
            hook = "UpdatePower",
            hookType = "method"
        },
        MONK = {
            frame = MonkHarmonyBarFrame,
            hook = "UpdatePower",
            hookType = "method"
        },
        DEATHKNIGHT = {
            frame = RuneFrame,
            hook = "UpdateRunes",
            hookType = "method"
        },
        EVOKER = {
            frame = EssencePlayerFrame,
            hook = "UpdatePower",
            hookType = "method"
        }
    }

    local info = classBarFrames[playerClass]
    if info then
        if not Theme:IsHooked(info.frame, info.hook) then
            if info.hookType == "script" then
                Theme:SecureHookScript(info.frame, info.hook, Theme.ClassBar)
            else
                Theme:SecureHook(info.frame, info.hook, Theme.ClassBar)
            end
        end

        Theme:ClassBar()
    elseif playerClass == "PALADIN" or playerClass == "PRIEST" then
        Theme:ClassBar()
    end

    if playerClass == "SHAMAN" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "DRUID" then
        if not Theme:IsHooked(TotemFrame, "OnEvent") then
            Theme:SecureHookScript(TotemFrame, "OnEvent", function(frame)
                for totem, _ in frame.totemPool:EnumerateActive() do
                    mUI:Skin({totem.Border}, true)
                end
            end)
        end

        Theme:ClassBar()
    end
end

function Theme:Unitframes()
    -- Unitframes
    mUI:Skin(PlayerFrame.PlayerFrameContainer)
    mUI:Skin(TargetFrame.TargetFrameContainer)
    mUI:Skin(FocusFrame.TargetFrameContainer)
    mUI:Skin(Boss1TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss2TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss3TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss4TargetFrame.TargetFrameContainer)
    mUI:Skin(Boss5TargetFrame.TargetFrameContainer)
    mUI:Skin({PetFrameTexture, TargetFrameToT.FrameTexture, FocusFrameToT.FrameTexture,
              PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon}, true)

    -- Move Target-of-Target/Focus-of-Target frames further out from their parent.
    if mUI.db.profile.unitframes.enabled and not InCombatLockdown() then
        TargetFrameToT:ClearAllPoints()
        FocusFrameToT:ClearAllPoints()
        TargetFrameToT:SetPoint("RIGHT", TargetFrame, "RIGHT", 45, -55)
        FocusFrameToT:SetPoint("RIGHT", FocusFrame, "RIGHT", 45, -55)
    end
end

function Theme:Castbars()
    -- Castbars
    mUI:Skin({PlayerCastingBarFrame.Background, TargetFrameSpellBar.Background, TargetFrameSpellBar.Border, FocusFrameSpellBar.Background,
              FocusFrameSpellBar.Border, Boss1TargetFrameSpellBar.Background, Boss1TargetFrameSpellBar.Border, Boss2TargetFrameSpellBar.Background,
              Boss2TargetFrameSpellBar.Border, Boss3TargetFrameSpellBar.Background, Boss3TargetFrameSpellBar.Border,
              Boss4TargetFrameSpellBar.Background, Boss4TargetFrameSpellBar.Border, Boss5TargetFrameSpellBar.Background,
              Boss5TargetFrameSpellBar.Border}, true)

    -- Castbar Icon Skinning
    for castbar in pairs(Theme.castbarIcons) do
        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))
    end
end

function Theme:Auras()
    -- BuffFrame Expand/Collapse Button
    mUI:Skin(BuffFrame.CollapseAndExpandButton)
    for button, type in pairs(Theme.aurabuttons) do
        if (type == "playerbuff" or type == "unitframebuff" or type == "raidframebuff") and button.mUIBorder then
            -- Preserve a frame's custom border color (e.g. stealable buffs); only
            -- reset plain buff borders to the theme's default shade.
            local c = button.mUIBorderColor
            if c then
                pcall(button.mUIBorder.SetVertexColor, button.mUIBorder, c.r, c.g, c.b, 1)
            else
                pcall(button.mUIBorder.SetVertexColor, button.mUIBorder, unpack(mUI:Color(0.25)))
            end
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

function Theme:Housing()
    if HousingDashboardFrame then
        mUI:Skin(HousingDashboardFrame)
        mUI:Skin(HousingDashboardFrame.NineSlice)
        C_Timer.After(0.15, function()
            mUI:Skin(HousingDashboardFrame.HouseInfoContent.ContentFrame.TabSystem.tabs[1])
            mUI:Skin(HousingDashboardFrame.HouseInfoContent.ContentFrame.TabSystem.tabs[2])
        end)
        mUI:Skin({HousingDashboardFrame.CatalogContent.SearchBox.Left, HousingDashboardFrame.CatalogContent.SearchBox.Middle,
                  HousingDashboardFrame.CatalogContent.SearchBox.Right}, true)

        -- Housing Dashboard Side Tabs (static named frames)
        if HousingDashboardFrame.TabButtons then
            for _, tab in ipairs(HousingDashboardFrame.TabButtons) do
                if tab.Background then
                    mUI:Skin({tab.Background}, true)
                end
            end
        end
    end

    if HousingModelPreviewFrame then
        mUI:Skin(HousingModelPreviewFrame)
        mUI:Skin(HousingModelPreviewFrame.NineSlice)
    end

    if HouseListFrame then
        mUI:Skin(HouseListFrame)
    end
end

function Theme:Catalyst()
    if ItemInteractionFrame then
        mUI:Skin(ItemInteractionFrame)
        mUI:Skin(ItemInteractionFrame.NineSlice)
        mUI:Skin(ItemInteractionFrame.Inset)
        mUI:Skin(ItemInteractionFrame.Inset.NineSlice)
        mUI:Skin(ItemInteractionFrame.ButtonFrame)
    end
end

function Theme:GameMenu(frame)
    C_Timer.After(0, function()
        for _, button in pairs(frame:GetLayoutChildren()) do
            if mUI.db.profile.misc.skinmenu then
                button.Left:SetDesaturated(true)
                button.Center:SetDesaturated(true)
                button.Right:SetDesaturated(true)
                button.Left:SetVertexColor(unpack(mUI:Color(0.15)))
                button.Center:SetVertexColor(unpack(mUI:Color(0.15)))
                button.Right:SetVertexColor(unpack(mUI:Color(0.15)))
            else
                button.Left:SetDesaturated(false)
                button.Center:SetDesaturated(false)
                button.Right:SetDesaturated(false)
                button.Left:SetVertexColor(1, 1, 1, 1)
                button.Center:SetVertexColor(1, 1, 1, 1)
                button.Right:SetVertexColor(1, 1, 1, 1)
            end
        end
    end)
end

function Theme:Framestack()
    if TableAttributeDisplay then
        mUI:Skin(TableAttributeDisplay)
        mUI:Skin(TableAttributeDisplay.LinesScrollFrame)
        mUI:Skin(TableAttributeDisplay.ScrollFrameArt)
        mUI:Skin(TableAttributeDisplay.ScrollFrameArt.NineSlice)
    end
end

function Theme:Frames()
    -- Bnet Toast
    Theme.blacklist[BNToastFrameIconTexture] = true
    mUI:Skin(BNToastFrame)

    -- Game Menu
    mUI:Skin(GameMenuFrame)
    mUI:Skin(GameMenuFrame.Header)
    mUI:Skin(GameMenuFrame.Border)

    -- StaticPopups
    mUI:Skin(StaticPopup1)
    mUI:Skin(StaticPopup2)
    mUI:Skin(StaticPopup3)
    mUI:Skin(StaticPopup1.BG)
    mUI:Skin(StaticPopup2.BG)
    mUI:Skin(StaticPopup3.BG)
    mUI:Skin(StaticPopup1EditBox.NineSlice)
    mUI:Skin(StaticPopup2EditBox.NineSlice)
    mUI:Skin(StaticPopup3EditBox.NineSlice)
    mUI:Skin({StaticPopup1EditBoxLeft, StaticPopup1EditBoxMid, StaticPopup1EditBoxRight, StaticPopup2EditBoxLeft, StaticPopup2EditBoxMid,
              StaticPopup2EditBoxRight, StaticPopup3EditBoxLeft, StaticPopup3EditBoxMid, StaticPopup3EditBoxRight}, true)

    -- EditMode
    mUI:Skin(EditModeManagerFrame)
    mUI:Skin(EditModeManagerFrame.Border)
    mUI:Skin(EditModeManagerFrame.AccountSettings.SettingsContainer.BorderArt)
    mUI:Skin(EditModeSystemSettingsDialog)
    mUI:Skin(EditModeSystemSettingsDialog.Border)
    mUI:Skin(EditModeUnsavedChangesDialog.Border)
    mUI:Skin(EditModeImportLayoutDialog.Border)
    mUI:Skin({EditModeImportLayoutDialog.ImportBox.LeftTex, EditModeImportLayoutDialog.ImportBox.MiddleTex,
              EditModeImportLayoutDialog.ImportBox.RightTex, EditModeImportLayoutDialog.ImportBox.TopTex,
              EditModeImportLayoutDialog.ImportBox.BottomTex, EditModeImportLayoutDialog.ImportBox.BottomLeftTex,
              EditModeImportLayoutDialog.ImportBox.BottomRightTex, EditModeImportLayoutDialog.ImportBox.TopLeftTex,
              EditModeImportLayoutDialog.ImportBox.TopRightTex, EditModeImportLayoutDialog.LayoutNameEditBox.Left,
              EditModeImportLayoutDialog.LayoutNameEditBox.Middle, EditModeImportLayoutDialog.LayoutNameEditBox.Right}, true)

    -- Vehicle Seat
    mUI:Skin(VehicleSeatIndicator)

    -- ReportFrame
    mUI:Skin(ReportFrame)
    mUI:Skin(ReportFrame.Border)

    -- LFG Ready/Invite Dialogs
    mUI:Skin(ReadyStatus.Border)
    mUI:Skin(LFGDungeonReadyStatus.Border)
    mUI:Skin(LFGDungeonReadyDialog)
    mUI:Skin(LFGDungeonReadyDialog.Border)
    mUI:Skin(LFGListApplicationDialog)
    mUI:Skin(LFGListApplicationDialog.Border)
    mUI:Skin(LFGListInviteDialog)
    mUI:Skin(LFGListInviteDialog.Border)
    mUI:Skin(LFGInvitePopup)
    mUI:Skin(LFGInvitePopup.Border)
    Theme:StyleTooltip(QueueStatusFrame)

    -- PVP Scoreboard
    mUI:Skin(PVPMatchScoreboard.Content)
    mUI:Skin(PVPScoreboardTab1)
    mUI:Skin(PVPScoreboardTab2)
    mUI:Skin(PVPScoreboardTab3)

    -- ReadyCheck
    mUI:Skin(ReadyCheckListenerFrame)
    mUI:Skin(ReadyCheckListenerFrame.NineSlice)

    if select(4, GetBuildInfo()) < 120100 then
        -- Battletag Add Frame
        mUI:Skin(BattleTagInviteFrame)
        mUI:Skin(BattleTagInviteFrame.Border)
    end

    -- Currency Transfer
    mUI:Skin(CurrencyTransferMenu)
    mUI:Skin(CurrencyTransferMenu.NineSlice)
    mUI:Skin(CurrencyTransferMenuInset)
    mUI:Skin(CurrencyTransferMenuInset.NineSlice)

    -- Renown Frame
    mUI:Skin(MajorFactionRenownFrame)

    -- Delves
    mUI:Skin(DelvesCompanionConfigurationFrame)
    mUI:Skin(DelvesCompanionConfigurationFrame.Border)

    -- Abandon
    mUI:Skin(InstanceAbandonPopup)
    mUI:Skin(InstanceAbandonPopup.BG)
    mUI:Skin(InstanceAbandonFrame)

    -- CooldownViewerSettings
    mUI:Skin(CooldownViewerSettings)
    mUI:Skin(CooldownViewerSettingsInset)
    mUI:Skin(CooldownViewerSettingsInset.NineSlice)
    mUI:Skin(CooldownViewerSettings.TitleContainer)
    mUI:Skin(CooldownViewerSettings.NineSlice)
    mUI:Skin(CooldownViewerLayoutDialog)
    mUI:Skin(CooldownViewerLayoutDialog.Border)
    mUI:Skin(CooldownViewerImportLayoutDialog)
    mUI:Skin(CooldownViewerImportLayoutDialog.Border)
    mUI:Skin(CooldownViewerSettingsEditAlert.BG)

    -- Guild Invite Frame
    mUI:Skin({GuildInviteFrameLeftBorder, GuildInviteFrameRightBorder, GuildInviteFrameTopBorder, GuildInviteFrameBottomBorder,
              GuildInviteFrameTopLeftCorner, GuildInviteFrameTopRightCorner, GuildInviteFrameBottomLeftCorner, GuildInviteFrameBottomRightCorner},
        true)

    for _, tab in pairs(CooldownViewerSettings.TabButtons) do
        Theme.blacklist[select(2, tab:GetRegions())] = true
        mUI:Skin(tab)
    end

    -- DropDowns
    if not Theme:IsHooked(MenuStyle1Mixin, "Generate") then
        Theme:SecureHook(MenuStyle1Mixin, "Generate", function(tooltip)
            mUI:Skin(tooltip)
        end)
    end

    if not Theme:IsHooked(MenuStyle2Mixin, "Generate") then
        Theme:SecureHook(MenuStyle2Mixin, "Generate", function(tooltip)
            mUI:Skin(tooltip)
        end)
    end
end

function Theme:Update()
    Theme:Achievements()
    Theme:AuctionHouse()
    Theme:AlliedRaces()
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
    Theme:ProfessionsBook()
    Theme:PlayerSpells()
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
    Theme:LFG()
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
    Theme:ClassBars()
    Theme:Unitframes()
    Theme:Castbars()
    Theme:Auras()
    Theme:Frames()
    Theme:Transmog()
    Theme:Housing()
    Theme:DamageMeter()
    Theme:Catalyst()
    Theme:Framestack()

    -- Tooltips
    for _, tooltip in next, Theme.tooltips do
        Theme:StyleTooltip(tooltip)
    end
end
