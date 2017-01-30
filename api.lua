-- Nmobs init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local check = {
  {'collisionbox', 'table', false},
  {'looks_for', 'table', false},
  {'name', 'string', true},
  {'nodebox', 'table', true},
  {'size', 'number', false},
  {'textures', 'table', false},
}


local liquids = {}
for _, n in pairs(minetest.registered_nodes) do
  if n.groups and n.groups.liquid then
    liquids[n.name] = true
  end
end


function nmobs_mod.step(self, dtime)
  self._last_step = self._last_step + dtime
  if self._last_step < 1 then
    return
  end
  self._last_step = 0

  self:_walk()
  self:_fall()
end


function nmobs_mod.walk(self)
  local v = {x=0, y=0, z=0}
  local dir = 0
  local spd = 1

  if self._looks_for then
    local pos = self.object:get_pos()
    pos.y = pos.y + self.collisionbox[2]
    local minp = vector.subtract(pos, 10)
    local maxp = vector.add(pos, 10)
    if self._destination and (math.random(20) == 1 or vector.distance(pos, self._destination) < 2) then
      self._destination = nil
    end
    if not self._destination then
      local nodes = minetest.find_nodes_in_area(minp, maxp, self._looks_for)
      if nodes and #nodes > 0 then
        self._destination = nodes[math.random(#nodes)]
      end
    end
    if self._destination then
      local target
      local path -- = minetest.find_path(pos,self._destination,10,2,2,'A*_noprefetch')
      if path then
        print('pathing')
        target = path[1]
      else
        target = self._destination
      end

      if target then
        local direction = vector.direction(pos, target)
        --print(dump(direction))
        dir = (math.atan(direction.z / direction.x) + math.pi / 2)
        if target.x > pos.x then
          dir = dir + math.pi
        end
        --print(dir)
        dir = dir + math.random() * 0.5 - 0.25
      end
      --print(vector.distance(pos, self._destination))
    end
  end

  if dir == 0 then
    dir = math.random() * 2 * math.pi
  end

  self.object:set_yaw(dir)
  v.x = - spd * math.sin(dir)
  v.z = spd * math.cos(dir)
  self.object:set_velocity(v)
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
    _walk = nmobs_mod.walk,
  }

  minetest.register_node(proto.textures[1], node)
  minetest.register_entity('nmobs:'..name, proto)
end
