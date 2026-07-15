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
        castbar.mUIBorder = castbar:CreateTexture()
        castbar.mUIBorder:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\border.png]])
        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Set Icon Mask
        castbar.mUIBorder.mask = castbar:CreateMaskTexture()
        castbar.mUIBorder.mask:SetTexture([[Interface\AddOns\mUI\Media\Textures\Core\mask.png]], "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
        castbar.mUIBorder.mask:SetAllPoints(castbar.Icon)
        castbar.mUIBorder:SetDrawLayer("OVERLAY", 7)
        castbar.Icon:AddMaskTexture(castbar.mUIBorder.mask)

        -- playerOverlay (OverlayPlayerCastingBarFrame) is the frame Blizzard
        -- swaps in over the real player castbar for the "Activating
        -- Specialization" cast shown while switching talents/specs - style
        -- it identically to the real player castbar.
        if unit == "player" or unit == "playerOverlay" then
            castbar.mUIBorder:SetSize(22, 22)
            castbar.mUIBorder:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
        else
            castbar.Icon:SetSize(16, 16)
            castbar.Icon.SetSize = function()
            end
            castbar.mUIBorder:SetPoint("CENTER", castbar.Icon, "CENTER", 0, 0)
            castbar.mUIBorder:SetSize(18, 18)
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
