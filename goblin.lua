-- Nmobs goblin.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The nodebox and textures are distributed as Public Domain (WTFPL).


nmobs.register_mob({
  attacks_player = true,
  hit_dice = 2,
  looks_for = {'default:stone_with_coal', 'default:stone_with_iron', 'default:stone_with_copper', 'default:stone_with_gold', 'default:stone_with_mese', 'default:stone_with_diamond', 'fun_caves:giant_mushroom_stem', 'default:mossycobble'},
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
      with = {'default:mossycobble', 'default:mossycobble', 'default:mossycobble'},
      when = 10,
    },
  },
  size = 0.7,
  spawn = {
    {
      nodes = {'default:stone', 'fun_caves:stone_with_algae', 'fun_caves:stone_with_lichen'},
      rarity = 20000,
    },
    {
      nodes = {'default:mossycobble'},
      rarity = 1000,
    },
  },
  tames = {'default:diamond'},
})


nmobs.register_mob({
  armor_class = 8,
  attacks_player = true,
  hit_dice = 4,
  looks_for = {'default:stone_with_coal', 'default:stone_with_iron', 'default:stone_with_copper', 'default:stone_with_gold', 'default:stone_with_mese', 'default:stone_with_diamond', 'fun_caves:giant_mushroom_stem', 'default:mossycobble'},
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
      with = {'default:mossycobble', 'default:mossycobble', 'default:mossycobble'},
      when = 10,
    },
  },
  size = 0.8,
  spawn = {
    {
      nodes = {'default:stone', 'fun_caves:stone_with_algae', 'fun_caves:stone_with_lichen'},
      rarity = 50000,
    },
    {
      nodes = {'default:mossycobble'},
      rarity = 1000,
    },
  },
  tames = {'default:diamond'},
})
