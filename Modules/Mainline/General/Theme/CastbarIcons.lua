local Theme = mUI:GetModule("mUI.Modules.General.Theme")

Theme.castbars = {
    player = "PlayerCastingBarFrame",
    playerOverlay = "OverlayPlayerCastingBarFrame",
    target = "TargetFrameSpellBar",
    focus = "FocusFrameSpellBar",
    boss1 = "Boss1TargetFrameSpellBar",
    boss2 = "Boss2TargetFrameSpellBar",
    boss3 = "Boss3TargetFrameSpellBar",
    boss4 = "Boss4TargetFrameSpellBar",
    boss5 = "Boss5TargetFrameSpellBar"
}

Theme.castbarIcons = {}

function Theme:CreateCastbarIcons(unit, castbar)
    if not castbar.mUIBorder then
        castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- Create Border
        castbar.mUIBorder = castbar:CreateTexture(nil, "OVERLAY", nil, 7)
        castbar.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\atlas.png]])
        castbar.mUIBorder:SetTexCoord(0.001953125, 0.142578125, 0.451171875, 0.591796875)
        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Set Icon Mask
        castbar.mUIBorder.mask = castbar:CreateMaskTexture()
        castbar.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Auras\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        castbar.mUIBorder.mask:SetAllPoints(castbar.Icon)
        castbar.Icon:AddMaskTexture(castbar.mUIBorder.mask)

        if unit == "player" or unit == "playerOverlay" then
            castbar.mUIBorder:SetSize(22, 22)
            -- castbar.mUIBorder:SetSize(22 * 1.75, 22 * 1.75)
            castbar.mUIBorder:SetPoint("TOPLEFT", castbar.Icon, "TOPLEFT", -9, 9)
            castbar.mUIBorder:SetPoint("BOTTOMRIGHT", castbar.Icon, "BOTTOMRIGHT", 9.75, -8.75)
        else
            castbar.Icon:SetSize(16, 16)
            castbar.Icon.SetSize = function()
            end
            castbar.mUIBorder:SetSize(16 * 1.85, 16 * 1.85)
            castbar.mUIBorder:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
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
