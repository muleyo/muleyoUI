local Friendlist = mUI:NewModule("mUI.Modules.General.Friendlist")

function Friendlist:OnInitialize()
    -- Variables
    self.pause = false
    self.classes = {
        ["Warrior"] = "WARRIOR",
        ["Death Knight"] = "DEATHKNIGHT",
        ["Paladin"] = "PALADIN",
        ["Hunter"] = "HUNTER",
        ["Rogue"] = "ROGUE",
        ["Priest"] = "PRIEST",
        ["Shaman"] = "SHAMAN",
        ["Mage"] = "MAGE",
        ["Warlock"] = "WARLOCK",
        ["Monk"] = "MONK",
        ["Druid"] = "DRUID",
        ["Demon Hunter"] = "DEMONHUNTER",
        ["Evoker"] = "EVOKER",
    }

    function self:AddFieldAlias(data, isBNet)
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

    function self:GetFriendInfo(query)
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
        self:AddFieldAlias(info)
        return info
    end

    function self:MergeTable(destination, source)
        for k, v in pairs(source) do
            destination[k] = v
        end
        return destination
    end

    function self:BNGetFriendGameAccountInfo(friendIndex, accountIndex, wowAccountGUID)
        local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex)
        local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex, wowAccountGUID)
        if not gameAccountInfo and not accountInfo then
            return
        end
        return self:MergeTable(gameAccountInfo or {}, accountInfo or {})
    end

    function self:PackageFriendBNetCharacter(data, id)
        for i = 1, C_BattleNet.GetFriendNumGameAccounts(id) do
            local temp = self:BNGetFriendGameAccountInfo(id, i)
            if temp and temp.clientProgram == BNET_CLIENT_WOW then
                for k, v in pairs(temp) do
                    data[k] = v
                end
                break
            end
        end
        self:AddFieldAlias(data, true)
        return data
    end

    function self:PackageFriend(buttonType, id)
        local temp = {}
        if buttonType == FRIENDS_BUTTON_TYPE_BNET then
            temp.type = buttonType
            temp.data = self:PackageFriendBNetCharacter(C_BattleNet.GetFriendAccountInfo(id), id)
        elseif buttonType == FRIENDS_BUTTON_TYPE_WOW then
            temp.type = buttonType
            temp.data = self:GetFriendInfo(id)
        end

        if temp.data then
            return temp
        end
    end

    function self:SetText(frame, ...)
        if self.pause then return end
        local button = frame:GetParent()
        local buttonType, id = button.buttonType, button.id
        if buttonType ~= FRIENDS_BUTTON_TYPE_BNET and buttonType ~= FRIENDS_BUTTON_TYPE_WOW then
            return
        end
        local friendWrapper = self:PackageFriend(buttonType, id)
        if not friendWrapper then return end

        if friendWrapper.data.class then
            self.pause = true
            local accountName = friendWrapper.data.accountName
            local level = friendWrapper.data.level
            local characterName = friendWrapper.data.characterName
            local class = friendWrapper.data.class
            local classcolor = RAID_CLASS_COLORS[self.classes[class]]
            local color = format("%02X%02X%02X", floor(classcolor.r * 255), floor(classcolor.g * 255),
                floor(classcolor.b * 255))

            if level == GetMaxLevelForLatestExpansion() then
                frame:SetText("|cff" .. color .. accountName .. " [" .. characterName .. "]|r")
            else
                frame:SetText("|cff" .. color .. accountName .. " [" .. characterName .. " - " .. level .. "]|r")
            end
        end
        self.pause = false
    end

    function self:HookButtons(buttons)
        for i = 1, #buttons do
            local button = buttons[i]
            if button.name and not self.buttons[button.name] then
                self.buttons[button.name] = true
                mUI:SecureHook(button.name, "SetText", function(frame, ...)
                    self:SetText(frame, ...)
                end)
            end
        end
    end

    function self:Update()
        local view = FriendsListFrame.ScrollBox:GetView()

        view:RegisterCallback(ScrollBoxListMixin.Event.OnAcquiredFrame, function(_, button, created)
            if created then
                if self.disabled then return end
                self:HookButtons({ button })
            end
        end)
    end
end

function Friendlist:OnEnable()
    self:Update()
    self.buttons = {}
    self.disabled = false
end

function Friendlist:OnDisable()
    self.disabled = true
    for button in pairs(self.buttons) do
        mUI:Unhook(button, "SetText")
    end
end
