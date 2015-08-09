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
   return self._guid
end

function joystick:getGamepadAxis()
   error("MOCK")
end

function joystick:getGamepadMapping()
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
   return self._name
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
   return true
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

local sticks = {}
for i=1, 4 do
   table.insert(sticks, setmetatable({
      _guid = "joy-" .. tostring(math.random()),
      _name = "joystick " .. tostring(math.random())
   }, joystick_mt))
end

function module.getJoystickCount()
   return #sticks
end

function module.getJoysticks()
   return sticks
end

function module.loadGamepadMappings()
   --error("MOCK")
end

function module.saveGamepadMappings()
   error("MOCK")
end

function module.setGamepadMapping()
   error("MOCK")
end

_G.love = {joystick = module}
