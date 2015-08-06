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
