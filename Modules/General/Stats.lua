local Stats = mUI:NewModule("mUI.Modules.General.Stats", "AceHook-3.0")

function Stats:OnInitialize()
    -- Load Database
    Stats.db = {
        display = mUI.db.profile.general.display,
        pos = mUI.db.profile.edit.statsframe
    }

    -- Variables
    Stats.stats = {}
    Stats.lastUpdate = 0

    -- Get Class Color
    local _, class = UnitClass("player")
    Stats.color = RAID_CLASS_COLORS[class]

    mUI.statsFrame = CreateFrame("Frame", "StatsFrame", UIParent)
    mUI.statsFrame:ClearAllPoints()
    mUI.statsFrame:SetPoint(Stats.db.pos.point, UIParent, Stats.db.pos.point, Stats.db.pos.x, Stats.db.pos.y)
    mUI.statsFrame:SetSize(75, 20)
    mUI.statsFrame.text = mUI.statsFrame:CreateFontString(nil, "BACKGROUND")
    mUI.statsFrame.text:SetPoint("CENTER", mUI.statsFrame)
    mUI.statsFrame.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    mUI.statsFrame.text:SetShadowOffset(1, -1)
    mUI.statsFrame.text:SetShadowColor(0, 0, 0)
    mUI.statsFrame.text:SetTextColor(Stats.color.r, Stats.color.g, Stats.color.b)

    function Stats:GetFPS()
        return "|c00ffffff" .. floor(GetFramerate()) .. "|r fps"
    end

    function Stats:GetLatency()
        return "|c00ffffff" .. select(4, GetNetStats()) .. "|r ms"
    end

    function Stats:GetSpeed()
        local isGliding, canGlide, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
        if isGliding then
            return "|c00ffffff" ..
                string.format("%d", forwardSpeed and (forwardSpeed / BASE_MOVEMENT_SPEED * 100)) .. "%|r speed"
        else
            return "|c00ffffff" ..
                string.format("%d", (GetUnitSpeed("player") / BASE_MOVEMENT_SPEED * 100)) .. "%|r speed"
        end
    end

    function Stats:Stats()
        if Stats.db.display.stats and Stats.db.display.movementspeed then
            return Stats:GetFPS() .. " " .. Stats:GetLatency() .. " " .. Stats:GetSpeed()
        elseif Stats.db.display.stats then
            return Stats:GetFPS() .. " " .. Stats:GetLatency()
        elseif Stats.db.display.movementspeed then
            return Stats:GetSpeed()
        else
            return Stats:GetFPS() .. " " .. Stats:GetLatency()
        end
    end

    function Stats:Update(frame, elapsed)
        Stats.lastUpdate = Stats.lastUpdate + elapsed
        if Stats.lastUpdate > 1 then
            Stats.lastUpdate = 0
            mUI.statsFrame.text:SetText(Stats:Stats())
            frame:SetWidth(mUI.statsFrame.text:GetStringWidth())
            frame:SetHeight(mUI.statsFrame.text:GetStringHeight())
        end
    end
end

function Stats:OnEnable()
    mUI.statsFrame:Show()
    Stats:HookScript(mUI.statsFrame, "OnUpdate", function(frame, elapsed)
        Stats:Update(frame, elapsed)
    end)
end

function Stats:OnDisable()
    mUI.statsFrame:Hide()
    Stats:UnhookAll()
end
