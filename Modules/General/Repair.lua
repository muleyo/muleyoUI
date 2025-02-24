local Repair = mUI:NewModule("mUI.Modules.General.Repair", "AceHook-3.0")

function Repair:OnInitialize()
    Repair.repair = CreateFrame("Frame")

    function Repair:Update(event)
        if not event == "MERCHANT_SHOW" then return end

        Repair.db = mUI.db.profile.general.automation
        if CanMerchantRepair() then
            local repairCost = GetRepairAllCost()
            if repairCost > 0 then
                local formattedCost = string.format("%.1fg", repairCost * 0.0001)
                if IsInGuild() and CanGuildBankRepair() and Repair.db.repair == "Guild" then
                    if (GetGuildBankWithdrawMoney() > 0) and (GetGuildBankWithdrawMoney() > GetGuildBankMoney()) and (GetGuildBankMoney() > repairCost) then
                        RepairAllItems(1)
                        mUI:Debug("|cffead000Repair cost covered by Guild Bank: " .. formattedCost .. "|r")
                    else
                        mUI:Debug("|cffead000Not enough gold in Guild Bank to cover the repair cost.|r")
                    end
                elseif Repair.db.repair == "Personal" then
                    local money = GetMoney()
                    if money > repairCost then
                        RepairAllItems()
                        mUI:Debug("|cffead000Repair cost: " .. formattedCost .. "|r")
                    else
                        mUI:Debug("cffead000Not enough gold to cover the repair cost.|r")
                    end
                end
            end
        end
    end
end

function Repair:OnEnable()
    Repair.repair:RegisterEvent("MERCHANT_SHOW")
    Repair:HookScript(Repair.repair, "OnEvent", function(_, event)
        Repair:Update(event)
    end)
end

function Repair:OnDisable()
    Repair.repair:UnregisterEvent("MERCHANT_SHOW")
    Repair:UnhookAll()
end
