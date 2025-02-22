local Theme = mUI:NewModule("mUI.Modules.General.Theme")

function Theme:OnInitialize()
    -- Initialize Database
    self.db = mUI.db.profile.general

    -- Hook Checks
    local dragonriding = false
    local classHook = false

    -- Style ActionButton
    local Bars = {
        _G["MultiBarBottomLeft"],
        _G["MultiBarBottomRight"],
        _G["MultiBarRight"],
        _G["MultiBarLeft"],
        _G["MultiBarRight"],
        _G["MultiBar5"],
        _G["MultiBar6"],
        _G["MultiBar7"],
    }

    local function StyleButton(Button, Type)
        local Name = Button:GetName()
        local NormalTexture = _G[Name .. "NormalTexture"]
        local Icon = _G[Name .. "Icon"]
        local Cooldown = _G[Name .. "Cooldown"]

        mUI:Skin({
            NormalTexture
        }, true)

        if Type ~= "StanceOrPet" then
            Cooldown:ClearAllPoints()
            Cooldown:SetPoint("TOPLEFT", Button, "TOPLEFT", 2, -2.5)
            Cooldown:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", -3, 3)
        end

        Icon:SetTexCoord(.08, .92, .08, .92)

        if C_AddOns.IsAddOnLoaded("Bartender4") then
            local ButtonWidth, ButtonHeight = Button:GetSize()
            Button:GetNormalTexture():SetSize(ButtonWidth + 2, ButtonHeight + 1)

            if Type ~= "Stance" and Type ~= "Pet" then
                Button:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
                Button:GetNormalTexture():SetSize(ButtonWidth + 6, ButtonHeight + 5)
            end
        end
    end

    local function StyleAction(Bar, Num)
        for i = 1, Num do
            local Name = Bar:GetName()
            local Button = _G[Name .. "Button" .. i]

            StyleButton(Button, "Actionbar")
        end
    end

    -- Style Class Bars
    local _, playerClass = UnitClass("player")
    local function classBar()
        -- Rogue
        if (playerClass == 'ROGUE') then
            for _, child in ipairs({ RogueComboPointBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.BGActive,
                    child.BGInactive,
                    child.BGShadow
                }, true)
                if (child.isCharged) then
                    mUI:Skin({
                        child.ChargedFrameActive
                    }, true)
                end
            end
            for _, child in ipairs({ ClassNameplateBarRogueFrame:GetChildren() }) do
                mUI:Skin({
                    child.BGActive,
                    child.BGInactive,
                    child.BGShadow
                }, true)
                if (child.isCharged) then
                    mUI:Skin({
                        child.ChargedFrameActive
                    }, true)
                end
            end
        elseif (playerClass == 'MAGE') then
            -- Mage
            for _, child in ipairs({ MageArcaneChargesFrame:GetChildren() }) do
                mUI:Skin({
                    child.ArcaneBG,
                    child.ArcaneBGShadow
                }, true)
            end
            for _, child in ipairs({ ClassNameplateBarMageFrame:GetChildren() }) do
                mUI:Skin({
                    child.ArcaneBG,
                    child.ArcaneBGShadow
                }, true)
            end
        elseif (playerClass == 'WARLOCK') then
            -- Warlock
            for _, child in ipairs({ WarlockPowerFrame:GetChildren() }) do
                mUI:Skin({
                    child.Background
                }, true)
            end
            for _, child in ipairs({ ClassNameplateBarWarlockFrame:GetChildren() }) do
                mUI:Skin({
                    child.Background
                }, true)
            end
        elseif (playerClass == 'DRUID') then
            -- Druid
            for _, child in ipairs({ DruidComboPointBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
            for _, child in ipairs({ ClassNameplateBarFeralDruidFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
        elseif (playerClass == 'MONK') then
            -- Monk
            for _, child in ipairs({ MonkHarmonyBarFrame:GetChildren() }) do
                mUI:Skin({
                    child.Chi_BG,
                    child.Chi_BG_Active
                }, true)
            end
            for _, child in ipairs({ ClassNameplateBarWindwalkerMonkFrame:GetChildren() }) do
                mUI:Skin({
                    child.Chi_BG,
                    child.Chi_BG_Active
                }, true)
            end
        elseif (playerClass == 'DEATHKNIGHT') then
            -- Death Knight
            for _, child in ipairs({ RuneFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
            for _, child in ipairs({ DeathKnightResourceOverlayFrame:GetChildren() }) do
                mUI:Skin({
                    child.BG_Active,
                    child.BG_Inactive,
                    child.BG_Shadow
                }, true)
            end
        elseif (playerClass == 'EVOKER') then
            -- Evoker
            for _, child in ipairs({ EssencePlayerFrame:GetChildren() }) do
                mUI:Skin({
                    child.EssenceFillDone.CircBG,
                    child.EssenceFillDone.CircBGActive
                }, true)
            end

            for _, child in ipairs({ ClassNameplateBarDracthyrFrame:GetChildren() }) do
                mUI:Skin({
                    child.EssenceFillDone.CircBG,
                    child.EssenceFillDone.CircBGActive
                }, true)
            end
        elseif (playerClass == 'PALADIN') then
            -- Paladin
            mUI:Skin({
                PaladinPowerBarFrame.Background,
                PaladinPowerBarFrame.ActiveTexture,
                ClassNameplateBarPaladinFrame.Background,
                ClassNameplateBarPaladinFrame.ActiveTexture
            }, true)
        end
    end

    -- Theme Function
    function self:Update()
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

        -- Dragonriding
        if not dragonriding then
            local updateFrame = CreateFrame("Frame")
            updateFrame:RegisterEvent("UPDATE_UI_WIDGET")
            updateFrame:HookScript("OnEvent", function()
                for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
                    mUI:Skin(child)
                    for _, vigor in ipairs({ child:GetChildren() }) do
                        if not self.forbiddenFrames[select(5, vigor:GetRegions())] then
                            self.forbiddenFrames[select(5, vigor:GetRegions())] = true
                        end
                        mUI:Skin(vigor)
                    end
                end
            end)
            dragonriding = true
        end

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
        for j = 1, #Bars do
            local Bar = Bars[j]
            if Bar then
                local Num = Bar.numButtonsShowable
                StyleAction(Bar, Num)
            end
        end

        local DefaultActionBarShowable = _G["MainMenuBar"].numButtonsShowable

        for i = 1, DefaultActionBarShowable do
            local Button = _G["ActionButton" .. i]

            if C_AddOns.IsAddOnLoaded("Masque") and C_AddOns.IsAddOnLoaded("MasqueBlizzBars") then return end
            StyleButton(Button, "Actionbar")
        end

        for i = 1, 10 do
            local StanceButton = _G["StanceButton" .. i]
            local PetButton = _G["PetActionButton" .. i]

            StyleButton(StanceButton, "StanceOrPet")
            StyleButton(PetButton, "StanceOrPet")
        end

        if C_AddOns.IsAddOnLoaded("Dominos") then
            if C_AddOns.IsAddOnLoaded("Masque") then return end
            for i = 1, 140 do
                local ActionButton = _G["DominosActionButton" .. i]
                if ActionButton then
                    StyleButton(ActionButton)
                end
            end

            for i = 1, 10 do
                local PetButton = _G["DominosPetActionButton" .. i]
                local StanceButton = _G["DominosStanceButton" .. i]

                if PetButton then
                    StyleButton(PetButton)
                end

                if StanceButton then
                    StyleButton(StanceButton)
                end
            end
        end

        if C_AddOns.IsAddOnLoaded("Bartender4") then
            if C_AddOns.IsAddOnLoaded("Masque") then return end
            for i = 1, 180 do
                local ActionButton = _G["BT4Button" .. i]
                if ActionButton then
                    StyleButton(ActionButton)
                end
            end

            for i = 1, 10 do
                local PetButton = _G["BT4PetButton" .. i]
                local StanceButton = _G["BT4StanceButton" .. i]

                if PetButton then
                    StyleButton(PetButton, "StanceOrPet")
                end

                if StanceButton then
                    StyleButton(StanceButton, "StanceOrPet")
                end
            end
        end

        -- Class Bars
        if (playerClass == 'ROGUE') then
            if not classHook then
                RogueComboPointBarFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'MAGE') then
            if not classHook then
                MageArcaneChargesFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'WARLOCK') then
            if not classHook then
                WarlockPowerFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'DRUID') then
            if not classHook then
                DruidComboPointBarFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'MONK') then
            if not classHook then
                MonkHarmonyBarFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'DEATHKNIGHT') then
            if not classHook then
                RuneFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end
        elseif (playerClass == 'EVOKER') then
            if not classHook then
                EssencePlayerFrame:HookScript("OnUpdate", classBar)
                classHook = true
            end

            classBar()
        elseif (playerClass == 'PALADIN') then
            classBar()
        elseif (playerClass == 'SHAMAN') then
            -- Totem Bar
            if not classHook then
                TotemFrame:HookScript("OnEvent", function(self)
                    for totem, _ in self.totemPool:EnumerateActive() do
                        mUI:Skin({
                            totem.Border
                        }, true)
                    end
                end)
                classHook = true
            end
        end
    end
end

function Theme:OnEnable()
    -- Load AddOns
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
    C_AddOns.LoadAddOn("Blizzard_InspectUI")
    C_AddOns.LoadAddOn("Blizzard_ItemUpgradeUI")

    -- Forbidden Frames which are not affected by Themes
    self.forbiddenFrames = {
        ["CalendarCreateEventIcon"] = true,
        ["FriendsFrameIcon"] = true,
        ["MacroFramePortrait"] = true,
        ["StaticPopup1AlertIcon"] = true,
        ["StaticPopup2AlertIcon"] = true,
        ["StaticPopup3AlertIcon"] = true,
        ["PVPReadyDialogBackground"] = true,
        ["LFGDungeonReadyDialogBackground"] = true,
        ["QuestFrameDetailPanelBg"] = true,
        [select(3, GossipFrame:GetRegions())] = true,
        [select(3, DressUpFrame:GetRegions())] = true,
        [select(2, ChatFrame1EditBox:GetRegions())] = true,
        [select(2, ChatFrame2EditBox:GetRegions())] = true,
        [select(2, ChatFrame3EditBox:GetRegions())] = true,
        [select(2, ChatFrame4EditBox:GetRegions())] = true,
        [select(2, ChatFrame5EditBox:GetRegions())] = true,
        [select(2, ChatFrame6EditBox:GetRegions())] = true,
        [select(2, ChatFrame7EditBox:GetRegions())] = true,
        [select(1, TradeFrame.RecipientOverlay:GetRegions())] = true,
        [select(4, LFGListInviteDialog:GetRegions())] = true,
        [select(8, AchievementFrame.Header:GetRegions())] = true,
        [select(2, MountJournal.BottomLeftInset.SlotButton:GetRegions())] = true,
        [select(4, PlayerSpellsFrame.TalentsFrame:GetRegions())] = true,
        [select(1, ContainerFrame1.Bg:GetRegions())] = true,
        [select(2, ContainerFrame1.Bg:GetRegions())] = true,
        [select(1, ContainerFrame2.Bg:GetRegions())] = true,
        [select(2, ContainerFrame2.Bg:GetRegions())] = true,
        [select(1, ContainerFrame3.Bg:GetRegions())] = true,
        [select(2, ContainerFrame3.Bg:GetRegions())] = true,
        [select(1, ContainerFrame4.Bg:GetRegions())] = true,
        [select(2, ContainerFrame4.Bg:GetRegions())] = true,
        [select(1, ContainerFrame5.Bg:GetRegions())] = true,
        [select(2, ContainerFrame5.Bg:GetRegions())] = true,
        [select(1, ContainerFrame6.Bg:GetRegions())] = true,
        [select(2, ContainerFrame6.Bg:GetRegions())] = true,
        [select(1, ContainerFrame7.Bg:GetRegions())] = true,
        [select(2, ContainerFrame7.Bg:GetRegions())] = true,
        [select(1, ContainerFrame8.Bg:GetRegions())] = true,
        [select(2, ContainerFrame8.Bg:GetRegions())] = true,
        [select(1, ContainerFrame9.Bg:GetRegions())] = true,
        [select(2, ContainerFrame9.Bg:GetRegions())] = true,
        [select(1, ContainerFrame10.Bg:GetRegions())] = true,
        [select(2, ContainerFrame10.Bg:GetRegions())] = true,
        [select(1, ContainerFrame11.Bg:GetRegions())] = true,
        [select(2, ContainerFrame11.Bg:GetRegions())] = true,
        [select(1, ContainerFrame12.Bg:GetRegions())] = true,
        [select(2, ContainerFrame12.Bg:GetRegions())] = true,
        [select(1, ContainerFrame13.Bg:GetRegions())] = true,
        [select(2, ContainerFrame13.Bg:GetRegions())] = true,
        [select(1, ContainerFrameCombinedBags.Bg:GetRegions())] = true,
        [select(2, ContainerFrameCombinedBags.Bg:GetRegions())] = true,
        [select(9, ChatConfigCategoryFrame.NineSlice:GetRegions())] = true,
        [select(9, ChatConfigBackgroundFrame.NineSlice:GetRegions())] = true,
        [select(2, CommunitiesFrame.ChatTab:GetRegions())] = true,
        [select(2, CommunitiesFrame.RosterTab:GetRegions())] = true,
        [select(2, CommunitiesFrame.GuildBenefitsTab:GetRegions())] = true,
        [select(2, CommunitiesFrame.GuildInfoTab:GetRegions())] = true,
        [select(2, ClubFinderCommunityAndGuildFinderFrame.ClubFinderSearchTab:GetRegions())] = true,
        [select(2, ClubFinderCommunityAndGuildFinderFrame.ClubFinderPendingTab:GetRegions())] = true,
        [select(2, ClubFinderGuildFinderFrame.ClubFinderSearchTab:GetRegions())] = true,
        [select(2, ClubFinderGuildFinderFrame.ClubFinderPendingTab:GetRegions())] = true,
        [select(9, CommunitiesGuildLogFrame.Container.NineSlice:GetRegions())] = true,
        [select(1, PlayerFrame.PlayerFrameContainer:GetRegions())] = true,
        [select(1, TargetFrame.TargetFrameContainer:GetRegions())] = true,
        [select(1, FocusFrame.TargetFrameContainer:GetRegions())] = true,
        [select(1, Boss1TargetFrame.TargetFrameContainer:GetRegions())] = true,
        [select(1, Boss2TargetFrame.TargetFrameContainer:GetRegions())] = true,
        [select(1, Boss3TargetFrame.TargetFrameContainer:GetRegions())] = true,
        [select(1, Boss4TargetFrame.TargetFrameContainer:GetRegions())] = true,
        [select(3, CalendarClassButton1:GetRegions())] = true,
        [select(3, CalendarClassButton2:GetRegions())] = true,
        [select(3, CalendarClassButton3:GetRegions())] = true,
        [select(3, CalendarClassButton4:GetRegions())] = true,
        [select(3, CalendarClassButton5:GetRegions())] = true,
        [select(3, CalendarClassButton6:GetRegions())] = true,
        [select(3, CalendarClassButton7:GetRegions())] = true,
        [select(3, CalendarClassButton8:GetRegions())] = true,
        [select(3, CalendarClassButton9:GetRegions())] = true,
        [select(3, CalendarClassButton10:GetRegions())] = true,
        [select(3, CalendarClassButton11:GetRegions())] = true,
        [select(3, CalendarClassButton12:GetRegions())] = true,
        [select(3, CalendarClassButton13:GetRegions())] = true,
        [select(5, CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar:GetRegions())] = true,
        [select(9, MacroFrameTextBackground.NineSlice:GetRegions())] = true,
    }

    -- Update Theme
    self:Update()

    -- Update Spellbok Text Colors
    mUI:SecureHook(SpellBookItemMixin, "UpdateVisuals", function(self)
        local theme = mUI.db.profile.general.theme

        if theme == "Disabled" then
            self.Name:SetTextColor(0.1803921610117, 0.10588236153126, 0.05882353335619)
            self.SubName:SetTextColor(0.1803921610117, 0.10588236153126, 0.05882353335619)
            self.Button.Border:SetVertexColor(1, 1, 1)
            self.Button.Border:SetDesaturated(false)
        else
            self.Name:SetTextColor(0.8, 0.8, 0.8)
            self.SubName:SetTextColor(0.8, 0.8, 0.8)
            self.Button.Border:SetVertexColor(0.5, 0.5, 0.5)
            self.Button.Border:SetDesaturated(true)
        end
    end)
end

function Theme:OnDisable()
    -- Update Theme
    self:Update()

    mUI:Unhook(SpellBookItemMixin, "UpdateVisuals")
end
