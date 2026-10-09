local Font = mUI:NewModule("mUI.Modules.General.Font", "AceHook-3.0")

function Font:OnInitialize()
    -- Load Database
    Font.db = mUI.db.profile.general

    Font.fonts = {SystemFont_NamePlateCastBar, SystemFont_NamePlateFixed, SystemFont_LargeNamePlateFixed, SystemFont_LargeNamePlate,
                  SystemFont_NamePlate, SystemFont_Outline_Small, SystemFont_Outline, SystemFont_InverseShadow_Small, SystemFont_Med2,
                  SystemFont_Med3, SystemFont_Shadow_Med3, SystemFont_Huge1, SystemFont_Huge1_Outline, SystemFont_OutlineThick_Huge2,
                  SystemFont_OutlineThick_Huge4, SystemFont_OutlineThick_WTF, NumberFont_GameNormal, NumberFont_Shadow_Small,
                  NumberFont_OutlineThick_Mono_Small, NumberFont_Shadow_Med, NumberFont_Normal_Med, NumberFont_Outline_Med, NumberFont_Outline_Large,
                  NumberFont_Outline_Huge, Fancy22Font, QuestFont_Huge, QuestFont_Outline_Huge, QuestFont_Super_Huge, QuestFont_Super_Huge_Outline,
                  SplashHeaderFont, Game11Font, Game12Font, Game13Font, Game13FontShadow, Game15Font, Game18Font, Game20Font, Game24Font, Game27Font,
                  Game30Font, Game32Font, Game36Font, Game48Font, Game48FontShadow, Game60Font, Game72Font, Game11Font_o1, Game12Font_o1,
                  Game13Font_o1, Game15Font_o1, QuestFont_Enormous, DestinyFontLarge, CoreAbilityFont, DestinyFontHuge, QuestFont_Shadow_Small,
                  MailFont_Large, SpellFont_Small, InvoiceFont_Med, InvoiceFont_Small, Tooltip_Med, Tooltip_Small, AchievementFont_Small,
                  ReputationDetailFont, FriendsFont_Normal, FriendsFont_Small, FriendsFont_Large, FriendsFont_UserText, GameFontHighlightSmall,
                  GameFontHighlightLarge, SystemFont_Shadow_Small, GameFont_Gigantic, GameFontNormalMed2, GameFontNormalMed3, ChatBubbleFont,
                  Fancy16Font, Fancy18Font, Fancy20Font, Fancy24Font, Fancy27Font, Fancy30Font, Fancy32Font, Fancy48Font, SystemFont_Tiny2,
                  SystemFont_Tiny, SystemFont_Shadow_Small, SystemFont_Small, SystemFont_Small2, SystemFont_Shadow_Small2,
                  SystemFont_Shadow_Med1_Outline, SystemFont_Shadow_Med1, QuestFont_Large, SystemFont_Large, SystemFont_Shadow_Large_Outline,
                  SystemFont_Shadow_Med2, SystemFont_Shadow_Large, SystemFont_Shadow_Large2, SystemFont_Shadow_Huge1, SystemFont_Huge2,
                  SystemFont_Shadow_Huge2, SystemFont_Shadow_Huge3, SystemFont_Shadow_Outline_Huge3, SystemFont_Shadow_Outline_Huge2, SystemFont_Med1,
                  SystemFont_WTF2, SystemFont_Outline_WTF2, GameTooltipHeader, System_IME, Number12Font_o1, ObjectiveTrackerLineFont,
                  ObjectiveTrackerHeaderFont, Game15Font_Shadow, QuestFont_Huge, GameFontNormal, GameFontNormalLeft, GameFontNormalSmall,
                  GameFontNormalLarge, GameFontDisable, GameFontRed, GameFontDisableSmallLeft, GameFontGreenSmall, SystemFont_NamePlate_Outlined,
                  SystemFont_NamePlate, SystemFont_NamePlateCastBar, GameFontWhiteTiny2, NumberFontNormal, NumberFontNormalSmall, System15Font,
                  SystemFont_Huge1_Outline_Slug, SystemFont_Huge4, SystemFont_Large2, SystemFont_Outline_Med2, SystemFont_Outline_Slug_Huge2,
                  SystemFont_Outline_Slug_Large2, SystemFont_Shadow_Huge1_Outline, SystemFont_Shadow_Huge2_Outline, SystemFont_Shadow_Huge4,
                  SystemFont_Shadow_Huge4_Outline, SystemFont_Shadow_Large2_Outline, SystemFont_Shadow_Med2_Outline, SystemFont_Shadow_Med3_Outline,
                  SystemFont_Shadow_Outline_Large, SystemFont_Shadow_Outline_Small, SystemFont_Shadow_Small2_Outline, SystemFont_Shadow_Small_Outline,
                  SystemFont16_Shadow_ThickOutline, SystemFont18_Shadow_ThickOutline, SystemFont22_Outline, SystemFont22_Shadow_Outline,
                  SystemFont22_Shadow_ThickOutline, Game10Font_o1, Game11Font_Shadow, Game120Font, Game16Font, Game17Font_Shadow, Game19Font,
                  Game21Font, Game22Font, Game32Font_Shadow2, Game36Font_Shadow2, Game40Font, Game40Font_Shadow2, Game42Font, Game46Font,
                  Game46Font_Shadow2, Game52Font_Shadow2, Game58Font_Shadow2, Game69Font_Shadow2, Game72Font_Shadow, Number11Font, Number12Font,
                  Number12FontOutline, Number13Font, Number15Font, Number16Font, Number18Font, NumberFont_Shadow_Large, NumberFont_Shadow_Tiny,
                  NumberFont_Small, PriceFont, Fancy12Font, Fancy14Font, Fancy36Font, Fancy40Font, QuestFont_30, QuestFont_39, DestinyFontMed,
                  FriendsFont_11, OrderHallTalentRowFont, ObjectiveTrackerFont12, ObjectiveTrackerFont13, ObjectiveTrackerFont14,
                  ObjectiveTrackerFont15, ObjectiveTrackerFont16, ObjectiveTrackerFont17, ObjectiveTrackerFont18, ObjectiveTrackerFont19,
                  ObjectiveTrackerFont20, ObjectiveTrackerFont21, ObjectiveTrackerFont22, GameFontNormal_NoShadow, GameFontNormalHuge,
                  GameFontNormalHuge2, GameFontNormalHuge2Outline, GameFontNormalHuge3, GameFontNormalHuge3Outline, GameFontNormalHuge4,
                  GameFontNormalHuge4Outline, GameFontNormalHugeBlack, GameFontNormalHugeOutline, GameFontNormalLarge2, GameFontNormalLargeLeft,
                  GameFontNormalLargeLeftTop, GameFontNormalLargeOutline, GameFontNormalLeftBottom, GameFontNormalLeftGreen, GameFontNormalLeftGrey,
                  GameFontNormalLeftLightBlue, GameFontNormalLeftLightGreen, GameFontNormalLeftLightGrey, GameFontNormalLeftOrange,
                  GameFontNormalLeftRed, GameFontNormalLeftYellow, GameFontNormalMed1, GameFontNormalMed2Outline, GameFontNormalMed3Outline,
                  GameFontNormalOutline, GameFontNormalOutline22, GameFontNormalShadowHuge2, GameFontNormalShadowOutline22, GameFontNormalSmall2,
                  GameFontNormalSmallBattleNetBlueLeft, GameFontNormalSmallLeft, GameFontNormalSmallOutline, GameFontNormalTiny, GameFontNormalTiny2,
                  GameFontNormalWTF2, GameFontNormalWTF2Outline, GameFontHighlight, GameFontHighlight_NoShadow, GameFontHighlightCenter,
                  GameFontHighlightExtraSmall, GameFontHighlightExtraSmallLeft, GameFontHighlightExtraSmallLeftTop, GameFontHighlightHuge,
                  GameFontHighlightHuge2, GameFontHighlightHugeOutline, GameFontHighlightLarge2, GameFontHighlightLeft, GameFontHighlightMed2,
                  GameFontHighlightMed2Outline, GameFontHighlightMedium, GameFontHighlightOutline, GameFontHighlightOutline22, GameFontHighlightRight,
                  GameFontHighlightShadowHuge2, GameFontHighlightShadowOutline22, GameFontHighlightSmall2, GameFontHighlightSmallLeft,
                  GameFontHighlightSmallLeftTop, GameFontHighlightSmallOutline, GameFontHighlightSmallRight, GameFontDisableHuge,
                  GameFontDisableLarge, GameFontDisableLeft, GameFontDisableMed2, GameFontDisableMed3, GameFontDisableOutline22, GameFontDisableSmall,
                  GameFontDisableSmall2, GameFontDisableTiny, GameFontDisableTiny2, GameFontBlack, GameFontBlackMedium, GameFontBlackSmall,
                  GameFontBlackSmall2, GameFontBlackTiny, GameFontBlackTiny2, GameFontDarkGraySmall, GameFontGreen, GameFontGreenLarge,
                  GameFontRedLarge, GameFontRedSmall, GameFontWhite, GameFontWhiteLarge, GameFontWhiteSmall, GameFontWhiteTiny, GameFont72Highlight,
                  GameFont72HighlightShadow, GameFont72Normal, GameFont72NormalShadow, Number11FontWhite, Number13FontGray, Number13FontRed,
                  Number13FontWhite, Number13FontYellow, Number14FontGray, Number14FontGreen, Number14FontRed, Number14FontWhite, Number15FontWhite,
                  Number18FontWhite, NumberFontNormalGray, NumberFontNormalHuge, NumberFontNormalLarge, NumberFontNormalLargeRight,
                  NumberFontNormalLargeRightGray, NumberFontNormalLargeRightRed, NumberFontNormalLargeRightYellow, NumberFontNormalLargeYellow,
                  NumberFontNormalRight, NumberFontNormalRightGray, NumberFontNormalRightGreen, NumberFontNormalRightRed, NumberFontNormalRightYellow,
                  NumberFontNormalSmallGray, NumberFontNormalYellow, NumberFontSmallBattleNetBlueLeft, NumberFontSmallWhiteLeft,
                  NumberFontSmallYellowLeft, PriceFontGray, PriceFontGreen, PriceFontRed, PriceFontWhite, PriceFontYellow, QuestFont,
                  QuestFont_Shadow_Enormous, QuestFont_Shadow_Huge, QuestFont_Shadow_Super_Huge, QuestFontHighlightHuge, QuestFontLeft,
                  QuestFontNormalHuge, QuestFontNormalLarge, QuestFontNormalSmall, QuestTitleFont, QuestTitleFontBlackShadow, BossEmoteNormalHuge,
                  ChatFontNormal, ChatFontSmall, CombatLogFont, ConsoleFontNormal, ConsoleFontSmall, DialogButtonHighlightText,
                  DialogButtonNormalText, ErrorFont, FocusFontSmall, GameNormalNumberFont, GameTooltipHeaderText, GameTooltipText,
                  GameTooltipTextSmall, IMEHighlight, IMENormal, InvoiceTextFontNormal, InvoiceTextFontSmall, ItemTextFontNormal, LFGActivityEntry,
                  LFGActivityEntryDifficult, LFGActivityEntryTrivial, LFGActivityHeader, MailTextFontNormal, MovieSubtitleFont, NewSubSpellFont,
                  NPE_TutorialKeyString, ObjectiveFont, OptionsFontLeft, PlayerChoiceTextFont, PVPInfoTextFont, QuestMapRewardsFont, SubSpellFont,
                  SubZoneTextFont, TextStatusBarText, TextStatusBarTextLarge, VehicleMenuBarStatusBarText, WhiteNormalNumberFont, WorldMapTextFont,
                  ZoneTextFont, UserScaledFontBody, UserScaledFontHeader, UserScaledFontGlueNormal, UserScaledFontGlueDisable,
                  UserScaledFontGlueHighlight, UserScaledFontGlueNormalLarge, UserScaledFontGlueNormalExtraSmall, UserScaledFontGameNormal,
                  UserScaledFontGameDisable, UserScaledFontGameHighlight, UserScaledFontGameHighlightRight, UserScaledFontGameNormalSmall,
                  UserScaledFontGameDisableSmall, UserScaledFontGameHighlightSmall, UserScaledFontGameNormalMed2, UserScaledFontGame15Shadow,
                  UserScaledFontGameNormalLarge, UserScaledFontGameHighlightLarge, UserScaledChatFontNormal, UserScaledFontNumberNormalRight,
                  UserScaledFontNumberNormalRightRed, UserScaledFontNumberNormalRightYellow, UserScaledFontNumberNormalRightGray,
                  UserScaledFontNumberNormalRightGreen, UserScaledFontSystem15Shadow}

    -- Functions
    function Font:Update()
        if Font.db.font == "None" then
            return
        end

        local fontSizes = {9, 9, 14, 14, 12}

        if (not C_AddOns.IsAddOnLoaded("NiceDamage")) and (not C_AddOns.IsAddOnLoaded("ClassicNumbers")) then
            DAMAGE_TEXT_FONT = Font.db.fontpath
        end
        STANDARD_TEXT_FONT = Font.db.fontpath
        UNIT_NAME_FONT = Font.db.fontpath
        NAMEPLATE_FONT = Font.db.fontpath
        NAMEPLATE_SPELLCAST_FONT = Font.db.fontpath
        UNIT_NAME_FONT_ROMAN = Font.db.fontpath

        -- Apply fonts
        for i, gameFont in pairs(Font.fonts) do
            local _, fontSize, fontStyle = gameFont:GetFont()
            gameFont:SetFont(Font.db.fontpath, fontSizes[i] or fontSize, fontStyle)
        end

        -- Set Font Size for Nameplate Names
        mUI:ApplyFont(SystemFont_LargeNamePlate, 9, "OUTLINE")
        mUI:ApplyFont(SystemFont_NamePlate, 9, "OUTLINE")
        mUI:ApplyFont(SystemFont_LargeNamePlateFixed, 9, "OUTLINE")
        mUI:ApplyFont(SystemFont_NamePlateFixed, 9, "OUTLINE")

        -- Set Font for Floating Combat Text (explicit to ensure outline flags are applied)
        SystemFont_World:SetFont(Font.db.fontpath, 64, "OUTLINE")
        SystemFont_World_ThickOutline:SetFont(Font.db.fontpath, 64, "THICKOUTLINE")

        -- Set Font Size for Community Chat
        CommunitiesFrame.Chat.MessageFrame:SetFont(Font.db.fontpath, 14, "OUTLINE")
    end

    Font:Update()
end

function Font:OnEnable()
    Font:Update()
end
