local Classbar = mUI:NewModule("mUI.Modules.Unitframes.Classbar", "AceHook-3.0")

function Classbar:OnInitialize()
    Classbar.paladin = PaladinPowerBarFrame.Show
    Classbar.Monk = MonkHarmonyBarFrame.Show
    Classbar.Druid = DruidComboPointBarFrame.Show
    Classbar.Evoker = EssencePlayerFrame.Show
    Classbar.DK = RuneFrame.Show
    Classbar.Warlock = WarlockPowerFrame.Show
    Classbar.Mage = MageArcaneChargesFrame.Show
    Classbar.Rogue = RogueComboPointBarFrame.Show
end

function Classbar:OnEnable()
    local _, class = UnitClass("player")

    if class == "PALADIN" then
        PaladinPowerBarFrame:Hide()
        Classbar:HookScript(PaladinPowerBarFrame, "OnShow", function()
            PaladinPowerBarFrame:Hide()
            PaladinPowerBarFrame.Show = function() end
        end)
    end

    if class == "MONK" then
        MonkHarmonyBarFrame:Hide()
        Classbar:HookScript(MonkHarmonyBarFrame, "OnShow", function()
            MonkHarmonyBarFrame:Hide()
            MonkHarmonyBarFrame.Show = function() end
        end)
    end

    if class == "DRUID" then
        DruidComboPointBarFrame:Hide()
        Classbar:HookScript(DruidComboPointBarFrame, "OnShow", function()
            DruidComboPointBarFrame:Hide()
            DruidComboPointBarFrame.Show = function() end
        end)
    end

    if class == "EVOKER" then
        EssencePlayerFrame:Hide()
        Classbar:HookScript(EssencePlayerFrame, "OnShow", function()
            EssencePlayerFrame:Hide()
            EssencePlayerFrame.Show = function() end
        end)
    end

    if class == "DEATHKNIGHT" then
        RuneFrame:Hide()
        Classbar:HookScript(RuneFrame, "OnShow", function()
            RuneFrame:Hide()
            RuneFrame.Show = function() end
        end)
    end

    if class == "WARLOCK" then
        WarlockPowerFrame:Hide()
        Classbar:HookScript(WarlockPowerFrame, "OnShow", function()
            WarlockPowerFrame:Hide()
            WarlockPowerFrame.Show = function() end
        end)
    end

    if class == "MAGE" then
        MageArcaneChargesFrame:Hide()
        Classbar:HookScript(MageArcaneChargesFrame, "OnShow", function()
            MageArcaneChargesFrame:Hide()
            MageArcaneChargesFrame.Show = function() end
        end)
    end

    if class == "ROGUE" then
        RogueComboPointBarFrame:Hide()
        Classbar:HookScript(RogueComboPointBarFrame, "OnShow", function()
            RogueComboPointBarFrame:Hide()
            RogueComboPointBarFrame.Show = function() end
        end)
    end
end

function Classbar:OnDisable()
    Classbar:UnhookAll()
end
