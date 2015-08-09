local data  = require 'love-gamepad.data'
local styles = require 'love-gamepad.styles'

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


function gamepad.new(name, guid)
	return setmetatable({
		state = gamepad.new_state(),
		name = name,
		guid = guid,
		style = styles.guids[guid] or "xboxone"
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
