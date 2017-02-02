-- Nmobs boulder.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The nodebox and textures are distributed as Public Domain (WTFPL).


nmobs.register_mob({
  armor_class = 2,
  attacks_player = true,
  hit_dice = 4,
  looks_for = {'default:stone', 'fun_caves:stone_with_algae', 'fun_caves:stone_with_lichen', 'fun_caves:stone_with_moss'},
  name = 'boulder',
  nodebox = {
    {-0.35, -0.35, -0.35, 0.35, 0.35, 0.35},
    {-0.45, -0.25, -0.25, -0.35, 0.25, 0.25},
    {0.35, -0.25, -0.25, 0.45, 0.25, 0.25},
    {-0.25, -0.45, -0.25, 0.25, -0.35, 0.25},
    {-0.25, 0.35, -0.25, 0.25, 0.45, 0.25},
    {-0.25, -0.25, -0.45, 0.25, 0.25, -0.35},
    {-0.25, -0.25, 0.35, 0.25, 0.25, 0.45},
  },
  sound = 'ccmobs_rockmonster',
  textures = {'default_stone'},
})
