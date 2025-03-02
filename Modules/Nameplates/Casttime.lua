local Casttime = mUI:NewModule("mUI.Modules.Nameplates.Casttime", "AceHook-3.0")

function Casttime:OnInitialize()
    -- Load Database
    Casttime.db = {
        nameplates = mUI.db.profile.nameplates,
        general = mUI.db.profile.general
    }

    -- Load Database
    Casttime.LSM = LibStub("LibSharedMedia-3.0")
    Casttime.font = Casttime.LSM:Fetch('font', Casttime.db.general.font)

    function Casttime:IconSkin(icon, parent)
        if not icon or (icon and icon.styled) then return end

        local backdrop = {
            bgFile = nil,
            edgeFile = "Interface\\Addons\\mUI\\Media\\Textures\\Core\\outer_shadow",
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
        border:SetTexture("Interface\\Addons\\mUI\\Media\\Textures\\Core\\gloss")
        border:SetTexCoord(0, 1, 0, 1)
        border:SetDrawLayer("BACKGROUND", -7)
        border:SetVertexColor(unpack(mUI:Color(0.25)))
        border:ClearAllPoints()
        border:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        icon.border = border

        local back = CreateFrame("Frame", nil, parent, "BackdropTemplate")
        back:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
        back:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
        back:SetFrameLevel(frame:GetFrameLevel() - 1)
        back:SetBackdrop(backdrop)
        back:SetBackdropBorderColor(unpack(mUI:Color(0.25)))
        back:SetAlpha(0.9)
        icon.bg = back
        icon.styled = true
    end

    function Casttime:NameplateCastbar(frame)
        if not frame or frame:IsForbidden() then return end
        if frame.unit and frame.unit:find('nameplate%d') then
            local _, _, _, _, _, _, _, castInterrupt = UnitCastingInfo(frame.unit);
            local _, _, _, _, _, _, channelInterrupt, _, _, _ = UnitChannelInfo(frame.unit);

            if frame and frame.Icon then
                if frame.BorderShield then
                    frame.BorderShield:ClearAllPoints()
                    frame.BorderShield:SetAtlas("ui-castingbar-shield")
                    PixelUtil.SetPoint(frame.BorderShield, "CENTER", frame, "LEFT", -10, 0)
                end

                frame.Icon:ClearAllPoints();
                PixelUtil.SetPoint(frame.Icon, "CENTER", frame, "LEFT", -10, 0);
                frame.Text:SetFont(Casttime.font, 10, "OUTLINE")
                Casttime:IconSkin(frame.Icon, frame)

                if castInterrupt or channelInterrupt then
                    frame.Icon:Hide()
                    frame.Icon.border:Hide()
                    frame.Icon.bg:Hide()
                else
                    frame.Icon:Show()
                    frame.Icon.border:Show()
                    frame.Icon.bg:Show()
                end

                if Casttime.db.nameplates.casttime then
                    if not frame.timer then
                        frame.timer = frame:CreateFontString(nil)
                        frame.timer:SetFont(Casttime.font, 8, "THINOUTLINE")
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

    function Casttime:NameplateCastbarIcon(frame)
        if not frame or frame:IsForbidden() then return end

        if frame.castBar and frame.castBar.Icon then
            if frame.castBar.BorderShield then
                frame.castBar.BorderShield:ClearAllPoints()
                PixelUtil.SetPoint(frame.castBar.BorderShield, "CENTER", frame.castBar, "LEFT", -10, 0)
            end

            frame.castBar.Icon:ClearAllPoints();
            PixelUtil.SetPoint(frame.castBar.Icon, "CENTER", frame.castBar, "LEFT", -10, 0);
            frame.castBar.Text:SetFont(Casttime.font, 10, "OUTLINE")
        end
    end
end

function Casttime:OnEnable()
    Casttime:SecureHook(CastingBarMixin, "OnUpdate", function(frame)
        Casttime:NameplateCastbar(frame)
    end)
    Casttime:SecureHook("DefaultCompactNamePlateFrameAnchorInternal", function(frame)
        Casttime:NameplateCastbarIcon(frame)
    end)
end

function Casttime:OnDisable()
    Casttime:UnhookAll()
end
