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

    function Health:HealthText(nameplate)
        if not Health.db.nameplates.healthtext then
            for healthtext in pairs(Health.healthtexts) do
                healthtext:SetText(nil)
            end
            return
        end

        if not nameplate or nameplate:IsForbidden() then return end
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
                    healthBar.text:SetText(string.format("%." .. Health.db.nameplates.decimals .. "f",
                        (currentHealth / maxHealth) * 100) .. "%")
                    Health.healthtexts[healthBar.text] = true
                else
                    healthBar.text:SetText(string.format("%." .. Health.db.nameplates.decimals .. "f",
                        (currentHealth / maxHealth) * 100) .. "%")
                end
            end
        end
    end

    function Health:Colors(nameplate)
        if not Health.db.nameplates.colors then return end
        if not nameplate or nameplate:IsForbidden() then return end
        if nameplate.unit and nameplate.unit:find('nameplate%d') then
            local playerRole = UnitGroupRolesAssigned("player")
            if UnitIsPlayer(nameplate.unit) then return end
            local healthBar = nameplate.healthBar
            local _, _, _, _, _, id = strsplit("-", UnitGUID(nameplate.unit) or "")
            local _, status = UnitDetailedThreatSituation("player", nameplate.unit)
            local rColor = FACTION_BAR_COLORS[UnitReaction(nameplate.unit, "player")]
            local color = Health.db.nameplates.npccolors[tonumber(id)] and
                Health.db.nameplates.npccolors[tonumber(id)].color or { r = 0, g = 1, b = 0.6 }
            local nColor = Health.db.nameplates.npccolors[tonumber(id)] and
                Health.db.nameplates.npccolors[tonumber(id)].color or { r = 1, g = 0, b = 0.3 }

            if (not status) or playerRole == "NONE" then
                if (UnitIsTapDenied(nameplate.unit)) and not UnitPlayerControlled(nameplate.unit) then
                    healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                elseif (not UnitIsTapDenied(nameplate.unit)) then
                    if mUI.db.profile.nameplates.npccolors[tonumber(id)] then
                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b)
                    else
                        healthBar:SetStatusBarColor(rColor.r, rColor.g, rColor.b);
                    end
                end
            else
                if playerRole == "TANK" then
                    if status and status == 3 then
                        healthBar:SetStatusBarColor(color.r, color.g, color.b)
                    elseif status and status == 2 then
                        healthBar:SetStatusBarColor(0.9, 0.7, 0)
                    else
                        healthBar:SetStatusBarColor(0.8, 0.3, 0.22)
                    end
                else
                    if status and status == 3 then
                        healthBar:SetStatusBarColor(0.8, 0.3, 0.22)
                    elseif status and status == 2 then
                        healthBar:SetStatusBarColor(0.9, 0.7, 0)
                    else
                        healthBar:SetStatusBarColor(color.r, color.g, color.b)
                    end
                end
            end
        end
    end

    function Health:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Name for Nameplate
            Health:HealthText(nameplate.UnitFrame)
            Health:Colors(nameplate.UnitFrame)
        end
    end
end

function Health:OnEnable()
    Health:SecureHook("CompactUnitFrame_UpdateHealth", function(nameplate)
        Health:HealthText(nameplate)
    end)

    Health:SecureHook("CompactUnitFrame_UpdateHealthColor", function(nameplate)
        Health:Colors(nameplate)
    end)
end

function Health:OnDisable()
    Health:UnhookAll()
end
