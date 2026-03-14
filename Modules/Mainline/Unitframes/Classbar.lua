local Classbar = mUI:NewModule("mUI.Modules.Unitframes.Classbar", "AceHook-3.0")

local function HideFrame(frame)
    frame:Hide()
end

function Classbar:OnInitialize()
    -- Load Database
    Classbar.db = mUI.db.profile.unitframes

    function Classbar:Update(isEnabled)
        local _, class = UnitClass("player")

        if class == "PALADIN" then
            if isEnabled then
                PaladinPowerBarFrame:Hide()
                if not Classbar:IsHooked(PaladinPowerBarFrame, "Show") then
                    Classbar:SecureHook(PaladinPowerBarFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(PaladinPowerBarFrame, "Show")
                PaladinPowerBarFrame:Show()
            end
        end

        if class == "MONK" then
            if isEnabled then
                MonkHarmonyBarFrame:Hide()
                if not Classbar:IsHooked(MonkHarmonyBarFrame, "Show") then
                    Classbar:SecureHook(MonkHarmonyBarFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(MonkHarmonyBarFrame, "Show")
                MonkHarmonyBarFrame:Show()
            end
        end

        if class == "DEATHKNIGHT" then
            if isEnabled then
                RuneFrame:Hide()
                if not Classbar:IsHooked(RuneFrame, "Show") then
                    Classbar:SecureHook(RuneFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(RuneFrame, "Show")
                RuneFrame:Show()
            end
        end

        if class == "WARLOCK" then
            if isEnabled then
                WarlockPowerFrame:Hide()
                if not Classbar:IsHooked(WarlockPowerFrame, "Show") then
                    Classbar:SecureHook(WarlockPowerFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(WarlockPowerFrame, "Show")
                WarlockPowerFrame:Show()
            end
        end

        if class == "MAGE" then
            if isEnabled then
                MageArcaneChargesFrame:Hide()
                if not Classbar:IsHooked(MageArcaneChargesFrame, "Show") then
                    Classbar:SecureHook(MageArcaneChargesFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(MageArcaneChargesFrame, "Show")
                MageArcaneChargesFrame:Show()
            end
        end

        if class == "DRUID" then
            if isEnabled then
                DruidComboPointBarFrame:Hide()
                if not Classbar:IsHooked(DruidComboPointBarFrame, "Show") then
                    Classbar:SecureHook(DruidComboPointBarFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(DruidComboPointBarFrame, "Show")
                DruidComboPointBarFrame:Show()
            end
        end

        if class == "EVOKER" then
            if isEnabled then
                EssencePlayerFrame:Hide()
                if not Classbar:IsHooked(EssencePlayerFrame, "Show") then
                    Classbar:SecureHook(EssencePlayerFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(EssencePlayerFrame, "Show")
                EssencePlayerFrame:Show()
            end
        end

        if class == "ROGUE" then
            if isEnabled then
                RogueComboPointBarFrame:Hide()
                if not Classbar:IsHooked(RogueComboPointBarFrame, "Show") then
                    Classbar:SecureHook(RogueComboPointBarFrame, "Show", HideFrame)
                end
            else
                Classbar:Unhook(RogueComboPointBarFrame, "Show")
                RogueComboPointBarFrame:Show()
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
