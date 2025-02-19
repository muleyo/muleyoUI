local Repair = mUI:NewModule("mUI.Modules.General.Repair")

function Repair:OnInitialize()
    self.repair = CreateFrame("Frame")
    self.repair:SetScript("OnEvent", function(_, event)
        if not event == "MERCHANT_SHOW" then return end

        local db = mUI.db.profile.general.automation
        if CanMerchantRepair() then
            local repairCost = GetRepairAllCost()
            if repairCost > 0 then
                local formattedCost = string.format("%.1fg", repairCost * 0.0001)
                if IsInGuild() and CanGuildBankRepair() and db.repair == "Guild" then
                    if (GetGuildBankWithdrawMoney() > 0) and (GetGuildBankWithdrawMoney() > GetGuildBankMoney()) and (GetGuildBankMoney() > repairCost) then
                        RepairAllItems(1)
                        mUI:Debug("|cffead000Repair cost covered by Guild Bank: " .. formattedCost .. "|r")
                    else
                        mUI:Debug("|cffead000Not enough gold in Guild Bank to cover the repair cost.|r")
                    end
                elseif db.repair == "Personal" then
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
    end)

    function self:Update()
        self.repair:RegisterEvent("MERCHANT_SHOW")
    end
end

function Repair:OnEnable()
    self.repair:RegisterEvent("MERCHANT_SHOW")
end

function Repair:OnDisable()
    self.repair:UnregisterEvent("MERCHANT_SHOW")
end
