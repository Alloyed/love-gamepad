# love-gamepad
A cleverly-named gamepad abstraction, built with temporarily embarrased
console games in mind.

Features:
* An abstract, extensible gamepad class. built-in implementations
  include normal gamepads and keyboards.
* optional controller level dispatch
* input aliasing, which can be used for more ergonomic/semantic code
* a more comprehensive gamepad DB, including extra metadata
* matches love's builtin callbacks+query model, so it can be used with
  other abstractions.

TODO:
* better axis <-> button mappings

## love-gamepad-prompt
An optional extensions for displaying button prompts based on gamepad
type. It uses the [free keyboard/controller prompts pack][C] by xelu,
licensed CC0.

If you'd like to make your own button prompts, all the detection code is
in love-gamepad: just use 

```
gamepad:getStyle()
```
to get the controller style, which can be any of [these styles][S]

[C]:http://opengameart.org/content/free-keyboard-and-controllers-prompts-pack
[S]:love-gamepad/styles.lua

## Installing

Install either using loverocks
```
$ loverocks install love-gamepad love-gamepad-prompt
```
or by copy-pasting the love-gamepad folder into your game.

### Example
```lua
local gamepads = require 'love-gamepad'
local player1
function love.load()
	gamepads.setup()
	keypad = gamepads.add_keypad {
		z = 'b', x = 'a',
		up = 'dpup', down = 'dpdown',
		left = 'dpleft', right = 'dpright'
	}
	player1 = gamepads.allGamepads()[1]
	function player1.onPressed(btn)
		print(btn)
	end
end
```

See [main.lua][M] for a slightly more in-depth demo, using
love-gamepad-prompt.
[M]:main.lua

### Tests
Tests are written for busted. Install with
```
$ luarocks install busted
```
and 
```
$ busted
```
to run tests
