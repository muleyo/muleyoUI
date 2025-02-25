local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Style Tooltips
Theme.backdrop = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    bgColor = { 0.03, 0.03, 0.03, 0.9 },
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor = { 0.1, 0.1, 0.1, 0.9 },
    azeriteBorderColor = { 1, 0.3, 0, 0.9 },
    tile = false,
    tileEdge = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

Theme.tooltips = {
    GameTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2,
    ItemRefTooltip,
    ItemRefShoppingTooltip1,
    ItemRefShoppingTooltip2,
    WorldMapTooltip,
    WorldMapCompareTooltip1,
    WorldMapCompareTooltip2
}

function Theme:StyleTooltip(frame)
    if frame then
        mUI:AddMixin(frame)
        frame:SetBackdrop(Theme.backdrop)
        frame:SetBackdropBorderColor(0.1, 0.1, 0.1, 0)
        if Theme.db.theme == "Dark" then
            frame:SetBackdropColor(unpack(Theme.backdrop.bgColor))
        elseif Theme.db.theme == "Disabled" then
            frame:SetBackdrop(nil)
        else
            frame:SetBackdropColor(unpack(mUI:Color(0.3, 0.3)))
        end
        if frame.NineSlice then
            if Theme.db.theme == "Dark" then
                frame.NineSlice:SetBorderColor(unpack(Theme.backdrop.borderColor))
            elseif Theme.db.theme == "Disabled" then
                frame.NineSlice:SetBorderColor(1, 1, 1, 1)
            else
                frame.NineSlice:SetBorderColor(unpack(mUI:Color(0.35, 1)))
            end
        end
    end
end
