local Invite = mUI:NewModule("mUI.Modules.General.Invite", "AceHook-3.0")

function Invite:OnInitialize()
    -- Local variables
    local hideStatic

    Invite.invite = CreateFrame("Frame")
    function Invite:Invite(_, event, _, _, _, _, _, _, guid)
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
    Invite.invite:RegisterEvent("PARTY_INVITE_REQUEST")
    Invite.invite:RegisterEvent("GROUP_ROSTER_UPDATE")
    Invite:HookScript(Invite.invite, "OnEvent", function(_, event, _, _, _, _, _, _, guid)
        Invite:Invite(_, event, _, _, _, _, _, _, guid)
    end)
end

function Invite:OnDisable()
    Invite.invite:UnregisterAllEvents()
    Invite:UnhookAll()
end
