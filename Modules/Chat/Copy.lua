local Copy = mUI:NewModule("mUI.Modules.Chat.Copy", "AceHook-3.0")

function Copy:OnInitialize()
    -- Create Frame
    Copy.frame = CreateFrame("Frame", "mUI_ChatCopyContainer", UIParent, "BackdropTemplate")
    Copy.frame:SetSize(600, 350)
    Copy.frame:SetPoint("CENTER", UIParent, "CENTER")
    Copy.frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeSize = 16,
        tile = true,
        tileSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    Copy.frame:SetBackdropColor(0, 0, 0)
    Copy.frame:Hide()

    -- Create Title
    Copy.title = Copy.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    Copy.title:SetPoint("TOP", Copy.frame, "TOP", 0, -8)
    Copy.title:SetTextColor(1, 1, 0)
    Copy.title:SetShadowOffset(1, -1)

    -- Create Close Button
    Copy.closeButton = CreateFrame("Button", nil, Copy.frame, "UIPanelCloseButton")
    Copy.closeButton:SetPoint("TOPRIGHT", 0, -1)

    -- Create Scrollbar
    Copy.scroll = CreateFrame("ScrollFrame", nil, Copy.frame, "UIPanelScrollFrameTemplate")
    Copy.scroll:SetPoint("TOPLEFT", 10, -30)
    Copy.scroll:SetPoint("BOTTOMRIGHT", -30, 10)

    Copy.editbox = CreateFrame("EditBox", nil, Copy.scroll)
    Copy.editbox:SetMultiLine(true)
    Copy.editbox:SetFontObject("ChatFontNormal")
    Copy.editbox:SetSize(Copy.frame:GetWidth() - 40, Copy.frame:GetHeight() - 60)
    Copy.editbox:SetAutoFocus(false)
    Copy.editbox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    Copy.scroll:SetScrollChild(Copy.editbox)
    Copy.editbox:SetScript("OnEscapePressed", function()
        Copy.frame:Hide()
    end)

    -- Create Button
    Copy.button = CreateFrame("Button", nil, UIParent) -- Set UIParent as the parent frame
    Copy.button:SetPoint("TOPLEFT", ChatFrame1, -27.5, 27.5)
    Copy.button:SetSize(20, 20)
    Copy.button:SetNormalTexture([[Interface\AddOns\mUI\Media\Textures\Chat\copynormal.png]])
    Copy.button:GetNormalTexture():SetSize(20, 20)
    Copy.button:SetHighlightTexture([[Interface\AddOns\mUI\Media\Textures\Chat\copyhighlight.png]])
    Copy.button:GetHighlightTexture():SetAllPoints(Copy.button:GetNormalTexture())
    Copy.button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(Copy.button, "ANCHOR_TOP")
        GameTooltip:SetText("Copy Chat Log")
        GameTooltip:Show()
    end)
    Copy.button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    function Copy:Chatlog()
        local chatFrame = SELECTED_DOCK_FRAME
        local chatHistory = ""
        for i = 1, chatFrame:GetNumMessages() do
            chatHistory = chatHistory .. chatFrame:GetMessageInfo(i) .. "\n"
        end
        Copy.editbox:SetText(chatHistory)
        Copy.title:SetText("Chat Log (" .. chatFrame.name .. ")")
        Copy.frame:Show()
    end
end

function Copy:OnEnable()
    Copy:RawHookScript(Copy.button, "OnClick", Copy.Chatlog)
end

function Copy:OnDisable()
    Copy:UnhookAll()
    Copy.frame:Hide()
    Copy.button:Hide()
end
