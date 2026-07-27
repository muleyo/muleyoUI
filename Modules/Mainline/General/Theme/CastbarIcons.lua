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
        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        -- Set Icon Mask
        castbar.mUIBorder.mask = castbar:CreateMaskTexture()
        castbar.mUIBorder.mask:SetAllPoints(castbar.Icon)
        castbar.Icon:AddMaskTexture(castbar.mUIBorder.mask)

        local isPlayer = unit == "player" or unit == "playerOverlay"
        if not isPlayer then
            castbar.Icon:SetSize(16, 16)
            castbar.Icon.SetSize = function()
            end
        end

        Theme:RegisterBorder({
            border = castbar.mUIBorder,
            coord = true,
            mask = castbar.mUIBorder.mask,
            applyGeometry = function(style)
                local ins = isPlayer and (style.castbarInset or 4) or (style.castbarInsetSmall or 3.5)
                castbar.mUIBorder:ClearAllPoints()
                castbar.mUIBorder:SetPoint("TOPLEFT", castbar.Icon, "TOPLEFT", -ins, ins)
                castbar.mUIBorder:SetPoint("BOTTOMRIGHT", castbar.Icon, "BOTTOMRIGHT", ins, -ins)
            end
        })

        castbar.mUIBorder:SetVertexColor(unpack(mUI:Color(0.25)))

        Theme.castbarIcons[castbar] = true
    end
end

function Theme:InitCastbarIcons()
    for unit, castbar in pairs(Theme.castbars) do
        Theme:CreateCastbarIcons(unit, _G[castbar])
    end
end
