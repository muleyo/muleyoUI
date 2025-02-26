local Theme = mUI:GetModule("mUI.Modules.General.Theme")

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

Theme.castbarIcons = {}

function Theme:CreateCastbarIcons(castbar)
    if not castbar.mUIBorder then
        local icon = castbar.Icon
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetDrawLayer("BACKGROUND", -8)

        local Backdrop = {
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

        local border = CreateFrame("Frame", castbar.mUIBorder, castbar)
        border.texture = border:CreateTexture(castbar.mUIBorder, "BACKGROUND", nil, -7)
        border.texture:SetTexture("Interface\\Addons\\mUI\\Media\\Textures\\Core\\gloss")
        border.texture:SetTexCoord(0, 1, 0, 1)
        border.texture:SetDrawLayer("BACKGROUND", -7)
        border.texture:ClearAllPoints()
        border.texture:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
        border.texture:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
        border.texture:SetVertexColor(0.4, 0.35, 0.35)

        border.shadow = CreateFrame("Frame", nil, border, "BackdropTemplate")
        border.shadow:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 4)
        border.shadow:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -4)
        border.shadow:SetFrameLevel(border:GetFrameLevel() - 1)
        border.shadow:SetBackdrop(Backdrop)
        border.shadow:SetBackdropBorderColor(unpack(mUI:Color(0.15)))

        castbar.mUIBorder = border

        Theme.castbarIcons[castbar] = true
    end
end

function Theme:InitCastbarIcons()
    for _, castbar in pairs(Theme.castbars) do
        Theme:CreateCastbarIcons(_G[castbar])
    end
end
