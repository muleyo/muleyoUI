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
        PlayerFrame_GetManaBar().ManaBarMask:SetAtlas(
            shown and "Unit_BarMask" or "UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana-Mask",
            TextureKitConstants.UseAtlasSize)
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

    local function SpendsMana(spellID)
        if not spellID or issecretvalue(spellID) then
            return false
        end

        local ok, costs = pcall(C_Spell.GetSpellPowerCost, spellID)
        for _, cost in ipairs(ok and costs or {}) do
            if cost.type == MANA and not issecretvalue(cost.cost) and cost.cost > 0 then
                return true
            end
        end

        return false
    end

    local function GetManaBar()
        if DruidMana.bar and DruidMana.bar:IsShown() then
            return DruidMana.bar
        end

        if UnitPowerType("player") == MANA then
            return PlayerFrame_GetManaBar()
        end
    end

    function DruidMana:StopFiveSecondRule()
        DruidMana.endTime = nil
        DruidMana.rule:SetScript("OnUpdate", nil)
        DruidMana.marker:Hide()
    end

    function DruidMana:UpdateFiveSecondRule()
        local remaining = DruidMana.endTime and (DruidMana.endTime - GetTime()) or 0
        local bar = GetManaBar()
        if remaining <= 0 or not bar then
            DruidMana:StopFiveSecondRule()
            return
        end

        -- The marker goes with the bar, and a change of form can change the bar
        local marker = DruidMana.marker
        if marker:GetParent() ~= bar then
            marker:SetParent(bar)
            marker:SetAllPoints(bar)
        end

        marker.line:SetPoint("CENTER", marker, "LEFT", (1 - remaining / 5) * bar:GetWidth(), 0)
        marker.text:SetFormattedText("%.1f", remaining)
        marker:Show()
    end

    function DruidMana:StartFiveSecondRule()
        DruidMana.endTime = GetTime() + 5
        DruidMana.rule:SetScript("OnUpdate", function()
            DruidMana:UpdateFiveSecondRule()
        end)
        DruidMana:UpdateFiveSecondRule()
    end

    local function BuildRule()
        local rule = CreateFrame("Frame")
        rule:SetScript("OnEvent", function(_, _, _, _, spellID)
            if SpendsMana(spellID) then
                DruidMana:StartFiveSecondRule()
            end
        end)

        local marker = CreateFrame("Frame", nil, UIParent)
        marker:Hide()
        marker.line = marker:CreateTexture(nil, "OVERLAY")
        marker.line:SetColorTexture(1, 1, 1, 0.95)
        marker.line:SetSize(2, 12)
        marker.text = marker:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
        marker.text:SetPoint("TOP", marker, "BOTTOM", 0, -2)

        DruidMana.rule = rule
        DruidMana.marker = marker
    end

    local function Build()
        local content = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain
        local bar = CreateFrame("StatusBar", "mUIDruidManaBar", content,
            "PlayerFrameAlternatePowerBarBaseTemplate, AlternatePowerBarTemplate")

        bar:SetParent(content)
        bar:ClearAllPoints()
        bar:SetPoint("TOPLEFT", content, "TOPLEFT", 85, -73)
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

        DruidMana.bar = bar
    end

    function DruidMana:Setup()
        if not DruidMana.bar then
            Build()
            BuildRule()
        end
    end
end

function DruidMana:OnEnable()
    -- The addon of someone else that has the same bar in the same place
    if select(2, UnitClass("player")) ~= "DRUID" or C_AddOns.IsAddOnLoaded("MiniDruidMana") then
        return
    end

    DruidMana:Setup()

    DruidMana.rule:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

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
        DruidMana.rule:UnregisterAllEvents()
        DruidMana:StopFiveSecondRule()
    end
end
