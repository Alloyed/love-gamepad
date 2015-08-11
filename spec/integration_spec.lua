require 'spec.love_mock'

local gamepad = require 'love-gamepad.init'


describe("system", function()
   gamepad.setup()
   local joys = love.joystick.getJoysticks()
   local pads = gamepad.allGamepads()
   it("takes names/guids from parent gamepads", function()
      for i=1, 4 do
	 assert.equal(joys[i]:getName(), pads[i]:getName())
	 assert.equal(joys[i]:getGUID(), pads[i]:getGUID())
      end
   end)

   it("responds to button presses/releases", function()
      assert.not_nil(love.gamepadpressed)
      assert.not_nil(love.gamepadreleased)
      local pressed = false
      pads[1].onPress = function(self, btn)
	 pressed = btn
      end
      pads[1].onRelease = function(self, btn)
	 pressed = btn .. "2"
      end
      love.gamepadpressed(joys[1], 'a')
      assert.equal('a', pressed)
      love.gamepadreleased(joys[1], 'a')
      assert.equal('a2', pressed)
   end)

   it("responds to trigger changes", function()
      assert.not_nil(love.gamepadaxis)
      local changed
      pads[1].onAxis = function(self, axis, val)
	 changed = {axis, val}
      end
      love.gamepadaxis(joys[1], 'triggerleft', .5)
      assert.same({'triggerleft', .5}, changed)
      love.gamepadaxis(joys[1], 'triggerleft', .4)
      assert.same({'triggerleft', .4}, changed)
   end)

   it("responds to stick changes", function()
      assert.not_nil(love.gamepadaxis)
      local changed
      pads[1].onStick = function(self, axis, x, y)
	 changed = {axis, x, y}
      end
      love.gamepadaxis(joys[1], 'leftx', .5)
      love.gamepadaxis(joys[1], 'lefty', .4)
      assert.same({'left', .5, .4}, changed)
   end)
end)
