--[[ LICENSE HEADER
  
  MIT Licensing (see LICENSE.txt)
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
]]

--- Unimobiles API.
--
-- @module umobs.api


--- Mobs Redo Functions
--
-- @section mobs_redo_f


--- Registers an entity with *mobs_redo* engine.
--
-- @function umobs.mobsRegisterMob
-- @tparam string name Name of the mob.
-- @tparam table def Definition table (See: [umobs.mobsRegisterMob.def](#umobs.mobsRegisterMob.def)).
function umobs.mobsRegisterMob(name, def)
	return mobs:register_mob(name, def)
end


--- Registers spawning behavior of mob for *mobs_redo* engine.
--
-- @function umobs.mobsRegisterSpawn
-- @tparam string name
-- @tparam table nodes
-- @tparam int max_light
-- @tparam int min_light
-- @tparam int chance
-- @tparam int active_object_count
-- @tparam int max_height
-- @tparam bool day_toggle
-- @see umobs.mobsRegisterSpawnSpecific
function umobs.mobsRegisterSpawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, day_toggle)
	return mobs:register_spawn(name, nodes, max_light, min_light, chance, active_object_count, max_height, day_toggle)
end


--- Registers spawning behavior of mob for *mobs_redo* engine.
--
-- @function umobs.mobsRegisterSpawnSpecific
-- @tparam string name Name of the animal/monster.
-- @tparam table nodes A list of nodes on top of which the mob can spawn.
-- @tparam table neighbors A list of nodes of which must be adjacent for the mob to spawn(default: ***{"air"}***).
-- @tparam int min_light The minimum light value of node for spawn to occur.
-- @tparam int max_light The maximum light value of node for spawn to occur.
-- @tparam int interval Same as in [minetest.register_abm](http://dev.minetest.net/minetest.register_abm) (default: ***30***).
-- @tparam int chance Same as in [minetest.register_abm](http://dev.minetest.net/minetest.register_abm).
-- @tparam int active_object_count Mob is only spawned if ***active_object_count_wider*** of ABM is <= this.
-- @tparam int min_height Minimum height at which mob will spawn.
-- @tparam int max_height Maximum height at which mob will spawn.
-- @tparam bool day_toggle
-- - Value descriptions:
--   - ***true:*** Mob will spawn during daytime.
--   - ***false:*** Mob will spawn during nighttime.
--   - ***nil:*** Mob will spawn anytime.
--
-- @tparam callback on_spawn
-- - Called after mob has spawned.
-- - Usage: ***on_spawn = function(self, pos)
function umobs.mobsRegisterSpawnSpecific(name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
	return mobs:spawn_specfic(name, nodes, neighbors, min_light, max_light, interval, chance, active_object_count, min_height, max_height, day_toggle, on_spawn)
end


--- Registers spawning behavior of mob for *mobs_redo* engine.
--
-- @function umobs.mobsSpawn
-- @tparam table def See: [umobs.mobsRegisterSpawnSpecific](#umobs.mobsRegisterSpawnSpecific), where parameters = table definition fields here.
function umobs.mobsSpawn(def)
	return mobs:spawn(def)
end


--- Registers an item that mob can use for ranged attack for *mobs_redo* engine.
--
-- @function umobs.mobsRegisterArrow
-- @tparam string name Name of throwable item.
-- @tparam table def See: [umobs.mobsRegisterArrow.def](#umobs.mobsRegisterArrow.def)
function umobs.mobsRegisterArrow(name, def)
	return mobs:register_arrow(name, def)
end


--- Registers a mob spawning egg for *mobs_redo* engine.
--
-- The "egg" is an item that is held in inventory when a mob is captured/tamed.
--
-- @function umobs.mobsRegisterEgg
-- @tparam string name Name of the mob to be spawned (ex.: "***mob:sheep***").
-- @tparam string description name of the egg (ex.: "***Spawn Sheep***").
-- @tparam background Texture displayed for egg in inventory.
-- @tparam int addegg Adds an egg image in front of your texture (1=yes, 0=no).
-- @tparam bool no_creative If ***true***, spawn egg is not available in creative mode (useful for destructive mobs like ***Dungeon Master***).
function umobs.mobsRegisterEgg(name, description, background, addegg, no_creative)
	return mobs:register_egg(name, description, background, addegg, no_creative)
end


--- Generates a self-destruct explosion from mob.
--
-- Explosion removes nodes in a specific radius and damages any
-- entity caught inside the blast radius. Protection will limit
-- node destruction but not entity damage.
--
-- @function umobs.mobsBoom
-- @param self The mob entity.
-- @tparam (pos) pos Position of explosion centre.
-- @tparam int radius Radius of explosion reach (typically set to ***3***).
function umobs.mobsBoom(self, pos, radius)
	return mobs:boom(self, pos, radius)
end


--- Generates a self-destruct explosion from mob.
--
-- ***DEPRECATED:*** Use [umobs.mobsBoom](#umobs.mobsBoom).
--
-- @function umobs.mobsExplosion
-- @tparam pos pos
-- @tparam int radius
function umobs.mobsExplosion(pos, radius)
	return mobs:explosion(pos, radius)
end


--- Attempts to capture a mob and place in inventory.
--
-- This function is generally called inside the ***on_rightclick***
-- section of the mob api code. It provides a chance of capturing
-- the mob by hand, using the net, or magic lasso items. It can
-- also have the player take the mob by force if tamed and replace
-- it with another item entirely.
--
-- @function umobs.mobsCaptureMob
-- @param self Mob information.
-- @param clicker Player information.
-- @tparam int chance_hand
-- - Chance of capturing mob by hand.
-- - ***0*** to disable.
-- - Min: ***0***
-- - Max: ***100***
--
-- @tparam int chance_net
-- - Chance of capturing mob with net.
-- - ***0*** to disable.
-- - Min: ***0***
-- - Max: ***100***
--
-- @tparam int chance_lasso
-- - Chance of capturing mob with magic lasso.
-- - ***0*** to disable.
-- - Min: ***0***
-- - Max: ***100***
--
-- @tparam bool force_take If ***true***, takes mob by force even if tamed by another player.
-- @tparam string replacewith On capture, place this item in inventory instead of mob (overrides new mob eggs with saved information).
function umobs.mobsCaptureMob(self, clicker, chance_hand, chance_net, chance_lasso, force_take, replacewith)
	return mobs:capture_mob(self, clicker, chance_hand, chance_net, chance_lasso, force_take, replacewith)
end


--- Allows feeding items to mobs.
--
-- This function allows the mob to be fed the item inside ***self.follow***
-- a set number of times to be tamed or bred as a result. Will return
-- ***true*** when mob is fed with item it likes.
--
-- @function umobs.mobsFeedTame
-- @param table self Mob information.
-- @param clicker Player information.
-- @tparam int feed_count Number of times mob must be fed to tame or breed.
-- @tparam bool breed If ***true***, mob can be bred and a child created afterwards.
-- @tparam bool tame If ***true***, mob can be tamed so player can pick them up.
function umobs.mobsFeedTame(self, clicker, feed_count, breed, tame)
	return mobs:feed_tame(self, clicker, feed_count, breed, tame)
end


--- Protects mobs from being attacked by other players.
--
-- This function can be used to right-click any tamed mob with
-- ***mobs:protector*** item. This will protect the mob from harm
-- inside a protected area from other players. Will return ***true***
-- when mob right-clicked with ***mobs:protector*** item.
--
-- @function umobs.mobsProtect
-- @param self Mob information.
-- @param clicker Player information.
function umobs.mobsProtect(self, clicker)
	return mobs:protect(self, clicker)
end


--- Attaches a player to the mob so it can be ridden.
--
-- @function umobs.mobsAttach
-- @param self Mob information.
-- @param player Player information.
function umobs.mobsAttach(self, player)
	return mobs:attach(self, player)
end


--- Detaches player from riding mob.
--
-- Detaches the player currently riding a mob to an offset position.
--
-- @function umobs.mobsDetach
-- @param player Player information.
-- @tparam pos offset Position table containing offset values.
function umobs.mobsDetach(player, offset)
	return mobs:detach(player, offset)
end


--- Controls mob movement with player.
--
-- Allows an attached player to move the mob around and animate it at same time.
--
-- @function umobs.mobsDrive
-- @param self Mob information.
-- @tparam string move_animation Pre-defined movement state animation (e.g. "***walk***").
-- @tparam string stand_animation Pre-defined standing state animation (e.g. "***stand***").
-- @tparam bool can_fly If ***true***, jump and sneak controls will allow mob to fly up and down.
-- @param dtime Tick time used inside function.
function umobs.mobsDrive(self, move_animation, stand_animation, can_fly, dtime)
	return mobs:drive(self, move_animation, stand_animation, can_fly, dtime)
end


--- Controls mob flight with player.
--
-- Allows the attached player to fly the mob around using directional controls.
-- 
-- **NOTE:** animation names are from the *pre-defined* animation lists inside mob registry without extensions.
--
-- @function umobs.mobsFly
-- @param self Mob information.
-- @param dtime Tick time used inside function.
-- @tparam int speed Speed at which mob moves in flight.
-- @tparam bool can_shoot If ***true***, player can fire arrow with mob (sneak and left mouse button fires).
-- @tparam string arrow_entity Name of item used for firing ranged attack.
-- @tparam string move_animation Pre-defined movement state animation (e.g. "***walk***", "***fly***", etc.).
-- @tparam string stand_animation Pre-defined standing state animation (e.g. "***stand***", "***blink***", etc.).
function umobs.mobsFly(self, dtime, speed, can_shoot, arrow_entity, move_animation, stand_animation)
	return mobs:fly(self, dtime, speed, can_shoot, arrow_entity, move_animation, stand_animation)
end


--- Sets current animation for mob.
--
-- Default: "***stand***"
--
-- @function umobs.mobsSetAnimation
-- @param self Mob information.
-- @tparam string name Name of animation (e.g. "***stand***", "***walk***", "***fly***", etc.).
function umobs.mobsSetAnimation(self, name)
	return mobs:set_animation(self, name)
end


--- Mobs Redo Function Definition Tables
--
-- @section mobs_redo_t


--- Definition table for [umobs.mobsRegisterMob](#umobs.mobsRegisterMob).
--
--
-- @table umobs.mobsRegisterMob.def
-- @tfield string type The type of the mob (***monster***, ***animal*** or ***npc***) where monsters attack players and npc's, animals and npc's tend to wander around and can attack when hit 1st.
-- @tfield bool passive Mob will *not* defend itself (set to ***false*** to attack).
-- @tfield bool docile_by_day When ***true***, mob will not attack during daylight hours unless provoked.
-- @tfield bool attacks_monsters Usually for npc's to attack monsters in area.
-- @tfield bool group_attack If ***true***, Will defend nearby mobs of same type from attack.
-- @tfield bool owner_loyal If ***true***, owned mobs will attack any monsters you punch.
-- @tfield bool attack_animals If ***true***, will attack animals as well as players and NPCs.
-- @tfield table specific_attack Table of entity names that monsters can attack (e.g. {"player", "mobs_animal:chicken"}).
-- @tfield int hp_min Minimum health.
-- @tfield int hp_max Maximum health (mob health is randomly selected between both).
-- @tfield bool physical Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @tfield table collisionbox Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @tfield string visual Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @tfield table visual_size Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @tfield table textures Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity). Although you can add multiple lines for random textures {{"texture1.png"},{"texture2.png"}}, 
-- @field gotten_texture Alternative texture for when ***self.gotten*** value is set to ***true*** (used for shearing sheep).
-- @field child_texture Texture of mod for when ***self.child*** is set to ***true***.
-- @tfield string mesh Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @field gotten_mesh Alternative mesh for when ***self.gotten*** is ***true*** (used for sheep).
-- @tfield bool makes_footstep_sound Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @field Items that, when held, will cause mob to follow player. Can be single string (e.g. "default:apple") or a table (e.g. {"default:apple", "default:diamond"}). These can also be used to feed and tame mob.
-- @tfield int view_range The range at which mob will follow or attack player or other entities.
-- @tfield int walk_chance chance of mob walking around (0 to 100). Set to 0 for jumping mob only.
-- @field walk_velocity the velocity when the monster is walking around
-- @field run_velocity the velocity when the monster is attacking a player
-- @tfield bool runaway If ***true***, mob will retreat when punched.
-- @tfield float stepheight minimum Node height mob can walk onto without jumping (default: 0.6).
-- @tfield bool jump If ***true***, mob can jump.
-- @tfield int jump_height Height mob can jump. Set to 0 to disable jump (default: 6).
-- @tfield bool fly If ***true***,  mob can fly through designated node types from ***fly_in*** (used for swimming mobs).
-- @field fly_in Node name that mob can fly inside (e.g. "air", "default:water_source" for fish).
-- @field damage The damage mob inflicts per melee attack.
-- @tfield float recovery_time How much time, in seconds, from when mob is hit until it recovers (default: 0.5).
-- @tfield int knock_back Strength of knock-back when mob is hit (default: 3).
-- @tfield table immune_to
-- - A table holding special tool/item names and damage the incur.
-- - Example:
-- <pre>
-- immune_to = {
--     {"default:sword_wood", 0},  \-- immune to sword
--     {"default:gold_lump", -10},  \-- gold lump heals
-- }
-- </pre>
--
-- @tfield int blood_amount Number of blood droplets that appear when hit.
-- @tfield string blood_texture Texture of blood droplets (default: "mobs_blood.png").
-- @tfield table drops
-- - List of tables with the following fields:
--   - ***name:*** (***string***) Item name (e.g. "default:stone").
--   - ***chance:*** (***int***) The inverted chance (same as in abm) to get the item.
--   - ***min:*** (***int***) Minimum number of items dropped at one time.
--   - ***max:*** (***int***) Maximum number of items dropped at one time.
-- - Example:
-- <pre>
-- drops = {
--     {name='default:stone', chance=2, min=5, max=5},
--     {name='default:mese_crystal', chance=100, min=1, max=3},
--     {name='mobs:meat', chance=1, min=2, max=5},
-- }
-- </pre>
--
-- @tfield int armor Armor strength (100 being normal). Lower numbers mane stronger armor while higher numbers make it weaker (weird I know but compatible with simple mobs).
-- @tfield string drawtype "front" or "side" (DEPRECATED: replaced with ***rotate***).
-- @tfield int rotate Sets mob rotation (0=front, 90=side, 180=back, 270=other side).
-- @field water_damage Damage per second mob incurs while in water.
-- @field lava_damage Damage per second mob incurs while in lava.
-- @field light_damage Damage per second mob incurs while in light.
-- @field suffocation Health value mob loses when inside a solid node.
-- @tfield bool fall_damage If ***true***, mob will retain damage when falling from heights.
-- @tfield int fall_speed Maximum falling velocity of mob (default: -10, must be lower than -2).
-- @tfield int fear_height Any drop over this value will make mob turn back. Set to 0 to disable (default: 0).
-- @tfield callback on_die
-- - Called when mob dies.
-- - Usage: ***on_die = function(self, pos)***
-- - Parameters:
--   - ***self:***
--   - ***pos:***
--
-- @tfield int floats Set to 1 to float in water, 0 to sink.
-- @tfield callback on_rightclick Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity).
-- @tfield int pathfinding
-- - Use pathfinder feature.
-- - Options:
--   - 0: Disable.
--   - 1: Use pathfinder to locate player.
--   - 2: Additionaly allow build/break (only works with ***dogfight*** attack).
--
-- @tfield string attack_type
-- - The attack type of a monster.
-- - Options:
--   - ***dogfight:*** Follows player in range and attacks when in reach.
--   - ***shoot:*** Shoots defined arrows when player is within range.
--   - ***explode:*** Follows player and will flash and explode when in reach.
--   - ***dogshoot:*** Shoots arrows when in range and one on one attack when in reach.
--
-- @field dogshoot_switch Allows switching between ***shoot*** and ***dogfight*** modes inside ***dogshoot*** using timer (1 = shoot, 2 = dogfight).
-- @tfield int dogshoot_count_max Number of seconds before switching to ***dogfight*** mode.
-- @tfield int dogshoot_count2_max Number of seconds before switching back to ***shoot*** mode.
-- @tfield callback custom_attack
-- - When set, this function is called instead of the normal mob melee attack.
-- - Usage: ***custom_attack = function(self, to_attack)***
-- - Parameters:
--   - ***self:***
--   - ***to_attack:***
--
-- @tfield bool double_melee_attack If ***false***, API will choose randomly between ***punch*** and ***punch2*** attack animations.
-- @tfield callbacks on_blast
-- - Called when an explosion happens near mob using TNT functions.
-- - Usage: ***on_blast = function(object, damage)
-- - Parameters:
--   - ***object:***
--   - ***damage:***
-- - Returns: (***do_damage***, ***do_knockback***, ***drops***)
--
-- @tfield int explosion_radius Radius of explosion attack (default: 1).
-- @tfield string arrow If the attack_type is ***shoot*** or ***dogshoot*** then the entity name of a pre-defined arrow is required (see below for arrow definition).
-- @field shoot_interval The minimum shoot interval.
-- @field shoot_offset +/- value to position arrow/fireball when fired.
-- @tfield int reach
-- - Range at which mob will shoot (default: 3).
--
-- ***SOUND***
--
-- ---
-- @tfield table sounds
-- - Sounds that will be heard from mob.
-- - Fields:
--   - ***random:*** Random sounds during gameplay.
--   - ***war_cry:*** Played when starting to attack player.
--   - ***attack:*** Played while attacking player.
--   - ***shoot_attack:*** Played while attacking player from range.
--   - ***damage:*** Played when mob is hit.
--   - ***death:*** Played when mob dies.
--   - ***jump:*** Played when jumping.
--   - ***explode:*** Played when explodes.
--   - ***distance:*** (***int***) Maximum distance sounds are heard from (default: 10).
--
-- ***EATING***
-- 
-- ---
-- Mobs can look for specific nodes as they walk and replace them to mimic eating:
--
-- @tfield callback on_replace
-- - Called when mob is about to replace a node.
-- - Usage: ***on_replace(self, pos, oldnode, newnode)***
-- - Parameters:
--   - ***self:*** ObjectRef of mob.
--   - ***pos:*** Position of node to replace.
--   - ***oldnode:*** Current node.
--   - ***newnode:*** What the node will become after replacing.
-- - Returns: (***bool***) If ***false*** is returned, the mob will not replace the node.
-- - By default, replacing sets ***self.gotten*** to ***true*** and resets the object properties.
--
-- @tfield table replace_what
-- - Group if items to replace (e.g. {"farming:wheat_8", "farming:carrot_8"}).
-- - Updated to use tables for what, with an y_offset. Example:
-- <pre>
-- replace_what = {
--     {"group:grass", "air", 0}, {"default:dirt_with_grass", "default:dirt", -1},
-- }
-- </pre>
--
-- @tfield string replace_with Replace with what (e.g. ***air*** or in chickens case ***mobs:egg***).
-- @tfield int replace_rate How random should the replace rate be (typically 10).
-- @field replace_offset +/- value to check specific node to replace.
--
-- ***ANIMATION***
--
-- ---
-- Mob animation comes in three parts, start_frame, end_frame and frame_speed which
-- can be added to the mob definition under pre-defined mob animation names like:
--
--      '*_loop' bool value to determine if any set animation loops e.g (die_loop = false)
--      defaults to true if not set
-- also  'speed_normal' for compatibility with older mobs for animation speed (deprecated)
-- @tfield table animation
-- - Animation ranges and speed of the model.
-- - Fields:
--   - ***stand_start, stand_end, stand_speed:*** When mob stands still.
--   - ***walk_start, walk_end, walk_speed:*** When mob walks.
--   - ***run_start, run_end, run_speed:*** When mob runs.
--   - ***fly_start, fly_end, fly_speed:*** When mob flies.
--   - ***punch_start, punch_end, punch_speed:*** When mob attacks.
--   - ***punch2_start, punch2_end, punch2_speed:*** When mob attacks (alternative).
--   - ***die_start, die_end, die_speed:*** When mob dies.


--- Definition table for [umobs.mobsRegisterArrow](#umobs.mobsRegisterArrow).
--
-- @table umobs.mobsRegisterArrow.def
-- @tfield string visual Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity)
-- @tfield size visual_size Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity)
-- @tfield table textures Same as in [minetest.register_entity](http://dev.minetest.net/minetest.register_entity)
-- @field velocity Velocity of the arrow.
-- @tfield bool drop If ***true***, any arrows hitting a node will drop as item.
-- @tfield callback hit_player
-- - Called when the arrow hits a player (should hurt the player).
-- - Usage: ***hit_player = function(self, player)***
-- - Parameters:
--   - ***self:***
--   - ***player***
--
-- @tfield callback hit_mob
-- - Called when the arrow hits a mob (should hurt the mob).
-- - Usage: ***hit_mobs(self, player)***
-- - Parameters:
--   - ***self:***
--   - ***player:***
--
-- @tfield callback hit_node
-- - Called when the arrow hits a node.
-- - Usage: ***hit_node = function(self, pos, node)***
-- - Parameters:
--   - ***self:***
--   - ***pos:***
--   - ***node:***
--
-- @tfield int tail When set to ***1*** adds a trail or tail to mob arrows.
-- @tfield string tail_texture Texture used for **tail** effect.
-- @tfield int tail_size Has size for **tail*** texture (default: between 5 and 10).
-- @tfield float expire How long tail appears for (default: 0.25).
-- @tfield int glow Value for how brightly tail glows. Can be between 0 to 10 (default: 0).
-- @tfield int rotate Degrees to rotate arrow.
-- @tfield callback on_step
-- - A custom function when arrow is active.
-- - Default: ***nil***


--- Mobs Redo Settings.
--
-- @section mobs_redo_s


--- Enable damage.
--
-- If ***true***, monsters will attack players.
--
-- @setting enable_damage
-- - Type: ***bool***
-- - Default: ***true***

--- Only peaceful mobs.
--
-- If ***true***, only animals will spawn in game.
--
-- @setting only_peaceful_mobs
-- - Type: ***bool***
-- - Default: ***false***

--- Disable blood.
--
-- If ***false***, blood effects appear when mob is hit.
--
-- @setting mobs_disable_blood
-- - Type: ***bool***
-- - Default: ***false***

--- Spawn in protected areas.
--
-- If set to ***1***, mobs will not spawn in protected areas.
--
-- @setting mobs_spawn_protected
-- - Type: ***int***
-- - Default: ***0***

--- Remove far mobs.
--
-- If ***true***, mobs that are outside players visual range will be removed.
--
-- @setting remove_far_mobs
-- - Type: ***bool***
-- - Default: ***false***

--- Settings for specific mobs.
--
-- Can change specific mob chance rate (0 to disable) and spawn number (e.g. ***mobs_animal:cow = 1000,5***).
--
-- @setting mobname

--- Mob difficulty.
-- 
-- Sets difficulty level (health and hit damage multiplied by this number).
--
-- @setting mob_difficulty
-- - Type: ***float***
-- - Default: ***1.0***

--- Show mob health.
--
-- If ***false*** then punching mob will not show health status.
--
-- @setting mob_show_health
-- - Type: ***bool***
-- - Default: ***true***


--- Mobs Redo Notes.
--
-- @section mobs_redo_notes


--- These variables need to be set before using the mobs functions:
--
-- - `self.v2:` Toggle switch used to define below values for the first time.
-- - `self.max_speed_forward:` Max speed mob can move forward.
-- - `self.max_speed_reverse:` Max speed mob can move backwards.
-- - `self.accel:` Acceleration speed.
-- - `self.terrain_type:` Integer containing terrain mob can walk on:
--   - ***1:*** water
--   - ***2:*** water/land???
--   - ***3:*** land
-- - `self.driver_attach_at:` Position offset for attaching player to mob.
-- - `self.driver_eye_offset:` Position offset for attached player view.
-- - `self.driver_scale:` Sets driver scale for mobs larger than {x=1, y=1}.
--
-- @notes Variables


--- Mobs Redo Examples.
--
-- @section mobs_redo_examples


--- Rideable horse.
--
-- Example of how to register a rideable horse:
-- <pre>
-- mobs:register_mob("mob_horse:horse", {
--     type = "animal",
--     visual = "mesh",
--     visual_size = {x = 1.20, y = 1.20},
--     mesh = "mobs_horse.x",
--     collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.25, 0.4},
--     animation = { 
--         speed_normal = 15,
--         speed_run = 30,
--         stand_start = 25,
--         stand_end = 75,
--         walk_start = 75,
--         walk_end = 100,
--         run_start = 75,
--         run_end = 100,
--     },
--     textures = {
--         {"mobs_horse.png"},
--         {"mobs_horsepeg.png"},
--         {"mobs_horseara.png"}
--     },
--     fear_height = 3,
--     runaway = true,
--     fly = false,
--     walk_chance = 60,
--     view_range = 5,
--     follow = {"farming:wheat"},
--     passive = true,
--     hp_min = 12,
--     hp_max = 16,
--     armor = 200,
--     lava_damage = 5,
--     fall_damage = 5,
--     water_damage = 1,
--     makes_footstep_sound = true,
--     drops = {
--         {name = "mobs:meat_raw", chance = 1, min = 2, max = 3}
--     },
--     do_custom = function(self, dtime)
--         \-- set needed values if not already present
--         if not self.v2 then
--         \-- elf.v2 = 0
--             self.max_speed_forward = 6
--             self.max_speed_reverse = 2
--             self.accel = 6
--             self.terrain_type = 3
--             self.driver_attach_at = {x = 0, y = 20, z = -2}
--             self.driver_eye_offset = {x = 0, y = 3, z = 0}
--             self.driver_scale = {x = 1, y = 1}
--         end
--         \-- if driver present allow control of horse
--         if self.driver then
--             mobs.drive(self, "walk", "stand", false, dtime)
--            return false \-- skip rest of mob functions
--         end
--          return true
--     end,
--     on_die = function(self, pos)
--         \-- drop saddle when horse is killed while riding
--         \-- also detach from horse properly
--         if self.driver then
--             minetest.add_item(pos, "mobs:saddle")
--             mobs.detach(self.driver, {x = 1, y = 0, z = 1})
--         end
--     end,
--     on_rightclick = function(self, clicker)
--         \-- make sure player is clicking
--         if not clicker or not clicker:is_player() then
--             return
--         end
--         \-- feed, tame or heal horse
--         if mobs:feed_tame(self, clicker, 10, true, true) then
--             return
--         end
--         \-- make sure tamed horse is being clicked by owner only
--         if self.tamed and self.owner == clicker:get_player_name() then
--             local inv = clicker:get_inventory()
--             \-- detatch player already riding horse
--             if self.driver and clicker == self.driver then
--                 mobs.detach(clicker, {x = 1, y = 0, z = 1})
--                 \-- add saddle back to inventory
--                 if inv:room_for_item("main", "mobs:saddle") then
--                     inv:add_item("main", "mobs:saddle")
--                 else
--                     minetest.add_item(clicker.getpos(), "mobs:saddle")
--                 end
--             \-- attach player to horse
--             elseif not self.driver
--             and clicker:get_wielded_item():get_name() == "mobs:saddle" then
--                 self.object:set_properties({stepheight = 1.1})
--                 mobs.attach(self, clicker)
--                 \-- take saddle from inventory
--                 inv:remove_item("main", "mobs:saddle")
--             end
--         end
--         \-- used to capture horse with magic lasso
--         mobs:capture_mob(self, clicker, 0, 0, 80, false, nil)
--     end
-- })
-- </pre>
--
-- @examples Horse
