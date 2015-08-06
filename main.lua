local lg = love.graphics
local lj = love.joystick

local GP = require 'love-gamepad'
local data = require 'love-gamepad.data'
local atlas = require 'love-gamepad.prompts'

function GP:onPressed(btn)
	--print(btn)
end

function love.load()
	GP.setup()
	pad = GP.add_keypad {
		z = 'b',
		x = 'a',
		up = 'leftup',
		down = 'leftdown',
		left = 'leftleft',
		right = 'leftright',
	}
	function pad:onStick(name, x, y)
		--print(name, x, y)
	end
	a = atlas.new()
end

function love.draw()
	lg.push()
	lg.translate(10, 10)
	for joy, pad in pairs(GP.allGamepads()) do
		lg.print(pad:getName(), 0, 0)
		lg.translate(0, 20)
		lg.push()
		for _, stick in ipairs{'left', 'right'} do
			local x, y = pad:stick(stick)
			x = (x * 20) + 25
			y = (y * 20) + 25
			lg.circle('line', 25, 25, 25)
			lg.circle('fill', x, y, 4)
			lg.translate(50, 0)
		end
		for _, a in ipairs{'triggerleft', 'triggerright'} do
			local v = pad:axis(a)
			y = (v * 20) + 25
			lg.rectangle('line', 0, y, 25, 10)
			lg.translate(25, 0)
		end
		for _, btn in ipairs(data.buttons) do
			if pad:isDown(btn) then
				local style = pad:getStyle()
				local img, q = a:get(("%s.%s.png"):format(style, btn))
				if img then
					lg.draw(img, q, 0, 0, 0, .5, .5)
					lg.translate(50, 0)
				end
			end
		end
		lg.pop()
		lg.translate(0, 55)
	end
	lg.pop()
end
