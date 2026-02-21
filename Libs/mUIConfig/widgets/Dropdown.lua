-- Widget is based on the AceGUIWidget-DropDown.lua supplied with AceGUI-3.0
-- Widget created by Yssaril
local AceGUI = LibStub("AceGUI-3.0")
local Media = LibStub("LibSharedMedia-3.0")

local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0-mUI")

do
    local widgetType = "mUI_Dropdown"
    local widgetVersion = 14

    local contentFrameCache = {}
    local function ReturnSelf(self)
        self:ClearAllPoints()
        self:Hide()
        self.check:Hide()
        table.insert(contentFrameCache, self)
    end

    local function ContentOnClick(this, button)
        local self = this.obj
        self:Fire("OnValueChanged", this.key)
        if self.dropdown then
            self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
        end
    end

    local function GetContentLine()
        local frame
        if next(contentFrameCache) then
            frame = table.remove(contentFrameCache)
        else
            frame = CreateFrame("Button", nil, UIParent)
            -- frame:SetWidth(200)
            frame:SetHeight(18)
            frame:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")
            frame:SetScript("OnClick", ContentOnClick)
            local check = frame:CreateTexture("OVERLAY")
            check:SetWidth(16)
            check:SetHeight(16)
            check:SetPoint("LEFT", frame, "LEFT", 1, -1)
            check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
            check:Hide()
            frame.check = check
            local text = frame:CreateFontString(nil, "OVERLAY", "GameFontWhite")
            text:SetPoint("TOPLEFT", check, "TOPRIGHT", 1, 0)
            text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 0)
            text:SetJustifyH("LEFT")
            frame.text = text
            frame.ReturnSelf = ReturnSelf
        end
        frame:Show()
        return frame
    end

    local function OnAcquire(self)
        self:SetHeight(44)
        self:SetWidth(200)
    end

    local function OnRelease(self)
        self:SetText("")
        self:SetLabel("")
        self:SetDisabled(false)

        self.value = nil
        self.list = nil
        self.open = nil
        self.hasClose = nil

        self.frame:ClearAllPoints()
        self.frame:Hide()
    end

    local function SetValue(self, value) -- Set the value to an item in the List.
        if self.list then
            self:SetText(self.list[value] or value or "")
        end
        self.value = value
    end

    local function GetValue(self)
        return self.value
    end

    local function SetList(self, list) -- Set the list of values for the dropdown (key => value pairs)
        self.list = list or {}
    end

    local function SetText(self, text) -- Set the text displayed in the box.
        self.frame.text:SetText(text or "")
    end

    local function SetLabel(self, text) -- Set the text for the label.
        self.frame.label:SetText(text or "")
    end

    local function AddItem(self, key, value) -- Add an item to the list.
        self.list = self.list or {}
        self.list[key] = value
    end
    local SetItemValue = AddItem -- Set the value of a item in the list. <<same as adding a new item>>

    local function SetMultiselect(self, flag)
    end -- Toggle multi-selecting. <<Dummy function to stay inline with the dropdown API>>
    local function GetMultiselect()
        return false
    end -- Query the multi-select flag. <<Dummy function to stay inline with the dropdown API>>
    local function SetItemDisabled(self, key)
    end -- Disable one item in the list. <<Dummy function to stay inline with the dropdown API>>

    local function SetDisabled(self, disabled) -- Disable the widget.
        self.disabled = disabled
        if disabled then
            self.frame:Disable()
        else
            self.frame:Enable()
        end
    end

    local function textSort(a, b)
        return string.upper(a) < string.upper(b)
    end

    local sortedlist = {}
    local function ToggleDrop(this)
        local self = this.obj
        if self.dropdown then
            self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
            AceGUI:ClearFocus()
        else
            AceGUI:SetFocus(self)
            self.dropdown = AGSMW:GetDropDownFrame()
            local width = self.frame:GetWidth()
            self.dropdown:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT")
            self.dropdown:SetPoint("TOPRIGHT", self.frame, "BOTTOMRIGHT", width < 160 and (160 - width) or 0, 0)
            for k, v in pairs(self.list) do
                sortedlist[#sortedlist + 1] = {
                    key = k,
                    value = v
                }
            end
            table.sort(sortedlist, function(a, b)
                return string.upper(a.value) < string.upper(b.value)
            end)
            for i, entry in ipairs(sortedlist) do
                local f = GetContentLine()
                f.text:SetText(entry.value)
                f.key = entry.key
                if entry.key == self.value then
                    f.check:Show()
                end
                f.obj = self
                self.dropdown:AddFrame(f)
            end
            wipe(sortedlist)
        end
    end

    local function ClearFocus(self)
        if self.dropdown then
            self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
        end
    end

    local function OnHide(this)
        local self = this.obj
        if self.dropdown then
            self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
        end
    end

    local function Drop_OnEnter(this)
        this.obj:Fire("OnEnter")
    end

    local function Drop_OnLeave(this)
        this.obj:Fire("OnLeave")
    end

    local function Constructor()
        local frame = AGSMW:GetBaseFrame()
        local self = {}

        self.type = widgetType
        self.frame = frame
        frame.obj = self
        frame.dropButton.obj = self
        frame.dropButton:SetScript("OnEnter", Drop_OnEnter)
        frame.dropButton:SetScript("OnLeave", Drop_OnLeave)
        frame.dropButton:SetScript("OnClick", ToggleDrop)
        frame:SetScript("OnHide", OnHide)

        self.alignoffset = 31

        self.OnRelease = OnRelease
        self.OnAcquire = OnAcquire
        self.ClearFocus = ClearFocus
        self.SetText = SetText
        self.SetValue = SetValue
        self.GetValue = GetValue
        self.SetList = SetList
        self.SetLabel = SetLabel
        self.SetDisabled = SetDisabled
        self.AddItem = AddItem
        self.SetMultiselect = SetMultiselect
        self.GetMultiselect = GetMultiselect
        self.SetItemValue = SetItemValue
        self.SetItemDisabled = SetItemDisabled
        self.ToggleDrop = ToggleDrop

        if not self.dropdownBorder then
            self.dropdownBorder = CreateFrame("Frame", nil, frame, "BackdropTemplate")
            local pixel = mUI:Scale(1)

            if widgetType == "Dropdown" then
                self.dropdownBorder:ClearAllPoints()
                self.dropdownBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -17.5)
                self.dropdownBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 1)
            else
                self.dropdownBorder:ClearAllPoints()
                self.dropdownBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -17.5)
                self.dropdownBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
            end

            self.dropdownBorder:SetBackdrop({
                edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeSize = pixel,
                insets = {
                    left = pixel,
                    right = pixel,
                    top = pixel,
                    bottom = pixel
                }
            })

            -- Disable pixel snapping on border textures
            for _, region in next, {self.dropdownBorder:GetRegions()} do
                if region and region.IsObjectType then
                    mUI:DisablePixelSnap(region)
                end
            end

            self.dropdownBorder:SetBackdropBorderColor(0, 0.6, 1, 1)
        end

        local normalTexture = frame.dropButton:GetNormalTexture()
        local pushedTexture = frame.dropButton:GetPushedTexture()
        local highlightTexture = frame.dropButton:GetHighlightTexture()
        local disabledTexture = frame.dropButton:GetDisabledTexture()

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
        local highlightTex = frame.dropButton:GetHighlightTexture()
        if highlightTex then
            highlightTex:SetBlendMode("ADD")
        end

        frame.DLeft:SetTexture(nil)
        frame.DMiddle:SetTexture(nil)
        frame.DRight:SetTexture(nil)

        AceGUI:RegisterAsWidget(self)
        return self
    end

    AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)

end
