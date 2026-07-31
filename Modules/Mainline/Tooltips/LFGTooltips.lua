local LFGTooltips = mUI:NewModule("mUI.Tooltips.LFGTooltips", "AceHook-3.0", "AceHook-3.0")

function LFGTooltips:OnInitialize()
    LFGTooltips.db = mUI.db.profile.tooltips
end

function LFGTooltips:OnEnable()
    -- Hide the cover frame that blocks mouse interaction for non-leaders
    if LFGListFrame and LFGListFrame.ApplicationViewer and LFGListFrame.ApplicationViewer.UnempoweredCover then
        LFGTooltips.unempoweredCover = LFGListFrame.ApplicationViewer.UnempoweredCover
        securecallfunction(LFGTooltips.unempoweredCover.EnableMouse, LFGTooltips.unempoweredCover, false)
    end

    -- Hook applicant member frames so non-leaders can read notes
    if not LFGTooltips:IsHooked("LFGListApplicationViewer_UpdateResults") then
        LFGTooltips:SecureHook("LFGListApplicationViewer_UpdateResults", function(self)
            local buttons = self.ScrollBox and self.ScrollBox:GetFrames()
            if buttons then
                for _, button in ipairs(buttons) do
                    LFGTooltips:HookApplicantEntry(button)
                end
            end
        end)
    end
end

function LFGTooltips:HookApplicantEntry(button)
    if not button then
        return
    end

    if button.Members then
        for _, member in pairs(button.Members) do
            if not LFGTooltips:IsHooked(member, "OnEnter") then
                LFGTooltips:SecureHookScript(member, "OnEnter", function(self)
                    local parent = self:GetParent()
                    if not parent or not parent.applicantID then
                        return
                    end

                    local memberIdx = self.memberIdx or 1
                    local name, classStr, localizedClass, _, itemLevel, _, tank, healer, damage, _, _, dungeonScore, _, _, _, specID =
                        securecallfunction(C_LFGList.GetApplicantMemberInfo, parent.applicantID, memberIdx)

                    if not name then
                        return
                    end

                    itemLevel = tonumber(itemLevel) or 0
                    dungeonScore = tonumber(dungeonScore) or 0

                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    local classColor = C_ClassColor.GetClassColor(classStr)
                    if classColor then
                        GameTooltip:SetText(name, classColor.r, classColor.g, classColor.b)
                    else
                        GameTooltip:SetText(name, 1, 1, 1)
                    end

                    local cr, cg, cb = 1, 1, 1
                    if classColor then
                        cr, cg, cb = classColor.r, classColor.g, classColor.b
                    end

                    if specID and specID > 0 then
                        local _, specName = GetSpecializationInfoByID(specID)
                        if specName then
                            local hex = string.format("|cff%02x%02x%02x", cr * 255, cg * 255, cb * 255)
                            GameTooltip:AddLine("Spec: " .. hex .. specName .. "|r", 1, 1, 1)
                        end
                    end

                    if itemLevel and itemLevel > 0 then
                        local hex = string.format("|cff%02x%02x%02x", cr * 255, cg * 255, cb * 255)
                        GameTooltip:AddLine("iLvl: " .. hex .. math.floor(itemLevel) .. "|r", 1, 1, 1)
                    end

                    if dungeonScore and dungeonScore > 0 then
                        local r, g, b = 1, 1, 1
                        if C_ChallengeMode and C_ChallengeMode.GetDungeonScoreRarityColor then
                            local color = C_ChallengeMode.GetDungeonScoreRarityColor(dungeonScore)
                            if color then
                                r, g, b = color.r, color.g, color.b
                            end
                        end
                        GameTooltip:AddLine("M+ Rating: " .. dungeonScore, r, g, b)
                    end

                    -- Show applicant note (use securecallfunction to avoid tainting the cached applicant table)
                    local comment = securecallfunction(function(id)
                        local info = C_LFGList.GetApplicantInfo(id)
                        return info and info.comment
                    end, parent.applicantID)
                    if comment and comment ~= "" then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine('"' .. comment .. '"', 1, 1, 1, true)
                    end

                    GameTooltip:Show()
                end)
            end
        end
    end
end

function LFGTooltips:OnDisable()
    -- Re-enable the cover frame for non-leaders
    if LFGTooltips.unempoweredCover then
        securecallfunction(LFGTooltips.unempoweredCover.EnableMouse, LFGTooltips.unempoweredCover, true)
    end
    LFGTooltips:UnhookAll()
end
