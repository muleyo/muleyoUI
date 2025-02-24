local Sell = mUI:NewModule("mUI.Modules.General.Sell", "AceHook-3.0")

function Sell:OnInitialize()
    Sell.sell = CreateFrame("Frame")

    function Sell:Update(event)
        if not event == "MERCHANT_SHOW" then return end

        local bag, slot
        for bag = 0, 4 do
            for slot = 0, C_Container.GetContainerNumSlots(bag) do
                local link = C_Container.GetContainerItemLink(bag, slot)
                if link and (select(3, C_Item.GetItemInfo(link)) == 0) then
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end
end

function Sell:OnEnable()
    Sell.sell:RegisterEvent("MERCHANT_SHOW")
    Sell:HookScript(Sell.sell, "OnEvent", function(_, event)
        Sell:Update(event)
    end)
end

function Sell:OnDisable()
    Sell.sell:UnregisterEvent("MERCHANT_SHOW")
    Sell:UnhookAll()
end
