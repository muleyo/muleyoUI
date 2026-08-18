local Style = mUI:NewModule("mUI.Modules.Castbars.Style", "AceHook-3.0")

function Style:OnInitialize()
    -- Load Database
    Style.db = {
        castbars = mUI.db.profile.castbars,
        general = mUI.db.profile.general
    }

    Style.LSM = LibStub("LibSharedMedia-3.0")
    Style.font = Style.LSM:Fetch('font', Style.db.general.font)

    -- Frames
    Style.frame = CreateFrame("Frame")

    -- Tables
    Style.castbars = {
        player = "PlayerCastingBarFrame",
        playerOverlay = "OverlayPlayerCastingBarFrame",
        target = "TargetFrameSpellBar",
        focus = "FocusFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }

    -- Backup Default Functions
    Style.textfunc = TargetFrameSpellBar.Text.SetText

    function Style:EnableStyle(unit, castbar)
        if unit == "player" or unit == "playerOverlay" then
            _G[castbar]:SetSize(209, 18)
            _G[castbar].StandardGlow:Hide()
            _G[castbar].TextBorder:Hide()
            _G[castbar].Border:Hide()

            _G[castbar].Text:ClearAllPoints()
            _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 0)
            _G[castbar].Text:SetFont(Style.font, 12, "OUTLINE")

            if Style.db.castbars.icon then
                _G[castbar].Icon:Show()
                _G[castbar].Icon:SetSize(20, 20)

                if _G[castbar].mUIBorder then
                    _G[castbar].mUIBorder:Show()
                end
            end
        else
            _G[castbar].Icon:SetSize(16, 16)
            _G[castbar].Icon:ClearAllPoints()
            _G[castbar].Icon:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -22, 2)
            _G[castbar].Text:ClearAllPoints()
            _G[castbar].Text:SetFont(Style.font, 11, "OUTLINE")
            _G[castbar]:SetSize(150, 12)
            _G[castbar].TextBorder:Hide()
            _G[castbar].BorderShield:ClearAllPoints()
            _G[castbar].BorderShield:SetPoint("CENTER", _G[castbar].Icon, "CENTER", 0, -2.5)
            _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 2.5)
            _G[castbar].Text:SetWidth(150)
            _G[castbar].Text:SetWordWrap(false)
        end
    end

    function Style:DisableStyle()
        for unit, castbar in pairs(Style.castbars) do
            if unit == "player" or unit == "playerOverlay" then
                _G[castbar]:SetSize(208.00001525879, 11.000000953674)
                _G[castbar].StandardGlow:Show()
                _G[castbar].TextBorder:Show()
                _G[castbar].Border:Show()
                _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 10)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -10)
                _G[castbar].Icon:SetSize(16, 16)
            else
                _G[castbar].TextBorder:Show()
                _G[castbar]:SetSize(150, 10)
                _G[castbar].BorderShield:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -27, 4)
                _G[castbar].Icon:SetSize(20, 20)
                _G[castbar].Icon:SetPoint("RIGHT", _G[castbar], "LEFT", -2, -5)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -8)
                _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 10)
                _G[castbar].Text.SetText = Style.textfunc
            end
        end
    end

    function Style:Update()
        for unit, castbar in pairs(Style.castbars) do
            Style:EnableStyle(unit, castbar)
        end
    end
end

function Style:OnEnable()
    -- Enable Style
    Style:Update()

    Style:SecureHookScript(PlayerCastingBarFrame, "OnEvent", function()
        Style:EnableStyle("player", "PlayerCastingBarFrame")
    end)

    Style:SecureHookScript(OverlayPlayerCastingBarFrame, "OnEvent", function()
        Style:EnableStyle("playerOverlay", "OverlayPlayerCastingBarFrame")
    end)

    Style:SecureHook(OverlayPlayerCastingBarFrame, "SetLook", function()
        Style:EnableStyle("playerOverlay", "OverlayPlayerCastingBarFrame")
    end)

    local function ReapplyPlayerCastbarStyle()
        if PlayerCastingBarFrame:IsShown() then
            Style:EnableStyle("player", "PlayerCastingBarFrame")
        end
        if OverlayPlayerCastingBarFrame:IsShown() then
            Style:EnableStyle("playerOverlay", "OverlayPlayerCastingBarFrame")
        end
    end

    for _, signal in ipairs({"PlayerSpellsFrame.TalentTab.Show", "PlayerSpellsFrame.TalentTab.Hide", "PlayerSpellsFrame.SpecFrame.Show",
                             "PlayerSpellsFrame.SpecFrame.Hide", "PlayerSpellsFrame.SpecFrame.ActivateSpec", "PlayerSpellsFrame.CloseFrame",
                             "TalentFrameBase.ButtonsUpdated"}) do
        EventRegistry:RegisterCallback(signal, ReapplyPlayerCastbarStyle, Style)
    end
end

function Style:OnDisable()
    -- Disable Style
    Style:UnhookAll()

    for _, signal in ipairs({"PlayerSpellsFrame.TalentTab.Show", "PlayerSpellsFrame.TalentTab.Hide", "PlayerSpellsFrame.SpecFrame.Show",
                             "PlayerSpellsFrame.SpecFrame.Hide", "PlayerSpellsFrame.SpecFrame.ActivateSpec", "PlayerSpellsFrame.CloseFrame",
                             "TalentFrameBase.ButtonsUpdated"}) do
        EventRegistry:UnregisterCallback(signal, Style)
    end

    Style:DisableStyle()
end
