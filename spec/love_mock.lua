local module = {}

local joystick = {}
local joystick_mt = {__index = joystick}

function joystick:getAxes()
   error("MOCK")
end

function joystick:getAxis()
   error("MOCK")
end

function joystick:getButtonCount()
   error("MOCK")
end

function joystick:getGUID()
   error("MOCK")
end

function joystick:getGamepadAxis()
   error("MOCK")
end

function joysticks:getGamepadMapping()
   error("MOCK")
end

function joystick:getHat()
   error("MOCK")
end

function joystick:getHatCount()
   error("MOCK")
end

function joystick:getID()
   error("MOCK")
end

function joystick:getName()
   error("MOCK")
end

function joystick:getVibration()
   error("MOCK")
end

function joystick:isConnected()
   error("MOCK")
end

function joystick:isDown()
   error("MOCK")
end

function joystick:isGamepad()
   error("MOCK")
end

function joystick:isGamepadDown(btn)
   error("MOCK")
end

function joystick:isVibrationSupported()
   error("MOCK")
end

function joystick:setVibration()
   error("MOCK")
end

function module.getJoystickCount()
   error("MOCK")
end

function module.getJoysticks()
   error("MOCK")
end

function module.loadGamepadMappings()
   error("MOCK")
end

function module.saveGamepadMappings()
   error("MOCK")
end

function module.setGamepadMapping()
   error("MOCK")
end

_G.love = {joystick = module}
