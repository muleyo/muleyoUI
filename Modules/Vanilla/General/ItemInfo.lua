local ItemInfo = mUI:NewModule("mUI.Modules.General.ItemInfo", "AceHook-3.0")

function ItemInfo:OnInitialize()
    -- Load Database
    ItemInfo.db = mUI.db.profile.general
    ItemInfo.LSM = LibStub("LibSharedMedia-3.0")

    -- CharacterFrame / InspectFrame Equipment Enchants, Gems and ItemLevels
    -- Variables & Tables
    ItemInfo.iteminfo = CreateFrame("Frame")
    ItemInfo.frame = CreateFrame("Frame")
    ItemInfo.scanningTooltip = CreateFrame("GameTooltip", "mUIScanningTooltip", nil, "GameTooltipTemplate")
    ItemInfo.scanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    ItemInfo.buttons = {}
    ItemInfo.LEGENDARY_ITEM_LEVEL = 483
    ItemInfo.STEP_ITEM_LEVEL = 17
    ItemInfo.levelThresholds = {}

    ItemInfo.buttonLayout = {
        [INVSLOT_HEAD] = "left",
        [INVSLOT_NECK] = "left",
        [INVSLOT_SHOULDER] = "left",
        [INVSLOT_BACK] = "left",
        [INVSLOT_CHEST] = "left",
        [INVSLOT_WRIST] = "left",

        [INVSLOT_HAND] = "right",
        [INVSLOT_WAIST] = "right",
        [INVSLOT_LEGS] = "right",
        [INVSLOT_FEET] = "right",
        [INVSLOT_FINGER1] = "right",
        [INVSLOT_FINGER2] = "right",
        [INVSLOT_TRINKET1] = "right",
        [INVSLOT_TRINKET2] = "right",

        [INVSLOT_MAINHAND] = "center",
        [INVSLOT_OFFHAND] = "center"
    }

    ItemInfo.characterSlots = {"CharacterHeadSlot", "CharacterNeckSlot", "CharacterShoulderSlot", "CharacterChestSlot",
                               "CharacterWaistSlot", "CharacterLegsSlot", "CharacterFeetSlot", "CharacterWristSlot",
                               "CharacterHandsSlot", "CharacterFinger0Slot", "CharacterFinger1Slot",
                               "CharacterTrinket0Slot", "CharacterTrinket1Slot", "CharacterBackSlot",
                               "CharacterMainHandSlot", "CharacterSecondaryHandSlot"}

    function ItemInfo:ColorGradient(perc, ...)
        if perc >= 1 then
            local r, g, b = select(select('#', ...) - 2, ...)
            return r, g, b
        elseif perc <= 0 then
            local r, g, b = ...
            return r, g, b
        end

        local num = select('#', ...) / 3

        local segment, relperc = math.modf(perc * (num - 1))
        local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

        return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
    end

    function ItemInfo:ColorGradientHP(perc)
        return ItemInfo:ColorGradient(perc, 1, 0, 0, 1, 1, 0, 0, 1, 0)
    end

    function ItemInfo:CreateAdditionalDisplayForButton(button)
        local parent = button:GetParent()
        local additionalFrame = CreateFrame("frame", nil, parent)
        additionalFrame:SetWidth(100)

        additionalFrame.ilvlDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")

        additionalFrame.durabilityDisplay = CreateFrame("StatusBar", nil, additionalFrame)
        additionalFrame.durabilityDisplay:SetMinMaxValues(0, 1)
        additionalFrame.durabilityDisplay:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        additionalFrame.durabilityDisplay:GetStatusBarTexture():SetHorizTile(false)
        additionalFrame.durabilityDisplay:GetStatusBarTexture():SetVertTile(false)
        additionalFrame.durabilityDisplay:SetHeight(40)
        additionalFrame.durabilityDisplay:SetWidth(2.3)
        additionalFrame.durabilityDisplay:SetOrientation("VERTICAL")

        return additionalFrame
    end

    function ItemInfo:positonLeft(button)
        local additionalFrame = button.mUIDisplay

        additionalFrame:SetPoint("TOPLEFT", button, "TOPRIGHT")
        additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT")

        additionalFrame.ilvlDisplay:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)

        additionalFrame.durabilityDisplay:SetPoint("TOPLEFT", button, "TOPLEFT", -6, 0)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -6, 0)
    end

    function ItemInfo:positonRight(button)
        local additionalFrame = button.mUIDisplay

        additionalFrame:SetPoint("TOPRIGHT", button, "TOPLEFT")
        additionalFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT")

        additionalFrame.ilvlDisplay:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)

        additionalFrame.durabilityDisplay:SetWidth(1.2)
        additionalFrame.durabilityDisplay:SetPoint("TOPRIGHT", button, "TOPRIGHT", 4, 0)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0)
    end

    function ItemInfo:positonCenter(button)
        local additionalFrame = button.mUIDisplay

        additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -100, 0)
        additionalFrame:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, -100)

        additionalFrame.durabilityDisplay:SetHeight(2)
        additionalFrame.durabilityDisplay:SetWidth(40)
        additionalFrame.durabilityDisplay:SetOrientation("HORIZONTAL")
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, -2)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -2)

        additionalFrame.ilvlDisplay:SetPoint("BOTTOM", button, "BOTTOM", 0, 2)
    end

    function ItemInfo:AnchorAdditionalDisplay(button)
        local layout = ItemInfo.buttonLayout[button:GetID()]
        if (layout == "left") then
            ItemInfo:positonLeft(button)
        elseif (layout == "right") then
            ItemInfo:positonRight(button)
        elseif (layout == "center") then
            ItemInfo:positonCenter(button)
        end
    end

    function ItemInfo:UpdateAdditionalDisplay(button, unit)
        local additionalFrame = button.mUIDisplay
        local slot = button:GetID()
        local itemLink = GetInventoryItemLink(unit, slot)

        additionalFrame.lastGUID = UnitGUID(unit)

        if (not additionalFrame.prevItemLink or itemLink ~= additionalFrame.prevItemLink) then
            local itemiLvlText = ""
            if (itemLink) then
                local ilvl = C_Item.GetDetailedItemLevelInfo(itemLink)
                local quality = GetInventoryItemQuality(unit, slot)
                if (quality) then
                    local hex = select(4, GetItemQualityColor(quality))
                    itemiLvlText = "|c" .. hex .. ilvl .. "|r"
                else
                    itemiLvlText = ilvl
                end
            end
            additionalFrame.ilvlDisplay:SetText(itemiLvlText)

            additionalFrame.prevItemLink = itemLink
        end

        local currentDurablity, maxDurability = GetInventoryItemDurability(slot)
        local percDurability = currentDurablity and currentDurablity / maxDurability

        if (not additionalFrame.prevDurability or additionalFrame.prevDurability ~= percDurability) then
            if (UnitIsUnit("player", unit) and percDurability and percDurability < 1) then
                additionalFrame.durabilityDisplay:Show()
                additionalFrame.durabilityDisplay:SetValue(percDurability)
                additionalFrame.durabilityDisplay:SetStatusBarColor(ItemInfo:ColorGradientHP(percDurability))
            else
                additionalFrame.durabilityDisplay:Hide()
            end
            additionalFrame.prevDurability = percDurability
        elseif not UnitIsUnit("player", unit) then
            additionalFrame.durabilityDisplay:Hide()
        end
    end

    function ItemInfo:CreateInspectIlvlDisplay()
        local parent = InspectPaperDollItemsFrame
        if (not parent.ilvlDisplay) then
            parent.ilvlDisplay = parent:CreateFontString(nil, "OVERLAY")
            parent.ilvlDisplay:SetFont(STANDARD_TEXT_FONT, 17, "THINOUTLINE")
            parent.ilvlDisplay:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -5, -30)

            ItemInfo.buttons[parent.ilvlDisplay] = true
        end
    end

    for i = 4, 1, -1 do
        ItemInfo.levelThresholds[i] = ItemInfo.LEGENDARY_ITEM_LEVEL - (ItemInfo.STEP_ITEM_LEVEL * (i - 1))
    end

    function ItemInfo:CalculatePreciseInspectItemLevel(unit)
        local totalItemLevel = 0
        local itemCount = 0

        -- Define the slots to check (same as character sheet)
        local slotsToCheck = {INVSLOT_HEAD, INVSLOT_NECK, INVSLOT_SHOULDER, INVSLOT_CHEST, INVSLOT_WAIST, INVSLOT_LEGS,
                              INVSLOT_FEET, INVSLOT_WRIST, INVSLOT_HAND, INVSLOT_FINGER1, INVSLOT_FINGER2,
                              INVSLOT_TRINKET1, INVSLOT_TRINKET2, INVSLOT_BACK, INVSLOT_MAINHAND, INVSLOT_OFFHAND}

        for _, slot in pairs(slotsToCheck) do
            local itemLink = GetInventoryItemLink(unit, slot)
            if itemLink then
                local itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
                if itemLevel and itemLevel > 0 then
                    totalItemLevel = totalItemLevel + itemLevel
                    itemCount = itemCount + 1
                end
            end
        end

        if itemCount > 0 then
            return totalItemLevel / itemCount
        else
            return 0
        end
    end

    function ItemInfo:UpdateInspectIlvlDisplay(unit)
        local ilvl = ItemInfo:CalculatePreciseInspectItemLevel(unit)
        local r, g, b
        if (ilvl < ItemInfo.levelThresholds[4]) then
            r, g, b = 0.98, 0.98, 0.98 -- fafafa
        elseif (ilvl < ItemInfo.levelThresholds[3]) then
            r, g, b = 0.12, 1.0, 0.0 -- 1eff00
        elseif (ilvl < ItemInfo.levelThresholds[2]) then
            r, g, b = 0.0, 0.44, 0.87 -- 0070dd
        elseif (ilvl < ItemInfo.levelThresholds[1]) then
            r, g, b = 0.64, 0.21, 0.93 -- a335ee
        else
            r, g, b = 1.0, 0.5, 0.0 -- ff8000
        end

        local parent = InspectPaperDollItemsFrame
        if ilvl == math.floor(ilvl) then
            parent.ilvlDisplay:SetText(string.format("%d", ilvl))
        else
            parent.ilvlDisplay:SetText(string.format("%.2f", ilvl))
        end
        parent.ilvlDisplay:SetTextColor(r, g, b, 1)
    end

    function ItemInfo:updateButton(button, unit)
        if (not ItemInfo.buttonLayout[button:GetID()]) then
            return
        end

        if (not button.mUIDisplay) then
            button.mUIDisplay = ItemInfo:CreateAdditionalDisplayForButton(button)
            ItemInfo:AnchorAdditionalDisplay(button)
            ItemInfo.buttons[button.mUIDisplay] = true
        end

        C_Timer.After(0.1, function()
            ItemInfo:UpdateAdditionalDisplay(button, unit)
        end)
    end

    function ItemInfo:MoveTalentButton(talentButton)
        talentButton:SetSize(72, 32)

        talentButton.Left:SetTexture(nil)
        talentButton.Left:SetTexCoord(0, 1, 0, 1)
        talentButton.Left:ClearAllPoints()
        talentButton.Left:SetPoint("TOPLEFT")
        talentButton.Left:SetAtlas("uiframe-tab-left", true)
        talentButton.Left:SetHeight(36)

        talentButton.Right:SetTexture(nil)
        talentButton.Right:SetTexCoord(0, 1, 0, 1)
        talentButton.Right:ClearAllPoints()
        talentButton.Right:SetPoint("TOPRIGHT", 6)
        talentButton.Right:SetAtlas("uiframe-tab-right", true)
        talentButton.Right:SetHeight(36)

        talentButton.Middle:SetTexture(nil)
        talentButton.Middle:SetTexCoord(0, 1, 0, 1)
        talentButton.Middle:ClearAllPoints()
        talentButton.Middle:SetPoint("LEFT", talentButton.Left, "RIGHT")
        talentButton.Middle:SetPoint("RIGHT", talentButton.Right, "LEFT")
        talentButton.Middle:SetAtlas("_uiframe-tab-center", true)
        talentButton.Middle:SetHeight(36)

        talentButton.LeftHighlight = talentButton:CreateTexture()
        talentButton.LeftHighlight:SetAtlas("uiframe-tab-left", true)
        talentButton.LeftHighlight:SetAlpha(0.4)
        talentButton.LeftHighlight:SetBlendMode("ADD")
        talentButton.LeftHighlight:SetPoint("TOPLEFT")
        talentButton.LeftHighlight:Hide()

        talentButton.RightHighlight = talentButton:CreateTexture()
        talentButton.RightHighlight:SetAtlas("uiframe-tab-right", true)
        talentButton.RightHighlight:SetAlpha(0.4)
        talentButton.RightHighlight:SetBlendMode("ADD")
        talentButton.RightHighlight:SetPoint("TOPRIGHT", 6)
        talentButton.RightHighlight:Hide()

        talentButton.MiddleHighlight = talentButton:CreateTexture()
        talentButton.MiddleHighlight:SetAtlas("_uiframe-tab-center", true)
        talentButton.MiddleHighlight:SetAlpha(0.4)
        talentButton.MiddleHighlight:SetBlendMode("ADD")
        talentButton.MiddleHighlight:SetPoint("LEFT", talentButton.Left, "RIGHT")
        talentButton.MiddleHighlight:SetPoint("RIGHT", talentButton.Right, "LEFT")
        talentButton.MiddleHighlight:Hide()

        talentButton:SetNormalFontObject(GameFontNormalSmall)
        talentButton:SetHighlightFontObject(GameFontHighlightSmall)
        talentButton:ClearHighlightTexture()
        talentButton.Text:ClearAllPoints()
        talentButton.Text:SetPoint("CENTER", 0, 2)
        talentButton.Text:SetHeight(10)

        talentButton:HookScript("OnEnter", function(ItemInfo)
            for _, v in ipairs({"MiddleHighlight", "LeftHighlight", "RightHighlight"}) do
                ItemInfo[v]:Show()
            end
        end)

        talentButton:HookScript("OnLeave", function(ItemInfo)
            for _, v in ipairs({"MiddleHighlight", "LeftHighlight", "RightHighlight"}) do
                ItemInfo[v]:Hide()
            end
        end)

        talentButton:SetScript("OnMouseDown", nil)
        talentButton:SetScript("OnMouseUp", nil)
        talentButton:SetScript("OnShow", nil)
        talentButton:SetScript("OnEnable", nil)
        talentButton:SetScript("OnDisable", nil)

        talentButton:ClearAllPoints()
        talentButton:SetPoint("LEFT", InspectFrameTab3, "RIGHT", 3, 0)
    end

    function ItemInfo:updateAllCharacterSlots()
        for _, slot in ipairs(ItemInfo.characterSlots) do
            local button = _G[slot]
            if (button) then
                ItemInfo:UpdateAdditionalDisplay(button, "player")
            end
        end
    end

    local lastUpdate = 0
    function ItemInfo:SOCKET_INFO_UPDATE()
        if (CharacterFrame:IsShown()) then
            local time = GetTime()
            if (time ~= lastUpdate) then
                ItemInfo:updateAllCharacterSlots()
                lastUpdate = time
            end
        end
    end

    function ItemInfo:UNIT_INVENTORY_CHANGED(unit)
        if (unit == "player") then
            ItemInfo:SOCKET_INFO_UPDATE()
        end
    end

    function ItemInfo:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    end

    -- Bag/Bank/Merchant Equipment ItemLevel
    -- Variables
    ItemInfo.levelstrings = {}
    function ItemInfo:MerchantItemlevel()
        local numItems = GetMerchantNumItems()

        for i = 1, MERCHANT_ITEMS_PER_PAGE do
            local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
            if index > numItems then
                return
            end

            local button = _G["MerchantItem" .. i .. "ItemButton"]
            if button and button:IsShown() then
                if not button.text then
                    button.text = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline")
                    button.text:SetPoint("CENTER", button, "BOTTOM", 0, 8)
                else
                    button.text:SetText("")
                end

                local itemLink = GetMerchantItemLink(index)
                if itemLink then
                    local _, _, quality, itemlevel, _, _, _, _, _, _, _, itemClassID = C_Item.GetItemInfo(itemLink)
                    if (itemlevel and itemlevel > 1) and (quality and quality > 1) and
                        (itemClassID == LE_ITEM_CLASS_WEAPON or itemClassID == LE_ITEM_CLASS_ARMOR) then
                        local _, _, _, color = C_Item.GetItemQualityColor(quality)
                        button.text:SetFormattedText('|c%s%s|r', color, itemlevel or '?')
                    end
                end
            end
        end
    end

    function ItemInfo:CreateItemLevelString(button)
        button.levelString = button:CreateFontString(nil, "OVERLAY")
        if ItemInfo.db.font ~= "None" then
            button.levelString:SetFont(ItemInfo.db.fontpath, 13, "OUTLINE")
        else
            button.levelString:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
        end
        button.levelString:SetPoint("CENTER", button, "BOTTOM", 0, 8)

        ItemInfo.levelstrings[button.levelString] = true
    end

    function ItemInfo:CheckContainerItems(item)
        local _, _, _, equipLoc, _, itemClass, itemSubClass = C_Item.GetItemInfoInstant(item:GetItemID())
        return (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor or
                   (itemClass == Enum.ItemClass.Gem and itemSubClass == Enum.ItemGemSubclass.Artifactrelic))
    end

    function ItemInfo:UpdateBagButton(button, item)
        if item:IsItemEmpty() then
            return
        end
        item:ContinueOnItemLoad(function()
            if not ItemInfo:CheckContainerItems(item) then
                return
            end
            local quality = item:GetItemQuality()
            if not item:GetCurrentItemLevel() then
                button.levelString:Hide()
            else
                ItemInfo:CreateItemLevelString(button)
                local _, _, _, hex = C_Item.GetItemQualityColor(quality)
                button.levelString:SetFormattedText('|c%s%s|r', hex, item:GetCurrentItemLevel() or '?')
                button.levelString:Show()
            end
        end)
    end

    function ItemInfo:UpdateContainerButton(button, bag, slot)
        if button.levelString then
            button.levelString:Hide()
        end

        local item = Item:CreateFromBagAndSlot(bag, slot or button:GetID())
        ItemInfo:UpdateBagButton(button, item)
    end

    function ItemInfo:Update(frame)
        for i = 1, frame.size do
            local button = _G[frame:GetName() .. "Item" .. i]
            ItemInfo:UpdateContainerButton(button, frame:GetID(), button:GetID())
        end
    end
end

function ItemInfo:OnEnable()
    -- CharacterFrame / InspectFrame Equipment Enchants, Gems and ItemLevels
    -- C_AddOns.LoadAddOn("Blizzard_InspectUI")

    ItemInfo:SecureHook("PaperDollItemSlotButton_Update", function(button)
        ItemInfo:updateButton(button, "player")
    end)

    if C_AddOns.IsAddOnLoaded("Blizzard_InspectUI") then
        if not ItemInfo:IsHooked("InspectPaperDollItemSlotButton_Update") then
            ItemInfo:SecureHook("InspectPaperDollItemSlotButton_Update", function(button)
                ItemInfo:updateButton(button, InspectFrame.unit)
            end)
        end

        if not ItemInfo:IsHooked("InspectPaperDollFrame_SetLevel") then
            ItemInfo:SecureHook("InspectPaperDollFrame_SetLevel", function()
                if not InspectFrame.unit then
                    return
                end
                ItemInfo:CreateInspectIlvlDisplay()
            end)
        end

        local talentButton = InspectPaperDollItemsFrame.InspectTalents
        mUI:Skin(talentButton)
    else
        ItemInfo.frame:RegisterEvent("ADDON_LOADED")
        ItemInfo:SecureHookScript(ItemInfo.frame, "OnEvent", function(_, _, addon)
            if addon == "Blizzard_InspectUI" then
                if not ItemInfo:IsHooked("InspectPaperDollItemSlotButton_Update") then
                    ItemInfo:SecureHook("InspectPaperDollItemSlotButton_Update", function(button)
                        ItemInfo:updateButton(button, InspectFrame.unit)
                    end)
                end

                if not ItemInfo:IsHooked("InspectPaperDollFrame_SetLevel") then
                    ItemInfo:SecureHook("InspectPaperDollFrame_SetLevel", function()
                        if not InspectFrame.unit then
                            return
                        end
                        ItemInfo:CreateInspectIlvlDisplay()
                    end)
                end

                local talentButton = InspectPaperDollItemsFrame.InspectTalents
                mUI:Skin(talentButton)
            end
        end)
    end

    ItemInfo.iteminfo:RegisterEvent("SOCKET_INFO_UPDATE")
    ItemInfo.iteminfo:RegisterEvent("UNIT_INVENTORY_CHANGED")
    ItemInfo.iteminfo:RegisterEvent("PLAYER_ENTERING_WORLD")
    ItemInfo:RawHookScript(ItemInfo.iteminfo, "OnEvent", function(_, event, ...)
        ItemInfo[event](ItemInfo, ...)
    end)

    for button in pairs(ItemInfo.buttons) do
        if not button:IsVisible() then
            button:Show()
        end
    end

    -- Bag/Bank/Merchant Equipment ItemLevel
    ItemInfo:SecureHook("MerchantFrame_UpdateMerchantInfo", function()
        ItemInfo:MerchantItemlevel()
    end)

    ItemInfo:SecureHook("ContainerFrame_Update", function(frame)
        ItemInfo:Update(frame)
    end)
end

function ItemInfo:OnDisable()
    ItemInfo:UnhookAll()

    -- CharacterFrame / InspectFrame Equipment Enchants, Gems and ItemLevels
    ItemInfo.iteminfo:UnregisterAllEvents()

    for button in pairs(ItemInfo.buttons) do
        button:Hide()
    end

    for levelString in pairs(ItemInfo.levelstrings) do
        levelString:Hide()
    end
end
