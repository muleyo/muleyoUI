local Raidframes_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size")

function Raidframes_Size:OnInitialize()
    -- Load Database
    Raidframes_Size.db = mUI.db.profile.unitframes.raidframes.size

    -- Backup original function
    Raidframes_Size.backup = CompactPartyFrameMember1.SetSize

    function Raidframes_Size:Update(x, y)
        for i = 1, 5 do
            local member = _G["CompactPartyFrameMember" .. i]
            local pet = _G["CompactPartyFramePet" .. i]
            member.SetSize = Raidframes_Size.backup
            pet.SetSize = Raidframes_Size.backup

            if x and y then
                member:SetSize(x, y)
                pet:SetWidth(x)
            else
                member:SetSize(Raidframes_Size.db.width, Raidframes_Size.db.height)
                pet:SetWidth(Raidframes_Size.db.width)
            end
            member.SetSize = function() end
            pet.SetSize = function()
            end
        end
    end
end

function Raidframes_Size:OnEnable()
    Raidframes_Size.x, Raidframes_Size.y = CompactPartyFrameMember1:GetSize()
    Raidframes_Size:Update()
end

function Raidframes_Size:OnDisable()
    Raidframes_Size:Update(Raidframes_Size.x, Raidframes_Size.y)
end
