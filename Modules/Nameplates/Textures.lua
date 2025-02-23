local Textures = mUI:NewModule("mUI.Modules.Nameplates.Textures")

function Textures:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    -- Load LSM
    self.LSM = LibStub("LibSharedMedia-3.0")

    -- Create Frame
    self.textures = CreateFrame("Frame")

    -- Get Nameplates
    self.nameplates = {}

    function self:SetTextures(nameplate)
        local texture = self.LSM:Fetch('statusbar', self.db.texture)

        if nameplate.unit then
            if self.db.texture == "None" then
                nameplate.healthBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
            elseif not self.db.focus then
                nameplate.healthBar:SetStatusBarTexture(texture)
            else
                if not UnitIsUnit(nameplate.unit, "focus") then
                    nameplate.healthBar:SetStatusBarTexture(texture)
                else
                    nameplate.healthBar:SetStatusBarTexture(
                    [[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]])
                end
            end
        end
    end

    function self:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Texture for Nameplate
            self:SetTextures(nameplate.UnitFrame)
        end
    end
end

function Textures:OnEnable()
    self.textures:RegisterEvent("PLAYER_FOCUS_CHANGED")
    self.textures:RegisterEvent("NAME_PLATE_CREATED")
    self.textures:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self.textures:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    mUI:HookScript(self.textures, "OnEvent", function()
        self:RefreshNameplates()
    end)
end

function Textures:OnDisable()
    mUI:Unhook(self.textures, "OnEvent")
    self:RefreshNameplates()
end
