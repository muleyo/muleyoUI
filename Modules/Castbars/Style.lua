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

    function Style:EnableStyle(unit)
        if unit and unit == "player" then
            _G[Style.castbars[unit]]:SetSize(209, 18)
            _G[Style.castbars[unit]].StandardGlow:Hide()
            _G[Style.castbars[unit]].TextBorder:Hide()
            _G[Style.castbars[unit]].Border:Hide()
            _G[Style.castbars[unit]].Text:ClearAllPoints()
            _G[Style.castbars[unit]].Text:SetPoint("TOP", _G[Style.castbars[unit]], "TOP", 0, -1)
            _G[Style.castbars[unit]].Text:SetFont(Style.font, 12, "OUTLINE")
        else
            for unitframe, castbar in pairs(Style.castbars) do
                if unitframe == "player" then
                    _G[castbar]:SetSize(209, 18)
                    _G[castbar].StandardGlow:Hide()
                    _G[castbar].TextBorder:Hide()
                    _G[castbar].Border:Hide()
                    _G[castbar].Text:ClearAllPoints()
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -1)
                    _G[castbar].Text:SetFont(Style.font, 12, "OUTLINE")
                else
                    _G[castbar]:SetSize(150, 12)
                    _G[castbar].TextBorder:Hide()
                    _G[castbar].BorderShield:ClearAllPoints()
                    _G[castbar].BorderShield:SetPoint("CENTER", _G[castbar].Icon, "CENTER", 0, -2.5)
                    _G[castbar].Icon:SetSize(16, 16)
                    _G[castbar].Icon:ClearAllPoints()
                    _G[castbar].Icon:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -22, 2)
                    _G[castbar].Text:ClearAllPoints()
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 2.5)
                    _G[castbar].Text:SetFont(Style.font, 11, "OUTLINE")
                    _G[castbar].Text.SetText = function(frame, text)
                        if strlen(text) > 19 then
                            Style.textfunc(frame, strsub(text, 0, 19) .. "...")
                        else
                            Style.textfunc(frame, text)
                        end
                    end
                end
            end
        end

        if Style.db.castbars.icon then
            PlayerCastingBarFrame.Icon:Show()
            PlayerCastingBarFrame.Icon:SetSize(20, 20)

            if Style.db.general.theme ~= "Disabled" then
                C_Timer.After(0.1, function()
                    PlayerCastingBarFrame.mUIBorder:Show()
                end)
            end
        end
    end

    function Style:DisableStyle()
        for unitframe, castbar in pairs(Style.castbars) do
            if unitframe == "player" then
                _G[castbar]:SetSize(208.00001525879, 11.000000953674)
                _G[castbar].StandardGlow:Show()
                _G[castbar].TextBorder:Show()
                _G[castbar].Border:Show()
                _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 10)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -10)
                _G[castbar].Icon:SetSize(16, 16)
            else
                _G[castbar]:SetSize(150, 10)
                _G[castbar].TextBorder:Show()
                _G[castbar].BorderShield:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -27, 4)
                _G[castbar].Icon:SetSize(20, 20)
                _G[castbar].Icon:SetPoint("RIGHT", _G[castbar], "LEFT", -2, -5)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -8)
                _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 10)
                _G[castbar].Text.SetText = Style.textfunc
            end
        end
    end
end

function Style:OnEnable()
    -- Enable Style
    Style:EnableStyle()
    Style:HookScript(Style.frame, "OnEvent", function()
        C_Timer.After(0, function()
            Style:EnableStyle()
        end)
    end)
    Style:HookScript(PlayerCastingBarFrame, "OnEvent", function()
        Style:EnableStyle("player")
    end)
    Style:SecureHook(C_EditMode, "OnEditModeExit", Style.EnableStyle)
end

function Style:OnDisable()
    -- Disable Style
    Style:UnhookAll()
    Style:DisableStyle()
end
