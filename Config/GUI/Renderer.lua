local mGUI = mUI.mGUI

local Renderer = {}
mGUI.Renderer = Renderer

local BASE_WIDTH = 170 -- AceConfig width-multiplier unit
local PAD_X, PAD_Y = 20, 14

StaticPopupDialogs["MUI_GUI_CONFIRM"] = {
    text = "%s",
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = function(popup)
        popup.data()
    end,
    OnCancel = function()
        -- Revert the widget's optimistic state change (e.g. an already-ticked checkbox)
        Renderer:Refresh()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

local RESIZABLE = {
    Dropdown = true,
    DropdownFont = true,
    DropdownStatusbar = true,
    DropdownMultiselect = true,
    Slider = true,
    EditBox = true,
    MultiLineEditBox = true,
    Header = true,
    Label = true,
    SectionTabs = true
}

-- ============================================================================
-- Option table helpers
-- ============================================================================

local function InfoFor(option)
    return {
        arg = option.arg
    }
end

local function Resolve(value, option)
    if type(value) == "function" then
        return value(InfoFor(option))
    end
    return value
end

-- confirm can be true (use confirmText), a string, or a function returning either
local function RunGuarded(option, apply)
    local confirm = option.confirm
    if type(confirm) == "function" then
        confirm = confirm(InfoFor(option))
    end
    if confirm then
        local text = type(confirm) == "string" and confirm or option.confirmText or (Resolve(option.name, option) .. "?")
        StaticPopup_Show("MUI_GUI_CONFIRM", text, nil, apply)
    else
        apply()
    end
end

local function SortedOptions(args)
    local entries = {}
    for key, option in pairs(args) do
        -- The module enable/disable toggle now lives on the sidebar tab, not the page
        if not mGUI.EnableKeys[key] then
            entries[#entries + 1] = {
                key = key,
                option = option
            }
        end
    end
    table.sort(entries, function(a, b)
        local orderA = a.option.order or 100
        local orderB = b.option.order or 100
        if orderA == orderB then
            return a.key < b.key
        end
        return orderA < orderB
    end)
    return entries
end

local function SplitSections(entries)
    local pinned, sections = {}, {}
    local tabbable = true
    for _, entry in ipairs(entries) do
        if entry.option.type == "header" then
            if type(entry.option.name) ~= "string" then
                tabbable = false
            end
            sections[#sections + 1] = {
                name = entry.option.name,
                entries = {}
            }
        elseif #sections == 0 then
            pinned[#pinned + 1] = entry
        else
            local section = sections[#sections]
            section.entries[#section.entries + 1] = entry
        end
    end
    return pinned, sections, tabbable and #sections >= 2
end

-- ============================================================================
-- Widget pools
-- ============================================================================

local pools = {}
local active = {}

local function Acquire(widgetType, parent)
    pools[widgetType] = pools[widgetType] or {}
    local widget = table.remove(pools[widgetType])
    if not widget then
        widget = mGUI.Widgets[widgetType](parent)
        widget.mGUIType = widgetType
    end
    widget:SetParent(parent)
    widget:Show()
    active[#active + 1] = widget
    return widget
end

local function ReleaseAll()
    for _, widget in ipairs(active) do
        widget:Hide()
        widget:ClearAllPoints()
        widget.OnValueChanged = nil
        widget.OnClick = nil
        widget.option = nil
        widget.optionInfo = nil
        table.insert(pools[widget.mGUIType], widget)
    end
    wipe(active)
end

-- ============================================================================
-- Per-type configuration: build the widget, bind get/set, report flow metrics
-- ============================================================================

local function WidthFor(option, natural)
    local width = option.width
    if width == "full" then
        return "full"
    elseif width == "half" then
        return BASE_WIDTH * 0.5
    elseif width == "double" then
        return BASE_WIDTH * 2
    elseif type(width) == "number" then
        return BASE_WIDTH * width
    end
    return natural
end

local Builders = {}

Builders.toggle = function(parent, option)
    local widget = Acquire("Checkbox", parent)
    widget:SetLabel(Resolve(option.name, option))
    widget:SetChecked(option.get and option.get(InfoFor(option)) or false)
    widget.OnValueChanged = function(_, checked)
        RunGuarded(option, function()
            option.set(InfoFor(option), checked)
            Renderer:Refresh()
        end)
    end
    local labelWidth = widget.label:GetStringWidth() + 34
    return widget, WidthFor(option, math.max(BASE_WIDTH, labelWidth)), 24
end

Builders.execute = function(parent, option)
    local widget = Acquire("Button", parent)
    widget:SetLabel(Resolve(option.name, option))
    widget.OnClick = function()
        RunGuarded(option, function()
            option.func(InfoFor(option))
            Renderer:Refresh()
        end)
    end
    return widget, WidthFor(option, math.max(140, widget:GetWidth())), 28
end

Builders.range = function(parent, option)
    local widget = Acquire("Slider", parent)
    widget:SetLabel(Resolve(option.name, option))
    widget:SetRange(option.min or 0, option.max or 100, option.step, option.isPercent)
    widget:SetValue(option.get and option.get(InfoFor(option)) or option.min or 0)
    widget.OnValueChanged = function(_, value, isLiveTick)
        RunGuarded(option, function()
            option.set(InfoFor(option), value)
            if isLiveTick then
                Renderer:RefreshStates()
                if mGUI.Preview then
                    mGUI.Preview:OnCategoryChanged(Renderer.currentKey)
                end
            else
                Renderer:Refresh()
            end
        end)
    end
    return widget, WidthFor(option, 230), 44
end

Builders.color = function(parent, option)
    local widget = Acquire("ColorPicker", parent)
    widget.hasAlpha = option.hasAlpha
    widget:SetLabel(Resolve(option.name, option))
    if option.get then
        widget:SetColor(option.get(InfoFor(option)))
    end
    widget.OnValueChanged = function(_, r, g, b, a)
        RunGuarded(option, function()
            option.set(InfoFor(option), r, g, b, a)
            Renderer:Refresh()
        end)
    end
    -- Title-above-swatch, matching Dropdown/Slider row height so the swatch's
    -- bottom edge lines up with those controls on a shared row.
    return widget, WidthFor(option, widget:GetWidth() + 10), 46
end

Builders.input = function(parent, option)
    local widgetType = option.multiline and "MultiLineEditBox" or "EditBox"
    local widget = Acquire(widgetType, parent)
    widget:SetLabel(Resolve(option.name, option))
    widget:SetValue(option.get and option.get(InfoFor(option)) or "")
    widget.selectAllOnFocus = option.selectAllOnFocus
    widget.OnValueChanged = function(_, text)
        RunGuarded(option, function()
            option.set(InfoFor(option), text)
            if option.multiline then
                Renderer:RefreshStates()
            else
                Renderer:Refresh()
            end
        end)
    end
    if option.multiline then
        local lines = type(option.multiline) == "number" and option.multiline or 12
        return widget, "full", 18 + lines * 16
    end
    return widget, WidthFor(option, 230), 46
end

Builders.select = function(parent, option)
    local widgetType = "Dropdown"
    if option.dialogControl == "mUI_LSM30_Font" then
        widgetType = "DropdownFont"
    elseif option.dialogControl == "mUI_LSM30_Status" then
        widgetType = "DropdownStatusbar"
    end

    local widget = Acquire(widgetType, parent)
    widget:SetLabel(Resolve(option.name, option))
    widget.optionInfo = InfoFor(option) -- passed to function values on menu open
    widget:SetOptions(option.values, option.sorting) -- may be a function; resolved on open
    widget:SetValue(option.get and option.get(InfoFor(option)))
    widget.OnValueChanged = function(_, key)
        RunGuarded(option, function()
            option.set(InfoFor(option), key)
            Renderer:Refresh()
        end)
    end
    local width = WidthFor(option, 190)
    if width ~= "full" then
        width = math.max(width, 190)
    end
    return widget, width, 46
end

-- AceConfig-style multiselect: get(info, key) / set(info, key, value) per
-- entry in option.values. The dropdown stays open across clicks, so unlike
-- every other builder this does NOT call Renderer:Refresh() from its
-- OnValueChanged -- that would release/rebuild the whole page (via
-- ReleaseAll) and close the open menu after every single checkbox click.
Builders.multiselect = function(parent, option)
    local widget = Acquire("DropdownMultiselect", parent)
    widget:SetLabel(Resolve(option.name, option))
    widget.optionInfo = InfoFor(option)
    widget.noneText = option.noneText
    widget:SetOptions(option.values, option.sorting)
    widget:SetGetter(function(key)
        return option.get(InfoFor(option), key)
    end)
    widget:SetToggle(function(key, checked)
        RunGuarded(option, function()
            option.set(InfoFor(option), key, checked)
            widget:UpdateText()
        end)
    end)
    local width = WidthFor(option, 190)
    if width ~= "full" then
        width = math.max(width, 190)
    end
    return widget, width, 46
end

Builders.header = function(parent, option)
    local widget = Acquire("Header", parent)
    widget:SetLabel(Resolve(option.name, option))
    return widget, "full", 30
end

Builders.description = function(parent, option)
    local widget = Acquire("Label", parent)
    widget:SetLabel(Resolve(option.name, option), option.fontSize)
    if option.image then
        widget:SetImage(Resolve(option.image, option), option.imageWidth, option.imageHeight)
    else
        widget:SetImage(nil)
    end
    return widget, "full", nil -- height measured after width is known
end

-- ============================================================================
-- Page rendering
-- ============================================================================

function Renderer:SetHost(scrollFrame, scrollChild)
    self.scrollFrame = scrollFrame
    self.scrollChild = scrollChild
end

-- Per-category active sub-tab (section name), kept across refreshes
Renderer.activeSection = {}

function Renderer:BuildRenderList(options)
    local entries = SortedOptions(options.args)
    local pinned, sections, tabbed = SplitSections(entries)
    if not tabbed then
        return entries
    end

    local activeIndex = 1
    local names = {}
    for i, section in ipairs(sections) do
        names[i] = section.name
        if section.name == self.activeSection[self.currentKey] then
            activeIndex = i
        end
    end
    self.activeSection[self.currentKey] = names[activeIndex]

    local items = {}
    for _, entry in ipairs(pinned) do
        items[#items + 1] = entry
    end
    items[#items + 1] = {
        tabs = names,
        activeIndex = activeIndex
    }
    for _, entry in ipairs(sections[activeIndex].entries) do
        items[#items + 1] = entry
    end
    return items
end

function Renderer:ActivateSectionFor(categoryKey, optionKey)
    local category = mGUI.categories and mGUI.categories[categoryKey]
    if not category then
        return
    end
    local currentSection
    for _, entry in ipairs(SortedOptions(category.options.args)) do
        if entry.option.type == "header" then
            if type(entry.option.name) ~= "string" then
                return -- dynamic header names -> page renders flat
            end
            currentSection = entry.option.name
        elseif entry.key == optionKey then
            if currentSection then
                self.activeSection[categoryKey] = currentSection
            end
            return
        end
    end
end

local function BuildSectionTabs(parent, item, width)
    local widget = Acquire("SectionTabs", parent)
    -- Width has to land before SetTabs -- it wraps overflowing tabs onto a
    -- second row and needs to know how much space it actually has to do that.
    widget:SetWidth(width)
    widget:SetTabs(item.tabs, item.activeIndex, function(sectionName)
        Renderer.activeSection[Renderer.currentKey] = sectionName
        Renderer:RenderCategory(Renderer.currentKey)
        Renderer.scrollFrame:SetVerticalScroll(0)
    end)
    return widget
end

function Renderer:RenderOptions(options)
    local parent = self.scrollChild
    ReleaseAll()

    local contentWidth = self.scrollFrame:GetWidth() - 10
    parent:SetWidth(contentWidth)

    local SLOT = math.floor(contentWidth / 4)

    local x, y, rowHeight = 0, 0, 0
    local function NewRow()
        if rowHeight > 0 then
            y = y + rowHeight + PAD_Y
        end
        x, rowHeight = 0, 0
    end

    local inSection = false

    for _, entry in ipairs(self:BuildRenderList(options)) do
        if entry.tabs then
            local widget = BuildSectionTabs(parent, entry, contentWidth)
            widget.mGUISectionContent = false
            NewRow()
            widget:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -y)
            widget.layoutY = y
            rowHeight = widget:GetHeight()
            NewRow()
            inSection = true
        else
            local option = entry.option
            local builder = Builders[option.type]
            local hidden = Resolve(option.hidden, option) or Resolve(option.guiHidden, option)

            if builder and not hidden then
                local widget, width, height = builder(parent, option)
                widget.option = option
                widget.optionKey = entry.key

                if widget.SetWidgetEnabled then
                    widget:SetWidgetEnabled(not Resolve(option.disabled, option))
                end
                if widget.SetTooltip then
                    widget:SetTooltip(option)
                elseif option.desc then
                    if not widget.mGUITooltipAttached then
                        widget.mGUITooltipAttached = true
                        mGUI:AttachTooltip(widget, function()
                            return widget.option and Resolve(widget.option.name, widget.option)
                        end, function()
                            return widget.option and Resolve(widget.option.desc, widget.option)
                        end)
                    end
                end

                local fullRow = width == "full"
                if fullRow then
                    NewRow()
                    width = contentWidth
                    if widget.UpdateHeight then
                        widget:UpdateHeight(width)
                        height = widget:GetHeight()
                    end
                    widget:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -y)
                    widget.layoutY = y
                    widget.mGUISectionContent = inSection
                    widget:SetWidth(width)
                    if height then
                        widget:SetHeight(height)
                    end
                    rowHeight = height or widget:GetHeight()
                    NewRow()
                else
                    local advance
                    if widget.mGUICompact then
                        advance = width + PAD_X
                    elseif RESIZABLE[widget.mGUIType] then
                        advance = math.max(1, math.floor(width / SLOT + 0.5)) * SLOT
                    else
                        advance = math.max(1, math.ceil(width / SLOT)) * SLOT
                    end
                    if x > 0 and x + advance > contentWidth + 1 then
                        NewRow()
                    end

                    widget:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
                    widget.layoutY = y -- exact page offset, used by search jump-to-option
                    widget.mGUISectionContent = inSection
                    if RESIZABLE[widget.mGUIType] then
                        -- Fill the slot (minus padding) so controls don't leave gaps
                        widget:SetWidth(advance - PAD_X)
                        if height then
                            widget:SetHeight(height)
                        end
                    end

                    x = x + advance
                    rowHeight = math.max(rowHeight, height or widget:GetHeight())
                end
            end
        end
    end

    NewRow()
    parent:SetHeight(y + 20)
end

function Renderer:GetActiveWidgets()
    return active
end

function Renderer:RenderCategory(key)
    local category = mGUI.categories and mGUI.categories[key]
    if not category then
        return
    end
    self.currentKey = key

    -- A running wheel animation would fight the scroll reset on page switches
    if self.scrollFrame.StopSmoothScroll then
        self.scrollFrame:StopSmoothScroll()
    end

    self:RenderOptions(category.options)

    local signature = key .. "/" .. (self.activeSection[key] or "")
    if key ~= self.lastKey then
        UIFrameFadeIn(self.scrollChild, 0.2, 0, 1)
    elseif signature ~= self.lastSignature then
        for _, widget in ipairs(active) do
            if widget.mGUISectionContent then
                UIFrameFadeIn(widget, 0.15, 0, 1)
            end
        end
    end
    self.lastKey = key
    self.lastSignature = signature

    if mGUI.Preview then
        mGUI.Preview:OnCategoryChanged(key)
    end
end

-- Lighter-weight alternative to Refresh(): re-evaluates the `disabled` state of
-- widgets already on the page WITHOUT releasing/reacquiring/repositioning them
-- (unlike Refresh(), which re-lays out the whole page), so it's safe to call
-- while a widget (e.g. a multiline EditBox) has active keyboard focus.
function Renderer:RefreshStates()
    for _, widget in ipairs(active) do
        local option = widget.option
        if option and widget.SetWidgetEnabled then
            widget:SetWidgetEnabled(not Resolve(option.disabled, option))
        end
    end
end

-- Re-render the current page (after any set) so dynamic names/hidden/disabled
-- update — replaces AceConfigRegistry:NotifyChange. Keeps the scroll position.
function Renderer:Refresh()
    if not self.currentKey then
        return
    end
    local scroll = self.scrollFrame:GetVerticalScroll()
    self:RenderCategory(self.currentKey)
    -- GetVerticalScrollRange is stale right after a re-render; compute it
    local range = math.max(0, self.scrollChild:GetHeight() - self.scrollFrame:GetHeight())
    self.scrollFrame:SetVerticalScroll(math.min(scroll, range))
end
