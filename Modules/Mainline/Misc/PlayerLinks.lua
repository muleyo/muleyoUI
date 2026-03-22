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
        realm = realm:gsub("(%l)(%u)", "%1 %2")
        realm = realm:gsub("'", "")
        return realm:gsub("%s+", "-"):lower()
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
        if fullName:find("-") then
            name, realm = fullName:match("^(.+)-(.+)$")
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
                realm = realm and realm ~= "" and realm or GetNormalizedRealmName()
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

        -- Hook MenuUtil.CreateContextMenu for non-tagged menus (LFG applicants)
        local origCreateContextMenu = MenuUtil.CreateContextMenu
        MenuUtil.CreateContextMenu = function(owner, generator, ...)
            if not PlayerLinks:IsEnabled() then
                return origCreateContextMenu(owner, generator, ...)
            end

            local lfgFullName = PlayerLinks.getLFGPlayerName(owner)
            if lfgFullName then
                local lfgName, lfgRealm = PlayerLinks.parseNameRealm(lfgFullName)
                if lfgName and lfgRealm then
                    local wrappedGenerator = function(ownerInner, rootDescription)
                        generator(ownerInner, rootDescription)
                        PlayerLinks.appendLinks(rootDescription, lfgName, lfgRealm)
                    end
                    return origCreateContextMenu(owner, wrappedGenerator, ...)
                end
            end

            return origCreateContextMenu(owner, generator, ...)
        end

        PlayerLinks.hooked = true
    end
end
