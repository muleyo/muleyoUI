local RF_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size", "AceHook-3.0")

function RF_Size:OnInitialize()
    -- Load Database
    RF_Size.db = mUI.db.profile.unitframes.raidframes.size

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

function RF_Size:OnEnable()
    RF_Size.x, RF_Size.y = CompactPartyFrameMember1:GetSize()
    RF_Size:Update()
end

function RF_Size:OnDisable()
    RF_Size:Update(RF_Size.x, RF_Size.y)

    for i = 1, 5 do
        local member = _G["CompactPartyFrameMember" .. i]
        local pet = _G["CompactPartyFramePet" .. i]
        member.SetSize = RF_Size.backup
        pet.SetSize = RF_Size.backup
    end
end
