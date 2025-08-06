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
    if mUI:IsClassic() then
        Style.castbars = {
            player = "CastingBarFrame",
            target = "TargetFrameSpellBar",
            focus = "FocusFrameSpellBar",
            boss1 = "Boss1TargetFrameSpellBar",
            boss2 = "Boss2TargetFrameSpellBar",
            boss3 = "Boss3TargetFrameSpellBar",
            boss4 = "Boss4TargetFrameSpellBar",
            boss5 = "Boss5TargetFrameSpellBar"
        }
    else
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
    end

    -- Backup Default Functions
    Style.textfunc = TargetFrameSpellBar.Text.SetText

    function Style:EnableStyle(unit, castbar)
        if unit == "player" then
            if mUI:IsClassic() then
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
            else
                _G[castbar]:SetSize(209, 18)
                _G[castbar].StandardGlow:Hide()
                _G[castbar].TextBorder:Hide()
                _G[castbar].Border:Hide()
                _G[castbar].CastTimeText:Hide()
            end

            _G[castbar].Text:ClearAllPoints()
            if mUI:IsClassic() then
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 2)
            else
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 0)
            end
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
            _G[castbar].Text.SetText = function(frame, text)
                if strlen(text) > 19 then
                    Style.textfunc(frame, strsub(text, 0, 19) .. "...")
                else
                    Style.textfunc(frame, text)
                end
            end

            if mUI:IsClassic() then
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 4)
                _G[castbar].BorderShield:SetTexture(0)
            else
                _G[castbar]:SetSize(150, 12)
                _G[castbar].TextBorder:Hide()
                _G[castbar].BorderShield:ClearAllPoints()
                _G[castbar].BorderShield:SetPoint("CENTER", _G[castbar].Icon, "CENTER", 0, -2.5)
                _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, 2.5)
            end
        end
    end

    function Style:DisableStyle()
        for unit, castbar in pairs(Style.castbars) do
            if unit == "player" then
                _G[castbar]:SetSize(208.00001525879, 11.000000953674)
                if mUI:IsClassic() then
                    _G[castbar].Border:SetTexture([[Interface\CastingBar\UI-CastingBar-Border]])
                    _G[castbar].Flash:SetTexture([[Interface\CastingBar\UI-CastingBar-Flash]])
                    _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 12)
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 1, 4.5)
                else
                    _G[castbar].StandardGlow:Show()
                    _G[castbar].TextBorder:Show()
                    _G[castbar].Border:Show()
                    _G[castbar].Text:SetFont([[Fonts\FRIZQT__.TTF]], 10)
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -10)
                    _G[castbar].Icon:SetSize(16, 16)
                end
            else
                if mUI:IsClassic() then
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 1, 4.5)
                    _G[castbar].Icon:SetSize(16, 17)
                else
                    _G[castbar].TextBorder:Show()
                    _G[castbar]:SetSize(150, 10)
                    _G[castbar].BorderShield:SetPoint("TOPLEFT", _G[castbar], "TOPLEFT", -27, 4)
                    _G[castbar].Icon:SetSize(20, 20)
                    _G[castbar].Icon:SetPoint("RIGHT", _G[castbar], "LEFT", -2, -5)
                    _G[castbar].Text:SetPoint("TOP", _G[castbar], "TOP", 0, -8)
                end

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

    if mUI:IsClassic() then
        Style:SecureHookScript(CastingBarFrame, "OnUpdate", function(self)
            if not UnitIsUnit("player", self.unit) then return end

            local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo("player")
            local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo("player")

            if notInterruptibleCast or notInterruptibleChannel then
                self:SetStatusBarColor(0.7, 0.7, 0.7)
            else
                local color
                local isChannel = UnitChannelInfo("player")

                if isChannel then
                    color = self.startChannelColor
                else
                    color = self.startCastColor
                end

                self:SetStatusBarColor(color.r, color.g, color.b)
            end
        end)

        Style:SecureHookScript(TargetFrameSpellBar, "OnUpdate", function(self)
            if not UnitIsUnit("target", self.unit) then return end

            local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo("target")
            local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo("target")

            if notInterruptibleCast or notInterruptibleChannel then
                self:SetStatusBarColor(0.7, 0.7, 0.7)
            else
                local color
                local isChannel = UnitChannelInfo("target")

                if isChannel then
                    color = self.startChannelColor
                else
                    color = self.startCastColor
                end

                self:SetStatusBarColor(color.r, color.g, color.b)
            end
        end)

        Style:SecureHookScript(FocusFrameSpellBar, "OnUpdate", function(self)
            if not UnitIsUnit("focus", self.unit) then return end

            local _, _, _, _, _, _, _, notInterruptibleCast = UnitCastingInfo("focus")
            local _, _, _, _, _, _, notInterruptibleChannel = UnitChannelInfo("focus")

            if notInterruptibleCast or notInterruptibleChannel then
                self:SetStatusBarColor(0.7, 0.7, 0.7)
            else
                local color
                local isChannel = UnitChannelInfo("focus")

                if isChannel then
                    color = self.startChannelColor
                else
                    color = self.startCastColor
                end

                self:SetStatusBarColor(color.r, color.g, color.b)
            end
        end)
    else
        Style.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
        Style.frame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
        Style:SecureHookScript(Style.frame, "OnEvent", function()
            Style:EnableStyle("player", "PlayerCastingBarFrame")
        end)
    end
end

function Style:OnDisable()
    -- Disable Style
    Style:UnhookAll()
    Style:DisableStyle()
end
