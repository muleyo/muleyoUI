local RF_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size", "AceHook-3.0")

function RF_Size:OnInitialize()
    -- Load Database
    RF_Size.db = mUI.db.profile.unitframes.raidframes.size

    -- Backup original functions
    RF_Size.functions = {}

    function RF_Size:Update(frame)
        if InCombatLockdown() then
            return
        end
        if IsInRaid() then
            return
        end
        if not IsInGroup() then
            return
        end

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
end

function RF_Size:OnEnable()
    RF_Size:SecureHook("CompactUnitFrame_UpdateAll", function(frame)
        RF_Size:Update(frame)
    end)
    RF_Size:Update()
end

function RF_Size:OnDisable()
    RF_Size:Update()
    RF_Size:UnhookAll()
end
