local Invite = mUI:NewModule("mUI.Modules.General.Invite")

function Invite:OnInitialize()
    -- Local variables
    local hideStatic

    self.invite = CreateFrame("Frame")
    function self:Invite(_, event, _, _, _, _, _, _, guid)
        if event == 'PARTY_INVITE_REQUEST' then
            if not guid or guid == '' or IsInGroup() then return end

            local queueButton = GetQueueStatusButton() -- don't auto accept during a queue
            if queueButton and queueButton:IsShown() then return end

            if BNGetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) or IsGuildMember(guid) then
                hideStatic = true
                AcceptGroup()
            end
        elseif event == 'GROUP_ROSTER_UPDATE' and hideStatic then
            if LFGInvitePopup then -- invited in custom created group
                StaticPopupSpecial_Hide(LFGInvitePopup)
            end

            StaticPopup_Hide('PARTY_INVITE')
            hideStatic = false
        end
    end
end

function Invite:OnEnable()
    self.invite:RegisterEvent("PARTY_INVITE_REQUEST")
    self.invite:RegisterEvent("GROUP_ROSTER_UPDATE")
    mUI:HookScript(self.invite, "OnEvent", function(_, event, _, _, _, _, _, _, guid)
        self:Invite(_, event, _, _, _, _, _, _, guid)
    end)
end

function Invite:OnDisable()
    self.invite:UnregisterAllEvents()
    mUI:Unhook(self.invite, "OnEvent")
end
