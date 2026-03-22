local LFGTooltips = mUI:NewModule("mUI.Tooltips.LFGTooltips", "AceHook-3.0")

function LFGTooltips:OnInitialize()
    LFGTooltips.db = mUI.db.profile.tooltips
end

function LFGTooltips:OnEnable()
    if not LFGTooltips.hooked then
        -- Hide the cover frame that blocks mouse interaction for non-leaders
        if LFGListFrame and LFGListFrame.ApplicationViewer and LFGListFrame.ApplicationViewer.UnempoweredCover then
            LFGTooltips.unempoweredCover = LFGListFrame.ApplicationViewer.UnempoweredCover
            LFGTooltips.unempoweredCover:EnableMouse(false)
        end

        -- Hook applicant member frames so non-leaders can read notes
        hooksecurefunc("LFGListApplicationViewer_UpdateResults", function(self)
            local buttons = self.ScrollBox and self.ScrollBox:GetFrames()
            if buttons then
                for _, button in ipairs(buttons) do
                    LFGTooltips:HookApplicantEntry(button)
                end
            end
        end)

        LFGTooltips.hooked = true
    end
end

function LFGTooltips:HookApplicantEntry(button)
    if not button or button.mUIApplicantHooked then
        return
    end
    button.mUIApplicantHooked = true

    if button.Members then
        for _, member in pairs(button.Members) do
            if not member.mUITooltipHooked then
                member.mUITooltipHooked = true
                member:HookScript("OnEnter", function(self)
                    local parent = self:GetParent()
                    if not parent or not parent.applicantID then
                        return
                    end

                    local memberIdx = self.memberIdx or 1
                    local name, classStr, _, _, itemLevel, _, _, _, _, _, dungeonScore =
                        C_LFGList.GetApplicantMemberInfo(parent.applicantID, memberIdx)

                    if not name then
                        return
                    end

                    itemLevel = tonumber(itemLevel) or 0
                    dungeonScore = tonumber(dungeonScore) or 0

                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    local classColor = RAID_CLASS_COLORS[classStr]
                    if classColor then
                        GameTooltip:SetText(name, classColor.r, classColor.g, classColor.b)
                    else
                        GameTooltip:SetText(name, 1, 1, 1)
                    end

                    if itemLevel and itemLevel > 0 then
                        GameTooltip:AddDoubleLine("Item Level", math.floor(itemLevel), 0.5, 0.5, 0.5, 1, 1, 1)
                    end

                    if dungeonScore and dungeonScore > 0 then
                        local r, g, b = 1, 1, 1
                        if C_ChallengeMode and C_ChallengeMode.GetDungeonScoreRarityColor then
                            local color = C_ChallengeMode.GetDungeonScoreRarityColor(dungeonScore)
                            if color then
                                r, g, b = color.r, color.g, color.b
                            end
                        end
                        GameTooltip:AddDoubleLine("M+ Rating", dungeonScore, 0.5, 0.5, 0.5, r, g, b)
                    end

                    -- Show applicant note
                    local applicantInfo = C_LFGList.GetApplicantInfo(parent.applicantID)
                    if applicantInfo and applicantInfo.comment and applicantInfo.comment ~= "" then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("Note:", 1, 0.82, 0)
                        GameTooltip:AddLine(applicantInfo.comment, 1, 1, 1, true)
                    end

                    GameTooltip:Show()
                end)

                member:HookScript("OnLeave", function()
                    GameTooltip:Hide()
                end)
            end
        end
    end
end

function LFGTooltips:OnDisable()
    -- Re-enable the cover frame for non-leaders
    if LFGTooltips.unempoweredCover then
        LFGTooltips.unempoweredCover:EnableMouse(true)
    end
    LFGTooltips:UnhookAll()
end
