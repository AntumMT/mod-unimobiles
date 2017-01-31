-- Nmobs init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local check = {
  {'collisionbox', 'table', false},
  {'looks_for', 'table', false},
  {'name', 'string', true},
  {'nodebox', 'table', true},
  {'run_speed', 'number', false},
  {'size', 'number', false},
  {'textures', 'table', false},
  {'walk_speed', 'number', false},
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
  self._last_step = 0

  if self._state == 'traveling' then
    self:_travel(self._walk_speed)
  else -- standing
    self:_stand()
  end
end


function nmobs_mod.stand(self)
  self.object:set_velocity({x=0,y=0,z=0})
  self._destination = nil

  if math.random(10) == 1 then
    self._destination = self:_new_destination('looks_for')
    if self._destination then
      self._state = 'traveling'
    else
      print('Nmobs: Error finding destination')
    end
  end
end


function nmobs_mod.travel(self, speed)
  if not self._destination or math.random(20) == 1 then
    self._state = 'standing'
    return
  end

  local pos = self.object:get_pos()
  pos.y = pos.y + self.collisionbox[2]
  if vector.distance(pos, self._destination) < 2 then
    self._state = 'standing'
    return
  end

  local target

  -- Why doesn't this ever work?
  local path -- = minetest.find_path(pos,self._destination,10,2,2,'A*_noprefetch')
  if path then
    print('pathing')
    target = path[1]
  else
    target = self._destination
  end

  local dir = nmobs_mod.dir_to_target(pos, target) + math.random() * 0.5 - 0.25
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


function nmobs_mod.new_destination(self, dtype)
  local dest
  local pos = self.object:get_pos()
  pos.y = pos.y + self.collisionbox[2]

  if dtype == 'looks_for' and self._looks_for then
    local minp = vector.subtract(pos, 10)
    local maxp = vector.add(pos, 10)

    local nodes = minetest.find_nodes_in_area(minp, maxp, self._looks_for)
    if nodes and #nodes > 0 then
      dest = nodes[math.random(#nodes)]
    end
  end

  if (not dest or math.random(10) == 1) and not self._aquatic then
    local minp = vector.subtract(pos, 15)
    local maxp = vector.add(pos, 15)
    local nodes = minetest.find_nodes_in_area_under_air(minp, maxp, nonliquids)
    if nodes and #nodes > 0 then
      dest = nodes[math.random(#nodes)]
    end
  end

  return dest
end


function nmobs_mod.fall(self)
  local acc = self.object:get_acceleration()
  local pos = self.object:get_pos()
  local node = minetest.get_node_or_nil(pos)
  local gravity = 3
  --print(dump(node))
  if node and liquids[node.name] then
    if acc.y < 0 then
      acc.y = acc.y / 2
    end
    gravity = -1
  end
  self.object:set_acceleration({x=0, y=acc.y-gravity, z=0})
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

  local proto = {
    --collide_with_objects = true,
    collisionbox = cbox,
    _last_step = 0,
    _looks_for = good_def.looks_for,
    on_step = nmobs_mod.step,
    physical = true,
    stepheight = 1.1,
    textures = {'nmobs:'..name..'_block',},
    visual = 'wielditem',
    visual_size = sz,
    _fall = nmobs_mod.fall,
    _new_destination = nmobs_mod.new_destination,
    _run_speed = (good_def.run_speed or 1),
    _stand = nmobs_mod.stand,
    _state = 'standing',
    _travel = nmobs_mod.travel,
    _walk_speed = (good_def.walk_speed or 1),
  }

  minetest.register_node(proto.textures[1], node)
  minetest.register_entity('nmobs:'..name, proto)
end
