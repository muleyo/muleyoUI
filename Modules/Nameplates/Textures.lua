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

    -- Target Arrows
    Textures.arrows = CreateFrame("Frame", nil)
    Textures.arrows.left = Textures.arrows:CreateTexture(nil, "OVERLAY")
    Textures.arrows.left:SetTexture([[Interface\AddOns\mUI\Media\Textures\Nameplates\arrowLeft.png]])
    Textures.arrows.left:SetSize(16, 16)
    Textures.arrows.right = Textures.arrows:CreateTexture(nil, "OVERLAY")
    Textures.arrows.right:SetTexture([[Interface\AddOns\mUI\Media\Textures\Nameplates\arrowRight.png]])
    Textures.arrows.right:SetSize(16, 16)

    function Textures:SetTextures(nameplate)
        local texture = Textures.LSM:Fetch('statusbar', Textures.db.texture)

        -- Target Arrows
        if UnitExists("target") and UnitIsUnit(nameplate.unit, "target") then
            Textures.arrows.left:SetPoint("LEFT", nameplate.healthBar, "LEFT", -16, 0)
            Textures.arrows.right:SetPoint("RIGHT", nameplate.healthBar, "RIGHT", 16, 0)

            Textures.arrows:Show()
        elseif not UnitExists("target") then
            Textures.arrows:Hide()
        end

        -- Hide Classification
        nameplate.ClassificationFrame:SetAlpha(0)

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

            -- Move Debuff Anchor
            if nameplate.BuffFrame and C_CVar.GetCVar("UnitNameNPC") == "1" then
                nameplate.BuffFrame:ClearAllPoints()
                nameplate.BuffFrame:SetPoint("TOPLEFT", nameplate.healthBar, "TOPLEFT", 0, -5)
            elseif nameplate.BuffFrame and C_CVar.GetCVar("UnitNameNPC") == "0" then
                nameplate.BuffFrame:ClearAllPoints()
                nameplate.BuffFrame:SetPoint("TOPLEFT", nameplate.healthBar, "TOPLEFT", 0, 17.5)
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
    Textures.textures:RegisterEvent("PLAYER_TARGET_CHANGED")
    Textures.textures:RegisterEvent("NAME_PLATE_CREATED")
    Textures.textures:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    --Textures.textures:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    Textures:HookScript(Textures.textures, "OnEvent", function(_, event)
        Textures:RefreshNameplates()
    end)
end

function Textures:OnDisable()
    Textures:UnhookAll()
    Textures:RefreshNameplates()
end
