local Fontsize = mUI:NewModule("mUI.Modules.Actionbars.Fontsize", "AceHook-3.0")

function Fontsize:OnInitialize()
    -- Load Database
    Fontsize.db = {
        actionbars = mUI.db.profile.actionbars,
        general = mUI.db.profile.general
    }

    -- Tables
    Fontsize.Bars = {
        _G["MultiBarBottomLeft"],
        _G["MultiBarBottomRight"],
        _G["MultiBarRight"],
        _G["MultiBarLeft"],
        _G["MultiBarRight"],
        _G["MultiBar5"],
        _G["MultiBar6"],
        _G["MultiBar7"],
    }

    -- Functions
    function Fontsize:Update()
        for _, Bar in pairs(Fontsize.Bars) do
            for i = 1, 12 do
                local Button = _G[Bar:GetName() .. "Button" .. i]
                local Name = Button:GetName()
                local HotKey = _G[Name .. "HotKey"]
                local Count = _G[Name .. "Count"]

                if Fontsize.db.general.font ~= "None" then
                    HotKey:SetFont(Fontsize.db.general.fontpath, Fontsize.db.actionbars.fontsize, "OUTLINE")
                    --Count:SetFont(Fontsize.db.general.fontpath, Fontsize.db.actionbars.fontsize, "OUTLINE")
                else
                    HotKey:SetFont(STANDARD_TEXT_FONT, Fontsize.db.actionbars.fontsize, "OUTLINE")
                    --Count:SetFont(STANDARD_TEXT_FONT, Fontsize.db.actionbars.fontsize, "OUTLINE")
                end
            end
        end

        for i = 1, 12 do
            if Fontsize.db.general.font ~= "None" then
                _G["ActionButton" .. i .. "HotKey"]:SetFont(Fontsize.db.general.fontpath, Fontsize.db.actionbars
                    .fontsize, "OUTLINE")
                --[[_G["ActionButton" .. i .. "Count"]:SetFont(Fontsize.db.general.fontpath, Fontsize.db.actionbars
                    .fontsize, "OUTLINE")]]
            else
                _G["ActionButton" .. i .. "HotKey"]:SetFont(STANDARD_TEXT_FONT, Fontsize.db.actionbars.fontsize,
                    "OUTLINE")
                --[[_G["ActionButton" .. i .. "Count"]:SetFont(STANDARD_TEXT_FONT, Fontsize.db.actionbars.fontsize,
                    "OUTLINE")]]
            end
        end
    end
end

function Fontsize:OnEnable()
    Fontsize:Update()
end

function Fontsize:OnDisable()
    Fontsize:Update()
end
