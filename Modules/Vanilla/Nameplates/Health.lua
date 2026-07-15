local Health = mUI:NewModule("mUI.Modules.Nameplates.Health", "AceHook-3.0")

function Health:OnInitialize()
    -- Load Database
    Health.db = {
        nameplates = mUI.db.profile.nameplates,
        general = mUI.db.profile.general
    }

    Health.LSM = LibStub("LibSharedMedia-3.0")
    Health.font = Health.LSM:Fetch('font', Health.db.general.font)

    -- Create Frame
    Health.health = CreateFrame("Frame")

    -- Tables
    Health.healthtexts = {}

    -- Variables
    local _, playerClass = UnitClass("player")

    function Health:HealthText(nameplate)
        if not Health.db.nameplates.healthtext then
            for healthtext in pairs(Health.healthtexts) do
                healthtext:SetText(nil)
            end
            return
        end

        if not nameplate or nameplate:IsForbidden() then
            return
        end
        if nameplate.unit:find('nameplate%d') then
            if nameplate.healthBar and UnitName("player") ~= UnitName(nameplate.unit) then
                local unit = nameplate.unit
                local healthBar = nameplate.healthBar
                local maxHealth = UnitHealthMax(unit)
                local currentHealth = UnitHealth(unit)

                if not healthBar.text then
                    healthBar.text = healthBar:CreateFontString(nil, "ARTWORK", nil)
                    healthBar.text:SetPoint("CENTER")
                    healthBar.text:SetFont(Health.font, 8, 'OUTLINE')
                    healthBar.text:SetText(string.format("%." .. Health.db.nameplates.decimals .. "f", (currentHealth / maxHealth) * 100) .. "%")
                    Health.healthtexts[healthBar.text] = true
                else
                    healthBar.text:SetText(string.format("%." .. Health.db.nameplates.decimals .. "f", (currentHealth / maxHealth) * 100) .. "%")
                end

                mUI:Skin(nameplate.healthBar.border)
                -- mUI:Skin({nameplate.CastBar.Border, nameplate.CastBar.BorderShield}, true)
            end
        end
    end

    function Health:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Name for Nameplate
            Health:HealthText(nameplate.UnitFrame)
        end
    end
end

function Health:OnEnable()
    Health:SecureHook("CompactUnitFrame_UpdateHealth", function(nameplate)
        Health:HealthText(nameplate)
    end)
end

function Health:OnDisable()
    Health:UnhookAll()
end
