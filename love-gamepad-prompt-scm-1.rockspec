package = "love-gamepad"
version = "scm-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
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
