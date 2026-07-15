local mGUI = mUI.mGUI

function mGUI.Widgets.Dropdown(parent)
    local container = CreateFrame("Frame", nil, parent)
    container:SetSize(190, 46)

    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetPoint("TOPLEFT", 0, -4)
    title:SetTextColor(unpack(mGUI.Colors.text))
    container.title = title

    local dropdown = CreateFrame("DropdownButton", nil, container, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("BOTTOMLEFT")
    dropdown:SetPoint("BOTTOMRIGHT")
    dropdown:SetHeight(26)
    container.dropdown = dropdown

    -- Swap the default textholder art for the ESC-menu three-slice body
    dropdown.Background:Hide()
    local slices = mGUI:CreateThreeSlice(dropdown, "128-RedButton")
    dropdown:SetHighlightAtlas("128-RedButton-Highlight", "ADD")
    local highlight = dropdown:GetHighlightTexture()
    highlight:SetDesaturated(true)
    highlight:SetVertexColor(unpack(mGUI.Colors.accent))

    -- Keep slices in sync with the mixin's state machine (hover/pressed/disabled).
    -- The mixin re-sets the Arrow atlas on every state change, so re-tint it here too.
    local function TintArrow(self)
        self.Arrow:SetDesaturated(true)
        self.Arrow:SetVertexColor(unpack(self:IsEnabled() and mGUI.Colors.accent or mGUI.Colors.textDim))
    end
    hooksecurefunc(dropdown, "OnButtonStateChanged", function(self)
        if not self:IsEnabled() then
            slices:SetState("Disabled")
        elseif self:IsDownOver() then
            slices:SetState("Pressed")
        else
            slices:SetState("Normal")
        end
        TintArrow(self)
    end)
    TintArrow(dropdown)

    local function IsSelected(key)
        return container.selected == key
    end
    local function SetSelected(key)
        container.selected = key
        if container.OnValueChanged then
            container:OnValueChanged(key)
        end
    end

    local function EntryLabel(values, key)
        if container.labelFromKey then
            return tostring(key)
        end
        return tostring(values[key])
    end

    local function ResolveOrder(values, sorting)
        if sorting then
            return sorting
        end
        local order = {}
        for key in pairs(values) do
            order[#order + 1] = key
        end
        table.sort(order, function(a, b)
            return EntryLabel(values, a) < EntryLabel(values, b)
        end)
        return order
    end

    dropdown:SetupMenu(function(_, rootDescription)
        local values = container.values
        if type(values) == "function" then
            values = values(container.optionInfo or {})
        end
        if not values then
            return
        end
        local order = ResolveOrder(values, container.sorting)
        if #order > 12 then
            rootDescription:SetScrollMode(20 * 20) -- ~20 rows, then scroll
        end
        for _, key in ipairs(order) do
            local radio = rootDescription:CreateRadio(EntryLabel(values, key), IsSelected, SetSelected, key)
            radio:AddInitializer(function(button)
                local tick = button.leftTexture2
                if tick then
                    tick.noRecurseHierarchy = true
                    tick:SetDesaturated(true)
                    tick:SetVertexColor(unpack(mGUI.Colors.accent))
                    C_Timer.After(0, function()
                        tick.noRecurseHierarchy = nil
                    end)
                end
            end)
            if container.DecorateEntry then
                container.DecorateEntry(radio, key, values[key])
            end
        end
    end)

    function container:SetLabel(text)
        mGUI:SetFont(self.title, 12)
        mGUI:SetFont(dropdown.Text, 12)
        self.title:SetText(text or "")
    end

    function container:SetOptions(values, sorting)
        self.values = values
        self.sorting = sorting
        dropdown:GenerateMenu()
    end

    function container:SetValue(key)
        self.selected = key
        dropdown:GenerateMenu()
    end

    function container:SetWidgetEnabled(enabled)
        dropdown:SetEnabled(enabled)
        self.title:SetTextColor(unpack(enabled and mGUI.Colors.text or mGUI.Colors.textDim))
    end

    return container
end
