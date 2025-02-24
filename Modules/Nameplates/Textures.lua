local Textures = mUI:NewModule("mUI.Modules.Nameplates.Textures", "AceHook-3.0")

function Textures:OnInitialize()
    -- Load Database
    Textures.db = mUI.db.profile.nameplates

    -- Load LSM
    Textures.LSM = LibStub("LibSharedMedia-3.0")

    -- Create Frame
    Textures.textures = CreateFrame("Frame")

    -- Get Nameplates
    Textures.nameplates = {}

    function Textures:SetTextures(nameplate)
        local texture = Textures.LSM:Fetch('statusbar', Textures.db.texture)

        if nameplate.unit then
            if Textures.db.texture == "None" then
                nameplate.healthBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
            elseif not Textures.db.focus then
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

    function Textures:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Texture for Nameplate
            Textures:SetTextures(nameplate.UnitFrame)
        end
    end
end

function Textures:OnEnable()
    Textures.textures:RegisterEvent("PLAYER_FOCUS_CHANGED")
    Textures.textures:RegisterEvent("NAME_PLATE_CREATED")
    Textures.textures:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    Textures.textures:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    Textures:HookScript(Textures.textures, "OnEvent", function()
        Textures:RefreshNameplates()
    end)
end

function Textures:OnDisable()
    Textures:UnhookAll()
    Textures:RefreshNameplates()
end
