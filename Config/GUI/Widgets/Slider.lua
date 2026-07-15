local mGUI = mUI.mGUI

function mGUI.Widgets.Slider(parent)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(230, 44)

    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", 0, -5)
    title:SetTextColor(unpack(mGUI.Colors.text))
    container.title = title

    local slider = CreateFrame("Slider", nil, container, "MinimalSliderTemplate")
    slider:SetPoint("BOTTOMLEFT", 0, 4)
    slider:SetSize(170, 12)
    slider:SetObeyStepOnDrag(true)
    container.slider = slider

    -- Track stretches with the container (flow layout may resize us)
    container:SetScript("OnSizeChanged", function(_, width)
        slider:SetWidth(math.max(80, width - 60))
    end)

    local valueBox = CreateFrame("EditBox", nil, container)
    valueBox:SetPoint("LEFT", slider, "RIGHT", 10, 0)
    valueBox:SetSize(46, 18)
    valueBox:SetAutoFocus(false)
    valueBox:SetJustifyH("CENTER")
    valueBox:SetTextColor(unpack(mGUI.Colors.accent))
    container.valueBox = valueBox

    local boxBg = valueBox:CreateTexture(nil, "BACKGROUND")
    boxBg:SetAllPoints()
    boxBg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    boxBg:SetVertexColor(unpack(mGUI.Colors.bgWidget))

    local function Round(container_, value)
        local step = container_.step or 1
        value = math.floor(value / step + 0.5) * step
        -- Avoid float noise like 0.30000000000000004
        return tonumber(string.format("%.4f", value))
    end

    local function DisplayValue(value)
        if container.isPercent then
            return math.floor(value * 100 + 0.5) .. "%"
        end
        return tostring(value)
    end

    local function Commit(value, fromSlider, isLiveTick)
        value = math.min(container.max or value, math.max(container.min or value, value))
        value = Round(container, value)
        -- Don't call slider:SetValue() while reacting to the slider's OWN
        -- OnValueChanged during an active drag - re-assigning the value from
        -- inside that callback fights the native drag/thumb tracking and
        -- can freeze dragging entirely. The slider is already at (or very
        -- near, via SetObeyStepOnDrag) this value, so it's not needed there;
        -- only sync it explicitly when committing from another source (the
        -- value edit box).
        if not fromSlider then
            slider:SetValue(value)
        end
        valueBox:SetText(DisplayValue(value))
        if container.OnValueChanged then
            -- `isLiveTick` tells Renderer.lua's Builders.range whether this
            -- is a mid-drag tick (use the cheap, non-destructive
            -- RefreshStates()) or the final commit (safe to do a full
            -- Refresh() - the destructive release/reacquire/reposition a
            -- full Refresh() does on EVERY tick was what froze dragging
            -- entirely, since it fights the OS mouse-drag capture on the
            -- thumb - even after the SetValue reentrancy above was fixed).
            container:OnValueChanged(value, isLiveTick)
        end
    end

    slider:SetScript("OnValueChanged", function(_, value, userInput)
        valueBox:SetText(DisplayValue(Round(container, value)))
        if userInput then
            Commit(value, true, true)
        end
    end)

    -- One final full settle-commit once the drag actually ends (mouse no
    -- longer captured), so dynamic name/hidden/disabled state across the
    -- whole page catches up without disrupting the drag itself.
    slider:HookScript("OnMouseUp", function()
        Commit(slider:GetValue(), true, false)
    end)

    valueBox:SetScript("OnEnterPressed", function(box)
        local raw = box:GetText():gsub("%%", "")
        local value = tonumber(raw)
        if value then
            if container.isPercent then
                value = value / 100
            end
            Commit(value)
        else
            box:SetText(DisplayValue(Round(container, slider:GetValue())))
        end
        box:ClearFocus()
    end)
    valueBox:SetScript("OnEscapePressed", function(box)
        box:SetText(DisplayValue(Round(container, slider:GetValue())))
        box:ClearFocus()
    end)

    function container:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        mGUI:SetFont(self.valueBox, 11)
        self.title:SetText(text or "")
    end

    function container:SetRange(min, max, step, isPercent)
        self.min, self.max, self.step, self.isPercent = min, max, step or 1, isPercent
        self.slider:SetMinMaxValues(min, max)
        self.slider:SetValueStep(step or 1)
    end

    function container:SetValue(value)
        self.slider:SetValue(value)
        self.valueBox:SetText(DisplayValue(Round(self, value)))
    end

    function container:SetWidgetEnabled(enabled)
        self.slider:SetEnabled(enabled)
        self.valueBox:SetEnabled(enabled)
        self.title:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
    end

    return container
end
