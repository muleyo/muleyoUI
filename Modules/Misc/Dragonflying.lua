local Dragonflying = mUI:NewModule("mUI.Modules.Misc.Dragonflying", "AceHook-3.0")

function Dragonflying:OnInitialize()
    Dragonflying.frame = CreateFrame("Frame")

    function Dragonflying:Update()
        for _, child in ipairs({ UIWidgetPowerBarContainerFrame:GetChildren() }) do
            for _, v in ipairs({ child:GetRegions() }) do
                if v:GetObjectType() == "Texture" then
                    v:SetAlpha(0)
                end
            end
        end
    end
end

function Dragonflying:OnEnable()
    Dragonflying.frame:RegisterEvent("UPDATE_UI_WIDGET")
    Dragonflying:HookScript(Dragonflying.frame, "OnEvent", Dragonflying.Update)
end

function Dragonflying:OnDisable()
    Dragonflying:UnhookAll()
end
