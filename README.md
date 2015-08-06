# love-gamepad
A cleverly-named gamepad extraction library.

### example
```lua
local gamepads = require 'love-gamepad'
local player1
function love.load()
	gamepads.setup()
	player1 = gamepads.allGamepads()[1]
	function player1.onPressed(btn)
		print(btn)
	end
end

```

See [main.lua][M] for a slightly more in-depth demo.
[M] main.lua
