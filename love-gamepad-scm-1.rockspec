package = "love-gamepad"
version = "scm-1"
source = {
   url = "git://github.com/Alloyed/love-gamepad"
}
description = {
   summary = "A gamepad abstraction library",
   homepage = "https://github/Alloyed/love-gamepad",
   license = "MIT"
}
dependencies = {
   "lua ~> 5.1",
   "love >= 0.9"
}
build = {
   type = "builtin",
   modules = {
      ["love-gamepad"] = "love-gamepad/init.lua",
      ["love-gamepad.atlas"] = "love-gamepad/atlas/init.lua",
      ["love-gamepad.data"] = "love-gamepad/data.lua",
      ["love-gamepad.gamepad"] = "love-gamepad/gamepad.lua",
      --["love-gamepad.multipad"] = "love-gamepad/multipad.lua"
   }
}
