local Dragonflying = mUI:NewModule("mUI.Modules.Misc.Dragonflying", "AceHook-3.0")

function Dragonflying:OnInitialize()
    Dragonflying.frame = CreateFrame("Frame")

    function Dragonflying:Update(show)
        for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
            for _, v in ipairs({ child:GetRegions() }) do
                if v:GetObjectType() == "Texture" then
                    if show then
                        v:Show()
                    else
                        v:Hide()
                    end
                end
            end
        end
    end
end

function Dragonflying:OnEnable()
    Dragonflying.frame:RegisterEvent("UPDATE_UI_WIDGET")
    Dragonflying:HookScript(Dragonflying.frame, "OnEvent", function()
        Dragonflying:Update()
    end)
end

function Dragonflying:OnDisable()
    Dragonflying:Update(true)
    Dragonflying:UnhookAll()
end
