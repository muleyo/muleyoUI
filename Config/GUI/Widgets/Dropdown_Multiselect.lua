local mGUI = mUI.mGUI

function mGUI.Widgets.DropdownMultiselect(parent)
    local container = mGUI.Widgets.Dropdown(parent)
    local dropdown = container.dropdown

    local function EntryLabel(values, key)
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

    local function ResolvedValues()
        local values = container.values
        if type(values) == "function" then
            values = values(container.optionInfo or {})
        end
        return values
    end

    local function IsSelected(key)
        return container.isSelectedFn ~= nil and container.isSelectedFn(key) or false
    end

    local function SetSelected(key)
        if container.toggleFn then
            container.toggleFn(key, not IsSelected(key))
        end
        container:UpdateText()
    end

    dropdown:SetupMenu(function(_, rootDescription)
        local values = ResolvedValues()
        if not values then
            return
        end
        local order = ResolveOrder(values, container.sorting)
        if #order > 12 then
            rootDescription:SetScrollMode(20 * 20) -- ~20 rows, then scroll
        end
        for _, key in ipairs(order) do
            local checkbox = rootDescription:CreateCheckbox(EntryLabel(values, key), IsSelected, SetSelected, key)
            checkbox:AddInitializer(function(button)
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
        end
    end)

    function container:UpdateText()
        local values = ResolvedValues()
        if not values then
            dropdown:OverrideText("")
            return
        end

        local order = ResolveOrder(values, self.sorting)
        local labels = {}
        for _, key in ipairs(order) do
            if IsSelected(key) then
                labels[#labels + 1] = EntryLabel(values, key)
            end
        end

        if #labels == 0 then
            dropdown:OverrideText(self.noneText or "None")
        elseif #labels > 2 then
            dropdown:OverrideText(#labels .. " Selected")
        else
            dropdown:OverrideText(table.concat(labels, ", "))
        end
    end

    function container:SetOptions(values, sorting)
        self.values = values
        self.sorting = sorting
        self:UpdateText()
    end

    function container:SetGetter(fn)
        self.isSelectedFn = fn
        self:UpdateText()
    end

    function container:SetToggle(fn)
        self.toggleFn = fn
    end

    container.SetValue = nil

    return container
end
