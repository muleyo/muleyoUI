local Hotkey = mUI:NewModule("mUI.Modules.Actionbars.Hotkey")

function Hotkey:OnInitialize()
    self.bars = {
        MainMenuBar = MainMenuBar,
        MultiBarBottomLeft = MultiBarBottomLeft,
        MultiBarBottomRight = MultiBarBottomRight,
        MultiBarLeft = MultiBarLeft,
        MultiBarRight = MultiBarRight,
        MultiBar5 = MultiBar5,
        MultiBar6 = MultiBar6,
        MultiBar7 = MultiBar7,
        PetActionBar = PetActionBar,
        StanceBar = StanceBar
    }

    function self:Update(isEnabled)
        local numButtons
        local hotkey
        for name, bar in pairs(self.bars) do
            if bar then
                numButtons = bar.numButtonsShowable
                for i = 1, numButtons do
                    if name == "MainMenuBar" then
                        hotkey = _G["ActionButton" .. i .. "HotKey"]
                    else
                        hotkey = _G[name .. "Button" .. i .. "HotKey"]
                    end

                    if hotkey then
                        if isEnabled then
                            hotkey:SetAlpha(0)
                        else
                            hotkey:SetAlpha(1)
                        end
                    end
                end
            end
        end
    end
end

function Hotkey:OnEnable()
    self:Update(true)
end

function Hotkey:OnDisable()
    self:Update(false)
end
