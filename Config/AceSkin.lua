function mUI:SkinCheckboxes()
    local AceGUI = LibStub("AceGUI-3.0")
    local OldConstructor = AceGUI.WidgetRegistry["CheckBox"]

    AceGUI.WidgetRegistry["CheckBox"] = function(...)
        local widget = OldConstructor(...)

        if widget.skinned then
            return widget
        end

        widget.skinned = true

        widget.SetType = function(self, type)
            local checkbg = self.checkbg
            local check = self.check
            local hl = self.highlight

            if type == "radio" then
                checkbg:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\radio_bg")
                check:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\radio_dot")
                hl:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\radio_hl")

                checkbg:SetSize(18, 18)
                check:SetBlendMode("ADD")
            else
                checkbg:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\checkbox_bg")
                check:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\checkbox_check")
                hl:SetTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\checkbox_hl")

                checkbg:SetSize(30, 30)
                check:SetBlendMode("BLEND")
            end
        end

        return widget
    end
end

function mUI:SkinInlineGroups()
    local AceGUI = LibStub("AceGUI-3.0")
    local OldConstructor = AceGUI.WidgetRegistry["InlineGroup"]

    AceGUI.WidgetRegistry["InlineGroup"] = function(...)
        local widget = OldConstructor(...)

        if widget.skinned then
            return widget
        end

        widget.skinned = true

        for i = 1, widget.frame:GetNumChildren() do
            local child = select(i, widget.frame:GetChildren())
            if child.GetBackdrop then
                widget.border = child
                break
            end
        end

        if widget.border then
            local pixelSize = PixelUtil.GetNearestPixelSize(1, widget.border:GetEffectiveScale())

            widget.border:SetBackdrop({
                edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeSize = pixelSize
            })

            widget.border:ClearAllPoints()
            PixelUtil.SetPoint(widget.border, "TOPLEFT", widget.frame, "TOPLEFT", 0, -20, 1, 1)
            widget.border:SetPoint("BOTTOMRIGHT", widget.frame, "BOTTOMRIGHT", 0, 0)

            widget.border:SetBackdropBorderColor(0, 0.6, 1, 1)

        end

        return widget
    end
end

function mUI:SkinDropdowns()
    local AceGUI = LibStub("AceGUI-3.0")
    local widgetTypes = {"Dropdown", "LSM30_Font", "LSM30_Sound", "LSM30_Statusbar", "LSM30_Border", "LSM30_Background"}

    for _, widgetType in ipairs(widgetTypes) do
        local OldConstructor = AceGUI.WidgetRegistry[widgetType]

        if OldConstructor then
            AceGUI.WidgetRegistry[widgetType] = function(...)
                local widget = OldConstructor(...)

                if widget.skinned then
                    return widget
                end

                widget.skinned = true

                local frame = widget.frame
                local button = frame.obj.button or frame.dropButton

                if widgetType == "Dropdown" then
                    frame.obj.dropdown.Left:SetTexture(nil)
                    frame.obj.dropdown.Middle:SetTexture(nil)
                    frame.obj.dropdown.Right:SetTexture(nil)
                else
                    frame.DLeft:SetTexture(nil)
                    frame.DMiddle:SetTexture(nil)
                    frame.DRight:SetTexture(nil)
                end

                if not frame.dropdownBorder then
                    frame.dropdownBorder = CreateFrame("Frame", nil, frame, "BackdropTemplate")

                    local pixelSize = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())

                    if widgetType == "Dropdown" then
                        frame.dropdownBorder:ClearAllPoints()
                        PixelUtil.SetPoint(frame.dropdownBorder, "TOPLEFT", frame, "TOPLEFT", 0, -17.5, 1, 1)
                        frame.dropdownBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 1)
                    else
                        frame.dropdownBorder:ClearAllPoints()
                        PixelUtil.SetPoint(frame.dropdownBorder, "TOPLEFT", frame, "TOPLEFT", 0, -17.5, 1, 1)
                        frame.dropdownBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
                    end

                    frame.dropdownBorder:SetBackdrop({
                        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                        edgeSize = pixelSize
                    })

                    frame.dropdownBorder:SetBackdropBorderColor(0, 0.6, 1, 1)
                end

                if button then
                    local normalTexture = button:GetNormalTexture()
                    local pushedTexture = button:GetPushedTexture()
                    local highlightTexture = button:GetHighlightTexture()
                    local disabledTexture = button:GetDisabledTexture()

                    normalTexture:SetAtlas("glues-characterSelect-icon-arrowDown")
                    normalTexture:SetDesaturated(true)
                    normalTexture:SetVertexColor(0, 0.6, 1)

                    pushedTexture:SetAtlas("glues-characterSelect-icon-arrowDown-pressed")
                    pushedTexture:SetDesaturated(true)
                    pushedTexture:SetVertexColor(0, 0.2, 1)

                    highlightTexture:SetAtlas("glues-characterSelect-icon-arrowDown-hover")
                    highlightTexture:SetDesaturated(true)
                    highlightTexture:SetVertexColor(0, 0.8, 1)

                    disabledTexture:SetAtlas("glues-characterSelect-icon-arrowDown-disabled")

                    -- Apply blend mode for highlight
                    local highlightTex = button:GetHighlightTexture()
                    if highlightTex then
                        highlightTex:SetBlendMode("ADD")
                    end
                end

                local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0")
                local OldGetDropDownFrame = AGSMW.GetDropDownFrame
                AGSMW.GetDropDownFrame = function(...)
                    local frame = OldGetDropDownFrame(...)

                    local pixelSize = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())

                    frame:SetBackdrop({
                        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                        tile = true,
                        tileSize = 32,
                        edgeSize = pixelSize
                    })
                    frame:SetBackdropBorderColor(0, 0.6, 1, 1)

                    -- ScrollBar
                    local scrollBar = frame.slider
                    local scrollBarPixelSize = PixelUtil.GetNearestPixelSize(1, scrollBar:GetEffectiveScale())

                    scrollBar:SetBackdrop({
                        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                        tile = true,
                        tileSize = 8,
                        edgeSize = scrollBarPixelSize
                    })
                    scrollBar:SetThumbTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\slider_thumb.png")
                    scrollBar:SetBackdropBorderColor(0, 0.6, 1, 1)

                    return frame
                end

                return widget
            end
        end
    end

    local OldConstructor = AceGUI.WidgetRegistry["Dropdown-Pullout"]

    AceGUI.WidgetRegistry["Dropdown-Pullout"] = function(...)
        local pullout = OldConstructor(...)

        local frame = pullout.frame

        if frame then
            local pixelSize = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())
            frame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                tile = true,
                tileSize = 32,
                edgeSize = pixelSize
            })
            frame:SetBackdropBorderColor(0, 0.6, 1, 1)
        end

        return pullout
    end
end

function mUI:SkinSlider()
    local AceGUI = LibStub("AceGUI-3.0")
    local OldConstructor = AceGUI.WidgetRegistry["Slider"]

    AceGUI.WidgetRegistry["Slider"] = function(...)
        local widget = OldConstructor(...)

        if widget.skinned then
            return widget
        end

        local frame = widget.frame

        widget.skinned = true

        local pixelSize = PixelUtil.GetNearestPixelSize(1, widget.slider:GetEffectiveScale())

        widget.slider:SetThumbTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\slider_thumb_horizontal.png")
        widget.slider:GetThumbTexture():SetSize(8, 11)

        -- Create a separate border frame like EditBox does
        if not widget.slider.border then
            widget.slider.border = CreateFrame("Frame", nil, widget.slider, "BackdropTemplate")

            widget.slider.border:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeSize = pixelSize
            })

            widget.slider.border:SetAllPoints(widget.slider)
            widget.slider.border:SetBackdropBorderColor(0, 0.6, 1, 1)
            widget.slider.border:SetFrameLevel(widget.slider:GetFrameLevel() - 1)

            widget.slider:SetBackdrop(nil)
        end

        PixelUtil.SetPoint(widget.slider, "TOPLEFT", frame, "TOPLEFT", 0, -20.5, 1, 1)
        widget.slider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 10.25)

        widget.editbox:ClearAllPoints()
        widget.editbox:SetPoint("CENTER", frame, "BOTTOM", 0, 0)

        widget.lowtext:ClearAllPoints()
        widget.lowtext:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)

        widget.hightext:ClearAllPoints()
        widget.hightext:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

        return widget
    end
end

function mUI:SkinEditBoxes()
    local AceGUI = LibStub("AceGUI-3.0")
    local widgetTypes = {"MultiLineEditBox", "EditBox"}
    for _, widgetType in ipairs(widgetTypes) do
        local OldConstructor = AceGUI.WidgetRegistry[widgetType]

        AceGUI.WidgetRegistry[widgetType] = function(...)
            local widget = OldConstructor(...)

            if widget.skinned then
                return widget
            end

            widget.skinned = true

            local frame = widget.frame

            if widgetType == "EditBox" then
                frame.obj.editbox.Left:SetTexture(nil)
                frame.obj.editbox.Middle:SetTexture(nil)
                frame.obj.editbox.Right:SetTexture(nil)

                if not frame.border then
                    frame.border = CreateFrame("Frame", nil, frame, "BackdropTemplate")

                    local pixelSize = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())

                    frame.border:ClearAllPoints()
                    PixelUtil.SetPoint(frame.border, "TOPLEFT", frame, "TOPLEFT", 1, -20)
                    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)

                    frame.border:SetBackdrop({
                        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                        edgeSize = pixelSize
                    })

                    frame.border:SetBackdropBorderColor(0, 0.6, 1, 1)
                end
            else
                local pixelSize = PixelUtil.GetNearestPixelSize(1, frame:GetEffectiveScale())

                widget.scrollBG:SetBackdrop({
                    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
                    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                    edgeSize = pixelSize
                })

                widget.scrollBG:SetBackdropBorderColor(0, 0.6, 1, 1)

                -- Adjust scrollBG to make room for the scrollbar
                widget.scrollBG:ClearAllPoints()
                widget.scrollBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
                widget.scrollBG:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 0)

                -- Hide scroll up/down buttons
                if widget.scrollFrame.ScrollBar.ScrollUpButton then
                    widget.scrollFrame.ScrollBar.ScrollUpButton:Hide()
                end
                if widget.scrollFrame.ScrollBar.ScrollDownButton then
                    widget.scrollFrame.ScrollBar.ScrollDownButton:Hide()
                end

                -- Make scrollbar thinner
                widget.scrollFrame.ScrollBar:SetWidth(8)

                widget.scrollFrame.ScrollBar:SetThumbTexture(
                    "Interface\\AddOns\\mUI\\Media\\Textures\\Config\\slider_thumb.png")

                -- Resize thumb texture to be thinner
                local thumbTexture = widget.scrollFrame.ScrollBar:GetThumbTexture()
                if thumbTexture then
                    thumbTexture:SetWidth(8)
                end

                -- Position scrollbar outside the editbox with spacing
                widget.scrollFrame.ScrollBar:ClearAllPoints()
                widget.scrollFrame.ScrollBar:SetPoint("TOPLEFT", widget.scrollBG, "TOPRIGHT", 2, -3)
                widget.scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", widget.scrollBG, "BOTTOMRIGHT", 2, 3)

                local scrollUp = widget.scrollFrame.ScrollBar.ScrollUpButton
                local scrollUpNormal = scrollUp:GetNormalTexture()
                local scrollUpPushed = scrollUp:GetPushedTexture()
                local scrollUpHighlight = scrollUp:GetHighlightTexture()
                local scrollUpDisabled = scrollUp:GetDisabledTexture()

                local scrollDown = widget.scrollFrame.ScrollBar.ScrollDownButton
                local scrollDownNormal = scrollDown:GetNormalTexture()
                local scrollDownPushed = scrollDown:GetPushedTexture()
                local scrollDownHighlight = scrollDown:GetHighlightTexture()
                local scrollDownDisabled = scrollDown:GetDisabledTexture()

                scrollUpNormal:SetAtlas("glues-characterSelect-icon-arrowUp")
                scrollUpNormal:SetDesaturated(true)
                scrollUpNormal:SetVertexColor(0, 0.6, 1)

                scrollUpPushed:SetAtlas("glues-characterSelect-icon-arrowUp-pressed")
                scrollUpPushed:SetDesaturated(true)
                scrollUpPushed:SetVertexColor(0, 0.2, 1)

                scrollUpHighlight:SetAtlas("glues-characterSelect-icon-arrowUp-hover")
                scrollUpHighlight:SetDesaturated(true)
                scrollUpHighlight:SetVertexColor(0, 0.8, 1)

                scrollUpDisabled:SetAtlas("glues-characterSelect-icon-arrowDown-disabled")
                scrollUpDisabled:SetRotation(math.pi)

                scrollDownNormal:SetAtlas("glues-characterSelect-icon-arrowDown")
                scrollDownNormal:SetDesaturated(true)
                scrollDownNormal:SetVertexColor(0, 0.6, 1)

                scrollDownPushed:SetAtlas("glues-characterSelect-icon-arrowDown-pressed")
                scrollDownPushed:SetDesaturated(true)
                scrollDownPushed:SetVertexColor(0, 0.2, 1)

                scrollDownHighlight:SetAtlas("glues-characterSelect-icon-arrowDown-hover")
                scrollDownHighlight:SetDesaturated(true)
                scrollDownHighlight:SetVertexColor(0, 0.8, 1)

                scrollDownDisabled:SetAtlas("glues-characterSelect-icon-arrowDown-disabled")

                if not widget.scrollFrame.ScrollBar.border then
                    widget.scrollFrame.ScrollBar.border = CreateFrame("Frame", nil, widget.scrollFrame.ScrollBar,
                        "BackdropTemplate")
                    local scrollBarPixelSize = PixelUtil.GetNearestPixelSize(1,
                        widget.scrollFrame.ScrollBar:GetEffectiveScale())

                    widget.scrollFrame.ScrollBar.border:SetBackdrop({
                        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                        edgeSize = scrollBarPixelSize
                    })

                    widget.scrollFrame.ScrollBar.border:ClearAllPoints()
                    widget.scrollFrame.ScrollBar.border:SetPoint("TOPLEFT", widget.scrollFrame.ScrollBar, "TOPLEFT", 0,
                        -0.5)
                    widget.scrollFrame.ScrollBar.border:SetPoint("BOTTOMRIGHT", widget.scrollFrame.ScrollBar,
                        "BOTTOMRIGHT", 0, 0)

                    widget.scrollFrame.ScrollBar.border:SetBackdropBorderColor(0, 0.6, 1, 1)
                end
            end

            widget.button:SetNormalTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_normal.png")
            widget.button:SetHighlightTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_highlight.png")
            widget.button:SetPushedTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_pressed.png")
            widget.button:SetDisabledTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_disabled.png")

            widget.button.Left:Hide()
            widget.button.Middle:Hide()
            widget.button.Right:Hide()

            return widget
        end
    end
end

function mUI:SkinButtons()
    local AceGUI = LibStub("AceGUI-3.0")
    local OldConstructor = AceGUI.WidgetRegistry["Button"]

    AceGUI.WidgetRegistry["Button"] = function(...)
        local widget = OldConstructor(...)

        if widget.skinned then
            return widget
        end

        widget.skinned = true

        local frame = widget.frame

        frame:SetNormalTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_normal.png")
        frame:SetHighlightTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_highlight.png")
        frame:SetPushedTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_pressed.png")
        frame:SetDisabledTexture("Interface\\AddOns\\mUI\\Media\\Textures\\Config\\button_disabled.png")

        -- Add spacing by insetting the content region slightly
        local normalTex = frame:GetNormalTexture()
        local highlightTex = frame:GetHighlightTexture()
        local pushedTex = frame:GetPushedTexture()
        local disabledTex = frame:GetDisabledTexture()

        for _, tex in pairs({normalTex, highlightTex, pushedTex, disabledTex}) do
            if tex then
                tex:ClearAllPoints()
                tex:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, 0)
                tex:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 0)
            end
        end

        frame.Left:Hide()
        frame.Middle:Hide()
        frame.Right:Hide()

        return widget
    end
end
