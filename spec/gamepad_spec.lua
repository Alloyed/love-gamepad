local gamepad = require 'love-gamepad.gamepad'
describe("gamepads", function()
   local they = it

   they("have names and ids", function()
	  local gp = gamepad.new("foo", "bar")
	  assert.equal('foo', gp:getName())
	  assert.equal('bar', gp:getGUID())
   end)

   they("respond to button press events", function()
	  local gp = gamepad.new("foo", "bar")
	  local pressed = false
	  function gp:onPress(btn)
		 pressed = btn
	  end
	  gp:pushPress("a")
	  assert.equal("a", pressed)
	  gp:pushPress("b")
	  assert.equal("b", pressed)
	  gp:pushPress("dpup")
	  assert.equal("dpup", pressed)
   end)

   they("respond to button release events", function()
	  local gp = gamepad.new("foo", "bar")
	  local pressed = false
	  function gp:onRelease(btn)
		 pressed = btn
	  end
	  gp:pushRelease("a")
	  assert.equal("a", pressed)
	  gp:pushRelease("b")
	  assert.equal("b", pressed)
	  gp:pushRelease("dpup")
	  assert.equal("dpup", pressed)
   end)

   they("report button state", function()
	  local gp = gamepad.new("foo", "bar")
	  gp:pushPress("a")
	  assert.truthy(gp:isDown('a'))
	  gp:pushRelease("a")
	  assert.falsy(gp:isDown('a'))
	  gp:pushPress("b")
	  assert.truthy(gp:isDown('circle'))
	  gp:pushRelease("b")
	  assert.falsy(gp:isDown('circle'))
   end)

   they("respond to axis events", function()
	  local gp = gamepad.new("foo", "bar")
	  local a, v
	  function gp:onAxis(axis, val)
		 a = axis
		 v = val
	  end
	  gp:pushAxis('triggerright', 0)
	  assert.equal('triggerright', a)
	  assert.equal(0,  v)

	  gp:pushAxis('triggerleft', .69)
	  assert.equal('triggerleft', a)
	  assert.equal(.69,  v)
   end)

   they("report axis state", function()
	  local gp = gamepad.new("foo", "bar")
	  gp:pushAxis('triggerright', 0.1)
	  assert.equal(0.1,  gp:axis('triggerright'))

	  gp:pushAxis('triggerleft', 0.69)
	  assert.equal(0.69,  gp:axis('l2'))
   end)

   they("respond to stick events", function()
	  local gp = gamepad.new("foo", "bar")
	  local ev
	  function gp:onStick(axis, _x, _y)
		 ev = {axis, _x, _y}
	  end
	  gp:pushAxis('leftx', .1)
	  gp:pushAxis('lefty', .2)
	  assert.same({'left', .1, .2}, ev)
	  gp:pushAxis('lefty', .4)
	  assert.same({'left', .1, .4}, ev)
	  gp:pushAxis('rightx', .4)
	  gp:pushAxis('righty', .3)
	  assert.same({'right', .4, .3}, ev)
   end)

   they("report stick state", function()
	  local gp = gamepad.new("foo", "bar")
	  gp:pushAxis('leftx', 0.1)
	  gp:pushAxis('lefty', 0.2)
	  assert.same({0.1, 0.2}, {gp:stick('left')})

	  gp:pushAxis('lefty', 0.3)
	  assert.same({0.1, 0.3}, {gp:stick('left')})

	  gp:pushAxis('rightx', 0.4)
	  gp:pushAxis('righty', 0.5)
	  assert.same({0.4, 0.5}, {gp:stick('right')})
   end)
end)
