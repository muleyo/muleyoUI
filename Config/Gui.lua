local Gui = mUI:NewModule("mUI.Config.Gui")

function Gui:OnInitialize()
    -- Initialize Database
    Gui.db = mUI.db.profile.gui

    -- Libraries
    local mGUI = mUI.mGUI

    -- Main Window (dimensions pixel-snapped so the border renders on all edges)
    Gui.frame = CreateFrame("Frame", "mUIOptions", UIParent, "BackdropTemplate")
    Gui.frame:SetFrameStrata("DIALOG")
    Gui.frame:SetSize(1100, 600)
    Gui.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Gui.frame:SetScale(Gui.db.scale)
    mGUI:ApplyBackdrop(Gui.frame, "bg", false)
    mGUI:ApplyWindowArt(Gui.frame)

    -- Make frame draggable
    Gui.frame:SetMovable(true)
    Gui.frame:SetUserPlaced(false)
    Gui.frame:SetClampedToScreen(true)
    Gui.frame:RegisterForDrag("LeftButton")

    -- Header Bar
    local header = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    -- PixelUtil (not plain SetPoint with the precomputed `px`) so THIS hop of
    -- the anchor chain is independently snapped to header's own effective
    -- pixel grid, instead of accumulating drift from reusing one constant
    -- computed against Gui.frame all the way down to deeply-nested children.
    PixelUtil.SetPoint(header, "TOPLEFT", Gui.frame, "TOPLEFT", 1, -1)
    PixelUtil.SetPoint(header, "TOPRIGHT", Gui.frame, "TOPRIGHT", -1, -1)
    header:SetHeight(48)
    mGUI:ApplyBackdrop(header, "bgAlt", false, 0.55)
    header:EnableMouse(true)
    -- Drag threshold: StartMoving()/StopMovingOrSizing() track the cursor
    -- continuously, so even a plain click (no intentional drag) still moves
    -- Gui.frame by a tiny amount from ordinary mouse jitter — enough to land
    -- searchBox at a slightly different sub-pixel screen position and make
    -- its 1px border rasterize inconsistently. Only actually start moving
    -- once the cursor has moved a few real pixels, so a plain click leaves
    -- the window (and searchBox) completely untouched.
    local DRAG_THRESHOLD = 4
    local dragStartX, dragStartY, isDragging
    header:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            dragStartX, dragStartY = GetCursorPosition()
            isDragging = false
            header:SetScript("OnUpdate", function()
                local x, y = GetCursorPosition()
                local scale = UIParent:GetEffectiveScale()
                local dx, dy = (x - dragStartX) / scale, (y - dragStartY) / scale
                if not isDragging and (math.abs(dx) > DRAG_THRESHOLD or math.abs(dy) > DRAG_THRESHOLD) then
                    isDragging = true
                    Gui.frame:StartMoving()
                end
            end)
        end
    end)
    header:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            header:SetScript("OnUpdate", nil)
            if isDragging then
                Gui.frame:StopMovingOrSizing()
            end
            isDragging = false
        end
    end)

    -- Version (top left corner)
    local versionText = header:CreateFontString(nil, "OVERLAY")
    versionText:SetPoint("TOPLEFT", header, "TOPLEFT", 10, -8)
    mGUI:SetFont(versionText, 12)
    versionText:SetText(C_AddOns.GetAddOnMetadata("mUI", "Version"))
    versionText:SetTextColor(unpack(mGUI.Colors.version))

    -- Logo (centered)
    local logo = header:CreateTexture(nil, "ARTWORK")
    logo:SetPoint("CENTER", header, "CENTER", 0, 0)
    logo:SetSize(70, 70)
    logo:SetTexture("Interface\\AddOns\\mUI\\Media\\logo.png")

    -- Close Button, tinted to match the dark/blue theme instead of stock red
    local closeButton = CreateFrame("Button", nil, header)
    closeButton:SetPoint("RIGHT", header, "RIGHT", -10, 0)
    closeButton:SetSize(24, 24)
    closeButton:SetNormalAtlas("RedButton-Exit")
    closeButton:SetPushedAtlas("RedButton-exit-pressed")
    closeButton:SetDisabledAtlas("RedButton-Exit-Disabled")
    closeButton:SetHighlightAtlas("RedButton-Highlight", "ADD")
    mGUI:TintIconButton(closeButton)
    closeButton:SetScript("OnClick", function()
        Gui:Close()
    end)

    -- Sidebar
    local sidebar = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    PixelUtil.SetPoint(sidebar, "TOPLEFT", header, "BOTTOMLEFT", 0, -1)
    PixelUtil.SetPoint(sidebar, "BOTTOMLEFT", Gui.frame, "BOTTOMLEFT", 1, 1)
    sidebar:SetWidth(200)
    mGUI:ApplyBackdrop(sidebar, "bgAlt", false, 0.55)

    -- Themed search box
    local searchBox = CreateFrame("Frame", nil, sidebar, "BackdropTemplate")
    PixelUtil.SetPoint(searchBox, "TOPLEFT", sidebar, "TOPLEFT", 10, -10)
    PixelUtil.SetSize(searchBox, 180, 24)
    mGUI:ApplyBackdrop(searchBox, "bgWidget", false)
    mGUI:ApplyQuadBorder(searchBox, mGUI.Colors.border)
    Gui.searchBox = searchBox

    local searchIcon = searchBox:CreateTexture(nil, "OVERLAY")
    searchIcon:SetPoint("LEFT", searchBox, "LEFT", 7, 0)
    searchIcon:SetSize(12, 12)
    searchIcon:SetAtlas("common-search-magnifyingglass")
    searchIcon:SetDesaturated(true)
    searchIcon:SetVertexColor(unpack(mGUI.Colors.textDim))

    local searchEdit = CreateFrame("EditBox", nil, searchBox)
    searchEdit:SetPoint("LEFT", searchIcon, "RIGHT", 6, 0)
    searchEdit:SetPoint("RIGHT", searchBox, "RIGHT", -6, 0)
    searchEdit:SetHeight(24)
    searchEdit:SetAutoFocus(false)
    mGUI:SetFont(searchEdit, 12)
    searchEdit:SetTextColor(unpack(mGUI.Colors.text))
    searchBox.editBox = searchEdit

    local placeholder = searchEdit:CreateFontString(nil, "ARTWORK")
    placeholder:SetPoint("LEFT", 2, 0)
    mGUI:SetFont(placeholder, 12)
    placeholder:SetTextColor(unpack(mGUI.Colors.textDim))
    placeholder:SetText("Search")

    searchEdit:SetScript("OnEscapePressed", searchEdit.ClearFocus)
    searchEdit:SetScript("OnTextChanged", function(box, userInput)
        placeholder:SetShown(box:GetText() == "")
        if userInput and mGUI.Search then
            mGUI.Search:OnTextChanged(box:GetText())
        end
    end)

    -- Content Area — translucent so the window background art shows through
    local contentFrame = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    PixelUtil.SetPoint(contentFrame, "TOPLEFT", sidebar, "TOPRIGHT", 1, 0)
    PixelUtil.SetPoint(contentFrame, "BOTTOMRIGHT", Gui.frame, "BOTTOMRIGHT", -1, 1)
    mGUI:ApplyBackdrop(contentFrame, "bg", false, 0.35)
    Gui.contentFrame = contentFrame

    -- Scrollable options page within the Content Area.
    local scrollFrame = CreateFrame("ScrollFrame", nil, contentFrame, "ScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 16, -16)
    scrollFrame:SetPoint("BOTTOMRIGHT", contentFrame, "BOTTOMRIGHT", -30, 16)

    -- ScrollFrameTemplate's OnLoad picks its scroll bar template from the
    -- global SCROLL_FRAME_SCROLL_BAR_TEMPLATE (Blizzard_SharedXML/
    -- ScrollDefine.lua): "MinimalScrollBar" (retail look) on Mainline, but
    -- the old chunky "WoWClassicScrollBar" on Mists/TBC/Vanilla. The Mists
    -- client build DOES still ship/use "MinimalScrollBar" (its own
    -- AuctionHouse/CharacterFrame/Collections panels use it) - it's just not
    -- the generic default there - so replace the auto-created bar with our
    -- own explicit "MinimalScrollBar" for a consistent retail-style
    -- scrollbar on every version. Offsets match Mainline's own ScrollDefine.
    if scrollFrame.ScrollBar then
        scrollFrame.ScrollBar:Hide()
        scrollFrame.ScrollBar:ClearAllPoints()
    end
    local scrollBar = CreateFrame("EventFrame", nil, scrollFrame, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 6, 2)
    scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 6, 5)
    scrollFrame.ScrollBar = scrollBar
    ScrollUtil.InitScrollFrameWithScrollBar(scrollFrame, scrollBar)
    scrollBar:Show()
    scrollBar:Update()
    scrollBar:SetHideIfUnscrollable(true)
    scrollBar:SetHideTrackIfThumbExceedsTrack(true)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(1, 1)
    scrollFrame:SetScrollChild(scrollChild)
    Gui.scrollFrame = scrollFrame

    mGUI:EnableSmoothScroll(scrollFrame)
    mGUI.Renderer:SetHost(scrollFrame, scrollChild)

    -- Close with fade-out
    function Gui:Close()
        mGUI:FadeHide(Gui.frame)
    end

    -- Sidebar Tabs
    Gui.tabs = {}
    local tabData = {{
        name = "General",
        app = "mUIOptions_General_Tab",
        atlas = "poi-transmogrifier"
    }, {
        name = "Actionbars",
        app = "mUIOptions_Actionbars_Tab",
        atlas = "NPE_Icon"
    }, {
        name = "Unitframes",
        app = "mUIOptions_Unitframes_Tab",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\charactercreateicons.png]],
        customAtlas = true,
        texCoords = {0.44482421875, 0.50732421875, 0.1279296875, 0.2529296875}
    }, {
        name = "Castbars",
        app = "mUIOptions_Castbars_Tab",
        icon = [[Interface\Icons\Spell_Arcane_ArcaneResilience]]
    }, {
        name = "Nameplates",
        app = "mUIOptions_Nameplates_Tab",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\uitutorialnameplates.png]],
        customAtlas = true,
        texCoords = {0.3662109375, 0.7294921875, 0.2607421875, 0.5185546875}
    }, {
        name = "Tooltips",
        app = "mUIOptions_Tooltips_Tab",
        atlas = "QuestTurnin"
    }, {
        name = "Map & Minimap",
        app = "mUIOptions_MapMinimap_Tab",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\objecticonsatlas.png]],
        customAtlas = true,
        texCoords = {0.2998046875, 0.3369140625, 0.2939453125, 0.3310546875}
    }, {
        name = "Chat",
        app = "mUIOptions_Chat_Tab",
        atlas = "communities-icon-chat"
    }, {
        name = "Misc",
        app = "mUIOptions_Misc_Tab",
        icon = [[Interface\Icons\INV_Misc_Gear_01]]
    }, {
        name = "Profiles",
        app = "mUIOptions_Profiles_Tab",
        icon = [[Interface\Icons\INV_Misc_Note_01]]
    }, {
        name = "About",
        app = "mUIOptions_About_Tab",
        icon = [[Interface\AddOns\mUI\Media\Logo.png]]
    }}

    -- Raidframes is currently only split out into its own tab for Mainline -
    -- Mists/TBC/Vanilla still have raidframe options folded into the
    -- Unitframes tab (see Core.lua), so there's no category for them here.
    if mUI:GameVersion()["Mainline"] then
        table.insert(tabData, 4, {
            name = "Raidframes",
            app = "mUIOptions_Raidframes_Tab",
            icon = [[Interface\Icons\Spell_Holy_PrayerOfHealing02]]
        })
    end

    local TAB_HEIGHT = 40
    local TABS_TOP_OFFSET = 42 -- below the search box

    local BLANK = "Interface\\ChatFrame\\ChatFrameBackground"

    local function CreateSidebarTab(parent, data, index)
        local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
        button:SetSize(196, TAB_HEIGHT - 1)
        button:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -TABS_TOP_OFFSET - ((index - 1) * TAB_HEIGHT))
        -- Very translucent base so the window background shimmers through
        mGUI:ApplyBackdrop(button, "bgWidget", false, 0.18)

        -- Hover highlight (faint white), shown on enter when not selected
        local hoverTex = button:CreateTexture(nil, "BACKGROUND")
        hoverTex:SetAllPoints()
        hoverTex:SetTexture(BLANK)
        hoverTex:SetVertexColor(1, 1, 1, 0.06)
        hoverTex:Hide()
        button.hoverTex = hoverTex

        -- Selection highlight (accent), alpha animated in/out on select
        local selTex = button:CreateTexture(nil, "BORDER")
        selTex:SetAllPoints()
        selTex:SetTexture(BLANK)
        selTex:SetVertexColor(unpack(mGUI.Colors.accent))
        selTex:SetAlpha(0)
        button.selTex = selTex

        -- Accent bar on the left edge of the selected tab
        local selBar = button:CreateTexture(nil, "ARTWORK")
        selBar:SetPoint("TOPLEFT")
        selBar:SetPoint("BOTTOMLEFT")
        selBar:SetWidth(3)
        selBar:SetTexture(BLANK)
        selBar:SetVertexColor(unpack(mGUI.Colors.accent))
        selBar:SetAlpha(0)
        button.selBar = selBar

        -- Icon
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetSize(22, 22)
        icon:SetPoint("LEFT", button, "LEFT", 10, 0)
        if data.icon then
            icon:SetTexture(data.icon)
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        elseif data.atlas then
            if data.customAtlas then
                icon:SetTexture(data.atlas)
                icon:SetTexCoord(unpack(data.texCoords))
            else
                icon:SetAtlas(data.atlas)
                icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
        end
        button.icon = icon

        -- Text
        local text = button:CreateFontString(nil, "OVERLAY")
        text:SetPoint("LEFT", icon, "RIGHT", 10, 0)
        mGUI:SetFont(text, 13)
        text:SetText(data.name)
        text:SetTextColor(unpack(mGUI.Colors.text))
        button.text = text

        -- Enable/Disable toggle (right edge)
        local toggle = mGUI.Widgets.Checkbox(button)
        toggle:SetPoint("RIGHT", button, "RIGHT", -10, 0)
        toggle:Hide()
        mGUI:AttachTooltip(toggle, function()
            return toggle:GetChecked() and "Enabled" or "Disabled"
        end, function()
            local action = toggle:GetChecked() and "off" or "on"
            return ("Toggle this module %s.\n\n|cffffff00Info:|r Requires Reload"):format(action)
        end, function()
            return toggle:GetChecked() and {0, 1, 0} or {1, 0, 0}
        end)
        button.toggle = toggle

        -- Highlight
        button:SetScript("OnEnter", function(self)
            if not self.selected then
                self.hoverTex:Show()
                self.text:SetTextColor(1, 1, 1)
            end
        end)
        button:SetScript("OnLeave", function(self)
            if not self.selected then
                self.hoverTex:Hide()
                self.text:SetTextColor(unpack(mGUI.Colors.text))
            end
        end)

        return button
    end

    -- Select a tab and open its options page (with a smooth highlight transition)
    local SEL_ALPHA = 0.28
    function Gui:SelectTab(tabName)
        Gui.currentTab = tabName
        for name, tab in pairs(Gui.tabs) do
            if name == tabName then
                tab.selected = true
                tab.hoverTex:Hide()
                UIFrameFadeIn(tab.selTex, 0.2, tab.selTex:GetAlpha(), SEL_ALPHA)
                UIFrameFadeIn(tab.selBar, 0.2, tab.selBar:GetAlpha(), 1)
                tab.text:SetTextColor(unpack(mGUI.Colors.accent))
            else
                if tab.selected then
                    UIFrameFadeOut(tab.selTex, 0.2, tab.selTex:GetAlpha(), 0)
                    UIFrameFadeOut(tab.selBar, 0.2, tab.selBar:GetAlpha(), 0)
                end
                tab.selected = false
                tab.text:SetTextColor(unpack(mGUI.Colors.text))
            end
        end

        -- A lingering search results flyout would overlap the new page
        if mGUI.Search and mGUI.Search.results then
            mGUI.Search.results:Hide()
        end

        scrollFrame:SetVerticalScroll(0)
        mGUI.Renderer:RenderCategory(Gui.apps[tabName])
    end

    -- Show a category by registry key. Hidden categories (no sidebar tab, e.g.
    -- profile import/export) render without changing the tab selection.
    function Gui:SelectByKey(key)
        for name, app in pairs(Gui.apps) do
            if app == key then
                Gui:SelectTab(name)
                return
            end
        end
        scrollFrame:SetVerticalScroll(0)
        mGUI.Renderer:RenderCategory(key)
    end

    -- Create all tab buttons
    Gui.apps = {}
    for i, data in ipairs(tabData) do
        local tab = CreateSidebarTab(sidebar, data, i)
        tab:SetScript("OnClick", function()
            Gui:SelectTab(data.name)
        end)
        Gui.tabs[data.name] = tab
        Gui.apps[data.name] = data.app
    end

    -- Show + wire the sidebar enable/disable toggles for categories that expose
    -- an `enable` option (their in-page toggle is skipped by the renderer).
    function Gui:RefreshSidebarToggles()
        for name, tab in pairs(Gui.tabs) do
            local enable = mGUI:GetEnableOption(mGUI.categories[Gui.apps[name]])
            if enable then
                tab.toggle:Show()
                tab.toggle:SetChecked(enable.get and enable.get({}) or false)
                tab.toggle.OnValueChanged = function(_, checked)
                    if enable.set then
                        enable.set({}, checked)
                    end
                end
            else
                tab.toggle:Hide()
            end
        end
    end

    -- On Show — reopen on whatever tab the user was last viewing, defaulting
    -- to General only the very first time the GUI is ever shown.
    Gui.frame:SetScript("OnShow", function(self)
        Gui:RefreshSidebarToggles()
        Gui:SelectTab(Gui.currentTab or "General")

        if Gui.searchBox then
            mGUI:ApplyQuadBorder(Gui.searchBox, mGUI.Colors.border)
        end

        -- Closing with ESCAPE leaves propagation switched off, so restore it
        -- here or the first keypress of the next session is swallowed. In
        -- combat this is skipped along with everything else below.
        if not InCombatLockdown() then
            self:SetPropagateKeyboardInput(true)
        end
    end)

    -- ESC key handler — deliberately NOT using UISpecialFrames, since that
    -- system hides the frame instantly, bypassing Gui:Close()'s fade-out.
    -- Handling ESCAPE ourselves lets it share the same smooth close as the
    -- titlebar close button.
    Gui.frame:EnableKeyboard(true)

    -- Guarded for the same reason as the handler below: the GUI is built
    -- lazily on first open, which can happen mid-fight.
    if not InCombatLockdown() then
        Gui.frame:SetPropagateKeyboardInput(true)
    end

    Gui.frame:SetScript("OnKeyDown", function(self, key)
        local escape = key == "ESCAPE"

        -- SetPropagateKeyboardInput is protected, so calling it under combat
        -- lockdown raises ADDON_ACTION_BLOCKED. This handler runs on every
        -- keypress, so with the options open during a fight it fired on each
        -- one. Out of combat we steer propagation as before; in combat we
        -- leave it alone, which costs only that ESCAPE also reaches the game
        -- menu instead of being swallowed here.
        if not InCombatLockdown() then
            self:SetPropagateKeyboardInput(not escape)
        end

        if escape then
            Gui:Close()
        end
    end)

    -- Hide the frame by default
    Gui.frame:Hide()
end
