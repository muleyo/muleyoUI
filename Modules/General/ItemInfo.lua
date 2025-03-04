local ItemInfo = mUI:NewModule("mUI.Modules.General.ItemInfo", "AceHook-3.0")

function ItemInfo:OnInitialize()
    -- Load Database
    ItemInfo.db = mUI.db.profile.general
    ItemInfo.LSM = LibStub("LibSharedMedia-3.0")

    -- CharacterFrame / InspectFrame Equipment Enchants, Gems and ItemLevels
    -- Variables & Tables
    ItemInfo.iteminfo = CreateFrame("Frame")
    ItemInfo.frame = CreateFrame("Frame")
    ItemInfo.buttons = {}
    ItemInfo.LEGENDARY_ITEM_LEVEL = 483
    ItemInfo.STEP_ITEM_LEVEL = 17
    ItemInfo.levelThresholds = {}
    ItemInfo.NUM_SOCKET_TEXTURES = 4
    ItemInfo.expansionRequiredSockets = {
        [10] = {
            [INVSLOT_NECK] = 2,
            [INVSLOT_FINGER1] = 2,
            [INVSLOT_FINGER2] = 2,
        },
        [9] = {
            [INVSLOT_NECK] = 3,
        }
    }

    ItemInfo.expansionEnchantableSlots = {
        [10] = {
            [INVSLOT_BACK] = true,
            [INVSLOT_CHEST] = true,
            [INVSLOT_WRIST] = true,
            [INVSLOT_WRIST] = true,
            [INVSLOT_LEGS] = true,
            [INVSLOT_FEET] = true,
            [INVSLOT_MAINHAND] = true,
            [INVSLOT_FINGER1] = true,
            [INVSLOT_FINGER2] = true,
        },
        [9] = {
            [INVSLOT_HEAD] = true,
            [INVSLOT_BACK] = true,
            [INVSLOT_CHEST] = true,
            [INVSLOT_WRIST] = true,
            [INVSLOT_WAIST] = true,
            [INVSLOT_LEGS] = true,
            [INVSLOT_FEET] = true,
            [INVSLOT_MAINHAND] = true,
            [INVSLOT_FINGER1] = true,
            [INVSLOT_FINGER2] = true,
        },
    }

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
        [INVSLOT_OFFHAND] = "center",
    }

    ItemInfo.characterSlots = {
        "CharacterHeadSlot",
        "CharacterNeckSlot",
        "CharacterShoulderSlot",
        "CharacterChestSlot",
        "CharacterWaistSlot",
        "CharacterLegsSlot",
        "CharacterFeetSlot",
        "CharacterWristSlot",
        "CharacterHandsSlot",
        "CharacterFinger0Slot",
        "CharacterFinger1Slot",
        "CharacterTrinket0Slot",
        "CharacterTrinket1Slot",
        "CharacterBackSlot",
        "CharacterMainHandSlot",
        "CharacterSecondaryHandSlot",
    }

    ItemInfo.gemsWeCareAbout = {
        192991, -- Increased Primary Stat and Versatility
        192985, -- Increased Primary Stat and Haste
        192982, -- Increased Primary Stat and Critical Strike
        192988, -- Increased Primary Stat and Mastery

        192945, -- Increased Haste and Critical Strike
        192948, -- Increased Haste and Mastery
        192952, -- Increased Haste and Versatility
        192955, -- Increased Haste

        192961, -- Increased Mastery and Haste
        192958, -- Increased Mastery and Critical Strike
        192964, -- Increased Mastery and Versatility
        192967, -- Increased Mastery

        192919, -- Increased Critical Strike and Haste
        192925, -- Increased Critical Strike and Versatility
        192922, -- Increased Critical Strike and Mastery
        192928, -- Increased Critical Strike

        192935, -- Increased Versatility and Haste
        192932, -- Increased Versatility and Critical Strike
        192938, -- Increased Versatility and Mastery
        192942, -- Increased Versatility

        192973, -- Increased Stamina and Haste
        192970, -- Increased Stamina and Critical Strike
        192979, -- Increased Stamina and Versatility
        192976, -- Increased Stamina and Mastery
    }

    ItemInfo.enchantReplacementTable = {
        ["Stamina"] = "Stam",
        ["Intellect"] = "Int",
        ["Agility"] = "Agi",
        ["Strength"] = "Str",

        ["Mastery"] = "Mast",
        ["Versatility"] = "Vers",
        ["Critical Strike"] = "Crit",
        ["Haste"] = "Haste",
        ["Avoidance"] = "Avoid",

        ["Minor Speed Increase"] = "Speed",
        ["Homebound Speed"] = "Speed & HS Red.",
        ["Plainsrunner's Breeze"] = "Speed",
        ["Graceful Avoid"] = "Avoid",
        ["Regenerative Leech"] = "Leech",
        ["Watcher's Loam"] = "Stam",
        ["Rider's Reassurance"] = "Mount Speed",
        ["Accelerated Agility"] = "Speed & Agi",
        ["Reserve of Int"] = "Mana & Int",
        ["Sustained Str"] = "Stam & Str",
        ["Waking Stats"] = "Primary Stat",

        ["Cavalry's March"] = "Mount Speed",
        ["Scout's March"] = "Speed",

        ["Defender's March"] = "Stam",
        ["Stormrider's Agi"] = "Agi & Speed",
        ["Council's Intellect"] = "Int & Mana",
        ["Crystalline Radiance"] = "Primary Stat",
        ["Oathsworn's Strength"] = "Str & Stam",

        ["Chant of Armored Avoid"] = "Avoid",
        ["Chant of Armored Leech"] = "Leech",
        ["Chant of Armored Speed"] = "Speed",
        ["Chant of Winged Grace"] = "Avoid & FallDmg",
        ["Chant of Leeching Fangs"] = "Leech & Recup",
        ["Chant of Burrowing Rapidity"] = "Speed & HScd",

        ["Cursed Haste"] = "Haste & \124cffcc0000-Vers\124r",
        ["Cursed Crit"] = "Crit & \124cffcc0000-Haste\124r",
        ["Cursed Mastery"] = "Mast & \124cffcc0000-Crit\124r",
        ["Cursed Versatility"] = "Vers & \124cffcc0000-Mast\124r",

        ["Shadowed Belt Clasp"] = "Stamina",

        ["Incandescent Essence"] = "Essence",
        -- strip all +, we are starved for space
        ["+"] = "",
    }

    ItemInfo.enchantPattern = ENCHANTED_TOOLTIP_LINE:gsub('%%s', '(.*)')
    ItemInfo.enchantAtlasPattern = "(.*)%s*|A:(.*):20:20|a"
    ItemInfo.enchatColoredPatten = "|cn(.*):(.*)|r"

    -- Functions
    function ItemInfo:GetItemEnchantAsText(unit, slot)
        local data = C_TooltipInfo.GetInventoryItem(unit, slot)
        for _, line in ipairs(data.lines) do
            local text = line.leftText
            local enchantText = string.match(text, ItemInfo.enchantPattern)
            if (enchantText) then
                local maybeEnchantText, atlas
                local maybeEnchantColor, maybeEnchantTextColored = enchantText:match(ItemInfo.enchatColoredPatten)
                if (maybeEnchantColor) then
                    enchantText = maybeEnchantTextColored
                else
                    maybeEnchantText, atlas = enchantText:match(ItemInfo.enchantAtlasPattern)
                    enchantText = maybeEnchantText or enchantText
                end

                return atlas, ItemInfo:ProcessEnchantText(enchantText)
            end
        end

        return nil, nil
    end

    function ItemInfo:GetSocketTextures(unit, slot)
        local data = C_TooltipInfo.GetInventoryItem(unit, slot)
        local textures = {}
        for i, line in ipairs(data.lines) do
            if line.type == 3 then
                if (line.gemIcon) then
                    table.insert(textures, line.gemIcon)
                else
                    table.insert(textures,
                        string.format("Interface\\ItemSocketingFrame\\UI-EmptySocket-%s", line.socketType))
                end
            end
        end

        return textures
    end

    function ItemInfo:CanEnchantSlot(unit, slot)
        local expansion = GetExpansionForLevel(UnitLevel(unit))
        local slotsThatHaveEnchants = expansion and ItemInfo.expansionEnchantableSlots[expansion] or {}

        -- all classes have something that increases power or survivability on chest/cloak/weapons/rings/wrist/boots/legs
        if (slotsThatHaveEnchants[slot]) then
            return true
        end

        -- Offhand filtering smile :)
        if (slot == INVSLOT_OFFHAND) then
            local offHandItemLink = GetInventoryItemLink(unit, slot)
            if (offHandItemLink) then
                local itemEquipLoc = select(4, GetItemInfoInstant(offHandItemLink))
                return itemEquipLoc ~= "INVTYPE_HOLDABLE" and itemEquipLoc ~= "INVTYPE_SHIELD"
            end
            return false
        end

        return false
    end

    function ItemInfo:pairsByKeys(t, f)
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0             -- iterator variable
        local iter = function() -- iterator function
            i = i + 1
            if a[i] == nil then
                return nil
            else
                return a[i], t[a[i]]
            end
        end
        return iter
    end

    function ItemInfo:ProcessEnchantText(enchantText)
        for seek, replacement in ItemInfo:pairsByKeys(ItemInfo.enchantReplacementTable) do
            enchantText = enchantText:gsub(seek, replacement)
        end
        return enchantText
    end

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

    function ItemInfo:AnchorTextureLeftOfParent(parent, textures)
        textures[1]:SetPoint("RIGHT", parent, "LEFT", -3, 1)
        for i = 2, ItemInfo.NUM_SOCKET_TEXTURES do
            textures[i]:SetPoint("RIGHT", textures[i - 1], "LEFT", -2, 0)
        end
    end

    function ItemInfo:AnchorTextureRightOfParent(parent, textures)
        textures[1]:SetPoint("LEFT", parent, "RIGHT", 3, 1)
        for i = 2, ItemInfo.NUM_SOCKET_TEXTURES do
            textures[i]:SetPoint("LEFT", textures[i - 1], "RIGHT", 2, 0)
        end
    end

    function ItemInfo:CreateAdditionalDisplayForButton(button)
        local parent = button:GetParent()
        local additionalFrame = CreateFrame("frame", nil, parent)
        additionalFrame:SetWidth(100)

        additionalFrame.ilvlDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")

        additionalFrame.enchantDisplay = additionalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline")
        additionalFrame.enchantDisplay:SetTextColor(0, 1, 0, 1)

        additionalFrame.durabilityDisplay = CreateFrame("StatusBar", nil, additionalFrame)
        additionalFrame.durabilityDisplay:SetMinMaxValues(0, 1)
        additionalFrame.durabilityDisplay:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
        additionalFrame.durabilityDisplay:GetStatusBarTexture():SetHorizTile(false)
        additionalFrame.durabilityDisplay:GetStatusBarTexture():SetVertTile(false)
        additionalFrame.durabilityDisplay:SetHeight(40)
        additionalFrame.durabilityDisplay:SetWidth(2.3)
        additionalFrame.durabilityDisplay:SetOrientation("VERTICAL")

        additionalFrame.socketDisplay = {}

        for i = 1, ItemInfo.NUM_SOCKET_TEXTURES do
            additionalFrame.socketDisplay[i] = additionalFrame:CreateTexture()
            additionalFrame.socketDisplay[i]:SetWidth(14)
            additionalFrame.socketDisplay[i]:SetHeight(14)
        end

        return additionalFrame
    end

    function ItemInfo:positonLeft(button)
        local additionalFrame = button.BCPDisplay

        additionalFrame:SetPoint("TOPLEFT", button, "TOPRIGHT")
        additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT")

        additionalFrame.ilvlDisplay:SetPoint("BOTTOMLEFT", additionalFrame, "BOTTOMLEFT", 10, 2)
        additionalFrame.enchantDisplay:SetPoint("TOPLEFT", additionalFrame, "TOPLEFT", 10, -7)

        additionalFrame.durabilityDisplay:SetPoint("TOPLEFT", button, "TOPLEFT", -6, 0)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -6, 0)

        ItemInfo:AnchorTextureRightOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay)
    end

    function ItemInfo:positonRight(button)
        local additionalFrame = button.BCPDisplay

        additionalFrame:SetPoint("TOPRIGHT", button, "TOPLEFT")
        additionalFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT")

        additionalFrame.ilvlDisplay:SetPoint("BOTTOMRIGHT", additionalFrame, "BOTTOMRIGHT", -10, 2)
        additionalFrame.enchantDisplay:SetPoint("TOPRIGHT", additionalFrame, "TOPRIGHT", -10, -7)

        additionalFrame.durabilityDisplay:SetWidth(1.2)
        additionalFrame.durabilityDisplay:SetPoint("TOPRIGHT", button, "TOPRIGHT", 4, 0)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, 0)

        ItemInfo:AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay)
    end

    function ItemInfo:positonCenter(button)
        local additionalFrame = button.BCPDisplay

        additionalFrame:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", -100, 0)
        additionalFrame:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, -100)

        additionalFrame.durabilityDisplay:SetHeight(2)
        additionalFrame.durabilityDisplay:SetWidth(40)
        additionalFrame.durabilityDisplay:SetOrientation("HORIZONTAL")
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, -2)
        additionalFrame.durabilityDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, -2)

        additionalFrame.ilvlDisplay:SetPoint("BOTTOM", button, "TOP", 0, 7)

        if (button:GetID() == INVSLOT_MAINHAND) then
            additionalFrame.enchantDisplay:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -5, 0)
            ItemInfo:AnchorTextureLeftOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay)
        else
            additionalFrame.enchantDisplay:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 5, 0)
            ItemInfo:AnchorTextureRightOfParent(additionalFrame.ilvlDisplay, additionalFrame.socketDisplay)
        end
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
        local additionalFrame = button.BCPDisplay
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

            local atlas, enchantText
            if itemLink then
                atlas, enchantText = ItemInfo:GetItemEnchantAsText(unit, slot)
            end

            local canEnchant = ItemInfo:CanEnchantSlot(unit, slot)

            if (not enchantText) then
                local shouldDisplayEchantMissingText = canEnchant and itemLink and
                    IsLevelAtEffectiveMaxLevel(UnitLevel(unit))
                additionalFrame.enchantDisplay:SetText(shouldDisplayEchantMissingText and "|cffff0000No Enchant|r" or
                    "")
            else
                --trim size
                local maxSize = 18
                local containsColor = string.find(enchantText, "|c")
                if (containsColor) then
                    maxSize = maxSize + strlen("|cffffffff|r")
                end
                enchantText = string.sub(enchantText, 1, maxSize)

                local enchantQuality = ""
                if atlas then
                    enchantQuality = "|A:" .. atlas .. ":12:12|a"
                end

                -- for symmetry, put quality on the left of offhand
                if slot == INVSLOT_OFFHAND then
                    additionalFrame.enchantDisplay:SetText(enchantQuality .. enchantText)
                else
                    additionalFrame.enchantDisplay:SetText(enchantText .. enchantQuality)
                end
            end

            local textures = itemLink and ItemInfo:GetSocketTextures(unit, slot) or {}
            for i = 1, ItemInfo.NUM_SOCKET_TEXTURES do
                local socketTexture = additionalFrame.socketDisplay[i]
                if (#textures >= i) then
                    socketTexture:SetTexture(textures[i])
                    socketTexture:SetVertexColor(1, 1, 1)
                    socketTexture:Show()
                else
                    local expansion = GetExpansionForLevel(UnitLevel(unit))
                    local expansionSocketRequirement = expansion and ItemInfo.expansionRequiredSockets[expansion]
                    if (expansionSocketRequirement and expansionSocketRequirement[slot] and i <= expansionSocketRequirement[slot]) then
                        socketTexture:SetTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket-Red")
                        socketTexture:SetVertexColor(1, 0, 0)
                        socketTexture:Show()
                    else
                        socketTexture:Hide()
                    end
                end
            end

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
            parent.ilvlDisplay = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline22")
            parent.ilvlDisplay:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -20)
            parent.ilvlDisplay:SetPoint("BOTTOMLEFT", parent, "TOPRIGHT", -80, -67)

            ItemInfo.buttons[parent.ilvlDisplay] = true
        end
    end

    for i = 4, 1, -1 do
        ItemInfo.levelThresholds[i] = ItemInfo.LEGENDARY_ITEM_LEVEL - (ItemInfo.STEP_ITEM_LEVEL * (i - 1))
    end

    function ItemInfo:UpdateInspectIlvlDisplay(unit)
        local ilvl = C_PaperDollInfo.GetInspectItemLevel(unit)
        local color
        if (ilvl < ItemInfo.levelThresholds[4]) then
            color = "fafafa"
        elseif (ilvl < ItemInfo.levelThresholds[3]) then
            color = "1eff00"
        elseif (ilvl < ItemInfo.levelThresholds[2]) then
            color = "0070dd"
        elseif (ilvl < ItemInfo.levelThresholds[1]) then
            color = "a335ee"
        else
            color = "ff8000"
        end

        local parent = InspectPaperDollItemsFrame
        parent.ilvlDisplay:SetText(string.format("|cff%s%d|r", color, ilvl))
    end

    function ItemInfo:updateButton(button, unit)
        if (not ItemInfo.buttonLayout[button:GetID()]) then return end

        if (not button.BCPDisplay) then
            button.BCPDisplay = ItemInfo:CreateAdditionalDisplayForButton(button)
            ItemInfo:AnchorAdditionalDisplay(button)
            ItemInfo.buttons[button.BCPDisplay] = true
        end

        ItemInfo:UpdateAdditionalDisplay(button, unit)
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
            for _, v in ipairs({ "MiddleHighlight", "LeftHighlight", "RightHighlight" }) do
                ItemInfo[v]:Show()
            end
        end)

        talentButton:HookScript("OnLeave", function(ItemInfo)
            for _, v in ipairs({ "MiddleHighlight", "LeftHighlight", "RightHighlight" }) do
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
        for _, gemID in ipairs(ItemInfo.gemsWeCareAbout) do
            C_Item.RequestLoadItemDataByID(gemID)
        end
    end

    ItemInfo:HookScript(CharacterFrame, "OnUpdate", function()
        local _, equippedItemLevel = GetAverageItemLevel()
        local itemLevelText
        if equippedItemLevel == math.floor(equippedItemLevel) then
            itemLevelText = string.format("%d", equippedItemLevel)
        else
            itemLevelText = string.format("%.2f", equippedItemLevel)
        end
        CharacterStatsPane.ItemLevelFrame.Value:SetText(itemLevelText)
    end)

    -- Bag/Bank/Merchant Equipment ItemLevel
    -- Variables
    ItemInfo.levelstrings = {}
    function ItemInfo:MerchantItemlevel()
        local numItems = GetMerchantNumItems()

        for i = 1, MERCHANT_ITEMS_PER_PAGE do
            local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
            if index > numItems then return end

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
        return (itemClass == Enum.ItemClass.Weapon or itemClass == Enum.ItemClass.Armor or (itemClass == Enum.ItemClass.Gem and itemSubClass == Enum.ItemGemSubclass.Artifactrelic))
    end

    function ItemInfo:UpdateBagButton(button, item)
        if item:IsItemEmpty() then return end
        item:ContinueOnItemLoad(function()
            if not ItemInfo:CheckContainerItems(item) then return end
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
        if button.levelString then button.levelString:Hide() end

        local item = Item:CreateFromBagAndSlot(bag, slot or button:GetID())
        ItemInfo:UpdateBagButton(button, item)
    end

    function ItemInfo:Update(frame)
        for _, itemButton in frame:EnumerateValidItems() do
            ItemInfo:UpdateContainerButton(itemButton, itemButton:GetBagID(), itemButton:GetID())
        end
    end
end

function ItemInfo:OnEnable()
    -- CharacterFrame / InspectFrame Equipment Enchants, Gems and ItemLevels
    --C_AddOns.LoadAddOn("Blizzard_InspectUI")

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
                if not InspectFrame.unit then return end
                ItemInfo:CreateInspectIlvlDisplay()
                ItemInfo:UpdateInspectIlvlDisplay(InspectFrame.unit)
            end)
        end

        local talentButton = InspectPaperDollItemsFrame.InspectTalents
        ItemInfo:MoveTalentButton(talentButton)
        mUI:Skin(talentButton)
    else
        ItemInfo.frame:RegisterEvent("ADDON_LOADED")
        ItemInfo:HookScript(ItemInfo.frame, "OnEvent", function(_, _, addon)
            if addon == "Blizzard_InspectUI" then
                if not ItemInfo:IsHooked("InspectPaperDollItemSlotButton_Update") then
                    ItemInfo:SecureHook("InspectPaperDollItemSlotButton_Update", function(button)
                        ItemInfo:updateButton(button, InspectFrame.unit)
                    end)
                end

                if not ItemInfo:IsHooked("InspectPaperDollFrame_SetLevel") then
                    ItemInfo:SecureHook("InspectPaperDollFrame_SetLevel", function()
                        if not InspectFrame.unit then return end
                        ItemInfo:CreateInspectIlvlDisplay()
                        ItemInfo:UpdateInspectIlvlDisplay(InspectFrame.unit)
                    end)
                end

                local talentButton = InspectPaperDollItemsFrame.InspectTalents
                ItemInfo:MoveTalentButton(talentButton)
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
    ItemInfo:SecureHook(ContainerFrameCombinedBags, "UpdateItems", function(frame)
        ItemInfo:Update(frame)
    end)

    for _, container in ipairs(ContainerFrameContainer.ContainerFrames) do
        ItemInfo:SecureHook(container, "UpdateItems", function(frame)
            ItemInfo:Update(frame)
        end)
    end
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
