local RF_Mouseover = mUI:NewModule("mUI.Modules.Unitframes.Raidframes_Mouseover", "AceHook-3.0")

function RF_Mouseover:OnInitialize()
    -- Load Database
    RF_Mouseover.db = mUI.db.profile.unitframes.raidframes

    -- Tables
    RF_Mouseover.frames = {"PartyFrameMember1", "PartyFrameMember2", "PartyFrameMember3", "PartyFrameMember4", "PartyFrameMember5", "PartyFramePet1",
                           "PartyFramePet2", "PartyFramePet3", "PartyFramePet4", "PartyFramePet5", "RaidFrame1", "RaidFrame2", "RaidFrame3",
                           "RaidFrame4", "RaidFrame5", "RaidFrame6", "RaidFrame7", "RaidFrame8", "RaidFrame9", "RaidFrame10", "RaidFrame11",
                           "RaidFrame12", "RaidFrame13", "RaidFrame14", "RaidFrame15", "RaidFrame16", "RaidFrame17", "RaidFrame18", "RaidFrame19",
                           "RaidFrame20", "RaidFrame21", "RaidFrame22", "RaidFrame23", "RaidFrame24", "RaidFrame25", "RaidFrame26", "RaidFrame27",
                           "RaidFrame28", "RaidFrame29", "RaidFrame30", "RaidFrame31", "RaidFrame32", "RaidFrame33", "RaidFrame34", "RaidFrame35",
                           "RaidFrame36", "RaidFrame37", "RaidFrame38", "RaidFrame39", "RaidFrame40", "RaidGroup1Member1", "RaidGroup1Member2",
                           "RaidGroup1Member3", "RaidGroup1Member4", "RaidGroup1Member5", "RaidGroup2Member1", "RaidGroup2Member2",
                           "RaidGroup2Member3", "RaidGroup2Member4", "RaidGroup2Member5", "RaidGroup3Member1", "RaidGroup3Member2",
                           "RaidGroup3Member3", "RaidGroup3Member4", "RaidGroup3Member5", "RaidGroup4Member1", "RaidGroup4Member2",
                           "RaidGroup4Member3", "RaidGroup4Member4", "RaidGroup4Member5", "RaidGroup5Member1", "RaidGroup5Member2",
                           "RaidGroup5Member3", "RaidGroup5Member4", "RaidGroup5Member5", "RaidGroup6Member1", "RaidGroup6Member2",
                           "RaidGroup6Member3", "RaidGroup6Member4", "RaidGroup6Member5", "RaidGroup7Member1", "RaidGroup7Member2",
                           "RaidGroup7Member3", "RaidGroup7Member4", "RaidGroup7Member5", "RaidGroup8Member1", "RaidGroup8Member2",
                           "RaidGroup8Member3", "RaidGroup8Member4", "RaidGroup8Member5"}

    function RF_Mouseover:SetHighlight(frame)
        if (not frame) or frame:IsForbidden() then
            return
        end

        local name = frame:GetName()
        if not name or not name:match("^Compact") then
            return
        end

        if not frame.mUIMouseoverHighlight then
            local highlight = frame:CreateTexture(nil, "OVERLAY", nil, 7)
            highlight:SetAllPoints(frame)
            highlight:SetTexture([[Interface\AddOns\mUI\Media\Textures\Raidframes\border.png]])
            highlight:SetVertexColor(1, 1, 1, 0.5)
            highlight:Hide()
            frame.mUIMouseoverHighlight = highlight
        end

        if frame.mUIMouseoverHooked then
            return
        end
        frame.mUIMouseoverHooked = true

        RF_Mouseover:SecureHookScript(frame, "OnEnter", function(self)
            self.mUIMouseoverHighlight:Show()
        end)
        RF_Mouseover:SecureHookScript(frame, "OnLeave", function(self)
            self.mUIMouseoverHighlight:Hide()
        end)
    end

    function RF_Mouseover:Update()
        for _, frame in pairs(RF_Mouseover.frames) do
            if _G["Compact" .. frame] then
                RF_Mouseover:SetHighlight(_G["Compact" .. frame])
            end
        end
    end

    function RF_Mouseover:Restore()
        for _, name in pairs(RF_Mouseover.frames) do
            local frame = _G["Compact" .. name]
            if frame then
                if frame.mUIMouseoverHighlight then
                    frame.mUIMouseoverHighlight:Hide()
                end
                frame.mUIMouseoverHooked = nil
            end
        end
    end
end

function RF_Mouseover:OnEnable()
    RF_Mouseover:SecureHook("CompactUnitFrame_UpdateHealthColor", function(frame)
        RF_Mouseover:SetHighlight(frame)
    end)

    RF_Mouseover:Update()
end

function RF_Mouseover:OnDisable()
    RF_Mouseover:UnhookAll()
    RF_Mouseover:Restore()
end
