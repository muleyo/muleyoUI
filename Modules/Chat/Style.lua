local Style = mUI:GetModule("mUI.Modules.Chat.Style")

function Style:OnEnable()
	-- Load Database
	Style.db = mUI.db.profile.chat

	-- Create Fonts
	Style:CreateFonts()

	-- Handle Dock
	Style:HandleDock(GeneralDockManager)

	local chatFrames = {}
	local tempChatFrames = {}
	local expectedChatFrames = {}

	-- static chat frames
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = Style:HandleChatFrame(_G["ChatFrame" .. i], i)
		if frame then
			chatFrames[frame] = true
		end

		Style:HandleChatTab(_G["ChatFrame" .. i .. "Tab"])
		Style:HandleEditBox(_G["ChatFrame" .. i .. "EditBox"])
		Style:HandleMinimizeButton(_G["ChatFrame" .. i .. "ButtonFrameMinimizeButton"], _G
			["ChatFrame" .. i .. "Tab"])

		if i == 1 then
			Style:HandleQuickJoinToastButton(QuickJoinToastButton)
			Style:HandleChannelButton(ChatFrameChannelButton)
			Style:HandleMenuButton(ChatFrameMenuButton)
			Style:HandleTTSButton(TextToSpeechButton)
		end
	end

	-- temporary chat frames
	Style:SecureHook("FCF_SetTemporaryWindowType", function(chatFrame, chatType, chatTarget)
		if not expectedChatFrames[chatType] then
			expectedChatFrames[chatType] = {}
		end

		-- the PET_BATTLE_COMBAT_LOG chatType doesn't have chatTarget
		if chatTarget then
			expectedChatFrames[chatType][chatTarget] = chatFrame
		else
			expectedChatFrames[chatType] = chatFrame
		end
	end)

	Style:SecureHook("FCF_OpenTemporaryWindow", function(chatType, chatTarget)
		local chatFrame = chatTarget and
			(expectedChatFrames[chatType] and expectedChatFrames[chatType][chatTarget]) or
			expectedChatFrames[chatType]
		if chatFrame then
			local frame = Style:HandleChatFrame(chatFrame, 1)
			if frame then
				Style:HandleChatTab(_G[chatFrame:GetName() .. "Tab"])
				Style:HandleEditBox(_G[chatFrame:GetName() .. "EditBox"])
				Style:HandleMinimizeButton(_G[chatFrame:GetName() .. "ButtonFrameMinimizeButton"],
					_G[chatFrame:GetName() .. "Tab"])

				tempChatFrames[frame] = true
			end
		end
	end)

	Style:SecureHook("FCF_Close", function(chatFrame)
		local frame = Style:GetSlidingFrameForChatFrame(chatFrame)
		if tempChatFrames[frame] then
			frame:Release()

			tempChatFrames[frame] = nil
		end
	end)

	Style:SecureHook("FCF_MinimizeFrame", function(chatFrame)
		if chatFrame.minFrame then
			Style:HandleMinimizedTab(chatFrame.minFrame)
		end
	end)

	-- ? consider moving it elsewhere
	Style.updater = CreateFrame("Frame", "mUIUpdater", UIParent)
	Style:HookScript(Style.updater, "OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.01 then
			for frame in next, chatFrames do
				frame:OnFrame()
			end

			for frame in next, tempChatFrames do
				frame:OnFrame()
			end

			self.elapsed = 0
		end
	end)

	-- ? consider moving it elsewhere as well
	Style:RegisterEvent("GLOBAL_MOUSE_DOWN", function(button)
		if mUI.db.profile.chat.lsglass.chat.fade.enabled then
			if button == "LeftButton" and mUI.db.profile.chat.lsglass.chat.fade.click then
				for frame in next, chatFrames do
					if frame:IsShown() and frame:IsMouseOver() and not frame:IsMouseOverHyperlink() then
						if frame:IsScrolling() then
							frame:ResetFadingTimer()
						else
							frame:FadeInMessages()
						end
					end
				end

				for frame in next, tempChatFrames do
					if frame:IsShown() and frame:IsMouseOver() and not frame:IsMouseOverHyperlink() then
						if frame:IsScrolling() then
							frame:ResetFadingTimer()
						else
							frame:FadeInMessages()
						end
					end
				end
			end
		end
	end)

	Style:EnableDispatcher()
	Style:EnableDragHook()
	Style:EnableAlerts()
end

function Style:OnDisable()
	Style:UnhookAll()
end
