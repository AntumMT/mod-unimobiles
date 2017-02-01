-- Nmobs init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local check = {
  {'armor', 'table', false},
  {'attacks_player', 'number', false},
  {'collisionbox', 'table', false},
  {'damage', 'number', false},
  {'environment', 'table', false},
  {'hit_dice', 'number', false},
  {'looks_for', 'table', false},
  {'lifespan', 'number', false},
  {'name', 'string', true},
  {'nodebox', 'table', true},
  {'rarity', 'number', false},
  {'run_speed', 'number', false},
  {'size', 'number', false},
  {'textures', 'table', false},
  {'vision', 'number', false},
  {'walk_speed', 'number', false},
  {'weapon_capabilities', 'table', false},
}


local liquids = {}
local nonliquids = {}
for _, n in pairs(minetest.registered_nodes) do
  if n.groups and n.groups.liquid then
    liquids[n.name] = true
  else
    nonliquids[#nonliquids+1] = n.name
  end
end


function nmobs_mod.step(self, dtime)
  self:_fall()

  self._last_step = self._last_step + dtime
  if self._last_step < 1 then
    return
  end

  if not self._born or ((minetest.get_gametime() - self._born) > (self._lifespan or 300)) then
    print('Nmobs: removing a '..self._name..'.')
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


function nmobs_mod.fight(self)
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
    self.object:set_velocity({x=0,y=0,z=0})
    self._target:punch(self.object, 1, self._weapon_capabilities, nil)
  else
    self._destination = self._target:get_pos()
    self:_travel(self._run_speed)
  end
end


function nmobs_mod.aggressive_behavior(self)
  if self._attacks_player then
    local prey = self:_find_prey()
    if prey then
      self._target = prey
      self._state = 'fighting'
      return true
    end
  end
end


function nmobs_mod.walk(self)
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


function nmobs_mod.flee(self)
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
    print('turning to fight')
    self._state = 'fighting'
  end
end


function nmobs_mod.stand(self)
  if self:_aggressive_behavior() then
    return
  end

  self.object:set_velocity({x=0,y=0,z=0})
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


function nmobs_mod.travel(self, speed)
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


function nmobs_mod.new_destination(self, dtype, object)
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


function nmobs_mod.fall(self)
  --local acc = self.object:get_acceleration()
  local acc = {x=0,y=0,z=0}
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

  if bug then
    local armor = self.object:get_armor_groups()
    local time_frac = 1
    local adj_damage
    if tool_capabilities and tool_capabilities.damage_groups then
      time_frac = math.limit(time_from_last_punch / tool_capabilities.full_punch_interval, 0, 1)
      for grp, dmg in pairs(tool_capabilities.damage_groups) do
        if not adj_damage then
          adj_damage = 0
        end

        adj_damage = adj_damage + dmg * time_frac * (armor[grp] or 0) / 100
      end
    end

    if not adj_damage then
      adj_damage = damage
    end

    hp = math.max(0, math.ceil(hp - adj_damage))
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
  self.object:set_armor_groups(self._armor_groups)

  if not self._born then
    self._born = minetest.get_gametime()
    self._lifespan = self._lifespan - dtime_s
    local pos = vector.round(self.object:get_pos())

    local hp = 0
    for i = 1, self._hit_dice do
      hp = hp + math.random(8)
    end
    self.object:set_hp(hp)
    print('Nmobs: activated a '..self._name..' with '..hp..' HP at ('..pos.x..','..pos.y..','..pos.z..'). Duration: '..self._lifespan)
  end
end


function nmobs_mod.abm_callback(name, pos, node, active_object_count, active_object_count_wider)
  local proto = nmobs_mod.mobs[name]
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
      print('Nmobs: missing '..att[1])
      return
    end

    if def[att[1]] and type(def[att[1]]) == att[2] then
      good_def[att[1]] = def[att[1]]
    end
  end

  local name = good_def.name:gsub('^.*:', '')
  good_def.size = good_def.size or 1

  if not good_def.textures then
    local t = {
      'nmobs_'..name..'_top.png',
      'nmobs_'..name..'_bottom.png',
      'nmobs_'..name..'_right.png',
      'nmobs_'..name..'_left.png',
      'nmobs_'..name..'_front.png',
      'nmobs_'..name..'_back.png',
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

  if not good_def.armor then
    good_def.armor = {fleshy = 100}
  end

  local environment
  if good_def.looks_for and not environment then
    environment = table.copy(good_def.looks_for)
  end

  local proto = {
    collide_with_objects = true,
    collisionbox = cbox,
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
    _rarity = (good_def.rarity or 10000),
    _run_speed = (good_def.run_speed or 3),
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

  if environment then
    minetest.register_abm({
      nodenames = environment,
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
