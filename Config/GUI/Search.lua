local mGUI = mUI.mGUI

local Search = {}
mGUI.Search = Search

local MAX_RESULTS = 10
local ROW_HEIGHT = 26

-- Display labels for categories without a sidebar tab
local HIDDEN_LABELS = {}

local function Resolve(value)
    if type(value) == "function" then
        return value({})
    end
    return value
end

local function CategoryLabel(key)
    if HIDDEN_LABELS[key] then
        return HIDDEN_LABELS[key]
    end
    local Gui = mUI:GetModule("mUI.Config.Gui")
    for name, app in pairs(Gui.apps) do
        if app == key then
            return name
        end
    end
    -- Fallback: "mUIOptions_XYZ_Tab" -> "XYZ"
    return (key:gsub("^mUIOptions_", ""):gsub("_Tab$", ""))
end

-- ============================================================================
-- Results list UI (created lazily)
-- ============================================================================

local function GetResultsFrame()
    if Search.results then
        return Search.results
    end

    local Gui = mUI:GetModule("mUI.Config.Gui")
    local frame = CreateFrame("Frame", nil, Gui.frame, "BackdropTemplate")
    frame:SetFrameLevel(Gui.frame:GetFrameLevel() + 50)
    PixelUtil.SetPoint(frame, "TOPLEFT", Gui.searchBox, "BOTTOMLEFT", -4, -5)
    PixelUtil.SetWidth(frame, 340)
    mGUI:ApplyBackdrop(frame, "bgAlt", "border")
    frame:Hide()

    frame.rows = {}
    for i = 1, MAX_RESULTS do
        local row = CreateFrame("Button", nil, frame, "BackdropTemplate")
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", 2, -2 - (i - 1) * ROW_HEIGHT)
        row:SetPoint("TOPRIGHT", -2, -2 - (i - 1) * ROW_HEIGHT)
        mGUI:ApplyBackdrop(row, "bgAlt", false)

        local category = row:CreateFontString(nil, "OVERLAY")
        category:SetPoint("LEFT", 8, 0)
        row.category = category

        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetPoint("LEFT", category, "RIGHT", 6, 0)
        name:SetPoint("RIGHT", -8, 0)
        name:SetJustifyH("LEFT")
        name:SetWordWrap(false)
        row.name = name

        row:SetScript("OnEnter", function(self)
            self:SetBackdropColor(unpack(mGUI.Colors.bgHover))
        end)
        row:SetScript("OnLeave", function(self)
            self:SetBackdropColor(unpack(mGUI.Colors.bgAlt))
        end)
        row:SetScript("OnClick", function(self)
            Search:JumpTo(self.categoryKey, self.optionKey)
        end)

        frame.rows[i] = row
    end

    local moreText = frame:CreateFontString(nil, "OVERLAY")
    moreText:SetPoint("BOTTOM", 0, 6)
    moreText:SetTextColor(unpack(mGUI.Colors.textDim))
    frame.moreText = moreText

    Search.results = frame
    return frame
end

-- ============================================================================
-- Searching
-- ============================================================================

local function Matches(option, needle)
    if option.type ~= "toggle" and option.type ~= "select" and option.type ~= "range" and option.type ~= "color" and option.type ~= "input" and
        option.type ~= "execute" then
        return false
    end
    if Resolve(option.hidden) then
        return false
    end
    local name = Resolve(option.name)
    if type(name) == "string" and name:lower():find(needle, 1, true) then
        return true
    end
    local desc = Resolve(option.desc)
    return type(desc) == "string" and desc:lower():find(needle, 1, true)
end

local function CollectResults(needle)
    local results = {}

    local keys = {}
    for key in pairs(mGUI.categories) do
        keys[#keys + 1] = key
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local category = mGUI.categories[key]
        if category and category.options and category.options.args then
            for optionKey, option in pairs(category.options.args) do
                -- enable toggle lives on the sidebar now, not the page
                if not mGUI.EnableKeys[optionKey] and Matches(option, needle) then
                    results[#results + 1] = {
                        categoryKey = key,
                        optionKey = optionKey,
                        name = Resolve(option.name)
                    }
                end
            end
        end
    end

    return results
end

function Search:OnTextChanged(text)
    text = (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if #text < 2 then
        if self.results then
            self.results:Hide()
        end
        return
    end

    local results = CollectResults(text:lower())
    local frame = GetResultsFrame()

    if #results == 0 then
        frame:Hide()
        return
    end

    local shown = math.min(#results, MAX_RESULTS)
    for i = 1, MAX_RESULTS do
        local row = frame.rows[i]
        local result = results[i]
        if result and i <= shown then
            mGUI:SetFont(row.category, 11)
            mGUI:SetFont(row.name, 12)
            row.category:SetText(CategoryLabel(result.categoryKey) .. ":")
            row.category:SetTextColor(unpack(mGUI.Colors.accent))
            row.name:SetText(result.name)
            row.name:SetTextColor(unpack(mGUI.Colors.text))
            row.categoryKey = result.categoryKey
            row.optionKey = result.optionKey
            row:Show()
        else
            row:Hide()
        end
    end

    local extra = #results - shown
    if extra > 0 then
        mGUI:SetFont(frame.moreText, 11)
        frame.moreText:SetText("+ " .. extra .. " more — keep typing")
        frame.moreText:Show()
        frame:SetHeight(4 + shown * ROW_HEIGHT + 20)
    else
        frame.moreText:Hide()
        frame:SetHeight(4 + shown * ROW_HEIGHT)
    end
    frame:Show()
end

-- ============================================================================
-- Jump to option: select category, scroll into view, flash
-- ============================================================================

local function GetFlash()
    if Search.flash then
        return Search.flash
    end

    local flash = CreateFrame("Frame")
    flash:SetFrameStrata("DIALOG")
    local tex = flash:CreateTexture(nil, "OVERLAY")
    tex:SetAllPoints()
    tex:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    tex:SetVertexColor(mGUI.Colors.accent[1], mGUI.Colors.accent[2], mGUI.Colors.accent[3], 0.25)

    local anim = flash:CreateAnimationGroup()
    for i = 0, 1 do
        local fadeIn = anim:CreateAnimation("Alpha")
        fadeIn:SetFromAlpha(0)
        fadeIn:SetToAlpha(1)
        fadeIn:SetDuration(0.25)
        fadeIn:SetOrder(i * 2 + 1)
        local fadeOut = anim:CreateAnimation("Alpha")
        fadeOut:SetFromAlpha(1)
        fadeOut:SetToAlpha(0)
        fadeOut:SetDuration(0.25)
        fadeOut:SetOrder(i * 2 + 2)
    end
    anim:SetScript("OnFinished", function()
        flash:Hide()
    end)
    flash.anim = anim

    Search.flash = flash
    return flash
end

function Search:JumpTo(categoryKey, optionKey)
    local Gui = mUI:GetModule("mUI.Config.Gui")
    -- Make sure the option's sub-tab is active before the page renders
    mGUI.Renderer:ActivateSectionFor(categoryKey, optionKey)
    mGUI:Select(categoryKey)

    for _, widget in ipairs(mGUI.Renderer:GetActiveWidgets()) do
        if widget.optionKey == optionKey then
            local scrollFrame = Gui.scrollFrame
            local target = math.max(0, (widget.layoutY or 0) - 20)
            -- GetVerticalScrollRange is stale right after a re-render; compute it
            local range = math.max(0, scrollFrame:GetScrollChild():GetHeight() - scrollFrame:GetHeight())
            scrollFrame:SetVerticalScroll(math.min(target, range))

            local flash = GetFlash()
            flash:SetParent(widget)
            flash:ClearAllPoints()
            flash:SetPoint("TOPLEFT", widget, "TOPLEFT", -6, 6)
            if widget.label then
                flash:SetPoint("BOTTOMRIGHT", widget.label, "BOTTOMRIGHT", 6, -6)
            else
                flash:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", 6, -6)
            end
            flash:Show()
            flash.anim:Restart()
            break
        end
    end

    if self.results then
        self.results:Hide()
    end
end
