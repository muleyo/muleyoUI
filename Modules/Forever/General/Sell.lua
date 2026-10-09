local Sell = mUI:NewModule("mUI.Modules.General.Sell", "AceHook-3.0")

function Sell:OnInitialize()
    Sell.sell = CreateFrame("Frame")

    function Sell:Update(event)
        if event == "MERCHANT_CLOSED" then
            Sell.queue = nil
            return
        end
        if event ~= "MERCHANT_SHOW" then
            return
        end

        local queue = {}
        for bag = 0, (NUM_TOTAL_EQUIPPED_BAG_SLOTS or 5) do
            for slot = 1, C_Container.GetContainerNumSlots(bag) do
                local info = C_Container.GetContainerItemInfo(bag, slot)
                if info and info.quality == Enum.ItemQuality.Poor and not info.hasNoValue then
                    queue[#queue + 1] = { bag = bag, slot = slot }
                end
            end
        end

        Sell.queue = queue
        local function sellNext()
            if Sell.queue ~= queue then return end
            local item = table.remove(queue, 1)
            if not item then return end
            C_Container.UseContainerItem(item.bag, item.slot)
            C_Timer.After(0.15, sellNext)
        end
        sellNext()
    end
end

function Sell:OnEnable()
    Sell.sell:RegisterEvent("MERCHANT_SHOW")
    Sell.sell:RegisterEvent("MERCHANT_CLOSED")
    Sell:SecureHookScript(Sell.sell, "OnEvent", function(_, event)
        Sell:Update(event)
    end)
end

function Sell:OnDisable()
    Sell.sell:UnregisterEvent("MERCHANT_SHOW")
    Sell.sell:UnregisterEvent("MERCHANT_CLOSED")
    Sell:UnhookAll()
end
