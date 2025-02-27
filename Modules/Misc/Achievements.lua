local Achievements = mUI:NewModule("mUI.Modules.Misc.Achievements")

function Achievements:OnInitialize()
    -- Current Achievement IDs
    Achievements.ids = {
        gladiator = 41032,
        shuffle = 41358,
        blitz = 41363
    }

    function Achievements:CreateButton(name, parent, label, yOffset)
        local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
        button:SetSize(25, 25)
        button:SetPoint("TOPLEFT", -360, yOffset)
        button:SetText(label)
        return button
    end

    -- Create Frame
    Achievements.frame = CreateFrame("Frame", "mUIAchievementButtons")
    Achievements.frame:SetSize(200, 150)
    Achievements.frame:SetPoint("CENTER")

    -- Create Buttons
    Achievements.shuffleButton = Achievements:CreateButton("mUITrackShuffle", Achievements.frame, ">", 277.5)
    Achievements.blitzButton = Achievements:CreateButton("mUITrackBlitz", Achievements.frame, ">", 220)
    Achievements.gladButton = Achievements:CreateButton("mUITrackGlad", Achievements.frame, ">", 110)

    -- Set Scripts
    Achievements.shuffleButton:SetScript("OnClick", function()
        C_ContentTracking.ToggleTracking(2, Achievements.ids.shuffle, 2)
    end)

    Achievements.blitzButton:SetScript("OnClick", function()
        C_ContentTracking.ToggleTracking(2, Achievements.ids.blitz, 2)
    end)

    Achievements.gladButton:SetScript("OnClick", function()
        C_ContentTracking.ToggleTracking(2, Achievements.ids.gladiator, 2)
    end)

    -- Hide Frame
    Achievements.frame:Hide()
end

function Achievements:OnEnable()
    C_Timer.After(0, function()
        Achievements.frame:SetParent(ConquestFrame.RatedSoloShuffle)
    end)

    Achievements.frame:Show()
end

function Achievements:OnDisable()
    Achievements.frame:Hide()
end
