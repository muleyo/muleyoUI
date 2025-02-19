local Stats = mUI:NewModule("mUI.Modules.General.Stats")

function Stats:OnInitialize()
    -- Initialize Database
    self.db = {
        display = mUI.db.profile.general.display,
        pos = mUI.db.profile.edit.statsframe
    }

    -- Variables
    self.stats = {}
    self.lastUpdate = 0

    -- Get Class Color
    local _, class = UnitClass("player")
    self.color = RAID_CLASS_COLORS[class]

    mUI.statsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
    mUI.statsFrame:ClearAllPoints()
    mUI.statsFrame:SetPoint(self.db.pos.point, UIParent, self.db.pos.point, self.db.pos.x, self.db.pos.y)
    mUI.statsFrame:SetSize(75, 20)
    mUI.statsFrame.text = mUI.statsFrame:CreateFontString(nil, "BACKGROUND")
    mUI.statsFrame.text:SetPoint("CENTER", mUI.statsFrame)
    mUI.statsFrame.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    mUI.statsFrame.text:SetShadowOffset(1, -1)
    mUI.statsFrame.text:SetShadowColor(0, 0, 0)
    mUI.statsFrame.text:SetTextColor(self.color.r, self.color.g, self.color.b)

    function self:GetFPS()
        return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps"
    end

    function self:GetLatency()
        return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms"
    end

    function self:GetSpeed()
        local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
        if isGliding then
            return "|c00ffffff" ..
                string.format("%d", forwardSpeed and (forwardSpeed / BASE_MOVEMENT_SPEED * 100)) .. "%|r speed"
        else
            return "|c00ffffff" ..
                string.format("%d", (GetUnitSpeed("player") / BASE_MOVEMENT_SPEED * 100)) .. "%|r speed"
        end
    end

    function self:Stats()
        if mUI.db.profile.general.display.stats and mUI.db.profile.general.display.movementspeed then
            return self:GetFPS() .. " " .. self:GetLatency() .. " " .. self:GetSpeed()
        else
            return self:GetFPS() .. " " .. self:GetLatency()
        end
    end

    function self:Update(frame, elapsed)
        self.lastUpdate = self.lastUpdate + elapsed
        if self.lastUpdate > 1 then
            self.lastUpdate = 0
            mUI.statsFrame.text:SetText(self:Stats())
            frame:SetWidth(mUI.statsFrame.text:GetStringWidth())
            frame:SetHeight(mUI.statsFrame.text:GetStringHeight())
        end
    end

    mUI.statsFrame:SetScript("OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)
end

function Stats:OnEnable()
    mUI.statsFrame:Show()
    mUI:HookScript(mUI.statsFrame, "OnUpdate", function(frame, elapsed)
        self:Update(frame, elapsed)
    end)
end

function Stats:OnDisable()
    mUI.statsFrame:Hide()
    mUI:Unhook(mUI.statsFrame, "OnUpdate")
end
