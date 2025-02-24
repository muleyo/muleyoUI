local Macro = mUI:NewModule("mUI.Modules.Actionbars.Macro")

function Macro:OnInitialize()
    Macro.bars = {
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

    function Macro:Update(isEnabled)
        local numButtons
        local macro
        for name, bar in pairs(Macro.bars) do
            if bar then
                numButtons = bar.numButtonsShowable
                for i = 1, numButtons do
                    if name == "MainMenuBar" then
                        macro = _G["ActionButton" .. i .. "Name"]
                    else
                        macro = _G[name .. "Button" .. i .. "Name"]
                    end

                    if macro then
                        if isEnabled then
                            macro:SetAlpha(0)
                        else
                            macro:SetAlpha(1)
                        end
                    end
                end
            end
        end
    end
end

function Macro:OnEnable()
    Macro:Update(true)
end

function Macro:OnDisable()
    Macro:Update(false)
end
