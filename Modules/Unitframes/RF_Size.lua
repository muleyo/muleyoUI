local RF_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size", "AceHook-3.0")

function RF_Size:OnInitialize()
    -- Load Database
    RF_Size.db = mUI.db.profile.unitframes.raidframes.size

    if mUI:IsClassic() then
        function RF_Size:Update(frame)
            if InCombatLockdown() then return end
            if IsInRaid() then return end
            if not IsInGroup() then return end

            if not RF_Size.x or not RF_Size.y then
                if CompactPartyFrameMember1 then
                    RF_Size.x, RF_Size.y = CompactPartyFrameMember1:GetSize()
                elseif CompactRaidFrame1 then
                    RF_Size.x, RF_Size.y = CompactRaidFrame1:GetSize()
                end
            end

            if frame and RF_Size.db.enabled then
                local name = frame:GetName()
                if name and (name:match("^Compact")) then
                    C_Timer.After(0.1, function()
                        if frame.unit:match("pet") then
                            frame:SetWidth(RF_Size.db.width)
                        else
                            frame:SetSize(RF_Size.db.width, RF_Size.db.height)
                        end

                        CompactRaidFrameContainer_TryUpdate(CompactRaidFrameContainer)
                    end)
                end
            elseif frame and (not RF_Size.db.enabled) then
                if frame then
                    frame:SetSize(RF_Size.x, RF_Size.y)
                end
                return
            elseif CompactPartyFrameMember1 or CompactRaidFrame1 then
                for i = 1, 10 do
                    local cparty = _G["CompactPartyFrameMember" .. i]
                    local craid = _G["CompactRaidFrame" .. i]

                    if cparty then
                        CompactUnitFrame_UpdateAll(cparty)
                    elseif craid then
                        CompactUnitFrame_UpdateAll(craid)
                    end
                end
            end
        end
    else
        -- Backup original function
        RF_Size.backup = CompactPartyFrameMember1.SetSize

        function RF_Size:Update(x, y)
            if InCombatLockdown() then return end
            for i = 1, 5 do
                local member = _G["CompactPartyFrameMember" .. i]
                local pet = _G["CompactPartyFramePet" .. i]
                member.SetSize = RF_Size.backup
                pet.SetSize = RF_Size.backup

                if x and y then
                    member:SetSize(x, y)
                    pet:SetWidth(x)
                else
                    member:SetSize(RF_Size.db.width, RF_Size.db.height)
                    pet:SetWidth(RF_Size.db.width)
                end
                member.SetSize = function() end
                pet.SetSize = function()
                end
            end
        end
    end
end

function RF_Size:OnEnable()
    if mUI:IsClassic() then
        RF_Size:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
            RF_Size:Update(frame)
        end)
        RF_Size:Update()
    else
        RF_Size.x, RF_Size.y = CompactPartyFrameMember1:GetSize()
        RF_Size:Update()
    end
end

function RF_Size:OnDisable()
    if mUI:IsClassic() then
        RF_Size:Update()
        RF_Size:UnhookAll()
    else
        RF_Size:Update(RF_Size.x, RF_Size.y)

        for i = 1, 5 do
            local member = _G["CompactPartyFrameMember" .. i]
            local pet = _G["CompactPartyFramePet" .. i]
            member.SetSize = RF_Size.backup
            pet.SetSize = RF_Size.backup
        end
    end
end
