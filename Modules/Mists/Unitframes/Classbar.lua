local Classbar = mUI:NewModule("mUI.Modules.Unitframes.Classbar", "AceHook-3.0")

function Classbar:OnInitialize()
    -- Load Database
    Classbar.db = mUI.db.profile.unitframes

    -- Backup functions
    Classbar.Paladin = PaladinPowerBar.Show
    Classbar.Monk = MonkHarmonyBar.Show
    Classbar.DK = RuneFrame.Show
    Classbar.Warlock = WarlockPowerFrame.Show

    function Classbar:Update(isEnabled)
        local _, class = UnitClass("player")

        if class == "PALADIN" then
            if isEnabled then
                PaladinPowerBar:Hide()
                Classbar:SecureHookScript(PaladinPowerBar, "OnShow", function()
                    PaladinPowerBar:Hide()
                    PaladinPowerBar.Show = function()
                    end
                end)
            else
                PaladinPowerBar.Show = Classbar.Paladin
                PaladinPowerBar:Show()
            end
        end

        if class == "MONK" then
            if isEnabled then
                MonkHarmonyBar:Hide()
                MonkHarmonyBar.Show = function()
                end
            else
                MonkHarmonyBar.Show = Classbar.Monk
                MonkHarmonyBar:Show()
            end
        end

        if class == "DEATHKNIGHT" then
            if isEnabled then
                RuneFrame:Hide()
                Classbar:SecureHookScript(RuneFrame, "OnShow", function()
                    RuneFrame:Hide()
                    RuneFrame.Show = function()
                    end
                end)
            else
                RuneFrame.Show = Classbar.DK
                RuneFrame:Show()
            end
        end

        if class == "WARLOCK" then
            if isEnabled then
                WarlockPowerFrame:Hide()
                WarlockPowerFrame.Show = function()
                end
            else
                WarlockPowerFrame.Show = Classbar.Warlock
                WarlockPowerFrame:Show()
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
