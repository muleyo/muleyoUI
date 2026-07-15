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
            Textures.arrows.right:SetPoint("RIGHT", nameplate.healthBar, "RIGHT", 32, 0)

            Textures.arrows:Show()
        elseif not UnitExists("target") then
            Textures.arrows:Hide()
        end

        if nameplate.unit then
            -- NOTE: always reapply (no "skip if already set" cache check) -
            -- WoW recycles/reuses nameplate frame objects for different units
            -- (e.g. when plates go off/on screen from turning your character),
            -- and silently resets the health bar texture back to default when
            -- it reassigns a frame - a cache keyed on the frame reference can't
            -- detect that, so it must be unconditionally reapplied every time.
            if Textures.db.texture == "None" then
                if not UnitIsUnit(nameplate.unit, "focus") then
                    nameplate.healthBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
                else
                    if Textures.db.focus then
                        nameplate.healthBar:SetStatusBarTexture([[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]])
                    else
                        nameplate.healthBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
                    end
                end
            else
                if not UnitIsUnit(nameplate.unit, "focus") then
                    nameplate.healthBar:SetStatusBarTexture(texture)
                else
                    if Textures.db.focus then
                        nameplate.healthBar:SetStatusBarTexture([[Interface\AddOns\mUI\Media\Textures\Nameplates\focusTexture]])
                    else
                        nameplate.healthBar:SetStatusBarTexture(texture)
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
    Textures.textures:RegisterEvent("PLAYER_TARGET_CHANGED")
    Textures.textures:RegisterEvent("NAME_PLATE_CREATED")
    Textures.textures:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    Textures.textures:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

    Textures:SecureHookScript(Textures.textures, "OnEvent", function(_, event, unit)
        Textures:RefreshNameplates()
    end)
end

function Textures:OnDisable()
    Textures:UnhookAll()
    Textures:RefreshNameplates()
end
