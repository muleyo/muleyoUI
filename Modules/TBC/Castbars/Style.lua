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

    function Style:EnableStyle(unit, castbar)
        if unit == "player" then
            _G[castbar].Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border-Small]])
            _G[castbar].Flash:SetTexture([[Interface\CastingBar\UI-CastingBar-Flash-Small]])
            _G[castbar].Border:ClearAllPoints()
            _G[castbar].Border:SetPoint("CENTER", _G[castbar])
            _G[castbar].Flash:ClearAllPoints()
            _G[castbar].Flash:SetPoint("CENTER", _G[castbar])
            _G[castbar]:SetMovable(true)
            _G[castbar]:SetUserPlaced(true)
            _G[castbar]:ClearAllPoints()
            _G[castbar]:SetPoint("CENTER", UIParent, 0, -150)
            _G[castbar].Text:ClearAllPoints()
            _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 2)
            _G[castbar].Text:SetFont(Style.font, 12, "OUTLINE")

            if Style.db.castbars.icon then
                _G[castbar].Icon:Show()
                _G[castbar].Icon:SetSize(20, 20)

                if Style.db.general.theme ~= "Disabled" then
                    if _G[castbar].mUIBorder and (not _G[castbar].mUIBorder:IsVisible()) then
                        _G[castbar].mUIBorder:Show()
                    end
                end
            end
        else
            _G[castbar].Icon:SetSize(16, 16)
            _G[castbar].Icon:ClearAllPoints()
            _G[castbar].Icon:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -22, 2)
            _G[castbar].Text:ClearAllPoints()
            _G[castbar].Text:SetFont(Style.font, 11, "OUTLINE")

            -- Cast Time Text - Only for Classic
            _G[castbar].Text.SetText = function(frame, text)
                if strlen(text) > 19 then
                    Style.textfunc(frame, strsub(text, 0, 19) .. "...")
                else
                    Style.textfunc(frame, text)
                end
            end

            _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 4)
            _G[castbar].BorderShield:SetTexture(0)
        end
    end

    function Style:DisableStyle()
        for unit, castbar in pairs(Style.castbars) do
            if unit == "player" then
                _G[castbar]:SetSize(208.00001525879, 11.000000953674)
                _G[castbar].Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border]])
                _G[castbar].Flash:SetTexture([[Interface\CastingBar\UI-CastingBar-Flash]])
                _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 12)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 1, 4.5)
            else
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 1, 4.5)
                _G[castbar].Icon:SetSize(16, 17)
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

    Style.castEventFrame = Style.castEventFrame or CreateFrame("Frame")

    local unitToCastbar = {
        player = PlayerCastingBarFrame,
        target = TargetFrameSpellBar,
        focus = FocusFrameSpellBar
    }

    local function UpdateCastbarColor(unit)
        local castbar = unitToCastbar[unit]
        if not castbar then
            return
        end

        local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo(unit)
        local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo(unit)

        if notInterruptibleCast or notInterruptibleChannel then
            castbar:SetStatusBarColor(0.7, 0.7, 0.7)
        else
            local isChannel = UnitChannelInfo(unit)
            local color = isChannel and castbar.startChannelColor or castbar.startCastColor
            if color then
                castbar:SetStatusBarColor(color.r, color.g, color.b)
            end
        end
    end

    Style.castEventFrame:RegisterEvent("UNIT_SPELLCAST_START")
    Style.castEventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
    Style.castEventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
    Style.castEventFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")

    Style.castEventFrame:SetScript("OnEvent", function(_, event, unit)
        if unitToCastbar[unit] then
            UpdateCastbarColor(unit)
        end
    end)
end

function Style:OnDisable()
    -- Disable Style
    if Style.castEventFrame then
        Style.castEventFrame:UnregisterAllEvents()
    end
    Style:UnhookAll()
    Style:DisableStyle()
end
