-- Nmobs init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local check = {
  {'armor_class', 'number', false},
  {'attacks_player', 'boolean', false},
  {'collisionbox', 'table', false},
  {'damage', 'number', false},
  {'environment', 'table', false},
  {'higher_than', 'number', false},
  {'hit_dice', 'number', false},
  {'looks_for', 'table', false},
  {'lower_than', 'number', false},
  {'lifespan', 'number', false},
  {'media_prefix', 'string', false},
  {'name', 'string', true},
  {'nodebox', 'table', true},
  {'nocturnal', 'boolean', false},
  {'rarity', 'number', false},
  {'run_speed', 'number', false},
  {'sound', 'string', false},
  {'size', 'number', false},
  {'textures', 'table', false},
  {'vision', 'number', false},
  {'walk_speed', 'number', false},
  {'weapon_capabilities', 'table', false},
}

local skip_serializing = {}
skip_serializing['_last_pos'] = true
skip_serializing['_destination'] = true
skip_serializing['_target'] = true

local null_vector = {x=0,y=0,z=0}


local liquids = {}
local nonliquids = {}
for _, n in pairs(minetest.registered_nodes) do
  if n.groups and n.groups.liquid then
    liquids[n.name] = true
  else
    nonliquids[#nonliquids+1] = n.name
  end
end


local damage_multiplier = {}
if elixirs_mod and elixirs_mod.damage_multiplier then
  damage_multiplier = elixirs_mod.damage_multiplier
end


function nmobs_mod.step(self, dtime)
  self:_fall()

  self._last_step = self._last_step + dtime
  if self._last_step < 1 then
    return
  end

  if not self._born or ((minetest.get_gametime() - self._born) > (self._lifespan or 300)) then
    --print('Nmobs: removing a '..self._name..'.')
    self.object:remove()
    return
  end

  self._last_step = 0

  --print(self._state)
  if self._state == 'traveling' then
    self:_walk()
  elseif self._state == 'fleeing' then
    self:_flee()
  elseif self._state == 'fighting' then
    self:_fight()
  else -- standing
    self:_stand()
  end

  self:_noise()
end


function nmobs_mod.find_prey(self)
  local prey = {}
  for _, player in pairs(minetest.get_connected_players()) do
    local opos = player:getpos()
    if vector.distance(self._last_pos, opos) < self._vision then
      prey[#prey+1] = player
    end
  end
  if #prey > 0 then
    return prey[math.random(#prey)]
  end
end


function nmobs_mod.noise(self)  -- self._noise
  local odds = 100
  local sound

  if self._sound then
    sound = self._sound
  end

  if self._state == 'fleeing' then
    odds = 5
    sound = self._sound_scared or sound
  elseif self._state == 'fighting' then
    odds = 10
    sound = self._sound_angry or sound
  elseif self._state == 'standing' then
    odds = 50
  end

  if sound and math.random(odds) == 1 then
    --print('noise: '..sound)
    minetest.sound_play(sound, {object = self.object})
  end
end


function nmobs_mod.fight(self)  -- self._fight
  if not self._target then
    self._state = 'standing'
    return
  end

  local opos = self._target:get_pos()
  if vector.distance(self._last_pos, opos) > self._vision then
    self._target = nil
    self._state = 'standing'
    return
  elseif vector.distance(self._last_pos, opos) < self._run_speed then
    self.object:set_velocity(null_vector)
    self._target:punch(self.object, 1, self._weapon_capabilities, nil)
  else
    self._destination = self._target:get_pos()
    self:_travel(self._run_speed)
  end
end


function nmobs_mod.aggressive_behavior(self)  -- self._aggressive_behavior
  if self._attacks_player then
    local prey = self:_find_prey()
    if prey then
      self._target = prey
      self._state = 'fighting'
      return true
    end
  end
end


function nmobs_mod.walk(self)  -- self._walk
  if self:_aggressive_behavior() then
    return
  end

  if not self._destination then
    self._state = 'standing'
    return
  end

  local pos = self._last_pos
  pos.y = pos.y + self.collisionbox[2]
  if math.random(20) == 1 or vector.distance(pos, self._destination) < 1 + self._walk_speed then
    self._state = 'standing'
    return
  end

  self:_travel(self._walk_speed)
end


function nmobs_mod.flee(self)  -- self._flee
  if not self._target then
    self._state = 'standing'
    return
  end

  local velocity = self.object:get_velocity()
  local speed = velocity.x + velocity.y + velocity.z

  local pos = self._last_pos
  local opos = self._target:get_pos()
  if vector.distance(pos, opos) > 50 then
    self._state = 'standing'
    return
  end

  if not self._destination or speed < self._run_speed / 2 then
    self._destination = self:_new_destination('flee', self._target)
  end

  if self._destination then
    pos.y = pos.y + self.collisionbox[2]
    if vector.distance(pos, self._destination) < 1 + speed then
      self._destination = nil
      return
    end

    self:_travel(self._run_speed)
  else
    --print('turning to fight')
    self._state = 'fighting'
  end
end


function nmobs_mod.stand(self)  -- self._stand
  if self:_aggressive_behavior() then
    return
  end

  self.object:set_velocity(null_vector)
  self._destination = nil

  if math.random(10) == 1 then
    self._destination = self:_new_destination('looks_for')
    if self._destination then
      self._state = 'traveling'
      return
    else
      self._destination = self:_new_destination()
      if self._destination then
        self._state = 'traveling'
        return
      else
        print('Nmobs: Error finding destination')
      end
    end
  end
end


function nmobs_mod.travel(self, speed)  -- self._travel
  local target

  -- Why doesn't this ever work?
  local path -- = minetest.find_path(pos,self._destination,10,2,2,'A*_noprefetch')
  if path then
    print('pathing')
    target = path[1]
  else
    target = self._destination
  end

  local dir = nmobs_mod.dir_to_target(self._last_pos, target) + math.random() * 0.5 - 0.25
  --print(vector.distance(pos, self._destination))

  local v = {x=0, y=0, z=0}
  self.object:set_yaw(dir)
  v.x = - speed * math.sin(dir)
  v.z = speed * math.cos(dir)
  self.object:set_velocity(v)
end


function nmobs_mod.dir_to_target(pos, target)
  local direction = vector.direction(pos, target)
  --print(dump(direction))

  local dir = (math.atan(direction.z / direction.x) + math.pi / 2)
  if target.x > pos.x then
    dir = dir + math.pi
  end
  --print(dir)

  return dir
end


function nmobs_mod.new_destination(self, dtype, object)  -- self._new_destination
  local dest
  local pos = self._last_pos
  pos.y = pos.y + self.collisionbox[2]

  if dtype == 'looks_for' and self._looks_for then
    local minp = vector.subtract(pos, 10)
    local maxp = vector.add(pos, 10)

    local nodes = minetest.find_nodes_in_area(minp, maxp, self._looks_for)
    if nodes and #nodes > 0 then
      dest = nodes[math.random(#nodes)]
    end

    return dest
  end

  if dtype == 'flee' and object then
    local opos = object:get_pos()
    local toward = vector.add(pos, vector.direction(opos, pos))
    local minp = vector.subtract(toward, 15)
    local maxp = vector.add(toward, 15)
    local nodes = minetest.find_nodes_in_area_under_air(minp, maxp, nonliquids)
    if nodes and #nodes > 0 then
      dest = nodes[math.random(#nodes)]
    end

    return dest
  end

  if (not dest or math.random(10) == 1) and not self._aquatic then
    local minp = vector.subtract(pos, 15)
    local maxp = vector.add(pos, 15)
    local nodes = minetest.find_nodes_in_area_under_air(minp, maxp, nonliquids)
    if nodes and #nodes > 0 then
      dest = nodes[math.random(#nodes)]
    end

    return dest
  end
end


function nmobs_mod.fall(self)  -- self._fall
  --local acc = self.object:get_acceleration()
  local acc = null_vector
  local pos = self.object:get_pos()
  local node = minetest.get_node_or_nil(pos)
  local gravity = 10

  self._last_pos = pos

  pos.y = pos.y - self.collisionbox[5]
  pos = vector.round(pos)
  --print(dump(node))
  if node and liquids[node.name] then
    --if acc.y < 0 then
    --  acc.y = acc.y / 2
    --end
    gravity = -1
  else
    --if acc.y > 0 then
    --  acc.y = acc.y / 2
    --end
  end
  self.object:set_acceleration({x=0, y=acc.y-gravity, z=0})
end


function nmobs_mod.take_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
  --print(dump(puncher))
  --print(self.object:get_hp())
  --print(damage)
  --print(dump(tool_capabilities))
  --print(dump(self.object:get_armor_groups()))
  --self.object:set_hp(self.object:get_hp() - damage)
  local hp = self.object:get_hp()
  local bug = true -- bug in minetest code prevents damage calculation

  local e_mult = 1
  local player_name
  if puncher and puncher.get_player_name then
    player_name = puncher:get_player_name()
    e_mult = damage_multiplier[player_name] or 1
  end

  if bug or e_mult ~= 1 then
    local armor = self.object:get_armor_groups()
    local time_frac = 1
    local adj_damage
    if tool_capabilities and tool_capabilities.damage_groups then
      time_frac = math.limit(time_from_last_punch / tool_capabilities.full_punch_interval, 0, 1)
      for grp, dmg in pairs(tool_capabilities.damage_groups) do
        if not adj_damage then
          adj_damage = 0
        end

        adj_damage = adj_damage + dmg * time_frac * e_mult * (armor[grp] or 0) / 100
        --print('Nmobs: adj_damage ('..grp..') -- '..adj_damage)
      end
    end

    if not adj_damage then
      adj_damage = damage
    end

    --print('Nmobs: adj_damage -- '..adj_damage)
    -- * display damage *

    adj_damage = math.floor(adj_damage + 0.5)

    if player_name then
      minetest.chat_send_player(player_name, 'You did '..adj_damage..' damage.')
    end

    hp = math.max(0, hp - adj_damage)
    self.object:set_hp(hp)
  else
    hp = hp - damage
  end

  if hp < 1 then
    if bug then
      self.object:remove()
    end
    -- ** drop code **
  end

  --print('hp down to '..(hp - damage))
  self._target = puncher
  if puncher and puncher:is_player() and vector.distance(self._last_pos, puncher:get_pos()) > self._vision then
    self._state = 'fleeing'
  elseif hp < 10 then
    --print('should flee')
    self._state = 'fleeing'
  else
    self._state = 'fighting'
  end

  return bug
end


function nmobs_mod.activate(self, staticdata, dtime_s)
  if staticdata then
    local data = minetest.deserialize(staticdata)
    if data and type(data) == 'table' then
      for k, d in pairs(data) do
        self[k] = d
      end
    end
  end

  self.object:set_armor_groups(self._armor_groups)
  self._state = 'standing'
  self.object:set_velocity(null_vector)
  if self._hp then
    self.object:set_hp(self._hp)
  end

  if not self._born then
    self._born = minetest.get_gametime()
    --self._lifespan = self._lifespan - dtime_s
    local pos = vector.round(self.object:get_pos())

    local hp = 0
    for i = 1, self._hit_dice do
      hp = hp + math.random(8)
    end
    self._hp = hp
    self.object:set_hp(hp)
    print('Nmobs: activated a '..self._name..' with '..hp..' HP at ('..pos.x..','..pos.y..','..pos.z..'). Game time: '..self._born)
  end

  if self._sound then
    minetest.sound_play(self._sound, {object = self.object})
  end
end

function nmobs_mod.get_staticdata(self)
  local data = {}

  self._hp = self.object:get_hp()

  for k, d in pairs(self) do
    if k:find('^_') and not skip_serializing[k] and not nmobs_mod.mobs[self._name][k] then
      --print('serializing '..k)
      data[k] = d
    end
  end

  --print('serialized data length: '..minetest.serialize(data):len())
  return minetest.serialize(data)
end


function nmobs_mod.abm_callback(name, pos, node, active_object_count, active_object_count_wider)
  local proto = nmobs_mod.mobs[name]
  if proto.lower_than and pos.y >= proto.lower_than then
    return
  end
  if proto.higher_than and pos.y <= proto.higher_than then
    return
  end
  if proto.nocturnal then
    local time = minetest.get_timeofday()
    if time > 0.15 and time < 0.65 then
      return
    end
  end

  local pos_above = {x=pos.x, y=pos.y+3, z=pos.z}
  local node_above = minetest.get_node_or_nil(pos_above)
  if node_above and node_above.name == 'air' and active_object_count < 3 then
    minetest.add_entity(pos_above, 'nmobs:'..name)
  end
end


function nmobs_mod.register_mob(def)
  local good_def = {}

  for _, att in pairs(check) do
    if att[3] and not def[att[1]] then
      print('Nmobs: registration missing '..att[1])
      return
    end

    if def[att[1]] and type(def[att[1]]) == att[2] then
      good_def[att[1]] = def[att[1]]
    end
  end

  local name = good_def.name:gsub('^.*:', '')
  good_def.size = good_def.size or 1

  if not good_def.media_prefix then
    good_def.media_prefix = 'nmobs'
  end
  if not good_def.textures then
    local t = {
      good_def.media_prefix..'_'..name..'_top.png',
      good_def.media_prefix..'_'..name..'_bottom.png',
      good_def.media_prefix..'_'..name..'_right.png',
      good_def.media_prefix..'_'..name..'_left.png',
      good_def.media_prefix..'_'..name..'_front.png',
      good_def.media_prefix..'_'..name..'_back.png',
    }

    good_def.textures = t
  end

  local node = {
    drawtype = 'nodebox',
    node_box = {
      type = 'fixed',
      fixed = good_def.nodebox,
    },
    tiles = good_def.textures,
  }

  local cbox = good_def.collisionbox
  if not cbox then
    -- measure nodebox
    cbox = {999, 999, 999, -999, -999, -999} 
    for _, box in pairs(good_def.nodebox) do
      for i = 1, 3 do
        if box[i] < cbox[i] then
          cbox[i] = box[i]
        end
      end
      for i = 4, 6 do
        if box[i] > cbox[i] then
          cbox[i] = box[i]
        end
      end
    end
    cbox[1] = (cbox[1] + cbox[3]) / 2
    cbox[4] = (cbox[4] + cbox[6]) / 2
    cbox[3] = cbox[1]
    cbox[6] = cbox[4]
  end

  local sz = {x=0.66, y=0.66, z=0.66}  -- Why aren't objects the same size as nodes?
  sz = vector.multiply(sz, good_def.size)
  for i = 1, #cbox do
    cbox[i] = cbox[i] * good_def.size
  end

  if not good_def.damage then
    good_def.damage = 1
  end
  if not good_def.weapon_capabilities then
    good_def.weapon_capabilities = {
      full_punch_interval=1,
      damage_groups = {fleshy=good_def.damage},
    }
  end

  if not good_def.armor_class then
    good_def.armor = {fleshy = 100}
  elseif good_def.armor_class > 0 then
    good_def.armor = {fleshy = good_def.armor_class * 10}
  else
    good_def.armor_class = math.max(good_def.armor_class, -8)
    good_def.armor = {fleshy = 9 + good_def.armor_class}
  end

  if good_def.armor_class then
    print(name..' AC: '..good_def.armor_class..', armor: '..good_def.armor['fleshy'])
  end

  if good_def.looks_for and not good_def.environment then
    good_def.environment = table.copy(good_def.looks_for)
  elseif good_def.environment and not good_def.looks_for then
    good_def.looks_for = table.copy(good_def.environment)
  end

  local proto = {
    collide_with_objects = true,
    collisionbox = cbox,
    get_staticdata = nmobs_mod.get_staticdata,
    hp_max = 2,
    hp_min = 1,
    on_activate = nmobs_mod.activate,
    on_step = nmobs_mod.step,
    on_punch = nmobs_mod.take_punch,
    physical = true,
    stepheight = 1.1,
    textures = {'nmobs:'..name..'_block',},
    visual = 'wielditem',
    visual_size = sz,
    _aggressive_behavior = nmobs_mod.aggressive_behavior,
    _armor_groups = good_def.armor,
    _attacks_player = good_def.attacks_player,
    _damage = good_def.damage,
    _environment = good_def.environment,
    _fall = nmobs_mod.fall,
    _fight = nmobs_mod.fight,
    _find_prey = nmobs_mod.find_prey,
    _flee = nmobs_mod.flee,
    _hit_dice = (good_def.hit_dice or 1),
    _last_step = 0,
    _lifespan = (good_def.lifespan or 300),
    _looks_for = good_def.looks_for,
    _name = name,
    _new_destination = nmobs_mod.new_destination,
    _noise = nmobs_mod.noise,
    _rarity = (good_def.rarity or 20000),
    _run_speed = (good_def.run_speed or 3),
    _sound = good_def.sound,
    _stand = nmobs_mod.stand,
    _state = 'standing',
    _target = nil,
    _travel = nmobs_mod.travel,
    _vision = (good_def.vision or 15),
    _walk = nmobs_mod.walk,
    _walk_speed = (good_def.walk_speed or 1),
    _weapon_capabilities = good_def.weapon_capabilities,
  }

  nmobs_mod.mobs[name] = proto

  minetest.register_node(proto.textures[1], node)
  minetest.register_entity('nmobs:'..name, proto)

  if proto._environment then
    minetest.register_abm({
      nodenames = proto._environment,
      neighbors = {'air'},
      interval = 30,
      chance = proto._rarity,
      catch_up = false,
      action = function(...)
        nmobs_mod.abm_callback(name, ...)
      end,
    })
  end
end
