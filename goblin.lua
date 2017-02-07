-- Nmobs goblin.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The nodebox and textures are distributed as Public Domain (WTFPL).


nmobs.register_mob({
  attacks_player = true,
  hit_dice = 2,
  --looks_for = {'default:stone_with_coal', 'default:stone_with_iron', 'default:stone_with_copper', 'default:stone_with_gold', 'default:stone_with_mese', 'default:stone_with_diamond', 'fun_caves:giant_mushroom_stem', 'default:mossycobble'},
  looks_for = {'default:mossycobble', 'default:dirt', 'default:stone_with_algae', 'default:stone_with_lichen'},
  name = 'goblin',
  nocturnal = true,
  nodebox = {
    {-0.25, -0.3125, -0.25, 0.25, 0.1875, 0.25}, -- body1
    {-0.25, -0.5, -0.125, -0.0625, -0.3125, 0.0625}, -- leftleg
    {0.0625, -0.5, -0.125, 0.25, -0.3125, 0.0625}, -- rightleg
    {0.0625, -0.5, -0.125, 0.3125, -0.4375, 0.1875}, -- rightfoot
    {-0.3125, -0.5, -0.125, -0.0625, -0.4375, 0.1875}, -- leftfoot
    {0.25, -0.25, -0.25, 0.3125, 0.1875, 0.25}, -- body2
    {-0.3125, -0.25, -0.25, -0.25, 0.1875, 0.25}, -- body3
    {-0.25, -0.25, 0.25, 0.25, 0.1875, 0.3125}, -- body4
    {-0.25, -0.25, -0.3125, 0.25, 0.1875, -0.25}, -- body5
    {-0.25, 0.25, -0.25, 0.25, 0.3125, 0.1875}, -- body6
    {-0.1875, 0.3125, -0.1875, 0.1875, 0.375, 0.1875}, -- body7
    {-0.1875, 0.375, 0.0625, -0.0625, 0.4375, 0.1875}, -- lefteye
    {0.0625, 0.375, 0.0625, 0.1875, 0.4375, 0.1875}, -- righteye
    {-0.4375, 0.0625, 0.0625, -0.3125, 0.125, 0.125}, -- leftarm1
    {0.3125, 0.0625, 0.0625, 0.4375, 0.125, 0.125}, -- rightarm1
    {0.375, -0.375, 0.0625, 0.5, -0.1875, 0.125}, -- righthand
    {-0.5, -0.375, 0.0625, -0.375, -0.1875, 0.125}, -- lefthand
    {-0.25, 0.1875, -0.25, 0.25, 0.25, 0.1875}, -- body8
    {-0.1875, 0.1875, 0.1875, -0.125, 0.3125, 0.25}, -- lip1
    {0.125, 0.1875, 0.1875, 0.1875, 0.3125, 0.25}, -- lip2
    {-0.1875, 0.25, 0.1875, 0.1875, 0.3125, 0.25}, -- lip3
    {-0.0625, 0.3125, 0.1875, 0.0625, 0.375, 0.25}, -- nose
    {-0.4375, -0.375, 0.0625, -0.375, 0.125, 0.125}, -- leftarm2
    {0.375, -0.375, 0.0625, 0.4375, 0.125, 0.125}, -- rightarm2
  },
  replaces = {
    --{
    --  replace = {'group:cracky', 'group:choppy', 'group:snappy'},
    --  with = {'air'},
    --  when = 10,
    --},
    {
      floor = true,
      replace = {'air'},
      with = {'default:dirt'},
      when = 10,
    },
    {
      floor = true,
      replace = {'group:cracky'},
      with = {'nmobs:mossycobble_slimy', 'default:mossycobble', 'nmobs:glowing_fungal_stone'},
      when = 10,
    },
    {
      replace = {'air'},
      with = {'nmobs:fairy_light'},
      when = 20,
    },
  },
  size = 0.7,
  spawn = {
    {
      nodes = {'default:stone', 'fun_caves:stone_with_algae', 'fun_caves:stone_with_lichen'},
      rarity = 20000,
    },
    {
      nodes = {'default:mossycobble', 'nmobs:mossycobble_slimy'},
      rarity = 1000,
    },
  },
  tames = {'default:diamond'},
  tunnel = {'group:cracky', 'group:crumbly'},
})


nmobs.register_mob({
  armor_class = 8,
  attacks_player = true,
  hit_dice = 4,
  --looks_for = {'default:stone_with_coal', 'default:stone_with_iron', 'default:stone_with_copper', 'default:stone_with_gold', 'default:stone_with_mese', 'default:stone_with_diamond', 'fun_caves:giant_mushroom_stem', 'default:mossycobble'},
  looks_for = {'default:mossycobble', 'default:dirt', 'default:stone_with_algae', 'default:stone_with_lichen'},
  name = 'goblin basher',
  nocturnal = true,
  nodebox = {
    {-0.25, -0.3125, -0.25, 0.25, 0.1875, 0.25}, -- body1
    {-0.25, -0.5, -0.125, -0.0625, -0.3125, 0.0625}, -- leftleg
    {0.0625, -0.5, -0.125, 0.25, -0.3125, 0.0625}, -- rightleg
    {0.0625, -0.5, -0.125, 0.3125, -0.4375, 0.1875}, -- rightfoot
    {-0.3125, -0.5, -0.125, -0.0625, -0.4375, 0.1875}, -- leftfoot
    {0.25, -0.25, -0.25, 0.3125, 0.1875, 0.25}, -- body2
    {-0.3125, -0.25, -0.25, -0.25, 0.1875, 0.25}, -- body3
    {-0.25, -0.25, 0.25, 0.25, 0.1875, 0.3125}, -- body4
    {-0.25, -0.25, -0.3125, 0.25, 0.1875, -0.25}, -- body5
    {-0.25, 0.25, -0.25, 0.25, 0.3125, 0.1875}, -- body6
    {-0.1875, 0.3125, -0.1875, 0.1875, 0.375, 0.1875}, -- body7
    {-0.1875, 0.375, 0.0625, -0.0625, 0.4375, 0.1875}, -- lefteye
    {0.0625, 0.375, 0.0625, 0.1875, 0.4375, 0.1875}, -- righteye
    {-0.4375, 0.0625, 0.0625, -0.3125, 0.125, 0.125}, -- leftarm1
    {0.3125, 0.0625, 0.0625, 0.4375, 0.125, 0.125}, -- rightarm1
    {0.375, -0.375, 0.0625, 0.5, -0.1875, 0.125}, -- righthand
    {-0.5, -0.375, 0.0625, -0.375, -0.1875, 0.125}, -- lefthand
    {-0.25, 0.1875, -0.25, 0.25, 0.25, 0.1875}, -- body8
    {-0.1875, 0.1875, 0.1875, -0.125, 0.3125, 0.25}, -- lip1
    {0.125, 0.1875, 0.1875, 0.1875, 0.3125, 0.25}, -- lip2
    {-0.1875, 0.25, 0.1875, 0.1875, 0.3125, 0.25}, -- lip3
    {-0.0625, 0.3125, 0.1875, 0.0625, 0.375, 0.25}, -- nose
    {-0.4375, -0.375, 0.0625, -0.375, 0.125, 0.125}, -- leftarm2
    {0.375, -0.375, 0.0625, 0.4375, 0.125, 0.125}, -- rightarm2
  },
  replaces = {
    --{
    --  replace = {'group:cracky', 'group:choppy', 'group:snappy'},
    --  with = {'air'},
    --  when = 10,
    --},
    {
      floor = true,
      replace = {'air'},
      with = {'default:dirt'},
      when = 10,
    },
    {
      floor = true,
      replace = {'group:cracky'},
      with = {'nmobs:mossycobble_slimy', 'default:mossycobble', 'nmobs:glowing_fungal_stone'},
      when = 10,
    },
    {
      replace = {'air'},
      with = {'nmobs:fairy_light'},
      when = 20,
    },
  },
  size = 0.8,
  spawn = {
    {
      nodes = {'default:stone', 'fun_caves:stone_with_algae', 'fun_caves:stone_with_lichen'},
      rarity = 50000,
    },
    {
      nodes = {'default:mossycobble', 'nmobs:mossycobble_slimy'},
      rarity = 1000,
    },
  },
  tames = {'default:diamond'},
  tunnel = {'group:cracky', 'group:crumbly'},
})


---------------------------------------------------------------
-- Nodes
---------------------------------------------------------------


if minetest.registered_items['underworlds:glowing_fungal_stone'] then
  minetest.register_alias("nmobs:glowing_fungal_stone", 'underworlds:glowing_fungal_stone')
  minetest.register_alias("nmobs:glowing_fungus", 'underworlds:glowing_fungus')
elseif minetest.registered_items['fun_caves:glowing_fungal_stone'] then
  minetest.register_alias("nmobs:glowing_fungal_stone", 'fun_caves:glowing_fungal_stone')
  minetest.register_alias("nmobs:glowing_fungus", 'fun_caves:glowing_fungus')
else
  -- Glowing fungal stone provides an eerie light.
  minetest.register_node("nmobs:glowing_fungal_stone", {
    description = "Glowing Fungal Stone",
    tiles = {"default_stone.png^vmg_glowing_fungal.png",},
    is_ground_content = true,
    light_source = light_max - 4,
    groups = {cracky=3, stone=1},
    drop = {items={ {items={"default:cobble"},}, {items={"fun_caves:glowing_fungus",},},},},
    sounds = default.node_sound_stone_defaults(),
  })

  -- Glowing fungus grows underground.
  minetest.register_craftitem("nmobs:glowing_fungus", {
    description = "Glowing Fungus",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"vmg_glowing_fungus.png"},
    inventory_image = "vmg_glowing_fungus.png",
    groups = {dig_immediate = 3},
  })
end


minetest.register_node("nmobs:fairy_light", {
	description = "Fairy Light",
	drawtype = "plantlike",
	visual_scale = 0.75,
	tiles = {"nmobs_fairy_light.png"},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 4,
	walkable = false,
	diggable = false,
	pointable = false,
	is_ground_content = false,
})


local mushrooms = {"flowers:mushroom_brown", "flowers:mushroom_red"}
minetest.register_abm({
	nodenames = {"nmobs:fairy_light",},
	interval = 30,
	chance = 30,
  catch_up = true,
	action = function(pos, node)
		if not (pos and node) then
			return
		end

    local pos_down = table.copy(pos)
    pos_down.y = pos_down.y - 1
    local node_down = minetest.get_node_or_nil(pos_down)
    if node_down and node_down.name == 'default:dirt' then
      minetest.set_node(pos, {name=mushrooms[math.random(#mushrooms)]})
    else
      minetest.remove_node(pos)
    end
	end,
})


---------------------------------------------------------------
-- Traps
---------------------------------------------------------------

minetest.register_node("nmobs:mossycobble_slimy", {
	description = "Messy Gobblestone",
	tiles = {"default_mossycobble.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1, trap = 1},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	light_source =  4,
})

minetest.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "nmobs:mossycobble_trap",
})

minetest.register_node("nmobs:stone_with_coal_trap", {
	description = "Coal Trap",
	tiles = {"default_cobble.png^default_mineral_coal.png"},
	groups = {cracky = 3, trap = 1},
	drop = 'default:coal_lump',
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})
