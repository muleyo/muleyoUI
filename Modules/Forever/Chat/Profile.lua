local Profile = mUI:NewModule("mUI.Modules.Chat.Profile", "AceEvent-3.0")

-- Saves the chat tabs of one character and gives them to the others: the tabs, the chat types and channels they show, colors, font
-- size, position and the order of the tabs. The saved setup is account wide, what a character got last is remembered per character.
function Profile:OnInitialize()
    -- The windows of the default UI aren't touched, apart from General and where the Combat Log is (docked, floating or hidden)
    local GENERAL = 1
    local COMBAT_LOG = 2
    -- Chat gets set up by the game for a moment after the login
    local SYNC_DELAY = 3
    local COLOR_EPSILON = 0.001

    local function Say(message)
        print("|cff009cffm|r|cffffd100UI|r: " .. message)
    end

    local function GetReservedWindows()
        return C_ChatInfo.GetNumReservedChatWindows()
    end

    local function GetMaxWindows()
        return Constants.ChatFrameConstants.MaxChatWindows
    end

    -- ========================================================================
    -- Reading a setup
    -- ========================================================================
    local function CollectNames(source)
        local list, seen = {}, {}
        for _, value in pairs(source or {}) do
            if type(value) == "string" and not issecretvalue(value) and not seen[value] then
                seen[value] = true
                list[#list + 1] = value
            end
        end
        table.sort(list)

        return list
    end

    local function CaptureWindow(id)
        local frame = FCF_GetChatFrameByID(id)
        if not frame then
            return nil
        end

        local name, fontSize, r, g, b, a, _, locked, _, uninteractable = FCF_GetChatWindowInfo(id)
        local window = {
            name = (type(name) == "string" and not issecretvalue(name)) and name or nil,
            fontSize = fontSize,
            r = r,
            g = g,
            b = b,
            a = a,
            locked = locked and true or false,
            uninteractable = uninteractable and true or false,
            docked = frame.isDocked and true or false,
            messageGroups = CollectNames(frame.messageTypeList),
            channels = CollectNames(frame.channelList)
        }

        if not window.docked then
            local point, x, y = GetChatWindowSavedPosition(id)
            local width, height = GetChatWindowSavedDimensions(id)
            if point then
                window.position = {
                    point = point,
                    x = x,
                    y = y,
                    width = width,
                    height = height
                }
            end
        end

        return window
    end

    local function CaptureColors()
        local colors = {}
        for chatType, info in pairs(ChatTypeInfo) do
            if type(info) == "table" and info.r and info.g and info.b then
                colors[chatType] = {
                    r = info.r,
                    g = info.g,
                    b = info.b,
                    byClass = info.colorNameByClass and true or false
                }
            end
        end

        return colors
    end

    local function GetTab(id)
        return _G["ChatFrame" .. id .. "Tab"]
    end

    -- Where the Combat Log is: docked, floating, or hidden (undocked, the frame and its tab hidden)
    local function CaptureCombatLog()
        local frame = FCF_GetChatFrameByID(COMBAT_LOG)
        local window = CaptureWindow(COMBAT_LOG)
        if not frame or not window then
            return nil
        end

        window.hidden = not window.docked and not frame:IsShown()

        return window
    end

    function Profile:Capture()
        local reserved = GetReservedWindows()
        local setup = {
            general = CaptureWindow(GENERAL),
            combatLog = CaptureCombatLog(),
            windows = {},
            dock = {},
            colors = CaptureColors()
        }

        local userWindow = {}
        for id = reserved + 1, GetMaxWindows() do
            if FCF_IsChatWindowIndexActive(id) then
                local window = CaptureWindow(id)
                if window then
                    setup.windows[#setup.windows + 1] = window
                    userWindow[id] = #setup.windows
                end
            end
        end

        -- The order of the docked tabs, the windows of the default UI sit in between the others
        for _, frame in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)) do
            local id = frame:GetID()
            if userWindow[id] then
                setup.dock[#setup.dock + 1] = {
                    user = userWindow[id]
                }
            elseif id <= reserved then
                setup.dock[#setup.dock + 1] = {
                    reserved = id
                }
            end
        end

        return setup
    end

    -- ========================================================================
    -- Applying a setup
    -- ========================================================================
    local function ApplyWindow(frame, window)
        frame:RemoveAllMessageGroups()
        frame:RemoveAllChannels()

        for _, group in ipairs(window.messageGroups or {}) do
            frame:AddMessageGroup(group)
        end
        for _, channel in ipairs(window.channels or {}) do
            frame:AddChannel(channel)
        end

        FCF_SetChatWindowFontSize(nil, frame, window.fontSize)
        FCF_SetWindowColor(frame, window.r, window.g, window.b)
        FCF_SetWindowAlpha(frame, window.a)
        FCF_SetUninteractable(frame, window.uninteractable)
    end

    -- A window that is not docked: where it is, how big it is, and whether it can be moved
    local function PlaceFloatingWindow(frame, window)
        FCF_UnDockFrame(frame)

        if window.position then
            local id = frame:GetID()
            SetChatWindowSavedPosition(id, window.position.point, window.position.x, window.position.y)
            if window.position.width and window.position.height then
                SetChatWindowSavedDimensions(id, window.position.width, window.position.height)
            end
            FCF_RestorePositionAndDimensions(frame)
        end

        FCF_SetTabPosition(frame, 0)
        FCF_SetLocked(frame, window.locked)
    end

    local function ApplyUserWindow(window)
        -- The name is a fallback for a window that has none
        local frame = FCF_OpenNewWindow(window.name, true)
        if not frame then
            return nil
        end

        ApplyWindow(frame, window)

        -- Windows start docked
        if not window.docked then
            PlaceFloatingWindow(frame, window)
        end

        return frame
    end

    -- Hidden is what happens when a window is undocked and hidden, along with its tab. Docked is left to the dock order.
    local function ApplyCombatLog(window)
        local frame = FCF_GetChatFrameByID(COMBAT_LOG)
        local tab = GetTab(COMBAT_LOG)
        if not frame or not tab then
            return
        end

        if window.hidden then
            FCF_UnDockFrame(frame)
            frame:Hide()
            tab:Hide()
        elseif window.docked then
            tab:Show()
        else
            PlaceFloatingWindow(frame, window)
            FCF_CheckShowChatFrame(frame)
            FCF_CheckShowChatFrame(tab)
            SetChatWindowShown(COMBAT_LOG, true)
        end
    end

    local function ApplyDockOrder(dock, userFrames, combatLogKnown)
        -- The frames in the order they are supposed to be docked in. Windows of the default UI that are not docked stay where they are,
        -- apart from the Combat Log when the setup says where it belongs.
        local wanted = {}
        for _, entry in ipairs(dock or {}) do
            local frame
            if entry.user then
                frame = userFrames[entry.user]
            elseif entry.reserved then
                frame = FCF_GetChatFrameByID(entry.reserved)
                local dockIt = entry.reserved == GENERAL or (entry.reserved == COMBAT_LOG and combatLogKnown)
                if frame and not dockIt and not frame.isDocked then
                    frame = nil
                end
            end

            if frame then
                wanted[#wanted + 1] = frame
            end
        end

        local docked = FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)
        for position, frame in ipairs(wanted) do
            -- General always stays first
            if docked[position] ~= frame and frame ~= DEFAULT_CHAT_FRAME then
                FCF_UnDockFrame(frame)
                FCF_DockFrame(frame, position)
            end
        end
    end

    local function ApplyColors(colors)
        for chatType, color in pairs(colors or {}) do
            local info = ChatTypeInfo[chatType]
            if info then
                if math.abs((info.r or 0) - color.r) > COLOR_EPSILON or math.abs((info.g or 0) - color.g) > COLOR_EPSILON or
                    math.abs((info.b or 0) - color.b) > COLOR_EPSILON then
                    ChangeChatColor(chatType, color.r, color.g, color.b)
                end
                if (info.colorNameByClass and true or false) ~= color.byClass then
                    SetChatColorNameByClass(chatType, color.byClass)
                end
            end
        end
    end

    -- Returns how many steps went wrong, a broken window must not stop the others
    function Profile:Apply(setup)
        local failures = 0
        local function Try(func, ...)
            local ok, result = pcall(func, ...)
            if not ok then
                failures = failures + 1
                mUI:Debug("Chat Setup: " .. tostring(result))
                return nil
            end

            return result
        end

        if setup.general then
            Try(ApplyWindow, DEFAULT_CHAT_FRAME, setup.general)
            -- General can be renamed. Without a name it gets its default one back.
            Try(FCF_SetWindowName, DEFAULT_CHAT_FRAME, setup.general.name)
        end

        -- Windows of this character that are not part of the setup
        for id = GetReservedWindows() + 1, GetMaxWindows() do
            if FCF_IsChatWindowIndexActive(id) then
                Try(FCF_Close, FCF_GetChatFrameByID(id))
            end
        end

        -- Setups from before the Combat Log was part of them leave it where it is
        if setup.combatLog then
            Try(ApplyCombatLog, setup.combatLog)
        end

        local userFrames = {}
        for index, window in ipairs(setup.windows or {}) do
            userFrames[index] = Try(ApplyUserWindow, window)
        end

        Try(ApplyDockOrder, setup.dock, userFrames, setup.combatLog ~= nil)
        Try(ApplyColors, setup.colors)
        Try(FCF_SelectDockFrame, DEFAULT_CHAT_FRAME)
        Try(FCF_DockUpdate)

        return failures
    end

    -- ========================================================================
    -- Saving and loading
    -- ========================================================================
    function Profile:HasSetup()
        return mUI.db.global.chat.setup and true or false
    end

    function Profile:HasBackup()
        return mUI.db.char.chat.backup and true or false
    end

    -- Who saved the setup and when, for the options
    function Profile:GetInfo()
        local global = mUI.db.global.chat
        if not global.setup then
            return nil
        end

        return global.savedBy, global.savedAt
    end

    function Profile:Save()
        local global = mUI.db.global.chat
        global.setup = Profile:Capture()
        global.version = (global.version or 0) + 1
        global.savedBy = UnitName("player") .. "-" .. GetRealmName()
        global.savedAt = time()

        -- This character has what it saved
        mUI.db.char.chat.version = global.version

        Say("Chat Setup saved")
    end

    local function LoadSetup(setup, version, backup)
        if backup then
            mUI.db.char.chat.backup = Profile:Capture()
        end

        local failures = Profile:Apply(setup)
        if version then
            mUI.db.char.chat.version = version
        end

        return failures
    end

    function Profile:Load()
        local global = mUI.db.global.chat
        if not global.setup then
            Say("There is no Chat Setup saved yet")
            return
        end

        local failures = LoadSetup(global.setup, global.version, true)
        if failures > 0 then
            Say("Chat Setup loaded, " .. failures .. " step(s) failed. |cffffff00Undo Load|r in the Chat options goes back")
        else
            Say("Chat Setup loaded")
        end
    end

    function Profile:Undo()
        local backup = mUI.db.char.chat.backup
        if not backup then
            Say("There is nothing to undo")
            return
        end

        LoadSetup(backup)
        mUI.db.char.chat.backup = false
        Say("Chat Setup restored")
    end

    -- ========================================================================
    -- Sync on login
    -- ========================================================================
    local function Sync()
        local global = mUI.db.global.chat
        if not global.setup or mUI.db.char.chat.version == global.version then
            return
        end

        Profile:Load()
    end

    function Profile:OnEnteringWorld(_, isInitialLogin, isReloadingUi)
        if not (isInitialLogin or isReloadingUi) then
            return
        end

        C_Timer.After(SYNC_DELAY, Sync)
    end
end

function Profile:OnEnable()
    Profile:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEnteringWorld")
end

function Profile:OnDisable()
    Profile:UnregisterEvent("PLAYER_ENTERING_WORLD")
end
