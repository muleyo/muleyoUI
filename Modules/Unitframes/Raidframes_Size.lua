local Raidframes_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size")

function Raidframes_Size:OnInitialize()
    -- Load Database
    Raidframes_Size.db = mUI.db.profile.unitframes.raidframes.size

    -- Backup original function
    Raidframes_Size.backup = CompactPartyFrameMember1.SetSize

    function Raidframes_Size:Update(x, y)
        for i = 1, 5 do
            local frame = _G["CompactPartyFrameMember" .. i]
            if frame then
                frame.SetSize = Raidframes_Size.backup

                if x and y then
                    frame:SetSize(x, y)
                else
                    frame:SetSize(Raidframes_Size.db.width, Raidframes_Size.db.height)
                end
                frame.SetSize = function() end
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
