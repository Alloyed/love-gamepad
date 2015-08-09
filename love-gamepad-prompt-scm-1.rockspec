package = "love-gamepad-prompt"
version = "scm-1"
source = {
   url = "git://github.com/Alloyed/love-gamepad"
}
description = {
   summary = "display icons representing gamepad buttons",
   homepage = "https://github.com/Alloyed/love-gamepad",
   license = "MIT"
}
dependencies = {
   "lua ~> 5.1",
   "love >= 0.9",
   "dkjson"
}
build = {
   type = "builtin",
   modules = {
      ["love-gamepad.prompt"]      = "love-gamepad/prompt.lua",
      ["love-gamepad.prompt.data"] = "love-gamepad/prompt/data.lua",
   }
}
