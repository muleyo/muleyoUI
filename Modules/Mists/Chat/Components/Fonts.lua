local Style = mUI:GetModule("mUI.Modules.Chat.Style")

-- Lua
local _G = getfenv(0)


local LSM = LibStub("LibSharedMedia-3.0")

function Style:CreateFonts()
	for i = 1, 10 do
		local messageFont = CreateFont("mUIMessageFont" .. i)
		messageFont:CopyFontObject(ChatFontNormal)
		messageFont:SetFont(
			LSM:Fetch("font", mUI.db.profile.general.font),
			Style.db.chat.font.size,
			Style.db.chat.font.outline and "OUTLINE" or ""
		)

		local mFont = messageFont:GetFont()
		if not mFont then
			-- a corrupt, missing, or misplaced font was supplied, reset it
			messageFont:SetFont(
				"Fonts\\ARIALN.TTF",
				Style.db.chat.font.size,
				Style.db.chat.font.outline and "OUTLINE" or ""
			)
		end

		messageFont:SetShadowColor(0, 0, 0, 1)

		if Style.db.chat.font.shadow then
			messageFont:SetShadowOffset(1, -1)
		else
			messageFont:SetShadowOffset(0, 0)
		end

		messageFont:SetJustifyH("LEFT")
		messageFont:SetJustifyV("MIDDLE")
	end

	local editBoxFont = CreateFont("mUIEditBoxFont")
	editBoxFont:CopyFontObject(GameFontNormalSmall)
	editBoxFont:SetFont(
		LSM:Fetch("font", mUI.db.profile.general.font),
		Style.db.edit.font.size,
		Style.db.edit.font.outline and "OUTLINE" or ""
	)

	local ebFont = editBoxFont:GetFont()
	if not ebFont then
		editBoxFont:SetFont(
			"Fonts\\ARIALN.TTF",
			Style.db.edit.font.size,
			Style.db.edit.font.outline and "OUTLINE" or ""
		)
	end

	editBoxFont:SetShadowColor(0, 0, 0, 1)

	if Style.db.edit.font.shadow then
		editBoxFont:SetShadowOffset(1, -1)
	else
		editBoxFont:SetShadowOffset(0, 0)
	end

	editBoxFont:SetJustifyH("LEFT")
	editBoxFont:SetJustifyV("MIDDLE")
end

function Style:UpdateMessageFont(id)
	local messageFont = _G["mUIMessageFont" .. id]
	messageFont:SetFont(
		LSM:Fetch("font", mUI.db.profile.general.font),
		Style.db.chat.font.size,
		Style.db.chat.font.outline and "OUTLINE" or ""
	)

	local font = messageFont:GetFont()
	if not font then
		-- a corrupt, missing, or misplaced font was supplied, reset it
		messageFont:SetFont(
			"Fonts\\ARIALN.TTF",
			Style.db.chat.font.size,
			Style.db.chat.font.outline and "OUTLINE" or ""
		)
	end

	if Style.db.chat.font.shadow then
		messageFont:SetShadowOffset(1, -1)
	else
		messageFont:SetShadowOffset(0, 0)
	end

	messageFont:SetJustifyH("LEFT")
	messageFont:SetJustifyV("MIDDLE")
end

function Style:UpdateMessageFonts()
	for i = 1, 10 do
		self:UpdateMessageFont(i)
	end
end

function Style:UpdateEditBoxFont()
	mUIEditBoxFont:SetFont(
		LSM:Fetch("font", mUI.db.profile.general.font),
		Style.db.edit.font.size,
		Style.db.edit.font.outline and "OUTLINE" or ""
	)

	local font = mUIEditBoxFont:GetFont()
	if not font then
		mUIEditBoxFont:SetFont(
			"Fonts\\ARIALN.TTF",
			Style.db.edit.font.size,
			Style.db.edit.font.outline and "OUTLINE" or ""
		)
	end

	if Style.db.edit.font.shadow then
		mUIEditBoxFont:SetShadowOffset(1, -1)
	else
		mUIEditBoxFont:SetShadowOffset(0, 0)
	end

	mUIEditBoxFont:SetJustifyH("LEFT")
	mUIEditBoxFont:SetJustifyV("MIDDLE")
end
