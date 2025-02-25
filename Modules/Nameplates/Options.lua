local Options = mUI:NewModule("mUI.Modules.Nameplates.Options", "AceHook-3.0")

function Options:OnInitialize()
    -- Load Database
    Options.db = mUI.db.profile.nameplates

    -- Create Frame
    Options.options = CreateFrame("Frame")

    function Options:Update()
        if Options.db.smartstacking then
            SetCVar("nameplateMotion", 1)     -- Set Nameplate to Stacking-Mode
            SetCVar("nameplateOverlapH", 0.5) -- Set Nameplate Stacking Distance Horizontal
            SetCVar("nameplateOverlapV", 0.5) -- Set Nameplate Stacking Distance Vertical
            SetCVar("nameplateMinScale", 1)   -- Set Nameplate Stacking Distance Vertical
        end

        SetCVar("NamePlateVerticalScale", Options.db.height)  -- Set Nameplate Height
        SetCVar("NamePlateHorizontalScale", Options.db.width) -- Set Nameplate Width

        -- Update Nameplate Size
        C_NamePlate.SetNamePlateEnemySize(110 * Options.db.width, 45 * Lerp(1.0, 1.25, Options.db.height))

        if not Options.db.smallerfriends then
            C_NamePlate.SetNamePlateFriendlySize(110 * Options.db.width, 45 * Lerp(1.0, 1.25, Options.db.height))
        else
            C_NamePlate.SetNamePlateFriendlySize(60, 40)
        end
    end
end

function Options:OnEnable()
    Options.options:RegisterEvent("PLAYER_ENTERING_WORLD")
    Options.options:RegisterEvent("VARIABLES_LOADED")
    Options:HookScript(Options.options, "OnEvent", function()
        Options:Update()
    end)
end
