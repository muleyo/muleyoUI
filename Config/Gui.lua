local Gui = mUI:NewModule("mUI.Config.Gui")

function Gui:OnInitialize()
    -- Initialize Database
    self.db = mUI.db.profile.gui

    -- Libraries
    local AceGUI = LibStub("AceGUI-3.0")
    local ACD = LibStub("AceConfigDialog-3.0")

    -- Create Options Frame
    local gui = CreateFrame("Frame", "mUIOptions", UIParent, "PortraitFrameTemplate")

    -- Set FrameStrata, Size and Default Position
    gui:SetFrameStrata("DIALOG")
    gui:SetSize(900, 500)
    gui:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
    gui:SetScale(self.db.scale)

    -- Set Background, Title and Portrait
    gui.TitleContainer.TitleText:SetText("|cff009cffmuleyo|rUI (" .. C_AddOns.GetAddOnMetadata("mUI", "version") .. ")")
    gui.TitleContainer.TitleText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    gui.PortraitContainer.portrait:SetTexture("Interface\\AddOns\\mUI\\Media\\logo.png")
    gui.Bg:SetColorTexture(-0.05, -0.05, -0.05, 0.8)

    -- Make frame draggable
    gui:SetMovable(true)
    gui:SetUserPlaced(true)
    gui:SetClampedToScreen(true)
    gui:SetClampRectInsets(800, -800, 0, 400)
    gui:RegisterForDrag("LeftButton")
    gui.TitleContainer:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then
            gui:StartMoving()
        end
    end)
    gui.TitleContainer:SetScript("OnMouseUp", function(_, button)
        if button == "LeftButton" then
            gui:StopMovingOrSizing()
        end
    end)

    -- Create Slider Value Text
    gui.scaleText = gui.TitleContainer:CreateFontString(nil, "OVERLAY")
    gui.scaleText:SetPoint("RIGHT", gui.TitleContainer, "RIGHT", -80, -1)
    gui.scaleText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    gui.scaleText:SetText(math.floor(self.db.scale * 100) .. "%")
    gui.scaleText:SetTextColor(1, 0.81960791349411, 0, 1)

    -- Create Scale Slider
    gui.scaleSlider = CreateFrame("Slider", nil, gui.TitleContainer, "MinimalSliderTemplate")
    gui.scaleSlider:SetPoint("RIGHT", gui.TitleContainer, "RIGHT", -3, -1)
    gui.scaleSlider:SetFrameLevel(gui.TitleContainer:GetFrameLevel() + 1)
    gui.scaleSlider:SetSize(80, 10)
    gui.scaleSlider:SetMinMaxValues(0.8, 1.5)
    gui.scaleSlider:SetValue(self.db.scale)
    gui.scaleSlider:SetValueStep(0.01)
    gui.scaleSlider:SetObeyStepOnDrag(true)
    gui.scaleSlider:HookScript("OnValueChanged", function(_, value)
        self.db.scale = value
        gui.scaleText:SetText(math.floor(value * 100) .. "%")
    end)
    gui.scaleSlider:HookScript("OnMouseUp", function()
        gui:SetScale(self.db.scale)
    end)

    -- Create Options Container
    gui.container = AceGUI:Create("ScrollFrame")
    gui.container:SetLayout("Fill")
    gui.container.frame:SetParent(gui)
    gui.container.frame:SetPoint("TOPLEFT", gui, "TOPLEFT", 25, -55)
    gui.container.frame:SetPoint("BOTTOMRIGHT", gui, "BOTTOMRIGHT", -25, 25)
    gui.container.content:SetPoint("TOPLEFT", gui, "TOPLEFT", 25, -55)
    gui.container.content:SetPoint("BOTTOMRIGHT", gui, "BOTTOMRIGHT", -25, 25)
    gui.container.frame:SetClipsChildren(true)
    gui.container.frame:Show()

    -- Create Tabs (credits to Slothpala)
    local function createTabs(frame, ...)
        local tab_system = CreateFrame("Frame", mUIOptionsTabs, frame, "TabSystemTemplate")
        local tabs = {}
        tab_system:SetTabSelectedCallback(function() end)
        tab_system:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 15, 2)
        for k, v in pairs({ ... }) do
            tab_system:AddTab(v)
            local tab = tab_system:GetTabButton(k)
            local min_width = tab.Left:GetWidth() + tab.Middle:GetWidth() + tab.Right:GetWidth()
            local text_width = tab.Text:GetWidth() + 20
            tab:SetWidth(math.max(min_width, text_width))
            tabs[v] = tab
        end
        tab_system:SetTab(1)
        tab_system:SetFrameStrata("DIALOG")
        return tab_system, tabs
    end

    gui.tab_system, gui.tabs = createTabs(
        gui,
        "General",
        "Actionbars",
        "Unitframes",
        "Castbars",
        "Nameplates",
        "Tooltips",
        "Map & Minimap",
        "Chat",
        "Misc",
        "Profiles",
        "About"
    )

    -- General Tab
    gui.tabs["General"]:HookScript("OnClick", function(self)
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_General_Tab", gui.container)
    end)

    -- Actionbars Tab
    gui.tabs["Actionbars"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Actionbars_Tab", gui.container)
    end)

    -- Unitframes Tab
    gui.tabs["Unitframes"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Unitframes_Tab", gui.container)
    end)

    -- Castbars Tab
    gui.tabs["Castbars"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Castbars_Tab", gui.container)
    end)

    -- Nameplates Tab
    gui.tabs["Nameplates"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Nameplates_Tab", gui.container)
    end)

    -- Tooltips Tab
    gui.tabs["Tooltips"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Tooltips_Tab", gui.container)
    end)

    -- Map & Minimap Tab
    gui.tabs["Map & Minimap"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_MapMinimap_Tab", gui.container)
    end)

    -- Chat Tab
    gui.tabs["Chat"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Chat_Tab", gui.container)
    end)

    -- Misc Tab
    gui.tabs["Misc"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Misc_Tab", gui.container)
    end)

    -- Profile Tab
    gui.tabs["Profiles"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_Profiles_Tab", gui.container)
    end)

    -- About Tab
    gui.tabs["About"]:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        ACD:Open("mUIOptions_About_Tab", gui.container)
    end)

    -- Smooth fade-out on close/esc
    gui.CloseButton:HookScript("OnClick", function()
        gui.container:ReleaseChildren()
        local fadeInfo = {}
        fadeInfo.mode = "OUT"
        fadeInfo.timeToFade = 0.2
        fadeInfo.finishedFunc = function()
            gui:Hide()
        end
        UIFrameFade(gui, fadeInfo)
    end)

    gui:HookScript("OnShow", function()
        gui.tab_system:SetTab(1)
        ACD:Open("mUIOptions_General_Tab", gui.container)
    end)

    gui:HookScript("OnHide", function()
        gui.container:ReleaseChildren()
    end)

    -- Theme gui Frame
    mUI:Skin(gui.NineSlice, false, true)
    mUI:Skin(gui.tabs["General"], false, true)
    mUI:Skin(gui.tabs["Actionbars"], false, true)
    mUI:Skin(gui.tabs["Unitframes"], false, true)
    mUI:Skin(gui.tabs["Castbars"], false, true)
    mUI:Skin(gui.tabs["Nameplates"], false, true)
    mUI:Skin(gui.tabs["Tooltips"], false, true)
    mUI:Skin(gui.tabs["Map & Minimap"], false, true)
    mUI:Skin(gui.tabs["Chat"], false, true)
    mUI:Skin(gui.tabs["Misc"], false, true)
    mUI:Skin(gui.tabs["Profiles"], false, true)
    mUI:Skin(gui.tabs["About"], false, true)

    -- Hide the frame by default
    gui:Hide()
end
