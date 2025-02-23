local Casttime = mUI:NewModule("mUI.Modules.Nameplates.Casttime")

function Casttime:OnInitialize()
    -- Load Database
    self.db = mUI.db.profile.nameplates

    function self:IconSkin(icon, parent)
        if not icon or (icon and icon.styled) then return end

        local backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\SUI\\Media\\Textures\\Core\\outer_shadow",
            tile = false,
            tileSize = 32,
            edgeSize = 4,
            insets = {
                left = 4,
                right = 4,
                top = 4,
                bottom = 4,
            },
        }

        local frame = CreateFrame("Frame", nil, parent)

        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

        local border = frame:CreateTexture(nil, "BACKGROUND")
        border:SetTexture("Interface\\Addons\\SUI\\Media\\Textures\\Core\\gloss")
        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer("BACKGROUND", -7)
        --border:SetVertexColor(unpack(SUI:Color()))
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        icon.border = border

        local back = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        back:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
        back:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
        back:SetFrameLevel(frame:GetFrameLevel() - 1)
        back:SetBackdrop(backdrop)
        back:SetBackdropBorderColor(unpack(mUI:Color(0.15)))
        back:SetAlpha(0.9)
        icon.bg = back
        icon.styled = true
    end

    function self:NameplateCastbar(frame)
        if not frame or frame:IsForbidden() then return end
        if frame.unit and frame.unit:find('nameplate%d') then
            local _, _, _, _, _, _, _, castInterrupt = UnitCastingInfo(frame.unit);
            local _, _, _, _, _, _, channelInterrupt, _, _, _ = UnitChannelInfo(frame.unit);

            if frame and frame.Icon then
                if frame.BorderShield then
                    frame.BorderShield:ClearAllPoints()
                    PixelUtil.SetPoint(frame.BorderShield, "CENTER", frame, "LEFT", -10, 0)
                end

                frame.Icon:ClearAllPoints();
                PixelUtil.SetPoint(frame.Icon, "CENTER", frame, "LEFT", -10, 0);
                frame.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
                self:IconSkin(frame.Icon, frame)

                if castInterrupt or channelInterrupt then
                    frame.Icon:Hide()
                    frame.Icon.border:Hide()
                    frame.Icon.bg:Hide()
                else
                    frame.Icon:Show()
                    frame.Icon.border:Show()
                    frame.Icon.bg:Show()
                end

                if self.db.casttime then
                    if not frame.timer then
                        frame.timer = frame:CreateFontString(nil)
                        frame.timer:SetFont(STANDARD_TEXT_FONT, 8, "THINOUTLINE")
                        frame.timer:SetPoint("CENTER", frame.Icon, "BOTTOM", 0, -5)
                        frame.timer:SetDrawLayer("OVERLAY")
                    else
                        if frame.casting then
                            frame.timer:SetText(format("%.1f", max(frame.maxValue - frame.value, 0)))
                        elseif frame.channeling then
                            frame.timer:SetText(format("%.1f", max(frame.value, 0)))
                        else
                            frame.timer:SetText("")
                        end
                    end
                else
                    if frame.timer then
                        frame.timer:SetText("")
                    end
                end
            end
        end
    end

    function self:NameplateCastbarIcon(frame)
        if not frame or frame:IsForbidden() then return end

        if frame.castBar and frame.castBar.Icon then
            if frame.castBar.BorderShield then
                frame.castBar.BorderShield:ClearAllPoints()
                PixelUtil.SetPoint(frame.castBar.BorderShield, "CENTER", frame.castBar, "LEFT", -10, 0)
            end

            frame.castBar.Icon:ClearAllPoints();
            PixelUtil.SetPoint(frame.castBar.Icon, "CENTER", frame.castBar, "LEFT", -10, 0);
            frame.castBar.Text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
        end
    end
end

function Casttime:OnEnable()
    mUI:SecureHook(CastingBarMixin, "OnUpdate", function(frame)
        self:NameplateCastbar(frame)
    end)
    mUI:SecureHook("DefaultCompactNamePlateFrameAnchorInternal", function(frame)
        self:NameplateCastbarIcon(frame)
    end)
end

function Casttime:OnDisable()
    mUI:Unhook(CastingBarMixin, "OnUpdate")
    mUI:Unhook("DefaultCompactNamePlateFrameAnchorInternal")
end
