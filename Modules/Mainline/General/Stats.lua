local Stats = mUI:NewModule("mUI.Modules.General.Stats", "AceHook-3.0")

function Stats:OnInitialize()
    -- Load Database
    Stats.db = {
        general = mUI.db.profile.general,
        display = mUI.db.profile.general.display,
        pos = mUI.db.profile.edit
    }

    -- Variables
    Stats.stats = {}
    Stats.ticker = nil

    -- Get Class Color
    local _, class = UnitClass("player")
    Stats.color = C_ClassColor.GetClassColor(class)

    mUI.statsFrame = CreateFrame("Frame", "mUIStatsFrame", UIParent)
    mUI.statsFrame:ClearAllPoints()
    mUI.statsFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)

    mUI.statsFrame:SetSize(75, 20)
    mUI.statsFrame.text = mUI.statsFrame:CreateFontString(nil, "BACKGROUND")
    mUI.statsFrame.text:SetPoint("CENTER", mUI.statsFrame)

    if Stats.db.general.font ~= "None" then
        mUI.statsFrame.text:SetFont(Stats.db.general.fontpath, 13, "OUTLINE")
    else
        mUI.statsFrame.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    end

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
        local isGliding, _, forwardSpeed = C_PlayerInfo.GetGlidingInfo()
        local pct
        if isGliding and forwardSpeed then
            local ok, v = pcall(function()
                return forwardSpeed / BASE_MOVEMENT_SPEED * 100
            end)
            pct = ok and v or nil
        else
            local ok, v = pcall(function()
                return GetUnitSpeed("player") / BASE_MOVEMENT_SPEED * 100
            end)
            pct = ok and v or nil
        end
        return "|c00ffffff" .. string.format("%d", pct or 0) .. "%|r speed"
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

    function Stats:Update()
        mUI.statsFrame.text:SetText(Stats:Stats())
        mUI.statsFrame:SetWidth(mUI.statsFrame.text:GetStringWidth())
        mUI.statsFrame:SetHeight(mUI.statsFrame.text:GetStringHeight())
    end
end

function Stats:OnEnable()
    mUI.statsFrame:Show()
    Stats:Update()
    Stats.ticker = C_Timer.NewTicker(0.5, function()
        Stats:Update()
    end)
end

function Stats:OnDisable()
    mUI.statsFrame:Hide()
    if Stats.ticker then
        Stats.ticker:Cancel()
        Stats.ticker = nil
    end
end
