local gamepad = require 'love-gamepad.gamepad'
local data = require 'love-gamepad.data'

local gamepads = {}
local joypads = {}
local registered_keys = {}
local active_pads = {}

local function remove_val(tbl, val)
	for i=1, #tbl do
		if tbl[i] == val then
			table.remove(tbl, i)
			return true
		end
	end
end

function gamepads.setup()
	love.joystick.loadGamepadMappings("gamecontrollerdb.txt")
	function love.joystickadded(joy)
		gamepads.add_joypad(joy)
	end
	function love.joystickremoved(joy)
		local pad = joypads[joy]
		remove_val(active_pads, pad)
		joypads[joy] = nil
	end

	local function gp_event(name)
		return function(joy, ...)
			local pad = joypads[joy]
			return pad[name](pad, ...)
		end
	end

	-- TODO: axis bundling, digital->analog/analog->digital
	love.gamepadaxis     = gp_event('pushAxis')
	love.gamepadpressed  = gp_event('pushPress')
	love.gamepadreleased = gp_event('pushRelease')

	local function kp_event(name)
		return function(k)
			local pad, btn = unpack(registered_keys[k] or {})
			if pad then
				return pad[name](pad, btn)
			end
		end
	end

	love.keypressed  = kp_event('pushPress')
	love.keyreleased = kp_event('pushRelease')

	for _, joy in ipairs(love.joystick.getJoysticks()) do
		gamepads.add_joypad(joy)
	end
end

function gamepads.getGamepad(num)
	return joypads[love.joystick:getJoysticks()[num]]
end

function gamepads.allGamepads()
	return active_pads
end

function gamepads.add_joypad(joy)
	if joypads[joy] then
		return nil, "already added"
	elseif not joy:isGamepad() then
		return nil, "not a gamepad"
	else
		joypads[joy] = gamepad.new(joy:getName(), joy:getGUID())
		table.insert(active_pads, joypads[joy])
		return joypads[joy]
	end
end
function gamepads.add_keypad(cfg)
	local pad = gamepad.new("Keyboard", "kb")
	table.insert(active_pads, pad)

	for key, btn in pairs(cfg) do
		registered_keys[key] = {pad, data.aliases[btn] or btn}
	end

	return pad
end

local empty = function() end
gamepads.onPressed = empty
gamepads.onReleased = empty
gamepads.onAnalog = empty

return gamepads
