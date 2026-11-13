local CVarBrowser = mUI:NewModule("mUI.Config.CVarBrowser")
mUI.CVarBrowser = CVarBrowser

-- A window with every CVar of the game: its value (red when it is not the default), the default, and who changed it last.
-- Values set in the window are enforced: they are saved and set again on login and whenever something else changes them.
--
-- Who changed a CVar is found by looking at the call stack when SetCVar is called. That only sees what happens after mUI is
-- loaded (addons that load before mUI are not seen), and the console window of the game doesn't go through Lua at all.
local mGUI = mUI.mGUI

local lower, find, match, format = string.lower, string.find, string.match, string.format

local SESSION_START = time()
local SELF_FILE = "mui[/\\]config[/\\]cvarbrowser%.lua"
local ADDON_PATH = "interface[/\\]+addons[/\\]+([^/\\:%]\"]+)[/\\]"
-- When something sets a CVar back this often within this many seconds, it's a fight that is not worth continuing
local FIGHT_LIMIT, FIGHT_WINDOW = 5, 10
-- Not more than one message per CVar within this many seconds
local TELL_INTERVAL = 60

local function Say(message)
    print("|cff009cffm|r|cffffd100UI|r: " .. message)
end

local function IsSecret(value)
    return issecretvalue and issecretvalue(value)
end

local function Escape(text)
    return (tostring(text):gsub("|", "||"))
end

-- ============================================================================
-- Reading CVars
-- ============================================================================
local GetCVarInfo = C_CVar.GetCVarInfo or GetCVarInfo

local function GetValue(name)
    local ok, value = pcall(C_CVar.GetCVar, name)
    if ok and value ~= nil then
        return tostring(value)
    end

    return nil
end

-- value, default, locked, secure, readOnly. Nothing for CVars that the game doesn't tell about.
local function ReadInfo(name)
    if not GetCVarInfo then
        return GetValue(name), nil, false, false, false
    end

    local ok, value, default, _, _, locked, secure, readOnly = pcall(GetCVarInfo, name)
    if not ok or value == nil then
        return nil, nil, false, false, false
    end

    return tostring(value), default ~= nil and tostring(default) or nil, locked and true or false, secure and true or false,
        readOnly and true or false
end

-- "1" and "1.000000" are the same value
local function SameValue(a, b)
    if a == b then
        return true
    end

    local numberA, numberB = tonumber(a), tonumber(b)
    if numberA and numberB then
        return math.abs(numberA - numberB) < 0.00001
    end

    return false
end

-- ============================================================================
-- Who changed what
-- ============================================================================
-- [lowercase name] = {addon, kind, detail, value, time}. Kept in the database, a record only counts while the CVar still has the
-- value it was given. The database isn't there yet when this loads: what is seen until then is kept here and goes into the
-- database in OnInitialize.
local records = {}
-- What the browser and the enforcement set themselves, they know who they are
local ownSet = false

local function Record(name, label, kind, detail)
    if type(name) ~= "string" or IsSecret(name) then
        return
    end

    local value = GetValue(name)
    if value == nil then
        return
    end

    local key = lower(name)
    local record = records[key]
    if not record then
        record = {}
        records[key] = record
    end

    record.addon, record.kind, record.detail = label, kind, detail
    record.value, record.time = value, time()
end

-- The record of a CVar that has the value given
local function GetSource(name, value)
    local record = records[lower(name)]
    if record and value ~= nil and SameValue(record.value, value) then
        return record
    end

    return nil
end

-- Looks at who called, from the inside out. The first addon (or script) on the stack is the one. Windows of the default UI
-- don't count as long as there is no addon: they are what a click in the settings looks like.
local function Attribute()
    if type(debugstack) ~= "function" then
        return "Unknown", "unknown"
    end

    local ok, stack = pcall(debugstack, 1, 30, 5)
    if not ok or type(stack) ~= "string" then
        return "Unknown", "unknown"
    end

    local blizzard = false
    for line in stack:gmatch("[^\n]+") do
        local path = lower(line)
        if not find(path, SELF_FILE) then
            local _, finish, name = find(path, ADDON_PATH)
            if name then
                -- The case of the folder, as it is written in the stack
                name = line:sub(finish - #name, finish - 1)
                if find(name, "^Blizzard_") then
                    blizzard = true
                else
                    return name, "addon"
                end
            elseif find(line, '%[string "') then
                return "Macro / Script", "console", match(line, '%[string "(.-)"%]')
            end
        end
    end

    if blizzard then
        return "Blizzard UI", "blizzard"
    end

    return "Unknown", "unknown"
end

local function OnSetCVar(name)
    if ownSet then
        return
    end

    local label, kind, detail = Attribute()
    Record(name, label, kind, detail)
end

-- "/console name value", the console of the game itself doesn't come through here
local function OnConsoleExec(command)
    if ownSet or type(command) ~= "string" or IsSecret(command) then
        return
    end

    local name = match(command, "^%s*(%S+)%s+%S")
    if not name or GetValue(name) == nil then
        return
    end

    local label, kind, detail = Attribute()
    if kind == "blizzard" or kind == "unknown" then
        label, kind = "Console", "console"
    end
    Record(name, label, kind, detail)
end

if C_CVar.SetCVar then
    hooksecurefunc(C_CVar, "SetCVar", OnSetCVar)
end
if C_CVar.SetCVarBitfield then
    hooksecurefunc(C_CVar, "SetCVarBitfield", OnSetCVar)
end
-- The old global, if the game still has it next to C_CVar
if type(SetCVar) == "function" and SetCVar ~= C_CVar.SetCVar then
    hooksecurefunc("SetCVar", OnSetCVar)
end
if type(ConsoleExec) == "function" then
    hooksecurefunc("ConsoleExec", OnConsoleExec)
end

-- ============================================================================
-- Setting and enforcing
-- ============================================================================
-- [name] = value, what the browser set. The name is the one of the game. Comes from the database in OnInitialize.
local enforced = {}
local enforcedKeys = {}
-- The enforcement is busy setting a value, the events of that are none of its business
local applying = false
-- CVars that have to wait for the combat to end
local waiting = {}
local fights, told = {}, {}

local function IndexEnforced()
    wipe(enforcedKeys)
    for name in pairs(enforced) do
        enforcedKeys[lower(name)] = name
    end
end

-- Sets the value and checks that the game took it
local function Set(name, value)
    ownSet, applying = true, true
    local ok = pcall(C_CVar.SetCVar, name, value)
    ownSet, applying = false, false

    local now = GetValue(name)
    if not (ok and now ~= nil and SameValue(now, value)) then
        return false
    end

    Record(name, "mUI", "browser", "CVar Browser")
    return true
end

-- Sets a CVar back to what the browser said. `notify` tells what happened when something else changed it.
local function Enforce(name, notify)
    local wanted = enforced[name]
    local current = GetValue(name)
    if wanted == nil or current == nil or SameValue(current, wanted) then
        return
    end

    -- Some CVars can't be set in combat
    if InCombatLockdown() then
        waiting[name] = true
        return
    end

    local now = GetTime()
    local fight = fights[name]
    if not fight or now - fight.since > FIGHT_WINDOW then
        fight = {
            since = now,
            count = 0
        }
        fights[name] = fight
    end
    fight.count = fight.count + 1
    if fight.count > FIGHT_LIMIT then
        if not fight.told then
            fight.told = true
            Say(format("|cffffd100%s|r keeps being changed by something else, mUI stops setting it back for a moment", name))
        end
        return
    end

    -- Before the record gets replaced by our own
    local source = GetSource(name, current)
    local culprit = source and source.addon or "something else"
    if Set(name, wanted) and notify and (not told[name] or now - told[name] > TELL_INTERVAL) then
        told[name] = now
        Say(format("|cffffd100%s|r was changed to %s by %s, mUI set it back to %s (CVar Browser)", name, current, culprit, wanted))
    end
end

local function EnforceAll()
    for name in pairs(enforced) do
        Enforce(name)
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("CVAR_UPDATE")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function(_, event, name)
    if event == "CVAR_UPDATE" then
        if applying or type(name) ~= "string" or IsSecret(name) then
            return
        end

        CVarBrowser:OnCVarChanged(name)

        local enforcedName = enforcedKeys[lower(name)]
        if enforcedName then
            -- Later, whoever it was is on the record by then
            C_Timer.After(0, function()
                Enforce(enforcedName, true)
            end)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        EnforceAll()
    else
        for waitingName in pairs(waiting) do
            waiting[waitingName] = nil
            Enforce(waitingName)
        end
    end
end)

function CVarBrowser:OnInitialize()
    local saved = mUI.db.global.cvars

    -- What was seen before the database was there is newer than what it has
    for key, record in pairs(records) do
        saved.sources[key] = record
    end
    records = saved.sources
    enforced = saved.enforced

    IndexEnforced()
    EnforceAll()
end

function CVarBrowser:IsEnforced(name)
    return enforced[name] ~= nil
end

-- Sets a CVar and enforces it. Returns whether it worked, and why not.
function CVarBrowser:Apply(name, value)
    if InCombatLockdown() then
        return false, "CVars can't be changed in combat"
    end

    if not Set(name, tostring(value)) then
        return false, "The game didn't take this value (read-only, protected or not valid)"
    end

    enforced[name] = GetValue(name)
    enforcedKeys[lower(name)] = name

    return true
end

-- Sets a CVar back to its default and stops enforcing it
function CVarBrowser:Reset(name)
    if InCombatLockdown() then
        return false, "CVars can't be changed in combat"
    end

    -- First, or the enforcement sets it back
    enforced[name] = nil
    enforcedKeys[lower(name)] = nil

    local _, default = ReadInfo(name)
    if default ~= nil and not Set(name, default) then
        return false, "The game didn't take the default"
    end

    return true
end

-- Keeps the value, stops enforcing it
function CVarBrowser:Release(name)
    enforced[name] = nil
    enforcedKeys[lower(name)] = nil
end

-- ============================================================================
-- The list
-- ============================================================================
local entries, entriesByKey

local function BuildEntries()
    if entries then
        return
    end

    entries, entriesByKey = {}, {}

    -- The one the console of the game itself uses
    local getCommands = ConsoleGetAllCommands or (C_Console and C_Console.GetAllCommands)
    local ok, commands = pcall(getCommands)
    local cvarType = Enum and Enum.ConsoleCommandType and Enum.ConsoleCommandType.Cvar or 0

    for _, info in ipairs(ok and commands or {}) do
        if info.commandType == cvarType and type(info.command) == "string" then
            local entry = {
                name = info.command,
                key = lower(info.command),
                help = info.help or ""
            }
            entries[#entries + 1] = entry
            entriesByKey[entry.key] = entry
        end
    end
end

local function RefreshEntry(entry)
    local value, default, locked, secure, readOnly = ReadInfo(entry.name)

    entry.value, entry.default = value, default
    entry.locked, entry.secure, entry.readOnly = locked, secure, readOnly
    entry.changed = value ~= nil and default ~= nil and not SameValue(value, default)
    entry.source = value ~= nil and GetSource(entry.name, value) or nil
    entry.enforced = enforced[entry.name] ~= nil
    entry.editable = value ~= nil and not (locked or secure or readOnly)
end

local function RefreshAll()
    for _, entry in ipairs(entries) do
        RefreshEntry(entry)
    end
end

-- Without colors
local function SourceText(entry)
    if entry.enforced then
        return "mUI (enforced)"
    end

    return entry.source and entry.source.addon or ""
end

local KIND_COLORS = {
    addon = "ffffff",
    browser = "009cff",
    blizzard = "999999",
    console = "999999",
    unknown = "999999"
}

local function ColoredSource(entry)
    if entry.enforced then
        return "|cff009cffmUI|r |cff999999(enforced)|r"
    end

    local source = entry.source
    if not source then
        return ""
    end

    local text = "|cff" .. (KIND_COLORS[source.kind] or "ffffff") .. Escape(source.addon) .. "|r"
    if source.time < SESSION_START then
        text = text .. " |cff777777(earlier)|r"
    end

    return text
end

local SORTS = {
    name = function(entry)
        return entry.key
    end,
    value = function(entry)
        return lower(entry.value or "")
    end,
    default = function(entry)
        return lower(entry.default or "")
    end,
    source = function(entry)
        local text = lower(SourceText(entry))
        -- CVars without a source go last
        return text == "" and "\255" or text
    end
}

-- ============================================================================
-- The window
-- ============================================================================
local ROW_HEIGHT = 22
local COLUMNS = {{
    key = "name",
    label = "Name",
    x = 8,
    width = 300
}, {
    key = "value",
    label = "Value",
    x = 318,
    width = 200
}, {
    key = "default",
    label = "Default",
    x = 528,
    width = 150
}, {
    key = "source",
    label = "Modified By",
    x = 688,
    width = 230
}}

local ui = {}
local state = {
    query = "",
    changed = false,
    addons = false,
    enforced = false,
    sort = "name",
    descending = false
}

local function CreateInput(parent, width)
    local box = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    PixelUtil.SetSize(box, width, 24)
    mGUI:ApplyBackdrop(box, "bgWidget", false)
    mGUI:ApplyQuadBorder(box, mGUI.Colors.border)

    local edit = CreateFrame("EditBox", nil, box)
    edit:SetPoint("TOPLEFT", 6, 0)
    edit:SetPoint("BOTTOMRIGHT", -6, 0)
    edit:SetAutoFocus(false)
    mGUI:SetFont(edit, 12)
    edit:SetTextColor(unpack(mGUI.Colors.text))
    edit:SetScript("OnEscapePressed", edit.ClearFocus)
    box.edit = edit

    return box
end

local function CreateText(parent, size, color)
    local text = parent:CreateFontString(nil, "OVERLAY")
    mGUI:SetFont(text, size or 12)
    text:SetTextColor(unpack(color or mGUI.Colors.text))
    text:SetJustifyH("LEFT")

    return text
end

-- Rows
local function UpdateRow(row, entry)
    row.name:SetText(Escape(entry.name))
    row.name:SetTextColor(unpack(entry.enforced and mGUI.Colors.accent or mGUI.Colors.text))

    if entry.value == nil then
        row.value:SetText("|cff777777(protected)|r")
    elseif entry.changed then
        row.value:SetText("|cffff4040" .. Escape(entry.value) .. "|r")
    else
        row.value:SetText(Escape(entry.value))
    end

    row.default:SetText(entry.default and Escape(entry.default) or "")
    row.source:SetText(ColoredSource(entry))
    row.selected:SetShown(state.selected == entry)
end

local function ShowTooltip(row)
    local entry = row.entry
    if not entry then
        return
    end

    GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
    GameTooltip:AddLine(entry.name, 1, 0.82, 0)
    if entry.help ~= "" then
        GameTooltip:AddLine(entry.help, 1, 1, 1, true)
    end
    GameTooltip:AddDoubleLine("Value", entry.value or "(protected)", 0.6, 0.6, 0.6, 1, 1, 1)
    GameTooltip:AddDoubleLine("Default", entry.default or "", 0.6, 0.6, 0.6, 1, 1, 1)
    if entry.enforced then
        GameTooltip:AddLine("Enforced by mUI", 0, 0.61, 1)
    elseif entry.source then
        GameTooltip:AddDoubleLine("Modified by", entry.source.addon, 0.6, 0.6, 0.6, 1, 1, 1)
    end
    GameTooltip:Show()
end

local function InitRow(row, entry)
    if not row.initialized then
        row.initialized = true

        local background = row:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints()
        background:SetColorTexture(1, 1, 1, 0.03)

        row.selected = row:CreateTexture(nil, "BACKGROUND", nil, 1)
        row.selected:SetAllPoints()
        row.selected:SetColorTexture(mGUI.Colors.accent[1], mGUI.Colors.accent[2], mGUI.Colors.accent[3], 0.25)
        row.selected:Hide()

        local highlight = row:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, 1, 1, 0.08)

        for _, column in ipairs(COLUMNS) do
            local text = CreateText(row, 12, column.key == "default" and mGUI.Colors.textDim or nil)
            text:SetPoint("LEFT", row, "LEFT", column.x, 0)
            text:SetWidth(column.width)
            text:SetWordWrap(false)
            row[column.key] = text
        end

        row:SetScript("OnClick", function(self)
            CVarBrowser:Select(self.entry)
        end)
        row:SetScript("OnEnter", ShowTooltip)
        row:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    row.entry = entry
    UpdateRow(row, entry)
end

local function RefreshRows()
    ui.scrollBox:ForEachFrame(function(row)
        if row.entry then
            UpdateRow(row, row.entry)
        end
    end)
end

-- Filtering and sorting
local function Matches(entry, terms)
    if state.changed and not entry.changed then
        return false
    end
    if state.addons and not (entry.source and entry.source.kind == "addon" and not entry.enforced) then
        return false
    end
    if state.enforced and not entry.enforced then
        return false
    end

    for _, term in ipairs(terms) do
        if not find(entry.key, term, 1, true) then
            return false
        end
    end

    return true
end

local function UpdateHeaders()
    for _, column in ipairs(COLUMNS) do
        local header = ui.headers[column.key]
        local active = state.sort == column.key
        header.text:SetText(column.label .. (active and (state.descending and " |A:NPE_ArrowDown:12:12|a" or " |A:NPE_ArrowUp:12:12|a") or ""))
        header.text:SetTextColor(unpack(active and mGUI.Colors.accent or mGUI.Colors.text))
    end
end

-- `keepPosition` keeps the list where it is, otherwise it goes to the top
local function Rebuild(keepPosition)
    BuildEntries()

    local terms = {}
    for term in lower(state.query):gmatch("%S+") do
        terms[#terms + 1] = term
    end

    local list = {}
    for _, entry in ipairs(entries) do
        if Matches(entry, terms) then
            list[#list + 1] = entry
        end
    end

    local sortKey = SORTS[state.sort]
    for _, entry in ipairs(list) do
        entry.sortKey = sortKey(entry)
    end
    local descending = state.descending
    table.sort(list, function(a, b)
        if a.sortKey ~= b.sortKey then
            if descending then
                return a.sortKey > b.sortKey
            end
            return a.sortKey < b.sortKey
        end

        return a.key < b.key
    end)

    ui.scrollBox:SetDataProvider(CreateDataProvider(list), keepPosition and true or false)
    ui.count:SetText(format("%d / %d CVars", #list, #entries))
    ui.empty:SetShown(#list == 0)
    UpdateHeaders()
end

-- The panel below the list
local function UpdateDetail()
    local entry = state.selected
    local detail = ui.detail

    if not entry then
        detail.name:SetText("Select a CVar")
        detail.flags:SetText("")
        detail.help:SetText("")
        detail.info:SetText("")
        detail.input.edit:SetText("")
        detail.input.edit:SetEnabled(false)
        detail.apply:SetWidgetEnabled(false)
        detail.reset:SetWidgetEnabled(false)
        detail.release:SetWidgetEnabled(false)
        return
    end

    detail.name:SetText(Escape(entry.name))

    local flags = {}
    if entry.readOnly then
        flags[#flags + 1] = "Read-only"
    end
    if entry.secure then
        flags[#flags + 1] = "Protected"
    end
    if entry.locked then
        flags[#flags + 1] = "Locked"
    end
    detail.flags:SetText(table.concat(flags, "  -  "))

    detail.help:SetText(entry.help ~= "" and Escape(entry.help) or "|cff777777No description|r")

    local lines = {}
    lines[#lines + 1] = "Default: " .. (entry.default and Escape(entry.default) or "-")
    if entry.enforced then
        lines[#lines + 1] = "|cff009cffEnforced by mUI|r: " .. Escape(enforced[entry.name])
    end
    local source = entry.source
    if source then
        local when = date("%d.%m.%Y %H:%M", source.time)
        local extra = source.detail and (" - " .. Escape(source.detail)) or ""
        lines[#lines + 1] = format("Last modified by |cffffd100%s|r%s (%s)", Escape(source.addon), extra, when)
    else
        lines[#lines + 1] = "|cff777777Modified by: unknown|r"
    end
    detail.info:SetText(table.concat(lines, "\n"))

    detail.input.edit:SetText(entry.value or "")
    detail.input.edit:SetCursorPosition(0)
    detail.input.edit:SetEnabled(entry.editable)
    detail.apply:SetWidgetEnabled(entry.editable)
    detail.reset:SetWidgetEnabled(entry.editable and entry.default ~= nil)
    detail.release:SetWidgetEnabled(entry.enforced)
end

local function SetStatus(text, good)
    ui.detail.status:SetText(text or "")
    ui.detail.status:SetTextColor(unpack(good and mGUI.Colors.accent or {1, 0.35, 0.35}))
end

function CVarBrowser:Select(entry)
    state.selected = entry
    SetStatus("")
    UpdateDetail()
    RefreshRows()
end

-- A change of a CVar while the window is open
local dirty, dirtyTimer = {}, false

function CVarBrowser:OnCVarChanged(name)
    if not (ui.frame and ui.frame:IsShown()) then
        return
    end

    dirty[lower(name)] = true
    if dirtyTimer then
        return
    end

    dirtyTimer = true
    -- After the hooks that tell who did it
    C_Timer.After(0.25, function()
        dirtyTimer = false
        for key in pairs(dirty) do
            dirty[key] = nil
            local entry = entriesByKey[key]
            if entry then
                RefreshEntry(entry)
            end
        end

        if ui.frame:IsShown() then
            RefreshRows()
            if state.selected then
                UpdateDetail()
            end
        end
    end)
end

local function Done(entry, ok, reason, message)
    RefreshEntry(entry)
    UpdateDetail()
    RefreshRows()
    if ok then
        SetStatus(message, true)
    else
        SetStatus(reason, false)
    end
end

local function CreateSearchBox(parent, width, placeholderText)
    local box = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    PixelUtil.SetSize(box, width, 24)
    mGUI:ApplyBackdrop(box, "bgWidget", false)
    mGUI:ApplyQuadBorder(box, mGUI.Colors.border)

    local icon = box:CreateTexture(nil, "OVERLAY")
    icon:SetPoint("LEFT", box, "LEFT", 7, 0)
    icon:SetSize(12, 12)
    icon:SetAtlas("common-search-magnifyingglass")
    icon:SetDesaturated(true)
    icon:SetVertexColor(unpack(mGUI.Colors.textDim))

    local edit = CreateFrame("EditBox", nil, box)
    edit:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    edit:SetPoint("RIGHT", box, "RIGHT", -6, 0)
    edit:SetHeight(24)
    edit:SetAutoFocus(false)
    mGUI:SetFont(edit, 12)
    edit:SetTextColor(unpack(mGUI.Colors.text))

    local placeholder = edit:CreateFontString(nil, "ARTWORK")
    placeholder:SetPoint("LEFT", 2, 0)
    mGUI:SetFont(placeholder, 12)
    placeholder:SetTextColor(unpack(mGUI.Colors.textDim))
    placeholder:SetText(placeholderText)

    edit:SetScript("OnEscapePressed", edit.ClearFocus)
    edit:SetScript("OnTextChanged", function(self, userInput)
        placeholder:SetShown(self:GetText() == "")
        if box.OnTextChanged then
            box.OnTextChanged(self:GetText(), userInput)
        end
    end)

    box.edit = edit

    return box
end

local function CreateDetail(frame)
    local detail = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    detail:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 16, 16)
    detail:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -16, 16)
    detail:SetHeight(170)
    mGUI:ApplyBackdrop(detail, "bgWidget", false, 0.6)
    mGUI:ApplyQuadBorder(detail, mGUI.Colors.border)
    ui.detail = detail

    detail.name = CreateText(detail, 14, {1, 0.82, 0})
    detail.name:SetPoint("TOPLEFT", detail, "TOPLEFT", 12, -10)

    detail.flags = CreateText(detail, 12, mGUI.Colors.textDim)
    detail.flags:SetPoint("TOPRIGHT", detail, "TOPRIGHT", -12, -12)
    detail.flags:SetJustifyH("RIGHT")

    detail.help = CreateText(detail, 12, mGUI.Colors.textDim)
    detail.help:SetPoint("TOPLEFT", detail, "TOPLEFT", 12, -34)
    detail.help:SetPoint("TOPRIGHT", detail, "TOPRIGHT", -12, -34)
    detail.help:SetHeight(30)
    detail.help:SetJustifyV("TOP")
    detail.help:SetWordWrap(true)

    detail.info = CreateText(detail, 12)
    detail.info:SetPoint("TOPLEFT", detail, "TOPLEFT", 12, -68)
    detail.info:SetPoint("TOPRIGHT", detail, "TOPRIGHT", -12, -68)
    detail.info:SetHeight(38)
    detail.info:SetJustifyV("TOP")
    detail.info:SetSpacing(2)

    detail.input = CreateInput(detail, 300)
    detail.input:SetPoint("BOTTOMLEFT", detail, "BOTTOMLEFT", 12, 40)

    local function Apply()
        local entry = state.selected
        if entry and entry.editable then
            detail.input.edit:ClearFocus()
            local ok, reason = CVarBrowser:Apply(entry.name, detail.input.edit:GetText())
            Done(entry, ok, reason, "Set and enforced by mUI")
        end
    end
    detail.input.edit:SetScript("OnEnterPressed", Apply)

    detail.apply = mGUI.Widgets.Button(detail)
    detail.apply:SetPoint("LEFT", detail.input, "RIGHT", 10, 0)
    detail.apply:SetLabel("Apply & Enforce")
    detail.apply.OnClick = Apply

    detail.reset = mGUI.Widgets.Button(detail)
    detail.reset:SetPoint("LEFT", detail.apply, "RIGHT", 6, 0)
    detail.reset:SetLabel("Reset to Default")
    detail.reset.OnClick = function()
        local entry = state.selected
        if entry then
            local ok, reason = CVarBrowser:Reset(entry.name)
            Done(entry, ok, reason, "Set to the default, no longer enforced")
        end
    end

    detail.release = mGUI.Widgets.Button(detail)
    detail.release:SetPoint("LEFT", detail.reset, "RIGHT", 6, 0)
    detail.release:SetLabel("Stop Enforcing")
    detail.release.OnClick = function()
        local entry = state.selected
        if entry then
            CVarBrowser:Release(entry.name)
            Done(entry, true, nil, "No longer enforced, the value stays")
        end
    end

    detail.status = CreateText(detail, 12)
    detail.status:SetPoint("BOTTOMLEFT", detail, "BOTTOMLEFT", 12, 12)
end

local function CreateWindow()
    local frame = CreateFrame("Frame", "mUICVarBrowser", UIParent, "BackdropTemplate")
    ui.frame = frame
    frame:SetFrameStrata("FULLSCREEN_DIALOG")
    frame:SetToplevel(true)
    frame:SetSize(980, 660)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetScale((mUI.db.profile.gui and mUI.db.profile.gui.scale) or 1)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    mGUI:ApplyBackdrop(frame, "bg", "border")
    mGUI:ApplyWindowArt(frame)

    -- ESC closes it with the fade, like the options. UISpecialFrames would hide it right away. Everything else goes on to the game,
    -- and while the options are open behind this window, ESC only closes this one.
    frame:EnableKeyboard(true)
    if not InCombatLockdown() then
        frame:SetPropagateKeyboardInput(true)
    end
    frame:SetScript("OnKeyDown", function(self, key)
        local escape = key == "ESCAPE"

        -- Protected in combat
        if not InCombatLockdown() then
            self:SetPropagateKeyboardInput(not escape)
        end

        if escape then
            CVarBrowser:Close()
        end
    end)

    -- Header
    local header = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    header:SetHeight(40)
    mGUI:ApplyBackdrop(header, "bgAlt", false, 0.55)
    header:EnableMouse(true)
    header:RegisterForDrag("LeftButton")
    header:SetScript("OnDragStart", function()
        frame:StartMoving()
    end)
    header:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
    end)

    local title = CreateText(header, 16)
    title:SetPoint("LEFT", header, "LEFT", 16, 0)
    title:SetText("|cff009cffCVar|r |cffffd100Browser|r")

    local close = CreateFrame("Button", nil, header)
    close:SetPoint("RIGHT", header, "RIGHT", -10, 0)
    close:SetSize(24, 24)
    close:SetNormalAtlas("RedButton-Exit")
    close:SetPushedAtlas("RedButton-exit-pressed")
    close:SetDisabledAtlas("RedButton-Exit-Disabled")
    close:SetHighlightAtlas("RedButton-Highlight", "ADD")
    mGUI:TintIconButton(close)
    close:SetScript("OnClick", function()
        CVarBrowser:Close()
    end)

    -- Search and filters
    local search = CreateSearchBox(frame, 260, "Search")
    search:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -56)
    search.OnTextChanged = function(text, userInput)
        if userInput then
            state.query = text
            Rebuild(false)
        end
    end
    ui.search = search

    local function CreateFilter(key, label, anchor, offset)
        local check = mGUI.Widgets.Checkbox(frame)
        check:SetPoint("LEFT", anchor, "RIGHT", offset, 0)
        check:SetLabel(label)
        check.OnValueChanged = function(_, checked)
            state[key] = checked and true or false
            Rebuild(false)
        end

        return check
    end
    local changedFilter = CreateFilter("changed", "Not Default", search, 16)
    local addonsFilter = CreateFilter("addons", "Set by AddOns", changedFilter.label, 18)
    CreateFilter("enforced", "Enforced", addonsFilter.label, 18)

    ui.count = CreateText(frame, 12, mGUI.Colors.textDim)
    ui.count:SetPoint("RIGHT", frame, "TOPRIGHT", -16, -68)
    ui.count:SetJustifyH("RIGHT")

    -- Column headers
    local columns = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    columns:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -92)
    columns:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -92)
    columns:SetHeight(22)
    mGUI:ApplyBackdrop(columns, "bgAlt", false, 0.8)

    ui.headers = {}
    for _, column in ipairs(COLUMNS) do
        local button = CreateFrame("Button", nil, columns)
        button:SetPoint("LEFT", columns, "LEFT", column.x - 4, 0)
        button:SetSize(column.width, 22)
        button.text = CreateText(button, 12)
        button.text:SetPoint("LEFT", button, "LEFT", 4, 0)

        local highlight = button:CreateTexture(nil, "HIGHLIGHT")
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, 1, 1, 0.08)

        button:SetScript("OnClick", function()
            if state.sort == column.key then
                state.descending = not state.descending
            else
                state.sort, state.descending = column.key, false
            end
            Rebuild(false)
        end)
        ui.headers[column.key] = button
    end

    -- The list
    local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -116)
    scrollBox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -34, 196)
    ui.scrollBox = scrollBox

    local scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 8, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 8, 0)

    local view = CreateScrollBoxListLinearView()
    view:SetElementInitializer("Button", InitRow)
    view:SetElementExtent(ROW_HEIGHT)
    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

    ui.empty = CreateText(scrollBox, 14, mGUI.Colors.textDim)
    ui.empty:SetPoint("CENTER", scrollBox, "CENTER", 0, 0)
    ui.empty:SetText("No CVars found")
    ui.empty:Hide()

    CreateDetail(frame)

    -- A new frame is shown already, and Show() on a frame that is shown doesn't do OnShow
    frame:Hide()
    frame:SetScript("OnShow", function(self)
        -- ESC leaves the propagation off, the first key after opening would be lost
        if not InCombatLockdown() then
            self:SetPropagateKeyboardInput(true)
        end

        BuildEntries()
        RefreshAll()
        Rebuild(true)
        UpdateDetail()
    end)
end

-- Fades in and out, like the options
function CVarBrowser:Open()
    if not ui.frame then
        CreateWindow()
    end

    mGUI:FadeShow(ui.frame)
end

function CVarBrowser:Close()
    if ui.frame then
        mGUI:FadeHide(ui.frame)
    end
end

function CVarBrowser:Toggle()
    if ui.frame and ui.frame:IsShown() then
        CVarBrowser:Close()
    else
        CVarBrowser:Open()
    end
end
