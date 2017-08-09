--[[ LICENSE HEADER
  
  MIT Licensing (see LICENSE.txt)
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
]]


unimobiles = {}

if core.get_mod_metadata then
	core.get_mod_metadata(unimobiles)
else
	unimobiles.name = minetest.get_current_modname()
end

unimobiles.path = minetest.get_modpath(unimobiles.name)
