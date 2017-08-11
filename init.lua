--[[ LICENSE HEADER
  
  MIT Licensing (see LICENSE.txt)
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
]]


umobs = {}

if core.get_mod_metadata then
	core.get_mod_metadata(umobs)
else
	umobs.name = minetest.get_current_modname()
end

umobs.path = minetest.get_modpath(umobs.name)


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
	dofile(umobs.path .. '/engine/' .. e .. '/init.lua')
end


local scripts = {
	'api',
}

for i, s in ipairs(scripts) do
	dofile(umobs.path .. '/' .. script .. '.lua')
end
