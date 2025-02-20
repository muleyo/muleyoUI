local Functions = mUI:NewModule("mUI.Functions")

function Functions:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile

    -- Get Modules
    local General = mUI:GetModule("mUI.Modules.General")

    -- Get Player Class, Colors and Theme
    local _, class = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[class]
    local customColor = self.db.general.color
    local themes = {
        Disabled = { 1, 1, 1 },
        Dark = { 0.3, 0.3, 0.3 },
        Class = { classColor.r, classColor.g, classColor.b },
        Custom = { customColor[1], customColor[2], customColor[3], customColor[4] },
    }
    local theme = themes[self.db.general.theme]

    -- Debug Print Function
    function mUI:Debug(msg)
        print("|cff009cffm|r|cffffd100UI|r:", msg)
    end

    -- Version check
    local currentVersion = C_AddOns.GetAddOnMetadata("mUI", "version")

    local function GetDefaultCommChannel()
        if IsInRaid() then
            return IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID"
        elseif IsInGroup() then
            return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
        elseif IsInGuild() then
            return "GUILD"
        else
            return "YELL"
        end
    end

    function mUI:ReceiveVersion(_, version, _, sender)
        if not self.db.new_version then
            if (version > currentVersion) then
                mUI:Debug(
                    "A newer version is available. If you experience any errors or bugs, updating is highly recommended.")
                self.db.new_version = version
            end
        elseif (self.db.new_version == currentVersion) or (self.db.new_version <= currentVersion) then
            self.db.new_version = false
        end
    end

    function mUI:SendVersion(channel)
        self:SendCommMessage("mUIVersion", currentVersion, channel or GetDefaultCommChannel())
    end

    mUI:RegisterComm("mUIVersion", "ReceiveVersion")
    mUI:RegisterEvent("ZONE_CHANGED_NEW_AREA", function()
        mUI:SendVersion()
        if IsInGuild() then mUI:SendVersion("GUILD") end
    end)
    C_Timer.After(30, function()
        mUI:SendVersion()
        if IsInGuild() then mUI:SendVersion("GUILD") end
        mUI:SendVersion("YELL")
    end)

    -- Link Popup
    function mUI:Link(url)
        if not url then return end
        StaticPopupDialogs["mUIPopup"] = nil
        StaticPopupDialogs["mUIPopup"] = {
            text = "|cff009cffmuleyo|rUI\n\n|cffffcc00Copy the link below ( CTRL + C )|r",
            button1 = CLOSE,
            whileDead = true,
            hideOnEscape = true,
            hasEditBox = true,
            editBoxWidth = 200,
            EditBoxOnEscapePressed = function(self)
                self:GetParent():Hide()
            end,
            OnShow = function(self, data)
                self.editBox:SetText(data.url)
                self.editBox:HighlightText()
                self.editBox:SetScript("OnKeyDown", function(_, key)
                    if key == "C" and IsControlKeyDown() then
                        C_Timer.After(0.3, function()
                            self.editBox:GetParent():Hide()
                            UIErrorsFrame:AddMessage("Link copied to clipboard")
                        end)
                    end
                end)
            end,
        }
        StaticPopup_Show("mUIPopup", "", "", { url = url })
    end

    function mUI:Reload(module)
        StaticPopupDialogs["mUIReloadPopup"] = nil -- Clear Popup before creating a new one
        StaticPopupDialogs["mUIReloadPopup"] = {
            text = "|cff009cffmuleyo|rUI\n\n|cffffcc00Your UI requires a reload.\n\nReason: " ..
                module .. "'|r",
            button1 = "Reload UI",
            whileDead = true,
            hideOnEscape = false,
            StaticPopup1Button1:HookScript("OnClick", function()
                ReloadUI()
            end)
        }
        StaticPopup_Show("mUIReloadPopup", "", "")
    end

    -- Theme Functions
    function mUI:Color(sub, alpha)
        -- Update Custom Color & Theme
        customColor = mUI.db.profile.general.color
        themes["Custom"] = { customColor[1], customColor[2], customColor[3], customColor[4] }
        if not General:IsEnabled() then
            theme = themes["Disabled"]
        else
            theme = themes[mUI.db.profile.general.theme]
        end

        if theme then
            if theme[4] then alpha = theme[4] end
            if not alpha then alpha = 1 end
            local color = { 0, 0, 0, alpha }
            if sub then
                color[1] = theme[1] - sub
                color[2] = theme[2] - sub
                color[3] = theme[3] - sub
            end
            return color
        end
    end

    function mUI:Skin(frame, isTable, isGui)
        -- Update Custom Color & Theme
        customColor = mUI.db.profile.general.color
        themes["Custom"] = { customColor[1], customColor[2], customColor[3], customColor[4] }
        if not General:IsEnabled() then
            theme = themes["Disabled"]
        else
            theme = themes[mUI.db.profile.general.theme]
        end

        -- Get forbiden frames
        local forbiddenFrames = mUI:GetModule("mUI.Modules.General.Theme").forbiddenFrames

        if frame then
            if isGui then
                for _, v in pairs({ frame:GetRegions() }) do
                    if v:GetObjectType() == "Texture" then
                        v:SetDesaturated(true)
                        v:SetVertexColor(0.15, 0.15, 0.15, 1)
                    end
                end
            elseif not isTable then
                for _, v in pairs({ frame:GetRegions() }) do
                    if (not forbiddenFrames[v:GetName()]) and (not forbiddenFrames[v]) then
                        if v:GetObjectType() == "Texture" then
                            if themes["Disabled"] == theme then
                                v:SetDesaturated(false)
                            else
                                v:SetDesaturated(true)
                            end
                            v:SetVertexColor(unpack(mUI:Color(0.15)))
                        end
                    end
                end
            else
                for _, v in pairs(frame) do
                    if v then
                        if themes["Disabled"] == theme then
                            v:SetDesaturated(false)
                        else
                            v:SetDesaturated(true)
                        end
                        v:SetVertexColor(unpack(mUI:Color(0.15)))
                    end
                end
            end
        end
    end
end
