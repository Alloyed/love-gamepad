local data = require 'love-gamepad.data'

local gamepad = {}
local gamepad_mt = {__index = gamepad}

function gamepad.new_state()
	local state = {}
	for _, name in ipairs(data.buttons) do
		state[name] = false
	end
	for _, name in ipairs(data.axes) do
		state[name] = 0
	end
	return state
end


local guid = {
	["xinput"] = "xboxone",
	-- win
	["88880803000000000000504944564944"] = "ps3",
	["4c056802000000000000504944564944"] = "ps3",
	["25090500000000000000504944564944"] = "ps3",
	["4c05c405000000000000504944564944"] = "ps4",
	["36280100000000000000504944564944"] = "ouya",
	["4d6963726f736f66742050432d6a6f79"] = "ouya",
	-- osx
	["4c050000000000006802000000000000"] = "ps3",
	["4c05000000000000c405000000000000"] = "ps4",
	["5e040000000000008e02000000000000"] = "xbox360",
	-- linux
	["030000004c0500006802000011010000"] = "ps3",
	["030000004c050000c405000011010000"] = "ps4",
	["03000000de280000ff11000001000000"] = "valve",
	["030000005e0400008e02000014010000"] = "xbox360",
	["030000005e0400008e02000010010000"] = "xbox360",
	["030000005e0400001907000000010000"] = "xbox360",
	["030000005e0400009102000007010000"] = "xbox360",
	["050000004c050000c405000000010000"] = "ps4",
	["060000004c0500006802000000010000"] = "ps3",
	["05000000362800000100000002010000"] = "ouya",
	["05000000362800000100000003010000"] = "ouya",
	["030000005e040000d102000001010000"] = "xboxone",
	["050000007e0500003003000001000000"] = "wiiu",
}

local function guess_style(name)
	if name:find("360") then
		return "xbox360"
	elseif name:find("Pro Controller") then
		return "wiiu"
	elseif name:find("Playstaion") or name:find("Sony Computer Enter") then
		return "ps4"
	end
	return "xboxone"
end

function gamepad.new(name, guid)
	return setmetatable({
		state = gamepad.new_state(),
		name = name,
		guid = guid,
		style = guess_style(name)
	}, gamepad_mt)
end

function gamepad:getName()
	return self.name
end

function gamepad:getGUID()
	return self.guid
end

function gamepad:getStyle()
	return self.style
end

function gamepad:isDown(btn)
	local raw_btn = data.aliases[btn] or btn
	return self.state[raw_btn]
end

function gamepad:axis(axis)
	local raw_axis = data.aliases[axis] or axis
	return self.state[raw_axis]
end

local function len(x,y)
	return math.sqrt(x*x + y*y)
end

local function normalize(x,y)
	local l = len(x,y)
	if l > 1 then
		return x/l, y/l
	end
	return x,y
end

local function analog(up, down, left, right)
	local x = (right and 1 or 0) + (left and -1 or 0)
	local y = (down and 1 or 0)  + (up and -1 or 0)
	return normalize(x, y)
end

function gamepad:stick(s)
	local ax, ay = self:axis(s.."x"), self:axis(s.."y")
	local dx, dy = analog(self:isDown(s.."up"), self:isDown(s.."down"),
	                      self:isDown(s.."left"), self:isDown(s.."right"))
	return normalize(ax + dx, ay + dy)
end

function gamepad:pushAxis(axis, val)
	self.state[axis] = val
	local stick = data.sticks[axis]
	if stick then
		return self.onStick and self:onStick(stick, self:stick(stick))
	else
		return self.onAxis and self:onAxis(axis, val)
	end
end

function gamepad:pushPress(btn)
	self.state[btn] = true
	local stick = data.sticks[btn]
	if stick then
		return self.onStick and self:onStick(stick, self:stick(stick))
	else
		return self.onPress and self:onPress(btn)
	end
end

function gamepad:pushRelease(btn)
	self.state[btn] = false
	local stick = data.sticks[btn]
	if stick then
		return self.onStick and self:onStick(stick, self:stick(stick))
	else
		return self.onRelease and self:onRelease(btn)
	end
end

return gamepad
