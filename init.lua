-- Nmobs init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


nmobs_mod = {}
nmobs = nmobs_mod
nmobs_mod.version = "1.0"
nmobs_mod.path = minetest.get_modpath(minetest.get_current_modname())
nmobs_mod.world = minetest.get_worldpath()
nmobs_mod.mobs = {}


function math.limit(n, l, h)
  return math.max(math.min(n, h), l)
end


dofile(nmobs_mod.path .. "/api.lua")
dofile(nmobs_mod.path .. "/cow.lua")
dofile(nmobs_mod.path .. "/goat.lua")
dofile(nmobs_mod.path .. "/pig.lua")
dofile(nmobs_mod.path .. "/sheep.lua")
