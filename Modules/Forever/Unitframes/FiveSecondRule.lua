local FiveSecondRule = mUI:NewModule("mUI.Modules.Unitframes.FiveSecondRule")

local MANA = Enum.PowerType.Mana
local DURATION = 5

function FiveSecondRule:OnInitialize()
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

    -- A Druid's own mana bar while in a form, otherwise the one of the Player Frame
    local function GetManaBar()
        if PlayerFrame.state == "vehicle" then
            return
        end

        local DruidMana = mUI:GetModule("mUI.Modules.Unitframes.DruidMana", true)
        local druidBar = DruidMana and DruidMana.bar
        if druidBar and druidBar:IsShown() then
            return druidBar
        end

        if UnitPowerType("player") == MANA then
            return PlayerFrame_GetManaBar()
        end
    end

    function FiveSecondRule:Stop()
        FiveSecondRule.endTime = nil
        FiveSecondRule.frame:SetScript("OnUpdate", nil)
        FiveSecondRule.marker:Hide()
    end

    function FiveSecondRule:Update()
        local remaining = FiveSecondRule.endTime and (FiveSecondRule.endTime - GetTime()) or 0
        local bar = GetManaBar()
        if remaining <= 0 or not bar then
            FiveSecondRule:Stop()
            return
        end

        -- The marker goes with the bar, a change of form can change it
        local marker = FiveSecondRule.marker
        if marker:GetParent() ~= bar then
            marker:SetParent(bar)
            marker:SetAllPoints(bar)
        end

        marker.line:SetPoint("CENTER", marker, "LEFT", (1 - remaining / DURATION) * bar:GetWidth(), 0)
        marker.text:SetFormattedText("%.1f", remaining)
        marker:Show()
    end

    function FiveSecondRule:Start()
        FiveSecondRule.endTime = GetTime() + DURATION
        FiveSecondRule.frame:SetScript("OnUpdate", function()
            FiveSecondRule:Update()
        end)
        FiveSecondRule:Update()
    end

    function FiveSecondRule:Setup()
        if FiveSecondRule.frame then
            return
        end

        local frame = CreateFrame("Frame")
        frame:SetScript("OnEvent", function(_, _, _, _, spellID)
            if SpendsMana(spellID) then
                FiveSecondRule:Start()
            end
        end)

        local marker = CreateFrame("Frame", nil, UIParent)
        marker:Hide()
        marker.line = marker:CreateTexture(nil, "OVERLAY")
        marker.line:SetColorTexture(1, 1, 1, 0.95)
        marker.line:SetSize(2, 12)
        marker.text = marker:CreateFontString(nil, "OVERLAY", "TextStatusBarText")
        marker.text:SetPoint("TOP", marker, "BOTTOM", 0, -2)

        FiveSecondRule.frame = frame
        FiveSecondRule.marker = marker
    end
end

function FiveSecondRule:OnEnable()
    FiveSecondRule:Setup()
    FiveSecondRule.frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
end

function FiveSecondRule:OnDisable()
    if FiveSecondRule.frame then
        FiveSecondRule.frame:UnregisterAllEvents()
        FiveSecondRule:Stop()
    end
end
