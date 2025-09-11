local SmoothHealth = mUI:NewModule("mUI.Modules.Unitframes.SmoothHealth", "AceHook-3.0")

function SmoothHealth:OnInitialize()
    SmoothHealth.frame = CreateFrame("Frame")
    SmoothHealth.speed = 25
    SmoothHealth.bars = {}
    SmoothHealth.unitframes = {
        "PlayerFrame", "TargetFrame", "TargetFrameToT", "FocusFrame", "FocusFrameToT",
        "Boss1TargetFrame", "Boss2TargetFrame", "Boss3TargetFrame", "Boss4TargetFrame", "Boss5TargetFrame"
    }
    function SmoothHealth:Update(elapsed)
        for bar, data in pairs(SmoothHealth.bars) do
            if bar and data then
                -- Additional safety check - ensure bar is still valid
                local success, isValid = pcall(function() return bar:GetParent() and not bar:IsForbidden() end)
                if success and isValid then
                    local cur = data.displayed
                    local target = data.target
                    local speed = data.speed or 5

                    -- Validate values
                    if cur and target and cur == cur and target == target then -- Check for valid numbers (not NaN)
                        if cur < 0 then cur = 0 end
                        if target < 0 then target = 0 end

                        -- Get bar's min/max values for proper clamping
                        local min, max = 0, 100
                        success = pcall(function()
                            local minVal, maxVal = bar:GetMinMaxValues()
                            if minVal and maxVal then
                                min, max = minVal, maxVal
                            end
                        end)

                        if max and max > 0 then
                            target = math.max(min or 0, math.min(max, target))
                            cur = math.max(min or 0, math.min(max, cur))
                        end

                        local diff = target - cur
                        if math.abs(diff) > 0.1 then
                            -- Use more responsive smoothing algorithm
                            local smoothFactor = math.min(1, elapsed * speed)

                            -- Prevent overshooting by checking direction changes
                            local new = cur + diff * smoothFactor

                            -- Additional safety: if we're very close to target, snap to it
                            if math.abs(target - new) < 0.5 then
                                new = target
                            end

                            data.displayed = new
                            success = pcall(function() bar:origSetValue(new) end)
                        else
                            data.displayed = target
                            success = pcall(function() bar:origSetValue(target) end)
                        end
                    end
                else
                    -- Bar is invalid, remove it from tracking
                    SmoothHealth.bars[bar] = nil
                end
            end
        end
    end

    function SmoothHealth:StatusBar(bar, speed)
        if not bar or bar.isSmooth then return end

        -- Verify the bar is valid before proceeding
        if bar:IsForbidden() then return end

        bar.isSmooth = true
        speed = speed or SmoothHealth.speed

        local cur = 0
        local success, value = pcall(function() return bar:GetValue() end)
        if success and value then
            cur = value
        end

        local min, max = 0, 100
        success = pcall(function()
            local minVal, maxVal = bar:GetMinMaxValues()
            if minVal and maxVal then
                min, max = minVal, maxVal
            end
        end)

        -- Ensure current value is within bounds
        if max and max > 0 then
            cur = math.max(min or 0, math.min(max, cur))
        end

        -- Always create the bars entry
        SmoothHealth.bars[bar] = { displayed = cur, target = cur, speed = speed }

        -- Backup original SetValue
        if not bar.origSetValue then
            bar.origSetValue = bar.SetValue
            bar.SetValue = function(self, value)
                if not value or value ~= value then return end -- Check for nil or NaN

                local data = SmoothHealth.bars[self]
                if data then
                    -- Clamp value to valid range
                    local min, max = 0, 100
                    local success = pcall(function()
                        local minVal, maxVal = self:GetMinMaxValues()
                        if minVal and maxVal then
                            min, max = minVal, maxVal
                        end
                    end)

                    if max and max > 0 then
                        value = math.max(min or 0, math.min(max, value))
                    end

                    -- If the target value changes dramatically, check if we should reset smoothing
                    local currentTarget = data.target
                    local currentDisplayed = data.displayed

                    -- If new value is very different from current target, consider resetting
                    if currentTarget and math.abs(value - currentTarget) > (max or 100) * 0.3 then
                        -- Large change detected, adjust displayed value to prevent extreme snapping
                        data.displayed = math.max(currentDisplayed - (max or 100) * 0.1,
                            math.min(currentDisplayed + (max or 100) * 0.1, value))
                    end

                    data.target = value
                else
                    pcall(function() self:origSetValue(value) end)
                end
            end
        end

        -- Hook SetMinMaxValues to prevent snapping on max health changes
        if not bar.origSetMinMax then
            bar.origSetMinMax = bar.SetMinMaxValues
            bar.SetMinMaxValues = function(self, min, max)
                local data = SmoothHealth.bars[self]
                local oldMin, oldMax = 0, 100

                -- Safely get old values
                pcall(function()
                    local minVal, maxVal = self:GetMinMaxValues()
                    if minVal and maxVal then
                        oldMin, oldMax = minVal, maxVal
                    end
                end)

                pcall(function() self:origSetMinMax(min, max) end)

                if data then
                    -- Handle max value changes gracefully
                    if oldMax and max and oldMax ~= max and oldMax > 0 then
                        -- Scale the current values proportionally if max changed
                        local scale = max / oldMax
                        if scale ~= scale then scale = 1 end -- Check for NaN

                        data.target = math.min(max, data.target * scale)
                        data.displayed = math.min(max, data.displayed * scale)
                    else
                        -- Simple clamping if we don't have old values
                        if data.target > max then data.target = max end
                        if data.displayed > max then data.displayed = max end
                    end

                    -- Ensure minimum values
                    if min then
                        if data.target < min then data.target = min end
                        if data.displayed < min then data.displayed = min end
                    end
                end
            end
        end
    end

    function SmoothHealth:UnitFrame(frame)
        if not (frame and frame.unit) or frame:IsForbidden() then return end

        if frame.healthBar then
            SmoothHealth:StatusBar(frame.healthBar, SmoothHealth.speed)
            local health = UnitHealth(frame.unit)
            if health and health >= 0 and SmoothHealth.bars[frame.healthBar] then
                SmoothHealth.bars[frame.healthBar].target = health
            end
        end
    end
end

function SmoothHealth:OnEnable()
    if mUI:IsClassic() then return end
    SmoothHealth:SecureHook("CompactUnitFrame_UpdateHealth", function(frame)
        SmoothHealth:UnitFrame(frame)
    end)
    SmoothHealth:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        SmoothHealth:UnitFrame(frame)
    end)
    SmoothHealth:SecureHookScript(SmoothHealth.frame, "OnUpdate", function(_, elapsed)
        SmoothHealth:Update(elapsed)
    end)

    -- Unit Frames
    for _, frame in ipairs(SmoothHealth.unitframes) do
        local frame = _G[frame]
        if frame then
            SmoothHealth:StatusBar(frame.healthbar, SmoothHealth.speed)
            SmoothHealth:StatusBar(frame.manabar, SmoothHealth.speed)
        end
    end
end

function SmoothHealth:OnDisable()
    SmoothHealth:UnhookAll()
end
