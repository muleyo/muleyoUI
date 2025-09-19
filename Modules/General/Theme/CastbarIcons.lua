local Theme = mUI:GetModule("mUI.Modules.General.Theme")

Theme.classic = WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC

if Theme.classic then
    Theme.castbars = {
        player = "CastingBarFrame",
        target = "TargetFrameSpellBar",
        focus = "FocusFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }
else
    Theme.castbars = {
        player = "PlayerCastingBarFrame",
        target = "TargetFrameSpellBar",
        focus = "FocusFrameSpellBar",
        boss1 = "Boss1TargetFrameSpellBar",
        boss2 = "Boss2TargetFrameSpellBar",
        boss3 = "Boss3TargetFrameSpellBar",
        boss4 = "Boss4TargetFrameSpellBar",
        boss5 = "Boss5TargetFrameSpellBar"
    }
end

Theme.castbarIcons = {}

function Theme:CreateCastbarIcons(unit, castbar)
    if not castbar.mUIBorder then
        castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Border
        castbar.mUIBorder = castbar:CreateTexture()
        if Theme.classic then
            castbar.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\uiactionbar2x.png]])
            castbar.mUIBorder:SetTexCoord(0.701171875, 0.880859375, 0.31689453125, 0.36083984375)
        else
            castbar.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border.png]])
        end

        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Set Icon Mask
        castbar.mUIBorder.mask = castbar:CreateMaskTexture()
        castbar.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]],
            "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        castbar.mUIBorder.mask:SetAllPoints(castbar.Icon)
        castbar.mUIBorder:SetDrawLayer("OVERLAY", 7)
        castbar.Icon:AddMaskTexture(castbar.mUIBorder.mask)

        if unit == "player" then
            if Theme.classic then
                castbar.mUIBorder:SetSize(22, 21)
                castbar.mUIBorder:SetPoint("TOPLEFT", castbar.Icon)
            else
                castbar.mUIBorder:SetSize(22, 22)
                castbar.mUIBorder:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
            end
        else
            castbar.Icon:SetSize(16, 16)
            castbar.Icon.SetSize = function() end
            if Theme.classic then
                castbar.mUIBorder:SetSize(16, 16)

                castbar.mUIBorder:SetPoint("TOPLEFT", castbar.Icon, "TOPLEFT", 0, 0)
                castbar.mUIBorder:SetPoint("BOTTOMRIGHT", castbar.Icon, "BOTTOMRIGHT", 1.25, -1.25)
            else
                castbar.mUIBorder:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
                castbar.mUIBorder:SetSize(18, 18)
            end
        end

        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        Theme.castbarIcons[castbar] = true
    end
end

function Theme:InitCastbarIcons()
    for unit, castbar in pairs(Theme.castbars) do
        Theme:CreateCastbarIcons(unit, _G[castbar])
    end
end
