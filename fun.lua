--
-- Easily register different spell types & shapes
--

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

local golden_apple       = "iadiscordia:golden_apple"
local kallisti           = "iadiscordia:kallisti"
local stick              = "default:stick"
local apple              = "default:apple"
local bucket_water       = "bucket:bucket_water"
local bucket_empty       = "bucket:bucket_empty"
local bucket_river_water = "bucket:bucket_river_water"
local bucket_lava        = "bucket:lava"
local mese_crystal       = "default:mese_crystal"
local obsidian_shard     = "default:obsidian_shard"
local diamond            = "default:diamond"
local gold_lump          = "default:gold_lump"
local torch              = "default:torch"
local ice                = "default:ice"
local basic_flame        = "fire:basic_flame"
local ice_slab           = "stairs:slab_ice"
local poop_turd          = "pooper:poop_turd"
local poop_pile          = "pooper:poop_pile"

local apple_rad          = 5
local rps_duration       = 30
local flood_rad          = 10
local bonemeal_rad       = 10

iadiscordia.caster_collides = function(pos, np)
	      np   = vector.round(np)
	local pos0 = vector.round(pos)
	local pos1 = vector.add  (pos, {x=0, y=1, z=0})
	      pos1 = vector.round(pos1)
	if vector.equals(np, pos0) then return true end
	if vector.equals(np, pos1) then return true end
	return false
end

iadiscordia.register_inventory_spell = function(src, dst, callback)
	assert(src ~= nil)
	assert(dst ~= nil)
	iadiscordia.register_spell(src, {
		password="Feed me, Seymour!",
		callback=function(user)
			local inv = user:get_inventory()
			local sz  = inv:get_size("main")
			for i=1,sz do
				local stack = inv:get_stack("main", i)
				if stack:is_empty() then
					local new_stack = ItemStack(dst.." 1")
					--stack:set_name("default:apple")
					--stack:set_count(1)
					inv:set_stack("main", i, new_stack)
				end
			end

			if callback ~= nil then
				callback(user:get_pos())
			end

			return dst
		end,
	})
end

iadiscordia.register_item_spell = function(src, dst, callback)
	assert(src ~= nil)
	assert(dst ~= nil)
	iadiscordia.register_spell(src, {
		password="Feed the world",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = apple_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"air",})
			for _,np in ipairs(nps) do
				minetest.add_item(np, ItemStack(dst.." 1"))
			end

			if callback ~= nil then
				callback(user:get_pos())
			end
			--return src
			return dst
		end,
	})
end


-- TODO maybe use gold
if minetest.get_modpath("default") then
	iadiscordia.register_day_spell = function(password, time)
		iadiscordia.register_spell(mese_crystal, {
			password=password,
			callback=function(user)
				minetest.set_timeofday(time)
			end,
		})
	end
end

-- TODO maybe use silver
if  minetest.get_modpath("moon_phases")
and minetest.get_modpath("default") then
	iadiscordia.register_moon_spell = function(password, phase)
		iadiscordia.register_spell(obsidian_shard, {
			password=password,
			callback=function(user)
				moon_phases.set_phase(phase)
			end,
		})
	end
end

if minetest.get_modpath("bonemeal") then
	local nodes        = {"group:dirt", "group:sand", "group:soil", "group:flora", "group:can_bonemeal",} -- TODO rip more types from bonemeal/mods.lua
	iadiscordia.register_bonemeal_spell = function(src, bonemeal)
		iadiscordia.register_spell(src, {
			password="Grow",
			callback=function(user)
				local rad    = bonemeal_rad
				local minp   = vector.subtract(pos, rad)
				local maxp   = vector.add     (pos, rad)
				local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
				for _,np in ipairs(nps) do
					bonemeal:on_use(np, bonemeal, nil)
				end
				return ""
			end,
		})
	end
end

iadiscordia.register_flood_spell = function(src, dst, find, node, callback, password, check_collision)
	iadiscordia.register_spell(src, {
		password=password,
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, find)
			for _,np in ipairs(nps) do
				if not check_collision
				or not iadiscordia.caster_collides(pos, np) then
					minetest.set_node(np, {name=node,})
				end
			end

			if callback ~= nil then
				callback(user:get_pos())
			end

			return dst
		end,
	})
end

iadiscordia.register_pond_spell = function(src, dst, node, callback, range)
	iadiscordia.register_spell(src, {
		password="Pond",
		callback=function(user)
			local pos    = user:get_pos()
			local rnd    = vector.round(pos)
			for dx=-flood_rad,flood_rad do
				for dz=-flood_rad,flood_rad do
					if range ~= nil and math.sqrt(dx*dx + dz*dz) <= range then
						-- within striking range
					else
					local x = rnd.x + dx
					local z = rnd.z + dz
					local my_y = nil
					for y=rnd.y-flood_rad,rnd.y+flood_rad do
						local p    = {x=x, y=y, z=z}
						local node = minetest.get_node(p)
						if node.name == "air" then
							my_y = y - 1
							--my_y = y
							break
						end
					end
					if my_y == nil then
						my_y   = math.random(-flood_rad, flood_rad)
					end
					local p    = {x=x, y=my_y, z=z}
					minetest.set_node(p, {name=node,})
					end
				end
			end

			if callback ~= nil then
				callback(user:get_pos())
			end
			
			return dst
		end
	})
end

iadiscordia.register_avalanche_spell = function(src, callback, offset)
	iadiscordia.register_spell(src, {
		password="Avalanche",
		callback=function(user)
			local pos    = user:get_pos()
			local rnd    = vector.round(pos)
			for dx=-flood_rad,flood_rad do
				for dz=-flood_rad,flood_rad do
					if math.sqrt(dx*dx + dz*dz) <= 5 then -- TODO parametrize
						-- within striking range
					else
					local x = rnd.x + dx
					local z = rnd.z + dz
					local my_y = nil
					for y=rnd.y+flood_rad,rnd.y-flood_rad,-1 do
						local p    = {x=x, y=y, z=z}
						local node = minetest.get_node(p)
						if node.name == "air" then
							if offset then
								my_y = y + 1
							else
								my_y = y
							end
							break
						end
					end
					if my_y == nil then
						my_y   = math.random(-flood_rad, flood_rad)
					end
					local p    = {x=x, y=my_y, z=z}
					--print("spawning poo: "..dump(p))
					minetest.set_node(p, {name=src,})
					minetest.spawn_falling_node(p)
				end
				end
			end

			if callback ~= nil then
				callback(user:get_pos())
			end

			return ""
		end
	})
end

--iadiscordia.register_floor_spell = function(src, callback, offset)
--	iadiscordia.register_spell(src, {
--		password="Walker, Texas Ranger",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					if math.sqrt(dx*dx + dz*dz) <= 5 then -- TODO parametrize
--						-- within striking range
--					else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y-flood_rad,rnd.y+flood_rad do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							if offset then
--								my_y = y - 1
--							else
--								my_y = y
--							end
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					minetest.set_node(p, {name=src,})
--					end
--				end
--			end
--
--			if callback ~= nil then
--				callback(user:get_pos())
--			end
--
--			return ""
--		end
--	})
--end

iadiscordia.register_rps_spell = function(password, safe_mode, lose_mode, message)
	iadiscordia.register_spell(kallisti, {        
		password=password,
		callback=function(user)
			local function helper()
				local players = minetest.get_connected_players()
				for _,player in ipairs(players) do
					local meta = player:get_meta()
					local rps  = meta:get_string("rps")
					if rps ~= nil and rps == safe_mode then
						-- safe
					elseif rps ~= nil and rps == lose_mode then -- paper punches rock
						iadiscordia.chat_send_user(user, message)
                				user:punch(player, 1.0, {
                    					full_punch_interval=1.0,
                    					damage_groups={fleshy=damage},
                				}, nil)
					else
						iadiscordia.chat_send_user(user, S("Rock, paper, scissors"))
                				player:punch(user, 1.0, {
                    					full_punch_interval=1.0,
                    					damage_groups={fleshy=damage},
                				}, nil)
					end
				end
			end
			local meta = user:get_meta()
			meta:set_string("rps", safe_mode)
			for t=1,rps_duration do
				minetest.after(t, helper)
			end
		end,
	})
end

