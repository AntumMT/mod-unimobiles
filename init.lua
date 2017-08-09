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


-- Mob Engines
local engines = {
	'entity_ai',
	'mila',
	'mob-engine',
	'mobf',
	'mobs_mc',
	'mobs_redo',
	'nmobs',
	'open_ai',
}

for i, e in ipairs(engines) do
	dofile(unimobiles.path .. '/engine/' .. e .. '/init.lua')
end


local scripts = {
	'api',
}

for i, s in ipairs(scripts) do
	dofile(unimobiles.path .. '/' .. script .. '.lua')
end
