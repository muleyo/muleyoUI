local RoleCheck = mUI:NewModule("mUI.Modules.General.RoleCheck", "AceHook-3.0")

function RoleCheck:OnInitialize()
    function RoleCheck:Accept()
        LFDRoleCheckPopupAcceptButton:Click()
    end
end

function RoleCheck:OnEnable()
    RoleCheck:SecureHookScript(LFDRoleCheckPopupAcceptButton, "OnShow", RoleCheck.Accept)
end

function RoleCheck:OnDisable()
    RoleCheck:UnhookAll()
end
