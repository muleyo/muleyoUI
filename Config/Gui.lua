local Gui = mUI:NewModule("mUI.Config.Gui")

function Gui:OnInitialize()
    -- Initialize Database
    Gui.db = mUI.db.profile.gui

    -- Libraries
    local AceGUI = LibStub("AceGUI-3.0")
    local ACD = LibStub("AceConfigDialog-3.0-mUI")
    local LSM = LibStub("LibSharedMedia-3.0")
    local font = LSM:Fetch('font', mUI.db.profile.general.font)

    -- Create Custom Options Frame
    Gui.frame = CreateFrame("Frame", "mUIOptions", UIParent, "BackdropTemplate")

    -- Set FrameStrata, Size and Default Position
    Gui.frame:SetFrameStrata("DIALOG")
    Gui.frame:SetSize(1100, 600)
    Gui.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    Gui.frame:SetScale(Gui.db.scale)

    -- Set Backdrop
    local pixel = mUI:Scale(1)
    Gui.frame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tileSize = pixel,
        edgeSize = pixel
    })

    -- Disable pixel snapping on border textures
    for _, region in next, {Gui.frame:GetRegions()} do
        if region and region.IsObjectType then
            mUI:DisablePixelSnap(region)
        end
    end

    Gui.frame:SetBackdropColor(0.05, 0.05, 0.05, 0.95)

    -- Make frame draggable
    Gui.frame:SetMovable(true)
    Gui.frame:SetUserPlaced(false)
    Gui.frame:SetClampedToScreen(true)
    Gui.frame:RegisterForDrag("LeftButton")

    -- Center GUI on login/reload
    Gui.frame:ClearAllPoints()
    Gui.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

    -- Create Header Bar
    local header = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    header:SetPoint("TOPLEFT", Gui.frame, "TOPLEFT", 2, -2)
    header:SetPoint("TOPRIGHT", Gui.frame, "TOPRIGHT", -2, -2)
    header:SetHeight(40)
    header:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = false
    })
    header:SetBackdropColor(0.02, 0.02, 0.02, 1)
    header:EnableMouse(true)
    header:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            Gui.frame:StartMoving()
        end
    end)
    header:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            Gui.frame:StopMovingOrSizing()
        end
    end)

    -- Title Text
    local titleText = header:CreateFontString(nil, "OVERLAY")
    titleText:SetPoint("LEFT", header, "LEFT", 15, 0)
    titleText:SetFont(font, 14, "OUTLINE")
    titleText:SetText("|cff009cffmuleyo|r|cffffd100UI|r " .. C_AddOns.GetAddOnMetadata("mUI", "version"))

    -- Create Slider Value Text
    local scaleText = header:CreateFontString(nil, "OVERLAY")
    scaleText:SetPoint("RIGHT", header, "RIGHT", -120, 0)
    scaleText:SetFont(font, 12, "OUTLINE")
    scaleText:SetText(math.floor(Gui.db.scale * 100) .. "%")
    scaleText:SetTextColor(1, 0.82, 0, 1)

    -- Create Scale Slider
    local scaleSlider = CreateFrame("Slider", nil, header, "MinimalSliderTemplate")
    scaleSlider:SetPoint("RIGHT", header, "RIGHT", -40, 0)
    scaleSlider:SetFrameLevel(header:GetFrameLevel() + 1)
    scaleSlider:SetSize(80, 10)
    scaleSlider:SetMinMaxValues(0.8, 1.5)
    scaleSlider:SetValue(Gui.db.scale)
    scaleSlider:SetValueStep(0.01)
    scaleSlider:SetObeyStepOnDrag(true)
    scaleSlider:HookScript("OnValueChanged", function(_, value)
        Gui.db.scale = value
        scaleText:SetText(math.floor(value * 100) .. "%")
    end)
    scaleSlider:HookScript("OnMouseUp", function()
        Gui.frame:SetScale(Gui.db.scale)
    end)

    -- Close Button
    local closeButton = CreateFrame("Button", nil, header)
    closeButton:SetPoint("RIGHT", header, "RIGHT", -10, 0)
    closeButton:SetSize(20, 20)

    -- Normal texture
    local normalTex = closeButton:CreateTexture(nil, "ARTWORK")
    normalTex:SetAllPoints()
    normalTex:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Core\\close")
    closeButton.normalTex = normalTex

    -- Highlight texture
    local highlightTex = closeButton:CreateTexture(nil, "HIGHLIGHT")
    highlightTex:SetAllPoints()
    highlightTex:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Core\\close_highlight")

    -- Create Sidebar for Tabs
    local sidebar = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    sidebar:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -1)
    sidebar:SetPoint("BOTTOMLEFT", Gui.frame, "BOTTOMLEFT", 2, 2)
    sidebar:SetWidth(200)
    sidebar:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = false
    })
    sidebar:SetBackdropColor(0.02, 0.02, 0.02, 0.9)

    -- Create Content Area
    local contentFrame = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    contentFrame:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 1, 0)
    contentFrame:SetPoint("BOTTOMRIGHT", Gui.frame, "BOTTOMRIGHT", -2, 2)
    contentFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        tile = false
    })
    contentFrame:SetBackdropColor(0.03, 0.03, 0.03, 0.8)
    contentFrame:SetBackdropColor(0.03, 0.03, 0.03, 0.8)

    -- Create Options Container within Content Area
    Gui.container = AceGUI:Create("SimpleGroup")
    Gui.container:SetLayout("Fill")
    Gui.container.frame:SetParent(contentFrame)
    Gui.container.frame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 10, -10)
    Gui.container.frame:SetPoint("BOTTOMRIGHT", contentFrame, "BOTTOMRIGHT", -20, 10)
    Gui.container.frame:SetClipsChildren(true)
    Gui.container.frame:Show()

    -- Hover effects
    closeButton:SetScript("OnEnter", function(self)
        self.normalTex:SetVertexColor(1, 0.3, 0.3)
    end)

    closeButton:SetScript("OnLeave", function(self)
        self.normalTex:SetVertexColor(1, 1, 1)
    end)

    closeButton:SetScript("OnClick", function()
        Gui.container:ReleaseChildren()
        local fadeInfo = {}
        fadeInfo.mode = "OUT"
        fadeInfo.timeToFade = 0.2
        fadeInfo.finishedFunc = function()
            Gui.frame:Hide()
        end
        UIFrameFade(Gui.frame, fadeInfo)
    end)

    -- Create Sidebar Tabs
    Gui.tabs = {}
    local tabData = {{
        name = "General",
        atlas = "poi-transmogrifier"
    }, {
        name = "Actionbars",
        atlas = "NPE_Icon"
    }, {
        name = "Unitframes",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\charactercreateicons.png]],
        customAtlas = true,
        texCoords = {0.44482421875, 0.50732421875, 0.1279296875, 0.2529296875}
    }, {
        name = "Castbars",
        icon = [[Interface\Icons\Spell_Arcane_ArcaneResilience]]
    }, {
        name = "Nameplates",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\uitutorialnameplates.png]],
        customAtlas = true,
        texCoords = {0.3662109375, 0.7294921875, 0.2607421875, 0.5185546875}
    }, {
        name = "Tooltips",
        atlas = "QuestTurnin"
    }, {
        name = "Map & Minimap",
        atlas = [[Interface\AddOns\mUI\Media\Textures\Config\objecticonsatlas.png]],
        customAtlas = true,
        texCoords = {0.2998046875, 0.3369140625, 0.2939453125, 0.3310546875}
    }, {
        name = "Chat",
        atlas = "communities-icon-chat"
    }, {
        name = "Misc",
        icon = [[Interface\Icons\INV_Misc_Gear_01]]
    }, {
        name = "Profiles",
        icon = [[Interface\Icons\INV_Misc_Note_01]]
    }, {
        name = "About",
        icon = [[Interface\AddOns\mUI\Media\Logo64x64.png]]
    }}

    local function CreateSidebarTab(parent, data, index)
        local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
        button:SetSize(196, 49)
        button:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -2 - ((index - 1) * 50))

        button:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            tile = false
        })
        button:SetBackdropColor(0.08, 0.08, 0.08, 0.8)

        -- Icon
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetSize(32, 32)
        icon:SetPoint("LEFT", button, "LEFT", 8, 0)
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
        text:SetFont(font, 13, "OUTLINE")
        text:SetText(data.name)
        text:SetTextColor(0.8, 0.8, 0.8)
        button.text = text

        -- Highlight
        button:SetScript("OnEnter", function(self)
            if not self.selected then
                self:SetBackdropColor(0.12, 0.12, 0.12, 1)
                self.text:SetTextColor(1, 1, 1)
            end
        end)

        button:SetScript("OnLeave", function(self)
            if not self.selected then
                self:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
                self.text:SetTextColor(0.8, 0.8, 0.8)
            end
        end)

        return button
    end

    -- Create all tab buttons
    for i, data in ipairs(tabData) do
        local tab = CreateSidebarTab(sidebar, data, i)
        Gui.tabs[data.name] = tab
    end

    -- Function to select a tab
    local function SelectTab(tabName)
        for name, tab in pairs(Gui.tabs) do
            if name == tabName then
                tab.selected = true
                tab:SetBackdropColor(0, 0.6, 1, 0.3)
                tab.text:SetTextColor(0, 0.8, 1)
            else
                tab.selected = false
                tab:SetBackdropColor(0.08, 0.08, 0.08, 0.8)
                tab.text:SetTextColor(0.8, 0.8, 0.8)
            end
        end
    end

    -- General Tab
    Gui.tabs["General"]:SetScript("OnClick", function()
        SelectTab("General")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_General_Tab", Gui.container)
    end)

    -- Actionbars Tab
    Gui.tabs["Actionbars"]:SetScript("OnClick", function()
        SelectTab("Actionbars")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Actionbars_Tab", Gui.container)
    end)

    -- Unitframes Tab
    Gui.tabs["Unitframes"]:SetScript("OnClick", function()
        SelectTab("Unitframes")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Unitframes_Tab", Gui.container)
    end)

    -- Castbars Tab
    Gui.tabs["Castbars"]:SetScript("OnClick", function()
        SelectTab("Castbars")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Castbars_Tab", Gui.container)
    end)

    -- Nameplates Tab
    Gui.tabs["Nameplates"]:SetScript("OnClick", function()
        SelectTab("Nameplates")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Nameplates_Tab", Gui.container)
    end)

    -- Tooltips Tab
    Gui.tabs["Tooltips"]:SetScript("OnClick", function()
        SelectTab("Tooltips")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Tooltips_Tab", Gui.container)
    end)

    -- Map & Minimap Tab
    Gui.tabs["Map & Minimap"]:SetScript("OnClick", function()
        SelectTab("Map & Minimap")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_MapMinimap_Tab", Gui.container)
    end)

    -- Chat Tab
    Gui.tabs["Chat"]:SetScript("OnClick", function()
        SelectTab("Chat")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Chat_Tab", Gui.container)
    end)

    -- Misc Tab
    Gui.tabs["Misc"]:SetScript("OnClick", function()
        SelectTab("Misc")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Misc_Tab", Gui.container)
    end)

    -- Profiles Tab
    Gui.tabs["Profiles"]:SetScript("OnClick", function()
        SelectTab("Profiles")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Profiles_Tab", Gui.container)
    end)

    -- About Tab
    Gui.tabs["About"]:SetScript("OnClick", function()
        SelectTab("About")
        Gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_About_Tab", Gui.container)
    end)

    -- On Show
    Gui.frame:SetScript("OnShow", function()
        SelectTab("General")
        ACD:Open("mUIOptions_General_Tab", Gui.container)
    end)

    -- On Hide
    Gui.frame:SetScript("OnHide", function()
        Gui.container:ReleaseChildren()
    end)

    -- ESC key handler
    tinsert(UISpecialFrames, "mUIOptions")

    -- Hide the frame by default
    Gui.frame:Hide()
end
