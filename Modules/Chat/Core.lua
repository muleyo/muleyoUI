local Style = mUI:NewModule("mUI.Modules.Chat.Style", "AceHook-3.0")

function Style:OnInitialize()
	-- Load Database
	Style.db = mUI.db.profile.chat.settings
end

-- Lua
local _G = getfenv(0)
local error = _G.error
local ipairs = _G.ipairs
local m_floor = _G.math.floor
local next = _G.next
local pcall = _G.pcall
local s_format = _G.string.format
local t_insert = _G.table.insert
local type = _G.type

--------------------
-- TEXT PROCESSOR --
--------------------

do
	local TEXT_PROCESSORS = {
		-- function(text)
		-- 	return text
		-- end,
	}

	function Style:ProcessText(text)
		for _, processor in ipairs(TEXT_PROCESSORS) do
			local isOK, val = pcall(processor, text)
			if isOK then
				text = val
			end
		end

		return text
	end
end

------------
-- EVENTS --
------------

do
	local listeners = {}

	function Style:Subscribe(messageType, listener)
		if not listeners[messageType] then
			listeners[messageType] = {}
		end

		t_insert(listeners[messageType], listener)
	end

	function Style:Dispatch(messageType, payload)
		if not listeners[messageType] then return end

		for _, listener in ipairs(listeners[messageType]) do
			listener(payload)
		end
	end
end

do
	Style.oneTimeEvents = { ADDON_LOADED = false, PLAYER_LOGIN = false }
	Style.registeredEvents = {}

	Style.dispatcher = CreateFrame("Frame", "mUIEventFrame")

	function Style:RegisterEvent(event, func)
		if Style.oneTimeEvents[event] then
			error(s_format("Failed to register for '%s' event, already fired!", event), 3)
		end

		if not func or type(func) ~= "function" then
			error(s_format("Failed to register for '%s' event, no handler!", event), 3)
		end

		if not Style.registeredEvents[event] then
			Style.registeredEvents[event] = {}

			Style.dispatcher:RegisterEvent(event)
		end

		Style.registeredEvents[event][func] = true
	end

	function Style:UnregisterEvent(event, func)
		local funcs = Style.registeredEvents[event]

		if funcs and funcs[func] then
			funcs[func] = nil

			if not next(funcs) then
				Style.registeredEvents[event] = nil

				Style.dispatcher:UnregisterEvent(event)
			end
		end
	end

	function Style:EnableDispatcher()
		Style:HookScript(Style.dispatcher, "OnEvent", function(_, event, ...)
			for func in next, Style.registeredEvents[event] do
				func(...)
			end

			if Style.oneTimeEvents[event] == false then
				Style.oneTimeEvents[event] = true
			end
		end)
	end
end

-----------
-- UTILS --
-----------

do
	local hidden = CreateFrame("Frame", nil, UIParent)
	hidden:Hide()

	function Style:ForceHide(object, skipEvents)
		if not object then return end

		object:Hide(true)
		object:SetParent(hidden)

		if object.EnableMouse then
			object:EnableMouse(false)
		end

		if object.UnregisterAllEvents then
			if not skipEvents then
				object:UnregisterAllEvents()
			end

			if object:GetName() then
				object.ignoreFramePositionManager = true
				object:SetAttribute("ignoreFramePositionManager", true)
			end

			object:SetAttribute("statehidden", true)
		end

		if object.SetUserPlaced then
			pcall(object.SetUserPlaced, object, true)
			pcall(object.SetDontSavePosition, object, true)
		end
	end
end

-----------
-- FADER --
-----------

do
	local function clamp(v)
		if v > 1 then
			return 1
		elseif v < 0 then
			return 0
		end

		return v
	end

	local function outCubic(t, b, c, d)
		t = t / d - 1
		return clamp(c * (t ^ 3 + 1) + b)
	end

	local FADE_IN = 1
	local FADE_OUT = -1

	local objects = {}
	local add, remove

	local updater = CreateFrame("Frame", "mUIFader")

	local function updater_OnUpdate(_, elapsed)
		for object, data in next, objects do
			data.fadeTimer = data.fadeTimer + elapsed
			if data.fadeTimer > 0 then
				data.initAlpha = data.initAlpha or object:GetAlpha()

				object:SetAlpha(outCubic(data.fadeTimer, data.initAlpha, data.finalAlpha - data.initAlpha,
					data.duration))

				if data.fadeTimer >= data.duration then
					remove(object)

					if data.callback then
						data.callback(object)
						data.callback = nil
					end

					object:SetAlpha(data.finalAlpha)
				end
			end
		end
	end

	function add(mode, object, delay, duration, callback)
		local initAlpha = object:GetAlpha()
		local finalAlpha = mode == FADE_IN and 1 or 0

		if delay == 0 and (duration == 0 or initAlpha == finalAlpha) then
			return callback and callback(object)
		end

		objects[object] = {
			mode = mode,
			fadeTimer = -delay,
			-- initAlpha = initAlpha,
			finalAlpha = finalAlpha,
			duration = duration,
			callback = callback
		}

		if not updater:GetScript("OnUpdate") then
			updater:SetScript("OnUpdate", updater_OnUpdate)
		end
	end

	function remove(object)
		objects[object] = nil

		if not next(objects) then
			updater:SetScript("OnUpdate", nil)
		end
	end

	function Style:FadeIn(object, duration, callback, delay)
		if not object then return end

		add(FADE_IN, object, delay or 0, duration * (1 - object:GetAlpha()), callback)
	end

	function Style:FadeOut(object, ...)
		if not object then return end

		add(FADE_OUT, object, ...)
	end

	function Style:StopFading(object, alpha)
		if not object then return end

		remove(object)

		object:SetAlpha(alpha or object:GetAlpha())
	end

	function Style:IsFading(object)
		local data = objects[object]
		if data then
			return data.mode
		end
	end
end

-------------
-- COLOURS --
-------------

do
	local color_proto = {}

	function color_proto:GetHex()
		return self.hex
	end

	-- override ColorMixin:GetRGBA
	function color_proto:GetRGBA(a)
		return self.r, self.g, self.b, a or self.a
	end

	-- override ColorMixin:SetRGBA
	function color_proto:SetRGBA(r, g, b, a)
		if r > 1 or g > 1 or b > 1 then
			r, g, b = r / 255, g / 255, b / 255
		end

		self.r = r
		self.g = g
		self.b = b
		self.a = a
		self.hex = s_format('ff%02x%02x%02x', self:GetRGBAsBytes())
	end

	-- override ColorMixin:WrapTextInColorCode
	function color_proto:WrapTextInColorCode(text)
		return "|c" .. self.hex .. text .. "|r"
	end

	function Style:CreateColor(r, g, b, a)
		local color = Mixin({}, ColorMixin, color_proto)
		color:SetRGBA(r, g, b, a)

		return color
	end
end

-----------
-- MATHS --
-----------

function Style:Round(v)
	return m_floor(v + 0.5)
end
