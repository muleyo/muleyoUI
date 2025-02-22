local Classbar = mUI:NewModule("mUI.Modules.Unitframes.Classbar")

function Classbar:OnInitialize()
    self.paladin = PaladinPowerBarFrame.Show
    self.Monk = MonkHarmonyBarFrame.Show
    self.Druid = DruidComboPointBarFrame.Show
    self.Evoker = EssencePlayerFrame.Show
    self.DK = RuneFrame.Show
    self.Warlock = WarlockPowerFrame.Show
    self.Mage = MageArcaneChargesFrame.Show
    self.Rogue = RogueComboPointBarFrame.Show
end

function Classbar:OnEnable()
    local _, class = UnitClass("player")

    if class == "PALADIN" then
        PaladinPowerBarFrame:Hide()
        mUI:HookScript(PaladinPowerBarFrame, "OnShow", function()
            PaladinPowerBarFrame:Hide()
            PaladinPowerBarFrame.Show = function() end
        end)
    end

    if class == "MONK" then
        MonkHarmonyBarFrame:Hide()
        mUI:HookScript(MonkHarmonyBarFrame, "OnShow", function()
            MonkHarmonyBarFrame:Hide()
            MonkHarmonyBarFrame.Show = function() end
        end)
    end

    if class == "DRUID" then
        DruidComboPointBarFrame:Hide()
        mUI:HookScript(DruidComboPointBarFrame, "OnShow", function()
            DruidComboPointBarFrame:Hide()
            DruidComboPointBarFrame.Show = function() end
        end)
    end

    if class == "EVOKER" then
        EssencePlayerFrame:Hide()
        mUI:HookScript(EssencePlayerFrame, "OnShow", function()
            EssencePlayerFrame:Hide()
            EssencePlayerFrame.Show = function() end
        end)
    end

    if class == "DEATHKNIGHT" then
        RuneFrame:Hide()
        mUI:HookScript(RuneFrame, "OnShow", function()
            RuneFrame:Hide()
            RuneFrame.Show = function() end
        end)
    end

    if class == "WARLOCK" then
        WarlockPowerFrame:Hide()
        mUI:HookScript(WarlockPowerFrame, "OnShow", function()
            WarlockPowerFrame:Hide()
            WarlockPowerFrame.Show = function() end
        end)
    end

    if class == "MAGE" then
        MageArcaneChargesFrame:Hide()
        mUI:HookScript(MageArcaneChargesFrame, "OnShow", function()
            MageArcaneChargesFrame:Hide()
            MageArcaneChargesFrame.Show = function() end
        end)
    end

    if class == "ROGUE" then
        RogueComboPointBarFrame:Hide()
        mUI:HookScript(RogueComboPointBarFrame, "OnShow", function()
            RogueComboPointBarFrame:Hide()
            RogueComboPointBarFrame.Show = function() end
        end)
    end
end

function Classbar:OnDisable()
    local _, class = UnitClass("player")
    if class == "PALADIN" then
        mUI:Unhook(PaladinPowerBarFrame, "OnShow")
        PaladinPowerBarFrame.Show = self.paladin
        PaladinPowerBarFrame:Show()
    end

    if class == "MONK" then
        mUI:Unhook(MonkHarmonyBarFrame, "OnShow")
        MonkHarmonyBarFrame.Show = self.Monk
        MonkHarmonyBarFrame:Show()
    end

    if class == "DRUID" then
        mUI:Unhook(DruidComboPointBarFrame, "OnShow")
        DruidComboPointBarFrame.Show = self.Druid
    end

    if class == "EVOKER" then
        mUI:Unhook(EssencePlayerFrame, "OnShow")
        EssencePlayerFrame.Show = self.Evoker
        EssencePlayerFrame:Show()
    end

    if class == "DEATHKNIGHT" then
        mUI:Unhook(RuneFrame, "OnShow")
        RuneFrame.Show = self.DK
        RuneFrame:Show()
    end

    if class == "WARLOCK" then
        mUI:Unhook(WarlockPowerFrame, "OnShow")
        WarlockPowerFrame.Show = self.Warlock
        WarlockPowerFrame:Show()
    end

    if class == "MAGE" then
        mUI:Unhook(MageArcaneChargesFrame, "OnShow")
        MageArcaneChargesFrame.Show = self.Mage
        MageArcaneChargesFrame:Show()
    end

    if class == "ROGUE" then
        mUI:Unhook(RogueComboPointBarFrame, "OnShow")
        RogueComboPointBarFrame.Show = self.Rogue
        RogueComboPointBarFrame:Show()
    end
end
