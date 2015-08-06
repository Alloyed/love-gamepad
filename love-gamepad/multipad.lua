local data = require 'gamepads.data'

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
		guid = guid
	}, gamepad_mt)
end

function gamepad:getName()
	return self.name
end

function gamepad:getGUID()
	return self.guid
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

local btns = {
	a = 0, b = 1, x = 2, y = 3,
	dpup = 4, dpdown = 5, dpleft = 6, dpright = 7,
	leftshoulder = 8, rightshoulder = 9,
	triggerleft = 10, triggerright = 11,
	leftstick = 12, rightstick = 13,
	back = 14, start = 15,
}

local quads = {}
local function symbol(name, img)
	local b = data.aliases[name] or name
	local i = btns[b]
	if not i then return nil, "no symbol" end
	if not quads[i] then
		local w, h = img:getDimensions()

		local qw, qh = 100, 100
		local wrap = 8

		local x = (i % wrap) * qw
		local y = math.floor(i / wrap) * qh
		quads[i] = love.graphics.newQuad(x, y, 100, 100, w, h)
	end
	return quads[i]
end

function gamepad:draw(name, x, y, w, h, r, ox, oy, kx, ky)
	local sx = w and (w / 100) or nil
	local sy = h and (h / 100) or nil
	local img = data.styles[self.style or 'default']
	local sym = symbol(name, img)
	if sym then
		love.graphics.draw(img, sym, x, y, r, sx, sy, ox, oy, kx, ky)
	end
end

return gamepad
