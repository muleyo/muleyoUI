local Hotkey = mUI:NewModule("mUI.Modules.Actionbars.Hotkey")

function Hotkey:OnInitialize()
    if mUI:IsClassic() then
        Hotkey.bars = {
            MainMenuBar = "MainMenuBar",
            MultiBarBottomLeft = "MultiBarBottomLeft",
            MultiBarBottomRight = "MultiBarBottomRight",
            MultiBarLeft = "MultiBarLeft",
            MultiBarRight = "MultiBarRight",
            MultiBar5 = "MultiBar5",
            MultiBar6 = "MultiBar6",
            MultiBar7 = "MultiBar7",
            PetActionBar = "PetActionBar",
            StanceBar = "StanceBar"
        }
    else
        Hotkey.bars = {
            MainActionBar = MainActionBar,
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
    end

    function Hotkey:Update(isEnabled)
        local numButtons
        local hotkey
        for name, bar in pairs(Hotkey.bars) do
            if bar then
                if mUI:IsClassic() then
                    numButtons = 12
                else
                    numButtons = bar.numButtonsShowable
                end

                for i = 1, numButtons do
                    if name == "MainActionBar" or name == "MainMenuBar" then
                        hotkey = _G["ActionButton" .. i .. "HotKey"]
                    elseif name == "PetActionBar" then
                        hotkey = _G["PetActionButton" .. i .. "HotKey"]
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
    Hotkey:Update(true)
end

function Hotkey:OnDisable()
    Hotkey:Update(false)
end
