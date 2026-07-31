local PlayerLinks = mUI:NewModule("mUI.Modules.Misc.PlayerLinks", "AceHook-3.0")

function PlayerLinks:OnInitialize()
    local regionMap = {
        [1] = "us",
        [2] = "kr",
        [3] = "eu",
        [4] = "tw",
        [5] = "cn"
    }

    local RU_REALM_EN = {
        ["Азурегос"] = "Azuregos",
        ["Борейскаятундра"] = "Borean Tundra",
        ["ВечнаяПесня"] = "Eversong",
        ["Галакронд"] = "Galakrond",
        ["Голдринн"] = "Goldrinn",
        ["Гордунни"] = "Gordunni",
        ["Дракономор"] = "Draenor",
        ["Король-лич"] = "Lich King",
        ["Пиратскаябухта"] = "Pirates' Cove",
        ["Разувий"] = "Razuvious",
        ["Ревущийфьорд"] = "Howling Fjord",
        ["СвежевательДуш"] = "Soulflayer",
        ["Седогрив"] = "Greymane",
        ["СтражСмерти"] = "Deathguard",
        ["Термоштепсель"] = "Thermaplugg",
        ["ТкачСмерти"] = "Deathweaver",
        ["ЧёрныйШрам"] = "Blackscar",
        ["Ясеневыйлес"] = "Ashenvale"
    }

    local function ResolveRealm(realm)
        if not realm then
            return nil
        end
        if string.find(realm, "[\208-\209]") then
            return RU_REALM_EN[string.gsub(realm, "%s+", "")]
        end
        return realm
    end

    local function CyrillicLower(s)
        return (s:gsub("[\208-\209][\128-\191]", function(c)
            local b1, b2 = c:byte(1, 2)
            local cp = (b1 - 0xC0) * 0x40 + (b2 - 0x80)
            if cp >= 0x410 and cp <= 0x42F then
                cp = cp + 0x20
            elseif cp == 0x401 then
                cp = 0x451
            else
                return c
            end
            return string.char(0xC0 + math.floor(cp / 0x40), 0x80 + (cp % 0x40))
        end))
    end

    local function ToDashSlug(realm)
        realm = string.gsub(realm, "(%l)(%u)", "%1 %2")
        realm = string.gsub(realm, "'", "")
        realm = CyrillicLower(realm)
        return string.lower(string.gsub(realm, "%s+", "-"))
    end

    local function RaiderIoSlug(realm)
        realm = ResolveRealm(realm)
        if not realm then
            return nil
        end
        return ToDashSlug(realm)
    end

    local function WarcraftLogsSlug(realm)
        if not realm then
            return nil
        end
        return ToDashSlug(realm)
    end

    local function CheckPvpSlug(realm)
        realm = ResolveRealm(realm)
        if not realm then
            return nil
        end
        realm = string.gsub(realm, "(%l)(%u)", "%1 %2")
        return (string.gsub(realm, " ", "%%20"))
    end

    local playerRegion = regionMap[GetCurrentRegion()] or "eu"

    local function AppendLinks(rootDescription, name, realm, region)
        if rootDescription._mUIPlayerLinks then
            return
        end

        rootDescription._mUIPlayerLinks = true

        region = region or playerRegion

        rootDescription:CreateDivider()
        rootDescription:CreateTitle("|cff009cffm|r|cffffd100UI|r Player Links")

        local wlogs = WarcraftLogsSlug(realm)
        local rio = RaiderIoSlug(realm)
        local cpvp = CheckPvpSlug(realm)

        if wlogs then
            rootDescription:CreateButton("WarcraftLogs", function()
                mUI:Link("https://www.warcraftlogs.com/character/" .. region .. "/" .. wlogs .. "/" .. name)
            end)
        end

        if rio then
            rootDescription:CreateButton("Raider.io", function()
                mUI:Link("https://raider.io/characters/" .. region .. "/" .. rio .. "/" .. name)
            end)
        end

        if cpvp then
            rootDescription:CreateButton("CheckPVP", function()
                mUI:Link("https://www.check-pvp.fr/" .. region .. "/" .. cpvp .. "/" .. name)
            end)
        end
    end

    local function ParseNameRealm(fullName, server)
        if not fullName then
            return nil
        end
        local name, realm
        if string.find(fullName, "-") then
            name, realm = string.match(fullName, "^(.+)-(.+)$")
        else
            name = fullName
            if server and server ~= "" then
                realm = server
            else
                realm = GetNormalizedRealmName()
            end
        end
        if not name or not realm or realm == "" then
            return nil
        end
        return name, realm
    end

    -- Handler for standard Menu.ModifyMenu hooks (unit frames, party, etc.)
    local function OnModifyMenu(owner, rootDescription, contextData)
        if not PlayerLinks:IsEnabled() then
            return
        end

        local name, realm

        if contextData.unit then
            name, realm = UnitName(contextData.unit)

            if name and not realm then
                realm = GetNormalizedRealmName()
            end
        end

        if issecretvalue(contextData.name) then
            return
        end

        if not name and contextData.name then
            name, realm = ParseNameRealm(contextData.name, contextData.server)
        end

        if not name or not realm then
            return
        end

        AppendLinks(rootDescription, name, realm)
    end

    local function OnModifyBNMenu(owner, rootDescription, contextData)
        if not PlayerLinks:IsEnabled() then
            return
        end

        local bnetID = contextData.bnetIDAccount
        if not bnetID then
            return
        end

        local accountInfo = C_BattleNet and C_BattleNet.GetAccountInfoByID and C_BattleNet.GetAccountInfoByID(bnetID)
        if not accountInfo then
            return
        end

        local gameInfo = accountInfo.gameAccountInfo
        if not gameInfo or gameInfo.clientProgram ~= BNET_CLIENT_WOW then
            return
        end
        if gameInfo.wowProjectID and gameInfo.wowProjectID ~= WOW_PROJECT_ID then
            return
        end

        local name = gameInfo.characterName
        local realm = gameInfo.realmName
        if not name or name == "" or not realm or realm == "" then
            return
        end

        local region = regionMap[gameInfo.regionID] or playerRegion
        AppendLinks(rootDescription, name, realm, region)
    end

    -- Try to extract player name from an LFG owner frame
    local function GetLFGPlayerName(owner)
        if not owner then
            return nil
        end

        -- Search results: browsing groups in the LFG list
        local resultID = owner.resultID
        if not resultID and owner.GetParent then
            local parent = owner:GetParent()
            if parent then
                resultID = resultID or parent.resultID
            end
        end

        if resultID then
            local searchResultInfo = securecallfunction(C_LFGList.GetSearchResultInfo, resultID)
            if searchResultInfo and searchResultInfo.leaderName then
                return searchResultInfo.leaderName
            end
        end

        -- Applicant viewer: someone applied to your group
        local applicantID = owner.applicantID
        local memberIdx = owner.memberIdx

        if not applicantID and owner.GetParent then
            local parent = owner:GetParent()
            if parent then
                applicantID = applicantID or parent.applicantID
                memberIdx = memberIdx or parent.memberIdx
            end
        end

        if applicantID and memberIdx then
            local name = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx)
            return name
        end

        return nil
    end

    PlayerLinks.hooked = false
    PlayerLinks.modifyMenuHandler = OnModifyMenu
    PlayerLinks.modifyBNMenuHandler = OnModifyBNMenu
    PlayerLinks.appendLinks = AppendLinks
    PlayerLinks.parseNameRealm = ParseNameRealm
    PlayerLinks.getLFGPlayerName = GetLFGPlayerName
end

function PlayerLinks:OnEnable()
    if not PlayerLinks.hooked then
        -- Standard unit frame menus, chat names, guild/community rosters
        local menus = {"MENU_UNIT_SELF", "MENU_UNIT_PARTY", "MENU_UNIT_PLAYER", "MENU_UNIT_RAID_PLAYER", "MENU_UNIT_ENEMY_PLAYER", "MENU_UNIT_FRIEND",
                       "MENU_UNIT_GUILD", "MENU_UNIT_GUILD_OFFLINE", "MENU_UNIT_COMMUNITIES_GUILD_MEMBER", "MENU_UNIT_COMMUNITIES_WOW_MEMBER",
                       "MENU_UNIT_CHAT_ROSTER"}

        for _, tag in ipairs(menus) do
            Menu.ModifyMenu(tag, PlayerLinks.modifyMenuHandler)
        end

        -- Battle.net friend menus (online + offline)
        local bnMenus = {"MENU_UNIT_BN_FRIEND", "MENU_UNIT_BN_FRIEND_OFFLINE"}
        for _, tag in ipairs(bnMenus) do
            Menu.ModifyMenu(tag, PlayerLinks.modifyBNMenuHandler)
        end

        -- Hook MenuUtil.CreateContextMenu
        local isRecreating = false
        if not PlayerLinks:IsHooked(MenuUtil, "CreateContextMenu") then
            PlayerLinks:SecureHook(MenuUtil, "CreateContextMenu", function(owner, generator, ...)
                if isRecreating or not PlayerLinks:IsEnabled() then
                    return
                end

                local lfgFullName = PlayerLinks.getLFGPlayerName(owner)
                if not lfgFullName then
                    return
                end

                local lfgName, lfgRealm = PlayerLinks.parseNameRealm(lfgFullName)
                if not lfgName or not lfgRealm then
                    return
                end

                isRecreating = true
                MenuUtil.CreateContextMenu(owner, function(ownerInner, rootDescription)
                    generator(ownerInner, rootDescription)
                    PlayerLinks.appendLinks(rootDescription, lfgName, lfgRealm)
                end, ...)
                isRecreating = false
            end)
        end

        PlayerLinks.hooked = true
    end
end

function PlayerLinks:OnDisable()
    PlayerLinks:UnhookAll()
end
