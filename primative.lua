-- Nmobs primative.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

-- The nodebox and textures are distributed as Public Domain (WTFPL).


nmobs.register_mob({
  attacks_player = true,
  armor_class = 9,
  hit_dice = 5,
  looks_for = {'group:soil'},
  name = 'Primative',
  nodebox = {
    {-0.06, 0.27, -0.0625, 0.06, 0.41, 0.06}, -- head
    {-0.09375, 0.035, -0.0625, 0.09375, 0.25, 0.11}, -- chest
    {-0.09375, -0.125, -0.0625, 0.09375, 0, 0.1}, -- pelvis
    {0.02, -0.5, -0.04, 0.09, -0.125, 0.05}, -- rightleg
    {-0.07, 0, -0.0625, 0.07, 0.25, 0.08}, -- spine
    {-0.09, -0.5, -0.04, -0.02, -0.125, 0.05}, -- leftleg
    {0.1, 0.05, 0, 0.16, 0.25, 0.06}, -- rightarm1
    {0.1, -0.02, 0, 0.16, 0.05, 0.24}, -- rightarm2
    {-0.09, -0.5, -0.02, -0.02, -0.47, 0.12}, -- leftfoot
    {0.02, -0.5, -0.02, 0.09, -0.47, 0.12}, -- rightfoot
    {0.1, -0.03, 0.24, 0.16, 0.06, 0.32}, -- righthand
    {-0.03, 0.25, -0.06, 0.03, 0.34375, 0.04}, -- neck
    {0.12, -0.5, 0.26, 0.14, 0.5, 0.29}, -- spear
    {0.09375, 0.2, 0, 0.1, 0.25, 0.04}, -- rightshoulder
    {-0.16, 0.05, 0, -0.1, 0.25, 0.06}, -- leftarm1
    {-0.1, 0.2, 0, -0.09375, 0.25, 0.04}, -- leftshoulder
    {-0.16, -0.02, 0, -0.1, 0.05, 0.24}, -- leftarm2
    {-0.16, -0.03, 0.24, -0.1, 0.06, 0.32}, -- lefthand
  },
  size = 1.6,
  tames = {'farming:wheat'},
})
