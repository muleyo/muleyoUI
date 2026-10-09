local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Style Tooltips
Theme.backdrop = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    bgColor = {0.03, 0.03, 0.03, 0.9},
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor = {0.1, 0.1, 0.1, 0.9},
    azeriteBorderColor = {1, 0.3, 0, 0.9},
    tile = false,
    tileEdge = false,
    tileSize = 16,
    edgeSize = 16,
    insets = {
        left = 3,
        right = 3,
        top = 3,
        bottom = 3
    }
}

Theme.tooltips = {GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, WorldMapTooltip,
                  WorldMapCompareTooltip1, WorldMapCompareTooltip2, ConquestTooltip}

function Theme:StyleTooltip(frame)
    if not frame then
        return
    end

    mUI:AddMixin(frame)

    if Theme.db.theme == "Disabled" then
        if frame.NineSlice and frame.NineSlice.SetBorderColor then
            pcall(frame.NineSlice.SetBorderColor, frame.NineSlice, 1, 1, 1, 1)
        end
        return
    end

    local ok = pcall(frame.SetBackdrop, frame, Theme.backdrop)
    if not ok then
        return
    end
    frame:SetBackdropBorderColor(0.1, 0.1, 0.1, 0)
    frame:SetBackdropColor(unpack(Theme.backdrop.bgColor))

    if frame.NineSlice and frame.NineSlice.SetBorderColor then
        if Theme.db.theme == "Dark" then
            pcall(frame.NineSlice.SetBorderColor, frame.NineSlice, unpack(Theme.backdrop.borderColor))
        else
            pcall(frame.NineSlice.SetBorderColor, frame.NineSlice, unpack(mUI:Color(0.35, 1)))
        end
    end
end

function Theme:StyleAuraTooltip()
    if not (AuraContainerInbound and AuraContainerInbound.SetTooltipBackdrop) then
        return
    end

    local bg = Theme.backdrop
    if not bg then
        return
    end

    local borderColor
    if Theme.db.theme == "Default" then
        borderColor = CreateColor(1, 1, 1, 1)
    else
        borderColor = CreateColor(unpack(Theme.backdrop.borderColor))
    end

    AuraContainerInbound.SetTooltipBackdrop({
        backdropInfo = Theme.backdrop,
        centerColor = CreateColor(0.03, 0.03, 0.03, 0.95),
        borderColor = borderColor
    })
end
