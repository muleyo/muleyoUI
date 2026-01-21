local Macro = mUI:NewModule("mUI.Modules.Actionbars.Macro")

function Macro:OnInitialize()
<<<<<<< HEAD:Modules/Mainline/Actionbars/Macro.lua
    Macro.bars = {
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
=======
    if mUI:IsClassic() then
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
    else
        Macro.bars = {
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
>>>>>>> 8199b4fe021e285074e487a7441bb1879e1fed59:Modules/Actionbars/Macro.lua

    function Macro:Update(isEnabled)
        local numButtons
        local macro
        for name, bar in pairs(Macro.bars) do
            if bar then
                numButtons = bar.numButtonsShowable

                for i = 1, numButtons do
<<<<<<< HEAD:Modules/Mainline/Actionbars/Macro.lua
                    if name == "MainActionBar" then
=======
                    if name == "MainActionBar" or name == "MainMenuBar" then
>>>>>>> 8199b4fe021e285074e487a7441bb1879e1fed59:Modules/Actionbars/Macro.lua
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
