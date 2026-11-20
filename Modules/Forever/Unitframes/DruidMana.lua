local DruidMana = mUI:NewModule("mUI.Modules.Unitframes.DruidMana", "AceHook-3.0")

local LSM = LibStub("LibSharedMedia-3.0")
local MANA = Enum.PowerType.Mana

function DruidMana:OnInitialize()
    local function ShouldShow()
        return DruidMana:IsEnabled() and PlayerFrame.state ~= "vehicle" and not UNIT_FRAME_SHOW_HEALTH_ONLY and
            UnitPowerType("player") ~= MANA and
            PlayerFrame_GetAlternatePowerBar() == nil
    end

    function DruidMana:SyncArt()
        if PlayerFrame.state == "vehicle" or UNIT_FRAME_SHOW_HEALTH_ONLY then
            return
        end

        local art = PlayerFrame.PlayerFrameContainer
        local shown = (DruidMana.bar ~= nil and DruidMana.bar:IsShown()) or PlayerFrame_GetAlternatePowerBar() ~= nil

        art.FrameTexture:SetShown(not shown)
        art.AlternatePowerFrameTexture:SetShown(shown)
        art.FrameFlash:SetAtlas(
            "UI-HUD-UnitFrame-Player-PortraitOn-" .. (shown and "ClassResource-" or "") .. "InCombat",
            TextureKitConstants.UseAtlasSize)

        local Style = mUI:GetModule("mUI.Modules.Unitframes.Style", true)
        if Style then
            Style:UpdatePlayerFlash()
        end
    end

    function DruidMana:UpdatePosition()
        local bar = DruidMana.bar
        if not bar then
            return
        end

        local Style = mUI:GetModule("mUI.Modules.Unitframes.Style", true)
        local content = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain

        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", content, "TOPLEFT", (Style and Style.active) and 85 or 87, -73)
    end

    function DruidMana:Refresh()
        DruidMana.bar:EvaluateUnit()
        DruidMana:SyncArt()
    end

    function DruidMana:ApplyTexture()
        local name = mUI.db.profile.unitframes.textures.unitframes
        local path = name ~= "None" and LSM:Fetch("statusbar", name, true)

        if path then
            DruidMana.bar:SetStatusBarTexture(path)
            DruidMana.bar:SetStatusBarColor(0, 0.5, 1)
        end
    end

    function DruidMana:UpdateTexture()
        if DruidMana.bar then
            DruidMana.bar:UpdateArt()
        end
    end

    local function Build()
        local content = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
        local bar = CreateFrame("StatusBar", "mUIDruidManaBar", content,
            "PlayerFrameAlternatePowerBarBaseTemplate, AlternatePowerBarTemplate")

        bar:SetParent(content)
        DruidMana.bar = bar
        DruidMana:UpdatePosition()
        bar:SetFrameLevel(content:GetFrameLevel())
        bar:SetMouseClickEnabled(false)
        bar.unit = "player"

        -- Replaces the text of the text status bar: it compares the mana, which is a secret number that tainted code can't compare
        function bar:UpdateTextString()
            local center, left, right = self.TextString, self.LeftText, self.RightText
            center:Hide()
            left:Hide()
            right:Hide()

            if not self.isEnabled or (GetCVar("statusText") ~= "1" and self.lockShow <= 0) then
                return
            end

            local mode = GetCVar("statusTextDisplay")
            if mode == "PERCENT" then
                center:SetFormattedText("%.0f%%", UnitPowerPercent("player", MANA, true, CurveConstants.ScaleTo100))
                center:Show()
            elseif mode == "BOTH" then
                left:SetFormattedText("%.0f%%", UnitPowerPercent("player", MANA, true, CurveConstants.ScaleTo100))
                left:Show()
                right:SetText(AbbreviateLargeNumbers(UnitPower("player", MANA)))
                right:Show()
            else
                center:SetFormattedText("%s / %s", AbbreviateLargeNumbers(UnitPower("player", MANA)),
                    AbbreviateLargeNumbers(UnitPowerMax("player", MANA)))
                center:Show()
            end
        end

        function bar:EvaluateUnit()
            self:SetPowerType(MANA, "MANA", true)
            self:SetBarEnabled(ShouldShow() and true or false)
        end

        function bar:AttachBarToUnitUI()
            self:Show()
        end

        function bar:RemoveBarFromUnitUI()
        end

        bar:HookScript("OnShow", function()
            DruidMana:SyncArt()
        end)
        bar:HookScript("OnHide", function()
            DruidMana:SyncArt()
        end)
    end

    function DruidMana:Setup()
        if not DruidMana.bar then
            Build()

            -- The Retail style has art for its mask
            local Style = mUI:GetModule("mUI.Modules.Unitframes.Style", true)
            if Style then
                Style:UpdateArt()
            end
        end
    end
end

function DruidMana:OnEnable()
    -- The addon of someone else that has the same bar in the same place
    if select(2, UnitClass("player")) ~= "DRUID" or C_AddOns.IsAddOnLoaded("MiniDruidMana") then
        return
    end

    DruidMana:Setup()

    DruidMana:SecureHook(DruidMana.bar, "UpdateArt", "ApplyTexture")
    DruidMana:SecureHook("PlayerFrame_ToPlayerArt", "Refresh")
    DruidMana:SecureHook("PlayerFrame_ToVehicleArt", "Refresh")

    DruidMana:Refresh()
end

function DruidMana:OnDisable()
    DruidMana:UnhookAll()

    -- Gone, and the frame gets the art it has without it
    if DruidMana.bar then
        DruidMana.bar:SetBarEnabled(false)
    end
end
