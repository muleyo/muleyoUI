local Health = mUI:NewModule("mUI.Modules.Nameplates.Health")

function Health:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    -- Create Frame
    self.health = CreateFrame("Frame")

    -- Tables
    self.healthtexts = {}

    function self:HealthText(nameplate)
        if not self.db.healthtext then
            for healthtext in pairs(self.healthtexts) do
                healthtext:SetText(nil)
            end

            nameplate.healthBar.text:SetText(nil)
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
                    healthBar.text:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
                    healthBar.text:SetText(string.format("%." .. self.db.decimals .. "f",
                        (currentHealth / maxHealth) * 100) .. "%")
                    self.healthtexts[healthBar.text] = true
                else
                    healthBar.text:SetText(string.format("%." .. self.db.decimals .. "f",
                        (currentHealth / maxHealth) * 100) .. "%")
                end
            end
        end
    end

    function self:Colors(nameplate)
        if not self.db.colors then return end
        if nameplate and nameplate:IsForbidden() then return end
        if nameplate.unit and nameplate.unit:find('nameplate%d') then
            local playerRole = UnitGroupRolesAssigned("player")
            if UnitIsPlayer(nameplate.unit) or (not UnitCanAttack("player", nameplate.unit)) then return end
            local _, _, _, _, _, id = strsplit("-", UnitGUID(nameplate.unit) or "")
            local _, status = UnitDetailedThreatSituation("player", nameplate.unit)
            local color = self.db.npccolors[tonumber(id)] or { r = 0, g = 1, b = 0.6, a = 1 }
            local nColor = self.db.npccolors[tonumber(id)] or { r = 1, g = 0, b = 0.3, a = 1 }

            if playerRole == "TANK" then
                if status and status == 3 then
                    healthBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                elseif status and status == 2 then
                    healthBar:SetStatusBarColor(1, 0.8, 0, 1)
                elseif status and (status == 1 or status == 0) then
                    healthBar:SetStatusBarColor(1, 0, 0.3, 1)
                else
                    if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                        healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                    elseif (not UnitIsTapDenied(unit)) then
                        local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                        if reaction and UnitReaction(unit, "player") == 4 then
                            healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                        elseif reaction and UnitReaction(unit, "player") == 2 then
                            healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                        elseif reaction then
                            healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                        else
                            healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                        end
                    end
                end
            elseif playerRole == "HEALER" or playerRole == "DAMAGER" then
                if status and status == 3 then
                    healthBar:SetStatusBarColor(1, 0, 0.3, 1)
                elseif status and status == 2 then
                    healthBar:SetStatusBarColor(1, 0.8, 0, 1)
                elseif status and (status == 1 or status == 0) then
                    healthBar:SetStatusBarColor(color.r, color.g, color.b, color.a)
                else
                    if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                        healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                    elseif (not UnitIsTapDenied(unit)) then
                        local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                        if reaction and UnitReaction(unit, "player") == 4 then
                            healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                        elseif reaction and UnitReaction(unit, "player") == 2 then
                            healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                        elseif reaction then
                            healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                        else
                            healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                        end
                    end
                end
            else
                if (UnitIsTapDenied(unit)) and not UnitPlayerControlled(unit) then
                    healthBar:SetStatusBarColor(0.5, 0.5, 0.5)
                elseif (not UnitIsTapDenied(unit)) then
                    local reaction = FACTION_BAR_COLORS[UnitReaction(unit, "player")];
                    if reaction and UnitReaction(unit, "player") == 4 then
                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                    elseif reaction and UnitReaction(unit, "player") == 2 then
                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                    elseif reaction then
                        healthBar:SetStatusBarColor(reaction.r, reaction.g, reaction.b);
                    else
                        healthBar:SetStatusBarColor(nColor.r, nColor.g, nColor.b, nColor.a)
                    end
                end
            end
        end
    end

    function self:RefreshNameplates()
        -- Get Nameplates
        for _, nameplate in pairs(C_NamePlate.GetNamePlates(false)) do
            -- Set Name for Nameplate
            self:HealthText(nameplate.UnitFrame)
            --self:Colors(nameplate.UnitFrame)
        end
    end
end

function Health:OnEnable()
    mUI:SecureHook("CompactUnitFrame_UpdateStatusText", function(nameplate)
        self:HealthText(nameplate)
        --self:Colors(nameplate)
    end)
end

function Health:OnDisable()
    mUI:Unhook("CompactUnitFrame_UpdateStatusText")
end
