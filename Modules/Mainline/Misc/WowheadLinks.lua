local WowheadLinks = mUI:NewModule("mUI.Modules.Misc.WowheadLinks", "AceHook-3.0")

-- Alt + left click on a link, an item or a quest shows its Wowhead page to copy
function WowheadLinks:OnInitialize()
    -- Forever has its own database on Wowhead
    local BASE_URL = "https://www.wowhead.com/"
    local FOREVER_URL = "https://www.wowhead.com/forever/"

    -- Link types that have a Wowhead page, and the page they use
    local PAGES = {
        item = "item",
        quest = "quest",
        spell = "spell",
        enchant = "spell",
        achievement = "achievement",
        currency = "currency"
    }

    local lastKey, lastTime = nil, 0

    local function IsAltClick(button)
        return button == "LeftButton" and IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown()
    end

    -- Takes a full hyperlink ("|cff...|Hitem:1234:...|h[Name]|h|r") as well as the link itself ("item:1234:...")
    local function ParseLink(link)
        if type(link) == "number" then
            return "item", link
        end
        if type(link) ~= "string" or issecretvalue(link) then
            return nil
        end

        local linkType, id = link:match("|H(%a+):(%d+)")
        if not linkType then
            linkType, id = link:match("^(%a+):(%d+)")
        end

        return linkType, tonumber(id)
    end

    function WowheadLinks:Show(linkType, id)
        local page = linkType and id and PAGES[linkType]
        if not page then
            return
        end

        -- Clicking a link in the chat can go through SetItemRef and HandleModifiedItemClick, show it once
        local key = page .. "=" .. id
        local now = GetTime()
        if key == lastKey and now - lastTime < 0.2 then
            return
        end
        lastKey, lastTime = key, now

        mUI:Link((mUI:GameVersion().Forever and FOREVER_URL or BASE_URL) .. key)
    end

    -- Links in the chat and everywhere else that goes through SetItemRef
    function WowheadLinks:OnLinkClick(link, _, button)
        if IsAltClick(button) then
            WowheadLinks:Show(ParseLink(link))
        end
    end

    -- Items in the bags, the bank, loot, merchants, the character panel and so on
    function WowheadLinks:OnItemClick(link)
        if IsAltClick(GetMouseButtonClicked and GetMouseButtonClicked()) then
            WowheadLinks:Show(ParseLink(link))
        end
    end

    -- The Alt click that is being handled. Its default action still runs after the link is shown, and there is no way to cancel it
    -- from a hook.
    local pending

    -- Quests in the quest log, the objective tracker, world quests and the map. They all try to link the quest in the chat first
    -- when clicked, which is a good moment to hook as the buttons call it by name at the time of the click
    function WowheadLinks:OnQuestClick(questID)
        if IsAltClick(GetMouseButtonClicked and GetMouseButtonClicked()) then
            WowheadLinks:Show("quest", questID)

            pending = {
                mapShown = WorldMapFrame ~= nil and WorldMapFrame:IsShown()
            }
            C_Timer.After(0, function()
                pending = nil
            end)
        end
    end

    -- A tracked quest opens the quest log, and with it the world map. That is not what an Alt click is for, so the map is closed
    -- again when it wasn't open. This is still within the click, nothing has been drawn yet.
    function WowheadLinks:OnQuestDetailsOpened()
        if pending and not pending.mapShown and WorldMapFrame and WorldMapFrame:IsShown() then
            HideUIPanel(WorldMapFrame)
        end
    end
end

function WowheadLinks:OnEnable()
    if SetItemRef then
        WowheadLinks:SecureHook("SetItemRef", "OnLinkClick")
    end
    if HandleModifiedItemClick then
        WowheadLinks:SecureHook("HandleModifiedItemClick", "OnItemClick")
    end
    if ChatFrameUtil and ChatFrameUtil.TryInsertQuestLinkForQuestID then
        WowheadLinks:SecureHook(ChatFrameUtil, "TryInsertQuestLinkForQuestID", "OnQuestClick")
    end
    if QuestMapFrame_OpenToQuestDetails then
        WowheadLinks:SecureHook("QuestMapFrame_OpenToQuestDetails", "OnQuestDetailsOpened")
    end
end

function WowheadLinks:OnDisable()
    WowheadLinks:UnhookAll()
end
