local PlayerLinks = mUI:NewModule("mUI.Modules.Misc.PlayerLinks")

function PlayerLinks:OnInitialize()
    local regionMap = {
        [1] = "us",
        [2] = "kr",
        [3] = "eu",
        [4] = "tw",
        [5] = "cn"
    }

    local function RealmSlug(realm)
        if not realm then
            return nil
        end
        realm = string.gsub(realm, "(%l)(%u)", "%1 %2")
        realm = string.gsub(realm, "'", "")
        return string.lower(string.gsub(realm, "%s+", "-"))
    end

    local region = regionMap[GetCurrentRegion()] or "eu"

    local function AppendLinks(rootDescription, name, realm)
        if rootDescription._mUIPlayerLinks then
            return
        end
        rootDescription._mUIPlayerLinks = true

        rootDescription:CreateDivider()
        rootDescription:CreateTitle("|cff009cffm|r|cffffd100UI|r Player Links")

        rootDescription:CreateButton("WarcraftLogs", function()
            mUI:Link("https://www.warcraftlogs.com/character/" .. region .. "/" .. realm .. "/" .. name)
        end)

        rootDescription:CreateButton("Raider.io", function()
            mUI:Link("https://raider.io/characters/" .. region .. "/" .. realm .. "/" .. name)
        end)

        rootDescription:CreateButton("CheckPVP", function()
            mUI:Link("https://www.check-pvp.fr/" .. region .. "/" .. realm .. "/" .. name)
        end)
    end

    local function ParseNameRealm(fullName)
        if not fullName then
            return nil
        end
        local name, realm
        if string.find(fullName, "-") then
            name, realm = string.match(fullName, "^(.+)-(.+)$")
        else
            name = fullName
            realm = GetNormalizedRealmName()
        end
        if not name or not realm or realm == "" then
            return nil
        end
        return name, RealmSlug(realm)
    end

    -- Handler for standard Menu.ModifyMenu hooks (unit frames, party, etc.)
    local function OnModifyMenu(owner, rootDescription, contextData)
        if not PlayerLinks:IsEnabled() then
            return
        end

        local name, realm

        if contextData.unit then
            name, realm = UnitName(contextData.unit)
            if name then
                if not realm then
                    realm = GetNormalizedRealmName()
                end

                realm = RealmSlug(realm)
            end
        end

        if not name and contextData.name then
            name, realm = ParseNameRealm(contextData.name)
            if not realm and contextData.server and contextData.server ~= "" then
                realm = RealmSlug(contextData.server)
            end
        end

        if not name or not realm then
            return
        end

        AppendLinks(rootDescription, name, realm)
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
            local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
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
    PlayerLinks.appendLinks = AppendLinks
    PlayerLinks.parseNameRealm = ParseNameRealm
    PlayerLinks.getLFGPlayerName = GetLFGPlayerName
end

function PlayerLinks:OnEnable()
    if not PlayerLinks.hooked then
        -- Standard unit frame menus
        local menus = {"MENU_UNIT_SELF", "MENU_UNIT_PARTY", "MENU_UNIT_PLAYER", "MENU_UNIT_RAID_PLAYER", "MENU_UNIT_ENEMY_PLAYER", "MENU_UNIT_FRIEND"}

        for _, tag in ipairs(menus) do
            Menu.ModifyMenu(tag, PlayerLinks.modifyMenuHandler)
        end

        -- Hook MenuUtil.CreateContextMenu
        local isRecreating = false
        hooksecurefunc(MenuUtil, "CreateContextMenu", function(owner, generator, ...)
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

            -- Re-open the menu with our links appended.  The original call
            -- already ran securely; this replaces it from insecure context
            -- (fine — it's our addon menu addition, not Blizzard's).
            isRecreating = true
            MenuUtil.CreateContextMenu(owner, function(ownerInner, rootDescription)
                generator(ownerInner, rootDescription)
                PlayerLinks.appendLinks(rootDescription, lfgName, lfgRealm)
            end, ...)
            isRecreating = false
        end)

        PlayerLinks.hooked = true
    end
end
