local Friendlist = mUI:NewModule("mUI.Modules.General.Friendlist", "AceHook-3.0")

function Friendlist:OnInitialize()
    -- Variables
    Friendlist.pause = false
    Friendlist.classes = {}

    for className, localizedClass in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
        Friendlist.classes[localizedClass] = className
    end

    for className, localizedClass in pairs(LOCALIZED_CLASS_NAMES_MALE) do
        Friendlist.classes[localizedClass] = className
    end

    function Friendlist:AddFieldAlias(data, isBNet)
        local function first(...)
            local temp
            for _, v in ipairs({ ... }) do
                temp = data[v]
                if temp ~= nil then
                    return temp, temp, temp
                end
            end
            return temp, temp, temp
        end

        data.bnet = isBNet
        data.isBNet = isBNet
        data.level, data.characterLevel = first("characterLevel", "level")
        data.class, data.className = first("className", "class")
        data.race, data.raceName = first("raceName", "race")
        data.faction, data.factionName = first("factionName", "faction")
        data.area, data.areaName = first("areaName", "area")
        data.connected, data.isOnline = first("isOnline", "connected")
        data.mobile, data.isWowMobile = first("isWowMobile", "mobile")
        data.afk, data.isAFK, data.isGameAFK = first("isGameAFK", "isAFK", "afk")
        data.dnd, data.isDND, data.isGameBusy = first("isGameBusy", "isDND", "dnd")
    end

    function Friendlist:GetFriendInfo(query)
        local info
        if type(query) == "number" then
            info = C_FriendList.GetFriendInfoByIndex(query)
        end
        if type(query) == "string" then
            info = C_FriendList.GetFriendInfo(query)
        end
        if not info then
            return
        end
        Friendlist:AddFieldAlias(info)
        return info
    end

    function Friendlist:MergeTable(destination, source)
        for k, v in pairs(source) do
            destination[k] = v
        end
        return destination
    end

    function Friendlist:BNGetFriendGameAccountInfo(friendIndex, accountIndex, wowAccountGUID)
        local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex)
        local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex, wowAccountGUID)
        if not gameAccountInfo and not accountInfo then
            return
        end
        return Friendlist:MergeTable(gameAccountInfo or {}, accountInfo or {})
    end

    function Friendlist:PackageFriendBNetCharacter(data, id)
        for i = 1, C_BattleNet.GetFriendNumGameAccounts(id) do
            local temp = Friendlist:BNGetFriendGameAccountInfo(id, i)
            if temp and temp.clientProgram == BNET_CLIENT_WOW then
                for k, v in pairs(temp) do
                    data[k] = v
                end
                break
            end
        end
        Friendlist:AddFieldAlias(data, true)
        return data
    end

    function Friendlist:PackageFriend(buttonType, id)
        local temp = {}
        if buttonType == FRIENDS_BUTTON_TYPE_BNET then
            temp.type = buttonType
            temp.data = Friendlist:PackageFriendBNetCharacter(C_BattleNet.GetFriendAccountInfo(id), id)
        elseif buttonType == FRIENDS_BUTTON_TYPE_WOW then
            temp.type = buttonType
            temp.data = Friendlist:GetFriendInfo(id)
        end

        if temp.data then
            return temp
        end
    end

    function Friendlist:SetText(frame, ...)
        if Friendlist.pause then return end
        local button = frame:GetParent()
        local buttonType, id = button.buttonType, button.id
        if buttonType ~= FRIENDS_BUTTON_TYPE_BNET and buttonType ~= FRIENDS_BUTTON_TYPE_WOW then
            return
        end
        local friendWrapper = Friendlist:PackageFriend(buttonType, id)
        if not friendWrapper then return end

        if friendWrapper.data.class and friendWrapper.data.class ~= "Unknown" then
            Friendlist.pause = true
            local accountName = friendWrapper.data.accountName
            local level = friendWrapper.data.level
            local characterName = friendWrapper.data.characterName
            local class = friendWrapper.data.class
            local color = RAID_CLASS_COLORS[Friendlist.classes[class]]:GenerateHexColorNoAlpha()

            if level == GetMaxLevelForLatestExpansion() then
                frame:SetText("|cff" .. color .. accountName .. " [" .. characterName .. "]|r")
            else
                frame:SetText("|cff" .. color .. accountName .. " [" .. characterName .. " - " .. level .. "]|r")
            end
        end
        Friendlist.pause = false
    end

    function Friendlist:HookButtons(buttons)
        for i = 1, #buttons do
            local button = buttons[i]
            if button.name and not Friendlist.buttons[button.name] then
                Friendlist.buttons[button.name] = true
                Friendlist:SecureHook(button.name, "SetText", function(frame, ...)
                    Friendlist:SetText(frame, ...)
                end)
            end
        end
    end

    function Friendlist:Update()
        local view = FriendsListFrame.ScrollBox:GetView()

        view:RegisterCallback(ScrollBoxListMixin.Event.OnAcquiredFrame, function(_, button, created)
            if created then
                if Friendlist.disabled then return end
                Friendlist:HookButtons({ button })
            end
        end)
    end
end

function Friendlist:OnEnable()
    Friendlist:Update()
    Friendlist.buttons = {}
    Friendlist.disabled = false
end

function Friendlist:OnDisable()
    Friendlist.disabled = true
    Friendlist:UnhookAll()
end
