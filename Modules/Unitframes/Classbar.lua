local Classbar = mUI:NewModule("mUI.Modules.Unitframes.Classbar", "AceHook-3.0")

function Classbar:OnInitialize()
    -- Load Database
    Classbar.db = mUI.db.profile.unitframes

    -- Backup functions
    if mUI:IsClassic() then
        Classbar.Paladin = PaladinPowerBar.Show
        Classbar.Monk = MonkHarmonyBar.Show
        Classbar.DK = RuneFrame.Show
        Classbar.Warlock = WarlockPowerFrame.Show
    else
        Classbar.Paladin = PaladinPowerBarFrame.Show
        Classbar.Monk = MonkHarmonyBarFrame.Show
        Classbar.Druid = DruidComboPointBarFrame.Show
        Classbar.Evoker = EssencePlayerFrame.Show
        Classbar.DK = RuneFrame.Show
        Classbar.Warlock = WarlockPowerFrame.Show
        Classbar.Mage = MageArcaneChargesFrame.Show
        Classbar.Rogue = RogueComboPointBarFrame.Show
    end

    function Classbar:Update(isEnabled)
        local _, class = UnitClass("player")

        if class == "PALADIN" then
            if isEnabled then
                if mUI:IsClassic() then
                    PaladinPowerBar:Hide()
                    Classbar:SecureHookScript(PaladinPowerBar, "OnShow", function()
                        PaladinPowerBar:Hide()
                        PaladinPowerBar.Show = function() end
                    end)
                else
                    PaladinPowerBarFrame:Hide()
                    Classbar:SecureHookScript(PaladinPowerBarFrame, "OnShow", function()
                        PaladinPowerBarFrame:Hide()
                        PaladinPowerBarFrame.Show = function() end
                    end)
                end
            else
                if mUI:IsClassic() then
                    PaladinPowerBar.Show = Classbar.Paladin
                    PaladinPowerBar:Show()
                else
                    PaladinPowerBarFrame.Show = Classbar.Paladin
                    PaladinPowerBarFrame:Show()
                end
            end
        end

        if class == "MONK" then
            if isEnabled then
                if mUI:IsClassic() then
                    MonkHarmonyBar:Hide()
                    MonkHarmonyBar.Show = function() end
                else
                    MonkHarmonyBarFrame:Hide()
                    Classbar:SecureHookScript(MonkHarmonyBarFrame, "OnShow", function()
                        MonkHarmonyBarFrame:Hide()
                        MonkHarmonyBarFrame.Show = function() end
                    end)
                end
            else
                if mUI:IsClassic() then
                    MonkHarmonyBar.Show = Classbar.Monk
                    MonkHarmonyBar:Show()
                else
                    MonkHarmonyBarFrame.Show = Classbar.Monk
                    MonkHarmonyBarFrame:Show()
                end
            end
        end

        if class == "DEATHKNIGHT" then
            if isEnabled then
                RuneFrame:Hide()
                Classbar:SecureHookScript(RuneFrame, "OnShow", function()
                    RuneFrame:Hide()
                    RuneFrame.Show = function() end
                end)
            else
                RuneFrame.Show = Classbar.DK
                RuneFrame:Show()
            end
        end

        if class == "WARLOCK" then
            if isEnabled then
                if mUI:IsClassic() then
                    WarlockPowerFrame:Hide()
                    WarlockPowerFrame.Show = function() end
                else
                    WarlockPowerFrame:Hide()
                    Classbar:SecureHookScript(WarlockPowerFrame, "OnShow", function()
                        WarlockPowerFrame:Hide()
                        WarlockPowerFrame.Show = function() end
                    end)
                end
            else
                WarlockPowerFrame.Show = Classbar.Warlock
                WarlockPowerFrame:Show()
            end
            WarlockPowerFrame:Hide()
        end

        if not mUI:IsClassic() then
            if class == "MAGE" then
                if isEnabled then
                    MageArcaneChargesFrame:Hide()
                    Classbar:SecureHookScript(MageArcaneChargesFrame, "OnShow", function()
                        MageArcaneChargesFrame:Hide()
                        MageArcaneChargesFrame.Show = function() end
                    end)
                else
                    MageArcaneChargesFrame.Show = Classbar.Mage
                    MageArcaneChargesFrame:Show()
                end
            end

            if class == "DRUID" then
                if isEnabled then
                    DruidComboPointBarFrame:Hide()
                    Classbar:SecureHookScript(DruidComboPointBarFrame, "OnShow", function()
                        DruidComboPointBarFrame:Hide()
                        DruidComboPointBarFrame.Show = function() end
                    end)
                else
                    DruidComboPointBarFrame.Show = Classbar.Druid
                    DruidComboPointBarFrame:Show()
                end
            end

            if class == "EVOKER" then
                if isEnabled then
                    EssencePlayerFrame:Hide()
                    Classbar:SecureHookScript(EssencePlayerFrame, "OnShow", function()
                        EssencePlayerFrame:Hide()
                        EssencePlayerFrame.Show = function() end
                    end)
                else
                    EssencePlayerFrame.Show = Classbar.Evoker
                    EssencePlayerFrame:Show()
                end
            end

            if class == "ROGUE" then
                if isEnabled then
                    RogueComboPointBarFrame:Hide()
                    Classbar:SecureHookScript(RogueComboPointBarFrame, "OnShow", function()
                        RogueComboPointBarFrame:Hide()
                        RogueComboPointBarFrame.Show = function() end
                    end)
                else
                    RogueComboPointBarFrame.Show = Classbar.Rogue
                    RogueComboPointBarFrame:Show()
                end
            end
        end
    end
end

function Classbar:OnEnable()
    Classbar:Update(true)
end

function Classbar:OnDisable()
    Classbar:UnhookAll()
    Classbar:Update(false)
end
