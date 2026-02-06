local Options = mUI:NewModule("mUI.Modules.Nameplates.Options", "AceHook-3.0")

function Options:OnInitialize()
    -- Load Database
    Options.db = mUI.db.profile.nameplates

    -- Create Frame
    Options.options = CreateFrame("Frame")

    function Options:Update()
        if Options.db.smartstacking then
            SetCVar("nameplateMotion", 1) -- Set Nameplate to Stacking-Mode
            SetCVar("nameplateOverlapV", 0.25) -- Set Nameplate Stacking Distance Vertical
            SetCVar("nameplateMinScale", 1) -- Set Nameplate Stacking Distance Vertical
        end
    end
end

function Options:OnEnable()
    Options.options:RegisterEvent("PLAYER_ENTERING_WORLD")
    Options.options:RegisterEvent("VARIABLES_LOADED")
    Options:SecureHookScript(Options.options, "OnEvent", function()
        Options:Update()
    end)
end
