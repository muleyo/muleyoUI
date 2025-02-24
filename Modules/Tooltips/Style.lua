local Style = mUI:NewModule("mUI.Tooltips.Style")

function Style:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.tooltips

    -- Tables
    self.cfg = {
        textColor = { 0.4, 0.4, 0.4 },
        bossColor = { 1, 0, 0 },
        eliteColor = { 1, 0, 0.5 },
        rareeliteColor = { 1, 0.5, 0 },
        rareColor = { 1, 0.5, 0 },
        levelColor = { 0.8, 0.8, 0.5 },
        deadColor = { 0.5, 0.5, 0.5 },
        targetColor = { 1, 0.5, 0.5 },
        guildColor = { 0.8, 0.0, 0.6 },
        afkColor = { 0, 1, 1 }
    }

    self.classColors = {}
    self.factionColors = {}

    -- Get Hex Colors
    self.cfg.targetColorHex = CreateColor(unpack(self.cfg.targetColor)):GenerateHexColor()
    self.cfg.afkColorHex = CreateColor(unpack(self.cfg.afkColor)):GenerateHexColor()

    for class, color in next, RAID_CLASS_COLORS do
        self.classColors[class] = CreateColor(color.r, color.g, color.b):GenerateHexColor()
    end

    for i, color in pairs(FACTION_BAR_COLORS) do
        self.factionColors[i] = CreateColor(color.r, color.g, color.b):GenerateHexColor()
    end

    -- Create GameTooltip Healthbar Background
    GameTooltipStatusBar.mUIbg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
    GameTooltipStatusBar.mUIbg:SetAllPoints()
    GameTooltipStatusBar.mUIbg:SetColorTexture(1, 1, 1)
    GameTooltipStatusBar.mUIbg:SetVertexColor(0, 0, 0, 0.5)
    GameTooltipStatusBar.mUIbg:SetAlpha(0)

    function self:SetStatusBarColor(frame, r, g, b)
        if not self.cfg.barColor then return end
        if r == self.cfg.barColor.r and g == self.cfg.barColor.g and b == self.cfg.barColor.b then return end
        frame:SetStatusBarColor(self.cfg.barColor.r, self.cfg.barColor.g, self.cfg.barColor.b)
    end

    function self:GetTarget(unit)
        if not self.db.style == "mUI" then return end
        if UnitIsUnit(unit, "player") then
            return ("|cffff0000%s|r"):format("<YOU>")
        elseif UnitIsPlayer(unit) then
            local _, class = UnitClass(unit)
            return ("|c%s%s|r"):format(self.classColors[class], UnitName(unit))
        elseif UnitReaction(unit, "player") then
            return ("|c%s%s|r"):format(self.factionColors[UnitReaction(unit, "player")], UnitName(unit))
        else
            return ("|cffffffff%s|r"):format(UnitName(unit))
        end
    end

    function self:OnTooltipSetUnit(frame)
        if not self.db.style == "mUI" then return end
        if not frame or frame ~= _G.GameTooltip then return end

        -- Get Unit
        local unitName, unit = frame:GetUnit()
        if not unit then return end
        for i = 2, GameTooltip:NumLines() do
            local line = _G["GameTooltipTextLeft" .. i]
            if line then
                if not line == 4 then
                    line:SetTextColor(unpack(self.cfg.textColor))
                end
            end
        end

        -- Raid Icon
        if unit and GetRaidTargetIndex(unit) then
            local raidIconIndex = GetRaidTargetIndex(unit)
            if GetRaidTargetIndex(unit) == 16 then
                GameTooltipTextLeft1:SetText(("%s"):format(unitName))
            else
                GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex] .. "14|t", unitName))
            end
        end

        -- Unit is Player
        if UnitIsPlayer(unit) then
            -- Get Class Color
            local _, unitClass = UnitClass(unit)
            local color = RAID_CLASS_COLORS[unitClass]
            self.cfg.barColor = color
            GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
            GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)

            local guildName, guildRank = GetGuildInfo(unit)
            if guildName then
                GameTooltipTextLeft2:SetText("<" .. guildName .. "> [" .. guildRank .. "]")
                GameTooltipTextLeft2:SetTextColor(unpack(self.cfg.guildColor))
            end

            local levelLine = guildName and GameTooltipTextLeft3 or GameTooltipTextLeft2
            local level = UnitLevel(unit)
            local color = GetCreatureDifficultyColor((level > 0) and level or 999)
            levelLine:SetTextColor(color.r, color.g, color.b)

            if UnitIsAFK(unit) then
                frame:AppendText((" |c%s<AFK>|r"):format(self.cfg.afkColorHex))
            end
        else -- Unit is NPC
            local reaction = UnitReaction(unit, "player")
            if reaction then
                local color = FACTION_BAR_COLORS[reaction]
                if color then
                    self.cfg.barColor = color
                    GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
                    GameTooltipTextLeft1:SetTextColor(color.r, color.g, color.b)
                end
            end

            local unitClassification = UnitClassification(unit)
            local levelLine
            if string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") then
                levelLine = GameTooltipTextLeft2
            elseif GameTooltipTextLeft3 ~= nil and string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") then
                GameTooltipTextLeft2:SetTextColor(unpack(self.cfg.guildColor))
                levelLine = GameTooltipTextLeft3
            end
            if levelLine then
                local l = UnitLevel(unit)
                local color = GetCreatureDifficultyColor((l > 0) and l or 999)
                levelLine:SetTextColor(color.r, color.g, color.b)
            end
            if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
                frame:AppendText(" |cffff0000[B]|r")
                GameTooltipTextLeft2:SetTextColor(unpack(self.cfg.bossColor))
            elseif unitClassification == "rare" then
                frame:AppendText(" |cffff9900[R]|r")
            elseif unitClassification == "rareelite" then
                frame:AppendText(" |cffff0000[R+]|r")
            elseif unitClassification == "elite" then
                frame:AppendText(" |cffff6666[E]|r")
            end
        end

        -- Unit is dead
        if UnitIsDeadOrGhost(unit) then
            GameTooltipTextLeft1:SetTextColor(unpack(self.cfg.deadColor))
        end

        -- Current Target
        if (UnitExists(unit .. "target")) then
            GameTooltip:AddDoubleLine(("|c%s%s|r"):format(self.cfg.targetColorHex, "Target"),
                self:GetTarget(unit .. "target") or "Unknown")
        end
    end

    function self:OnTooltipSetSpell(tooltip, spellid)
        if not self.db.style == "mUI" then return end
        if not spellid then return end
        if type(spellid) == "table" and #spellid == 1 then spellid = spellid[1] end
        local frame, text
        for i = 1, 15 do
            frame = _G[tooltip:GetName() .. "TextLeft" .. i]
            if frame then text = frame:GetText() end
            if text and string.find(text, "|cff0099ffID|r") then return end
        end
        tooltip:AddDoubleLine("|cff0099ffID|r", spellid)
        tooltip:Show()
    end

    function self:OnMacroTooltipSetSpell(tooltip)
        if not self.db.style == "mUI" then return end
        if tooltip:GetTooltipData() and tooltip:GetTooltipData().lines and tooltip:GetTooltipData().lines[2] and
            tooltip:GetTooltipData().lines[2].leftText then
            local tooltipData = tooltip:GetTooltipData()
            local tooltipName = tooltipData.lines[2].leftText
            local spellInfo   = C_Spell.GetSpellInfo(tooltipName)

            if (spellInfo and spellInfo.spellID) then
                self:OnTooltipSetSpell(tooltip, spellInfo.spellID)
            end
        end
    end
end

function Style:OnEnable()
    -- Hook Tooltips
    if not self.hooked then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, function(tooltip)
            self:OnMacroTooltipSetSpell(tooltip)
        end)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
            self:OnTooltipSetSpell(tooltip, data.id)
        end)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura, function(tooltip, data)
            self:OnTooltipSetSpell(tooltip, data.id)
        end)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(frame)
            self:OnTooltipSetUnit(frame)
        end)

        self.hooked = true
    end

    mUI:SecureHook(GameTooltipStatusBar, "SetStatusBarColor", function(frame, r, g, b)
        self:SetStatusBarColor(frame, r, g, b)
    end)

    -- Set Healthbar Texture
    GameTooltipStatusBar:SetStatusBarTexture([[Interface\Addons\mUI\Media\Textures\Tooltip\UI-TargetingFrame-BarFill]])

    -- Show Gametooltip Healthbar Background
    GameTooltipStatusBar.mUIbg:SetAlpha(1)

    -- Set Statusbar Position
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint("LEFT", 4.5, 0)
    GameTooltipStatusBar:SetPoint("RIGHT", -4.5, 0)
    GameTooltipStatusBar:SetPoint("TOP", 0, -3)
    GameTooltipStatusBar:SetHeight(4)
end

function Style:OnDisable()
    -- Unhook
    mUI:Unhook(GameTooltipStatusBar, "SetStatusBarColor")

    -- Reset Healthbar Texture
    GameTooltipStatusBar:SetStatusBarTexture([[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])

    -- Hide Gametooltip Healthbar Background
    GameTooltipStatusBar.mUIbg:SetAlpha(0)

    -- Reset Statusbar Position and Height
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint("LEFT", 4.5, 0)
    GameTooltipStatusBar:SetPoint("RIGHT", -4.5, 0)
    GameTooltipStatusBar:SetPoint("BOTTOM", 0, -9)
    GameTooltipStatusBar:SetHeight(8)
end
