local Achievements = mUI:NewModule("mUI.Modules.Misc.Achievements")

function Achievements:OnInitialize()
    Achievements.frame = CreateFrame("Frame")
    -- Current Achievement IDs
    Achievements.ids = {
        gladiator = 41032,
        shuffle = 41358,
        blitz = 41363
    }

    function Achievements:CreateButton(name, parent, label, yOffset)
        local button = CreateFrame("Button", name, UIParent, "UIPanelButtonTemplate")
        button:SetSize(25, 25)
        button:SetText(label)
        return button
    end

    -- Create Buttons
    Achievements.shuffleButton = Achievements:CreateButton("mUITrackShuffle", nil, ">", 0)
    Achievements.blitzButton = Achievements:CreateButton("mUITrackBlitz", nil, ">", 0)
    Achievements.gladButton = Achievements:CreateButton("mUITrackGlad", nil, ">", 0)

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

    Achievements.shuffleButton:Hide()
    Achievements.blitzButton:Hide()
    Achievements.gladButton:Hide()
end

function Achievements:OnEnable()
    Achievements.frame:RegisterEvent("ADDON_LOADED")
    Achievements.frame:SetScript("OnEvent", function(self, event, addon)
        if addon == "Blizzard_PVPUI" then
            -- Set Parents
            Achievements.shuffleButton:SetParent(ConquestFrame.RatedSoloShuffle)
            Achievements.blitzButton:SetParent(ConquestFrame.RatedBGBlitz)
            Achievements.gladButton:SetParent(ConquestFrame.Arena3v3)

            -- Set Points
            Achievements.shuffleButton:SetPoint("TOPRIGHT", ConquestFrame.RatedSoloShuffle, "TOPRIGHT", 10, -17.5)
            Achievements.blitzButton:SetPoint("TOPRIGHT", ConquestFrame.RatedBGBlitz, "TOPRIGHT", 10, -17.5)
            Achievements.gladButton:SetPoint("TOPRIGHT", ConquestFrame.Arena3v3, "TOPRIGHT", 10, -17.5)

            -- Show Buttons
            Achievements.shuffleButton:Show()
            Achievements.blitzButton:Show()
            Achievements.gladButton:Show()
        end
    end)
end

function Achievements:OnDisable()
    -- Hide Buttons
    Achievements.shuffleButton:Hide()
    Achievements.blitzButton:Hide()
    Achievements.gladButton:Hide()
end
