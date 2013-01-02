-------------------------------------------------------------------------------
-- Mob Framework Mod by Sapier
-- 
-- You may copy, use, modify or do nearly anything except removing this
-- copyright notice. 
-- And of course you are NOT allow to pretend you have written it.
--
--! @file inventory.lua
--! @brief component containing mob inventory related functions
--! @copyright Sapier
--! @author Sapier
--! @date 2013-01-02
--
--! @defgroup inventory inventory subcomponent
--! @brief Component handling mob inventory
--! @ingroup framework_int
--! @{
-- Contact sapier a t gmx net
-------------------------------------------------------------------------------

--! @class mob_inventory
--! @brief inventory features
mob_inventory = {}

--!@}
mob_inventory.trader_inventories = {}
mob_inventory.formspecs = {}


-------------------------------------------------------------------------------
-- name: allow_move(inv, from_list, from_index, to_list, to_index, count, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param from_list name of list elements taken 
--! @param from_index index at list elements taken
--! @param to_list list name of list elements being put
--! @param to_index index at list elements being put
--! @param count number of elements moved
--! @param player doing changes
--
--! @return number of elements allowed to move
-------------------------------------------------------------------------------
function mob_inventory.allow_move(inv, from_list, from_index, to_list, to_index, count, player)

	dbg_mobf.trader_inv_lvl1("MOBF: move inv: " .. tostring(inv) .. " from:" .. dump(from_list) .. 
								" to: " .. dump(to_list))
	if to_list ~= "selection" or
		from_list == "price_1" or 
		from_list == "price_2" or
		from_list == "pay" or
		from_list == "takeaway" or
		from_list == "identifier" then
		return 0
	end

	return count
end

-------------------------------------------------------------------------------
-- name: allow_put(inv, listname, index, stack, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param listname name of list changed
--! @param index index in list changed
--! @param stack moved
--! @param player doing changes
--
--! @return number of elements allowed to put
-------------------------------------------------------------------------------
function mob_inventory.allow_put(inv, listname, index, stack, player)
	dbg_mobf.trader_inv_lvl1("MOBF: put inv: " .. tostring(inv) .. " to:" .. dump(listname))
	
	if listname == "pay" then
		return 99
	end
	
	return 0
end

-------------------------------------------------------------------------------
-- name: allow_take(inv, listname, index, stack, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param listname name of list changed
--! @param index index in list changed
--! @param stack moved
--! @param player doing changes
--
--! @return number of elements allowed to take
-------------------------------------------------------------------------------
function mob_inventory.allow_take(inv, listname, index, stack, player)
	dbg_mobf.trader_inv_lvl1("MOBF: take inv: " .. tostring(inv) .. " to:" .. dump(listname))
	
	if listname == "takeaway" or
		listname == "pay" then
		return 99
	end
	return 0
end

-------------------------------------------------------------------------------
-- name: on_move(inv, from_list, from_index, to_list, to_index, count, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param from_list name of list elements taken 
--! @param from_index index at list elements taken
--! @param to_list list name of list elements being put
--! @param to_index index at list elements being put
--! @param count number of elements moved
--! @param player doing changes
-------------------------------------------------------------------------------
function mob_inventory.on_move(inv, from_list, from_index, to_list, to_index, count, player)
	dbg_mobf.trader_inv_lvl1("MOBF: inv\"" .. tostring(inv) .. "\" moving " .. count .. " items from: " .. from_list .. ":" .. from_index .. " to: " .. to_list .. ":" .. to_index)

	if from_list == "goods" and
		to_list == "selection" then
		
		local moved = inv.get_stack(inv,to_list, to_index)
		
		local elements = moved.get_count(moved)
		
		if elements > 1 then
			moved = moved.take_item(moved,elements-1)
			inv.set_stack(inv,from_list, from_index, moved)
			inv.set_stack(inv,to_list, to_index, moved)
		else
			inv.set_stack(inv,from_list, from_index, moved)
		end
		
		local entity = mob_inventory.get_entity(inv)
		
		if entity == nil then
			dbg_mobf.trader_inv_lvl1("MOBF: move unable to find linked entity")
			return
		end
		
		local goodname = moved.get_name(moved)
		dbg_mobf.trader_inv_lvl1("MOBF: good selected: " .. goodname)
		
		--get element put to selection
		mob_inventory.fill_prices(entity,inv,goodname)
		mob_inventory.update_takeaway(inv)
	end
end

-------------------------------------------------------------------------------
-- name: on_put(inv, listname, index, stack, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param listname name of list changed
--! @param index index in list changed
--! @param stack moved
--! @param player doing changes
-------------------------------------------------------------------------------
function mob_inventory.on_put(inv, listname, index, stack, player)
	if listname == "pay" then
		local now_at_pay = inv.get_stack(inv,"pay",1)
		local playername = player.get_player_name(player)
		local count = now_at_pay.get_count(now_at_pay)
		local name  = now_at_pay.get_name(now_at_pay)
		dbg_mobf.trader_inv_lvl1("MOBF: putpay player: " .. playername .. " pays now count=" .. count .. " of type=" ..name)
		
		mob_inventory.update_takeaway(inv)
	end
end



-------------------------------------------------------------------------------
-- name: on_take(inv, listname, index, stack, player)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inv inventory reference
--! @param listname name of list changed
--! @param index index in list changed
--! @param stack moved
--! @param player doing changes
-------------------------------------------------------------------------------
function mob_inventory.on_take(inv, listname, index, stack, player)
	if listname == "takeaway" then
		local now_at_pay = inv.get_stack(inv,"pay",index)
		local playername = player.get_player_name(player)
		local count = now_at_pay.get_count(now_at_pay)
		local name  = now_at_pay.get_name(now_at_pay)
		dbg_mobf.trader_inv_lvl2("MOBF: takeaway player: " .. playername .. " pays now count=" .. count .. " of type=" ..name)
		
		if not mob_inventory.check_pay(inv,true) then
			dbg_mobf.trader_inv_lvl1("MOBF: error player hasn't payed enough!")
		end
		
		mob_inventory.update_takeaway(inv)
	end
	
	if listname == "pay" then
		if mob_inventory.check_pay(inv,false) then
			local selection = inv.get_stack(inv,"selection", 1)
			
			if selection ~= nil then
				inv.set_stack(inv,"takeaway",1,selection)
			else
				dbg_mobf.trader_inv_lvl1("MOBF: nothing selected to buy")
			end
		else
			inv.set_stack(inv,"takeaway",1,nil)
		end
	end
end


-------------------------------------------------------------------------------
-- name: update_takeaway(inv)
--
--! @brief update content of takeaway
--! @memberof mob_inventory
--
--! @param inventory to check
-------------------------------------------------------------------------------
function mob_inventory.update_takeaway(inv)
	if mob_inventory.check_pay(inv,false) then
		local selection = inv.get_stack(inv,"selection", 1)
		
		if selection ~= nil then
			inv.set_stack(inv,"takeaway",1,selection)
		else
			dbg_mobf.trader_inv_lvl1("MOBF: nothing selected to buy")
		end
	else
		inv.set_stack(inv,"takeaway",1,nil)
	end
end

-------------------------------------------------------------------------------
-- name: check_pay(inv)
--
--! @brief check if there is enough at payroll
--! @memberof mob_inventory
--
--! @param inventory to check
--
--! @return true/false
-------------------------------------------------------------------------------
function mob_inventory.check_pay(inv,paynow)
	local now_at_pay = inv.get_stack(inv,"pay",1)
	local count = now_at_pay.get_count(now_at_pay)
	local name  = now_at_pay.get_name(now_at_pay)
	
	local price1 = inv.get_stack(inv,"price_1", 1)
	local price2 = inv.get_stack(inv,"price_2", 1)
	
	if price1.get_name(price1) == name then
		local price = price1.get_count(price1)
		if price <= count then
			if paynow then
				now_at_pay.take_item(now_at_pay,price)
				inv.set_stack(inv,"pay",1,now_at_pay)
				return true
			else
				return true
			end
		else
			if paynow then
				inv.set_stack(inv,"pay",1,nil)
			end
		end
	end
		
	if price1.get_name(price2) == name then
		local price = price1.get_count(price2)
		if price <= count then
			if paynow then
				now_at_pay.take_item(now_at_pay,price)
				inv.set_stack(inv,"pay",1,now_at_pay)
				return true
			else
				return true
			end
		else
			if paynow then
				inv.set_stack(inv,"pay",1,nil)
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------
-- name: init_detached_inventories(entity,now)
--
--! @brief initialize dynamic data required by harvesting
--! @memberof mob_inventory
--
--! @param entity mob to initialize harvest dynamic data
--! @param now current time
-------------------------------------------------------------------------------
function mob_inventory.init_trader_inventory(entity)
	--TODO find out why calling "tostring" is necessary?!
	local tradername       = tostring(entity.data.trader_inventory.random_names[math.random(1,#entity.data.trader_inventory.random_names)])
	dbg_mobf.trader_inv_lvl3("MOBF: randomly selected \"" .. tradername .. "\" as name")
	local unique_entity_id = string.gsub(tostring(entity),"table: ","")
	--local unique_entity_id = "testinv"
	local trader_inventory = minetest.create_detached_inventory(unique_entity_id,
	{
		allow_move 	= mob_inventory.allow_move,
		allow_put 	= mob_inventory.allow_put,
		allow_take 	= mob_inventory.allow_take,
	
		on_move 	= mob_inventory.on_move,
		on_put 		= mob_inventory.on_put,
		on_take 	= mob_inventory.on_take,
	})
	
	trader_inventory.set_size(trader_inventory,"goods",16)
	trader_inventory.set_size(trader_inventory,"takeaway",1)
	trader_inventory.set_size(trader_inventory,"selection",1)
	trader_inventory.set_size(trader_inventory,"price_1",1)
	trader_inventory.set_size(trader_inventory,"price_2",1)
	trader_inventory.set_size(trader_inventory,"pay",1)
	
	--TODO dirty workaround
	trader_inventory.set_size(trader_inventory,"identifier",1)
	trader_inventory.set_stack(trader_inventory,"identifier",1,unique_entity_id .. " 1")
	
	local identifier_item_stack = trader_inventory.get_stack(trader_inventory,"identifier", 1)
	local identifier  = identifier_item_stack.get_name(identifier_item_stack)
	dbg_mobf.trader_inv_lvl3("MOBF: added identifier item: " .. identifier)
	
	
	mob_inventory.add_goods(entity,trader_inventory)
	
	--register to trader inventories
	table.insert(mob_inventory.trader_inventories, {
										identifier 	= unique_entity_id,
										inv_ref 	= trader_inventory,
										ent_ref 	= entity,
										})
	dbg_mobf.trader_inv_lvl3("MOBF: registering identifier: " .. unique_entity_id .. " invref \"" .. tostring(trader_inventory) .. "\"  for entity \"" .. tostring(entity) .. "\"" )

	local trader_formspec = "size[8,10;]" ..
			"label[2,0;Trader " .. tradername .. " Inventory]" .. 
			"label[0,1;Selling:]" ..
			"list[detached:" .. unique_entity_id .. ";goods;0,1.5;8,2;]" ..
			"label[0,4.0;Selection]" ..
			"list[detached:" .. unique_entity_id .. ";selection;0,4.5;1,1;]" ..
			"label[1.25,4.75;-->]" ..
			"label[2,4.0;Price]" ..
			"list[detached:" .. unique_entity_id .. ";price_1;2,4.5;1,1;]" ..
			"label[3,4.0;or]" ..
			"list[detached:" .. unique_entity_id .. ";price_2;3,4.5;1,1;]" ..
			"label[4.25,4.75;-->]" ..
			"label[5,4.0;Pay]" ..
			"list[detached:" .. unique_entity_id .. ";pay;5,4.5;1,1;]" ..
			"label[6.25,4.75;-->]" ..
			"label[6.75,4.0;Takeaway]" ..
			"list[detached:" .. unique_entity_id .. ";takeaway;7,4.5;1,1;]" ..
			"list[current_player;main;0,6;8,4;]"
			
	if mob_inventory.register_formspec("formspec_" .. unique_entity_id,trader_formspec) == false then
		dbg_mobf.trader_inv_lvl1("MOBF: unable to create trader formspec")
	end
end


-------------------------------------------------------------------------------
-- name: config_check(entity)
--
--! @brief check if mob is configured as trader
--! @memberof mob_inventory
--
--! @param entity mob being checked
--! @return true/false if trader or not
-------------------------------------------------------------------------------
function mob_inventory.config_check(entity)
	if entity.data.trader_inventory ~= nil then
		return true
	end
	
	return false
end

-------------------------------------------------------------------------------
-- name: register_formspec(name,formspec)
--
--! @brief check if mob is configured as trader
--! @memberof mob_inventory
--
--! @param entity mob being checked
--! @return true/false if succesfull or not
-------------------------------------------------------------------------------
function mob_inventory.register_formspec(name,formspec)

	if mob_inventory.formspecs[name] == nil then
		mob_inventory.formspecs[name] = formspec
		return true
	end

	return false
end

-------------------------------------------------------------------------------
-- name: callback(entity,player,now)
--
--! @brief callback handler for harvest by player
--! @memberof mob_inventory
--
--! @param entity mob being harvested
--! @param player player harvesting
--! @param now the current time
--! @return true/false if handled by harvesting or not
-------------------------------------------------------------------------------
function mob_inventory.trader_callback(entity,player)
	local unique_entity_id = string.gsub(tostring(entity),"table: ","")
	--local unique_entity_id = "testinv"
	local playername = player.get_player_name(player)
	
	if mob_inventory.formspecs["formspec_" .. unique_entity_id] ~= nil then
		if minetest.show_formspec(playername,mob_inventory.formspecs["formspec_" .. unique_entity_id]) == false then
			dbg_mobf.trader_inv_lvl1("MOBF: unable to show trader formspec")
		end
	end
end

-------------------------------------------------------------------------------
-- name: get_entity(inv)
--
--! @brief find entity linked to inventory
--! @memberof mob_inventory
--
--! @param inv name of inventory
-------------------------------------------------------------------------------
function mob_inventory.get_entity(inv)
	dbg_mobf.trader_inv_lvl3("MOBF: checking " .. #mob_inventory.trader_inventories .. " registred inventorys")
	
	--TODO this is a dirty workaround
	local identifier_item_stack = inv.get_stack(inv,"identifier", 1)
	local identifier  = identifier_item_stack.get_name(identifier_item_stack)
	
	
	for i=1,#mob_inventory.trader_inventories,1 do
		dbg_mobf.trader_inv_lvl3("MOBF: comparing \"" .. identifier .. "\" to \"" .. mob_inventory.trader_inventories[i].identifier .. "\"")
		if mob_inventory.trader_inventories[i].identifier == identifier then
			return mob_inventory.trader_inventories[i].ent_ref
		end
	end
	
	return nil
end

-------------------------------------------------------------------------------
-- name: fill_prices(entity,inventory,goodname)
--
--! @brief fill price fields
--! @memberof mob_inventory
--
--! @param entity to look for prices
--! @param inventory to set prices
--! @param goodname name of good to set prices for
-------------------------------------------------------------------------------
function mob_inventory.fill_prices(entity,inventory,goodname)

	--get price info from entity
	local good = nil
	
	for i=1,#entity.data.trader_inventory.goods,1 do
		local stackstring = goodname .. " 1"
		dbg_mobf.trader_inv_lvl3("MOBF: comparing \"" .. stackstring .. "\" to \"" .. entity.data.trader_inventory.goods[i][1] .. "\"")
		if entity.data.trader_inventory.goods[i][1] == stackstring then
			good = entity.data.trader_inventory.goods[i]
		end
	end
	
	if good ~= nil then
		inventory.set_stack(inventory,"price_1", 1, good[2])
		inventory.set_stack(inventory,"price_2", 1, good[3])
	end
end

-------------------------------------------------------------------------------
-- name: add_goods(entity,trader_inventory)
--
--! @brief fill inventory with mobs goods
--! @memberof mob_inventory
--
--! @param entity to look for prices
--! @param trader_inventory to put goods
-------------------------------------------------------------------------------
function mob_inventory.add_goods(entity,trader_inventory)
	dbg_mobf.trader_inv_lvl3("MOBF: adding " .. #entity.data.trader_inventory.goods .. " goods for trader")
	for i=1,#entity.data.trader_inventory.goods,1 do
		dbg_mobf.trader_inv_lvl3("MOBF:\tadding " .. entity.data.trader_inventory.goods[i][1])
		trader_inventory.add_item(trader_inventory,"goods",entity.data.trader_inventory.goods[i][1])
	end

end