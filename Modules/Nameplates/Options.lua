local Options = mUI:NewModule("mUI.Modules.Nameplates.Options")

function Options:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    -- Create Frame
    self.options = CreateFrame("Frame")

    function self:Update()
        if self.db.smartstacking then
            SetCVar("nameplateMotion", 1)     -- Set Nameplate to Stacking-Mode
            SetCVar("nameplateOverlapH", 0.5) -- Set Nameplate Stacking Distance Horizontal
            SetCVar("nameplateOverlapV", 0.5) -- Set Nameplate Stacking Distance Vertical
            SetCVar("nameplateMinScale", 1)   -- Set Nameplate Stacking Distance Vertical
        end

        SetCVar("NamePlateVerticalScale", self.db.height)  -- Set Nameplate Height
        SetCVar("NamePlateHorizontalScale", self.db.width) -- Set Nameplate Width

        -- Update Nameplate Size
        C_NamePlate.SetNamePlateEnemySize(110 * self.db.width, 45 * Lerp(1.0, 1.25, self.db.height))

        if not self.db.smallerfriends then
            C_NamePlate.SetNamePlateFriendlySize(110 * self.db.width, 45 * Lerp(1.0, 1.25, self.db.height))
        else
            C_NamePlate.SetNamePlateFriendlySize(60, 40)
        end
    end
end

function Options:OnEnable()
    self.options:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.options:RegisterEvent("VARIABLES_LOADED")
    mUI:HookScript(self.options, "OnEvent", function()
        self:Update()
    end)
end

function Options:OnDisable()
    mUI:Unhook(self.options, "OnEvent")
end
