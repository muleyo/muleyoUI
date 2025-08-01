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
        if not icon or (parent and parent.mUIBorder) then return end

        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Border
        parent.mUIBorder = parent:CreateTexture()
        if mUI:IsClassic() then
            parent.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
            parent.mUIBorder:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        else
            parent.mUIBorder:SetAtlas("UI-HUD-ActionBar-IconFrame")
        end

        parent.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Set Icon Mask
        parent.mUIBorder.mask = parent:CreateMaskTexture()
        parent.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border_mask.png]],
            "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        parent.mUIBorder.mask:SetAllPoints(icon)
        parent.mUIBorder:SetDrawLayer("OVERLAY", 1)
        icon:AddMaskTexture(parent.mUIBorder.mask)

        if mUI:IsClassic() then
            parent.mUIBorder:SetPoint("TOPLEFT", icon, "TOPLEFT", -0.75, 0.75)
            parent.mUIBorder:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -0.75)
        else
            parent.mUIBorder:SetPoint("TOPLEFT", icon, "TOPLEFT", -0.75, 0.75)
            parent.mUIBorder:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1.8, -0.75)
        end
    end

    function Casttime:NameplateCastbar(frame)
        if not frame or frame:IsForbidden() then return end
        if frame.unit and frame.unit:find('nameplate%d') then
            local _, _, _, _, _, _, _, castInterrupt = UnitCastingInfo(frame.unit)
            local _, _, _, _, _, _, channelInterrupt, _, _, _ = UnitChannelInfo(frame.unit)

            if frame and frame.Icon then
                if not mUI:IsClassic() then
                    if frame.BorderShield then
                        frame.BorderShield:ClearAllPoints()
                        frame.BorderShield:SetAtlas("ui-castingbar-shield")
                        PixelUtil.SetPoint(frame.BorderShield, "CENTER", frame, "LEFT", -10, 0)
                    end
                end

                if mUI:IsClassic() then
                    frame:SetStatusBarTexture(Casttime.LSM:Fetch('statusbar', Casttime.db.nameplates.texture))
                    frame:GetStatusBarTexture():SetDrawLayer("BORDER")
                end

                frame.Icon:ClearAllPoints()
                if mUI:IsClassic() then
                    PixelUtil.SetPoint(frame.Icon, "CENTER", frame, "LEFT", -11.25, 2.5)
                else
                    PixelUtil.SetPoint(frame.Icon, "CENTER", frame, "LEFT", -10, 0)
                end
                frame.Text:SetFont(Casttime.font, 10, "OUTLINE")
                Casttime:IconSkin(frame.Icon, frame)

                if not mUI:IsClassic() then
                    if castInterrupt or channelInterrupt then
                        frame.Icon:Hide()
                        frame.mUIBorder:Hide()
                    else
                        frame.Icon:Show()
                        frame.mUIBorder:Show()
                    end
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

            frame.castBar.Icon:ClearAllPoints()
            PixelUtil.SetPoint(frame.castBar.Icon, "CENTER", frame.castBar, "LEFT", -10, 0)
            frame.castBar.Text:SetFont(Casttime.font, 10, "OUTLINE")
        end
    end
end

function Casttime:OnEnable()
    if mUI:IsClassic() then
        Casttime:SecureHook("CastingBarFrame_OnUpdate", function(frame)
            Casttime:NameplateCastbar(frame)
        end)
    else
        Casttime:SecureHook(CastingBarMixin, "OnUpdate", function(frame)
            Casttime:NameplateCastbar(frame)
        end)

        Casttime:SecureHook("DefaultCompactNamePlateFrameAnchorInternal", function(frame)
            Casttime:NameplateCastbarIcon(frame)
        end)
    end
end

function Casttime:OnDisable()
    Casttime:UnhookAll()
end
