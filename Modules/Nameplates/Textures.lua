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
                if not UnitIsUnit(nameplate.unit, "focus") then
                    if Textures.nameplates[nameplate] == "None" then return end

                    nameplate.healthBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])

                    Textures.nameplates[nameplate] = "None"
                else
                    if Textures.db.focus then
                        if Textures.nameplates[nameplate] == "Focus" then return end
                        nameplate.healthBar:SetStatusBarTexture(
                            [[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]])

                        Textures.nameplates[nameplate] = "Focus"
                    else
                        if Textures.nameplates[nameplate] == "defaultFocus" then return end
                        nameplate.healthBar:SetStatusBarTexture(
                            [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])

                        Textures.nameplates[nameplate] = "None"
                    end
                end
            else
                if not UnitIsUnit(nameplate.unit, "focus") then
                    if Textures.nameplates[nameplate] == "Custom" then return end

                    nameplate.healthBar:SetStatusBarTexture(texture)

                    Textures.nameplates[nameplate] = "Custom"
                else
                    if Textures.db.focus then
                        if Textures.nameplates[nameplate] == "Focus" then return end

                        nameplate.healthBar:SetStatusBarTexture(
                            [[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]])

                        Textures.nameplates[nameplate] = "Focus"
                    else
                        if Textures.nameplates[nameplate] == "Custom" then return end

                        nameplate.healthBar:SetStatusBarTexture(texture)

                        Textures.nameplates[nameplate] = "Custom"
                    end
                end
            end
        end
    end

    function Textures:RefreshNameplates(reset)
        -- Get Nameplates
        if reset then
            Textures.nameplates = {}
        end
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
    --Textures.textures:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    Textures:HookScript(Textures.textures, "OnEvent", function()
        Textures:RefreshNameplates()
    end)
end

function Textures:OnDisable()
    Textures:UnhookAll()
    Textures:RefreshNameplates()
end
