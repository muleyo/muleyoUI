local RF_Size = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Size", "AceHook-3.0")

function RF_Size:OnInitialize()
    -- Load Database
    RF_Size.db = mUI.db.profile.unitframes.raidframes.size

    -- Backup original functions
    RF_Size.functions = {}

    function RF_Size:UpdateFunctions()
        for _, memberFrame in ipairs(CompactPartyFrame.memberUnitFrames) do
            if memberFrame then
                -- Store original SetSize function
                memberFrame.originalSetSize = memberFrame.SetSize

                -- Replace SetSize
                memberFrame.SetSize = function(self, width, height)
                    if InCombatLockdown() then
                        return
                    end
                    self.originalSetSize(self, RF_Size.db.width, RF_Size.db.height)
                end
            end
        end

        for _, petFrame in ipairs(CompactPartyFrame.petUnitFrames) do
            if petFrame then
                -- Store original SetSize function
                petFrame.originalSetSize = petFrame.SetSize

                -- Replace SetSize
                petFrame.SetSize = function(self, width, height)
                    if InCombatLockdown() then
                        return
                    end
                    self.originalSetSize(self, RF_Size.db.width, height)
                end
            end
        end
    end

    function RF_Size:Update(x, y)
        if InCombatLockdown() then
            return
        end
        for i = 1, 5 do
            local member = _G["CompactPartyFrameMember" .. i]
            local pet = _G["CompactPartyFramePet" .. i]

            if x and y then
                member:SetSize(x, y)
                pet:SetWidth(x)
            else
                member:SetSize(RF_Size.db.width, RF_Size.db.height)
                pet:SetWidth(RF_Size.db.width)
            end
        end
    end
end

function RF_Size:OnEnable()
    RF_Size.x, RF_Size.y = CompactPartyFrameMember1:GetSize()
    RF_Size:UpdateFunctions()
    RF_Size:Update()
end

function RF_Size:OnDisable()
    for i = 1, 5 do
        local member = _G["CompactPartyFrameMember" .. i]
        local pet = _G["CompactPartyFramePet" .. i]
        member.SetSize = member.originalSetSize
        pet.SetSize = pet.originalSetSize
    end

    RF_Size:Update(RF_Size.x, RF_Size.y)
end
