local Theme = mUI:GetModule("mUI.Modules.General.Theme")

-- Style ActionButton
Theme.Bars = {
    _G["MultiBarBottomLeft"],
    _G["MultiBarBottomRight"],
    _G["MultiBarRight"],
    _G["MultiBarLeft"],
    _G["MultiBarRight"],
    _G["MultiBar5"],
    _G["MultiBar6"],
    _G["MultiBar7"],
}

function Theme:StyleButton(Button, Type)
    local Name = Button:GetName()
    local NormalTexture = _G[Name .. "NormalTexture"]
    local Icon = _G[Name .. "Icon"]
    local Cooldown = _G[Name .. "Cooldown"]

    Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    mUI:Skin({ NormalTexture }, true)

    if Type ~= "StanceOrPet" then
        Cooldown:ClearAllPoints()
        Cooldown:SetPoint("TOPLEFT", Button, "TOPLEFT", 2, -2.5)
        Cooldown:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT", -3, 3)
    end

    if C_AddOns.IsAddOnLoaded("Bartender4") then
        local ButtonWidth, ButtonHeight = Button:GetSize()
        Button:GetNormalTexture():SetSize(ButtonWidth + 2, ButtonHeight + 1)

        if Type ~= "Stance" and Type ~= "Pet" then
            Button:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
            Button:GetNormalTexture():SetSize(ButtonWidth + 6, ButtonHeight + 5)
        end
    end
end

function Theme:StyleAction(Bar, Num)
    for i = 1, Num do
        local Name = Bar:GetName()
        local Button = _G[Name .. "Button" .. i]

        Theme:StyleButton(Button, "Actionbar")
    end
end
