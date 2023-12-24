local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

--
-- Golden Apple & Kallisti
--

local golden_apple = "iadiscordia:golden_apple"
local kallisti     = "iadiscordia:kallisti"
local stick        = "default:stick"
local apple        = "default:apple"

if minetest.get_modpath("default") then
	local apples = {
		golden_apple = apple,
		kallisti     = golden_apple,
	}
	for src,dst in pairs(apples) do
		iadiscordia.register_inventory_spell(src, dst, nil)
--		iadiscordia.register_spell(src, {
--			password="Feed me, Seymour!",
--			callback=function(user)
--				local inv = user:get_inventory()
--				local sz  = inv:get_size("main")
--				for i=1,sz do
--					local stack = inv:get_stack("main", i)
--					if stack:is_empty() then
--						local new_stack = ItemStack(dst.." 1")
--						--stack:set_name("default:apple")
--						--stack:set_count(1)
--						inv:set_stack("main", i, new_stack)
--					end
--				end
--	
--				return dst
--			end,
--		})

		iadiscordia.register_item_spell(src, dst, nil)
--		iadiscordia.register_spell(src, {
--			password="Apples",
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rad    = 5
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"air",})
--				for _,np in ipairs(nps) do
--					minetest.add_item(np, ItemStack(dst.." 1"))
--				end
--	
--				--return src
--				return dst
--			end,
--		})
	end
	-- TODO convert nodes in area to apples
end

--
-- Lightning
--

if  minetest.get_modpath("lightning")
and minetest.get_modpath("default") then
	local copper_ingot  = "default:copper_ingot"
	local lightning_rad = 15
	--iadiscordia.register_spell(copper_ingot, {
	iadiscordia.register_spell(stick, {
		password="Smite me",
		callback=function(user)
			local pos    = user:get_pos()
			lightning.strike(pos)
			return ""
		end,
	})

	--iadiscordia.register_spell(copper_ingot, {
	iadiscordia.register_spell(stick, {
		password="Storm",
		callback=function(user)
			local function helper()
				while true do
					local pos    = user:get_pos()
					local rnd    = vector.round(pos)
					local x      = pos.x + math.random(-lightning_rad, lightning_rad)
					local z      = pos.z + math.random(-lightning_rad, lightning_rad)
					local dx     = x - pos.x
					local dz     = z - pos.z
					if math.sqrt(dx*dx + dz*dz) <= 5 then
						-- within striking range
					else
						local my_y = nil
						for y=rnd.y-lightning_rad,rnd.y+lightning_rad do
							local p    = {x=x, y=y, z=z}
							local node = minetest.get_node(p)
							if node.name == "air" then
								--my_y = y - 1
								my_y = y
								break
							end
						end
						if my_y == nil then
							my_y   = math.random(-lightning_rad, lightning_rad)
						end
						local p    = {x=x, y=my_y, z=z}
						local res  = lightning.strike(p)
						if res then
							print("helper() strike "..dump(p))
							--break
						else
							print("helper() miss "..dump(p))
						end
						break
					end
				end
			end

			--local lightning_cnt = 10
			--local cnt    = 1
			--local function timer()
			--	cnt = cnt + 1
			--	if cnt <= lightning_cnt then
			--		minetest.after(1, timer)
			--	end
			--end
				
			local lightning_cnt = 30
			for cnt=1,lightning_cnt do
				minetest.after(cnt, helper)
			end
			return ""
		end,
	})

	iadiscordia.register_spell(stick, {
		password="Chain Lightning",
		callback=function(user)
			local function helper()
				local pos     = user:get_pos()
				local players = minetest.get_connected_players()
				local targets = {}
				for _,objref in ipairs(players) do
					local objpos = objref:get_pos()
					if vector.distance(pos, objpos) <= 5 then
						-- within striking range
					else
						table.insert(targets, objpos) -- TODO sorted
					end
				end
				local i       = math.random(1, #targets)
				local target  = targets[i]
				lightning.strike(target)
			end

			local lightning_cnt = 30
			for cnt=1,lightning_cnt do
				minetest.after(cnt, helper)
			end
			helper()
			return ""
		end,
	})

	iadiscordia.register_spell(stick, {
		password="Forked Lightning",
		callback=function(user)
			local pos     = user:get_pos()
			local players = minetest.get_connected_players()
			local targets = {}
			for _,objref in ipairs(players) do
				local objpos = objref:get_pos()
				if vector.distance(pos, objpos) <= 5 then
					-- within striking range
				else
					--table.insert(targets, objpos) -- TODO sorted
					table.insert(targets, objref) -- TODO sorted
				end
			end
			local i       = math.random(1, #targets)
			local target  = targets[i]

			local function helper()
				--lightning.strike(target)
				local objpos = target:get_pos()
				if vector.distance(pos, objpos) <= 5 then
					-- within striking range
				else
					lightning.strike(objpos)
				end
			end

			local lightning_cnt = 30
			for cnt=1,lightning_cnt do
				minetest.after(cnt, helper)
			end
			helper()
			return ""
		end,
	})

	iadiscordia.register_spell(stick, {
		password="Ignite", -- TODO might need to be on a timer
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = lightning_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:flammable",})
			for _,np in ipairs(nps) do
				if vector.distance(pos, np) <= 5 then
					-- within striking range
				else
					lightning.strike(np)
				end
			end

			return ""
		end,
	})

	iadiscordia.register_spell(stick, {
		password="Toaster in the bathtub",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = lightning_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:liquid", "group:water",})
			for _,np in ipairs(nps) do
				if vector.distance(pos, np) <= 5 then
					-- within striking range
				else
					lightning.strike(np)
				end
			end

			return ""
		end,
	})
end

--
-- Tides and Floods
--

local bucket_water       = "bucket:bucket_water"
local bucket_empty       = "bucket:bucket_empty"
local bucket_river_water = "bucket:bucket_river_water"
local bucket_lava        = "bucket:lava"
if  minetest.get_modpath("tidesandfloods")
and minetest.get_modpath("bucket") then
	local flood_rad = 10
	iadiscordia.register_spell(bucket_water, {
		password="Noah's Ark",
		callback=function(user)
			tidesandfloods.water_level = tidesandfloods.water_level + flood_rad
		end,
	})
	iadiscordia.register_spell(bucket_empty, {
		password="Noah's Ark",
		callback=function(user)
			tidesandfloods.water_level = tidesandfloods.water_level - flood_rad
		end,
	})
	iadiscordia.register_spell(bucket_water, {
		password="Reset",
		callback=function(user)
			tidesandfloods.water_level = 0
		end,
	})
	iadiscordia.register_spell(bucket_empty, {
		password="Reset",
		callback=function(user)
			tidesandfloods.water_level = 0
		end,
	})
end

--
-- Sum Air Currents
--

if  minetest.get_modpath("sum_air_currents")
and minetest.get_modpath("default") then
	iadiscordia.register_spell(stick, {
		password="Windy",
		callback=function(user)
			sum_air_currents.wind_speed = sum_air_currents.max_wind_speed
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Calm",
		callback=function(user)
			sum_air_currents.wind_speed = 0
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Random Wind",
		callback=function(user)
			sum_air_currents.wind_speed = math.random(0, sum_air_currents.max_wind_speed)
		end,
	})
end

--
-- Time of Day
--

local mese_crystal   = "default:mese_crystal"
local obsidian_shard = "default:obsidian_shard"
-- TODO maybe just use mese or gold for manipulating the sun cycles
if minetest.get_modpath("default") then
--	iadiscordia.register_day_spell = function(password, time)
--		iadiscordia.register_spell(mese_crystal, {
--			password=password,
--			callback=function(user)
--				minetest.set_timeofday(time)
--			end,
--		})
--	end
	iadiscordia.register_day_spell("Morning",  0.25)
	iadiscordia.register_day_spell("Midday",   0.5)
	iadiscordia.register_day_spell("Evening",  0.75)
	iadiscordia.register_day_spell("Midnight", 0.0)
--	iadiscordia.register_spell(mese_crystal, {
--		password="Morning",
--		callback=function(user)
--			minetest.set_timeofday(0.25)
--		end,
--	})
--	iadiscordia.register_spell(mese_crystal, {
--		password="Midday",
--		callback=function(user)
--			minetest.set_timeofday(0.5)
--		end,
--	})
--	iadiscordia.register_spell(mese_crystal, {
--		password="Evening",
--		callback=function(user)
--			minetest.set_timeofday(0.75)
--		end,
--	})
--	iadiscordia.register_spell(mese_crystal, {
--		password="Midnight",
--		callback=function(user)
--			minetest.set_timeofday(0.0)
--		end,
--	})
end

--
-- Convert Expensive Items
--

local diamond   = "default:diamond"
local gold_lump = "default:gold_lump"
if minetest.get_modpath("default") then
	iadiscordia.register_replacement(mese_crystal,   gold_lump,      "All that glitters is gold")
	iadiscordia.register_replacement(diamond,        gold_lump,      "All that glitters is gold")
	iadiscordia.register_replacement(obsidian_shard, gold_lump,      "All that glitters is gold")

	iadiscordia.register_replacement(mese_crystal,   diamond,        "Diamonds are forever")
	iadiscordia.register_replacement(gold_lump,      diamond,        "Diamonds are forever")
	iadiscordia.register_replacement(obsidian_shard, diamond,        "Diamonds are forever")

	iadiscordia.register_replacement(mese_crystal,   obsidian_shard, "I want it painted black")
	iadiscordia.register_replacement(diamond,        obsidian_shard, "I want it painted black")
	iadiscordia.register_replacement(gold_lump,      obsidian_shard, "I want it painted black")

	iadiscordia.register_replacement(diamond,        mese_crystal,   "I've got the power")
	iadiscordia.register_replacement(gold_lump,      mese_crystal,   "I've got the power")
	iadiscordia.register_replacement(obsidian_shard, mese_crystal,   "I've got the power")
end

--
-- Moon Phases
--

-- TODO maybe use silver
if  minetest.get_modpath("moon_phases")
and minetest.get_modpath("default") then
--	iadiscordia.register_moon_spell = function(password, phase)
--		iadiscordia.register_spell(obsidian_shard, {
--			password=password,
--			callback=function(user)
--				moon_phases.set_phase(phase)
--			end,
--		})
--	end
	iadiscordia.register_moon_spell("Waxing Crescent", 1)
	iadiscordia.register_moon_spell("First Quarter",   2)
	iadiscordia.register_moon_spell("Waxing Gibbous",  3)
	iadiscordia.register_moon_spell("Full Moon",       4)
	iadiscordia.register_moon_spell("Waning Gibbous",  5)
	iadiscordia.register_moon_spell("Third Quarter",   6)
	iadiscordia.register_moon_spell("Waning Crescent", 7)
	iadiscordia.register_moon_spell("New Moon",        8)

--	iadiscordia.register_spell(obsidian_shard, {
--		password="Waxing Crescent",
--		callback=function(user)
--			moon_phases.set_phase(1)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="First Quarter",
--		callback=function(user)
--			moon_phases.set_phase(2)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="Waxing Gibbous",
--		callback=function(user)
--			moon_phases.set_phase(2)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="Full Moon",
--		callback=function(user)
--			moon_phases.set_phase(4)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="Waning Gibbous",
--		callback=function(user)
--			moon_phases.set_phase(5)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="Third Quarter",
--		callback=function(user)
--			moon_phases.set_phase(6)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="Waning Crescent",
--		callback=function(user)
--			moon_phases.set_phase(7)
--		end,
--	})
--	iadiscordia.register_spell(obsidian_shard, {
--		password="New Moon",
--		callback=function(user)
--			moon_phases.set_phase(8)
--		end,
--	})
end

--
-- Permissions
--

if minetest.get_modpath("playerplus") then
	iadiscordia.register_spell(stick, {
		password="Knockback Off",
		callback=function(user)
			local name  = user:get_player_name()
			--local privs = minetest.get_player_privs(name)
			--privs = table.copy(privs)
			--privs.no_knockback = true
			minetest.set_player_privs(name, { no_knockback = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Knockback On",
		callback=function(user)
			local name  = user:get_player_name()
			--local privs = minetest.get_player_privs(name)
			--privs = table.copy(privs)
			--privs.no_knockback = true
			minetest.set_player_privs(name, { no_knockback = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Knockback",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { no_knockback = not priv.no_knockback, })
		end,
	})
end

if minetest.get_modpath("adv_lightsabers") then
	local kyber_crystal = "adv_lightsabers:kyber_crystal"
	iadiscordia.register_spell(kyber_crystal, {
		password="Jedi",
		callback=function(user)
			local name = user:get_player_name()
			minetest.set_player_privs(name, { force_abilities = true, })
		end
	})
	iadiscordia.register_spell(kyber_crystal, {
		password="Squib",
		callback=function(user)
			local name = user:get_player_name()
			minetest.set_player_privs(name, { force_abilities = false, })
		end
	})
	iadiscordia.register_spell(kyber_crystal, {
		password="Force",
		callback=function(user)
			local name = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { force_abilities = not priv.force_abilities, })
		end
	})
end

if minetest.get_modpath("locks") then
	iadiscordia.register_spell(stick, {
		password="Dig Locks On",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { diglocks = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Dig Locks Off",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { diglocks = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Dig Locks",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { diglocks = not priv.diglocks, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks On",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { openlocks = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks Off",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { openlocks = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { openlocks = not priv.openlocks, })
		end,
	})
end

--
-- Cross
--

if  minetest.get_modpath("church_cross")
and minetest.get_modpath("iadecor") then
	-- TODO other crosses
	local cross_rad  = 30
	local cross_gold = "church_cross:cross_gold"
	iadiscordia.register_spell(cross_gold, {
		password="Holy",
		callback=function(user)
			local pos   = user:get_pos()
			local rad   = cross_rad
			iamedusa.fix_crosses(pos, rad)
			--local minp  = vector.subtract(pos, rad)
			--local maxp  = vector.add     (pos, rad)
			--local nps,_ = minetest.find_nodes_in_area(minp, maxp, {"group:church_cross",})
			--for _,np in ipairs(nps) do
			--	local node = minetest.get_node(np)
			--	if      0 <= node.param2 and node.param2 <=  3 then
			--		-- already upward
			--	elseif  4 <= node.param2 and node.param2 <=  7 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 -  4})
			--	elseif  8 <= node.param2 and node.param2 <= 11 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 -  8})
			--	elseif 12 <= node.param2 and node.param2 <= 15 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 - 12})
			--	elseif 16 <= node.param2 and node.param2 <= 19 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 - 16})
			--	elseif 20 <= node.param2 and node.param2 <= 23 then
			--		local r = math.random(4,19)
			--		minetest.set_node(np, {name=node.name, param2 = r})
			--		minetest.after(1, minetest.set_node, np, {name=node.name, param2 = node.param2 - 20})
			--	end
			--end
		end,
	})
	iadiscordia.register_spell(cross_gold, {
		password="Unholy",
		callback=function(user)
			local pos   = user:get_pos()
			local rad   = cross_rad
			iamedusa.invert_crosses(pos, rad)
			--local minp  = vector.subtract(pos, rad)
			--local maxp  = vector.add     (pos, rad)
			--local nps,_ = minetest.find_nodes_in_area(minp, maxp, {"group:church_cross",})
			--for _,np in ipairs(nps) do
			--	local node = minetest.get_node(np)
			--	if      0 <= node.param2 and node.param2 <=  3 then
			--		local r = math.random(4,19)
			--		minetest.set_node(np, {name=node.name, param2 = r})
			--		minetest.after(1, minetest.set_node, np, {name=node.name, param2 = node.param2 + 20})
			--	elseif  4 <= node.param2 and node.param2 <=  7 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 + 16})
			--	elseif  8 <= node.param2 and node.param2 <= 11 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 + 12})
			--	elseif 12 <= node.param2 and node.param2 <= 15 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 +  8})
			--	elseif 16 <= node.param2 and node.param2 <= 19 then
			--		minetest.set_node(np, {name=node.name, param2 = node.param2 +  4})
			--	elseif 20 <= node.param2 and node.param2 <= 23 then
			--		-- already downward
			--	end
			--end
		end,
	})
end

local torch = "default:torch"
if  minetest.get_modpath("church_candles")
and minetest.get_modpath("default") then
	local candle_rad = 30
	local church_candles = {}
	church_candles.types = {
        {
                unlit = "church_candles:candle",
                lit = "church_candles:candle_lit",
                --name = "Candle",
                --ingot = nil,
                --image = "church_candles_candle"
        },
                {
                unlit = "church_candles:candle_floor_steel",
                lit = "church_candles:candle_floor_steel_lit",
                --name = "Steel Candle Stick",
                --ingot = items.steel_ingot,
                --image = "church_candles_candle_steel"
        },
        {
                unlit = "church_candles:candle_floor_copper",
                lit = "church_candles:candle_floor_copper_lit",
                --name = "Copper Candle Stick",
                --ingot = items.copper_ingot,
                --image = "church_candles_candle_copper"
        },
        {
                unlit = "church_candles:candle_floor_silver",
                lit = "church_candles:candle_floor_silver_lit",
                --name = "Silver Candle Stick",
                --ingot = items.silver_ingot,
                --image = "church_candles_candle_silver"
        },
        {
                unlit = "church_candles:candle_floor_gold",
                lit = "church_candles:candle_floor_gold_lit",
                --name = "Gold Candle Stick",
                --ingot = items.gold_ingot,
                --image = "church_candles_candle_gold"
        },
        {
                unlit = "church_candles:candle_floor_bronze",
                lit = "church_candles:candle_floor_bronze_lit",
                --name = "Bronze Candle Stick",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candle_bronze"
        },
        {
                unlit = "church_candles:candle_wall_steel",
                lit = "church_candles:candle_wall_steel_lit",
                --name = "Steel Wall-Mount Candle",
                --ingot = items.steel_ingot,
                --image = "church_candles_candle_steel"
        },
        {
                unlit = "church_candles:candle_wall_copper",
                lit = "church_candles:candle_wall_copper_lit",
                --name = "Copper Wall-Mount Candle",
                --ingot = items.copper_ingot,
                --image = "church_candles_candle_copper"
        },
        {
                unlit = "church_candles:candle_wall_silver",
                lit = "church_candles:candle_wall_silver_lit",
                --name = "Silver Wall-Mount Candle",
                --ingot = items.silver_ingot,
                --image = "church_candles_candle_silver"
        },
        {
                unlit = "church_candles:candle_wall_gold",
                lit = "church_candles:candle_wall_gold_lit",
                --name = "Gold Wall-Mount Candle",
                --ingot = items.gold_ingot,
                --image = "church_candles_candle_gold"
        },
        {
                unlit = "church_candles:candle_wall_bronze",
                lit = "church_candles:candle_wall_bronze_lit",
                --name = "Bronze Wall-Mount Candle",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candle_bronze"
        },
        {
                unlit = "church_candles:candelabra_steel",
                lit = "church_candles:candelabra_steel_lit",
                --name = "Steel Candelebra",
                --ingot = items.steel_ingot,
                --image = "church_candles_candelabra_steel"
        },
        {
                unlit = "church_candles:candelabra_copper",
                lit = "church_candles:candelabra_copper_lit",
                --name = "Copper Candelebra",
                --ingot = items.copper_ingot,
                --image = "church_candles_candelabra_copper"
        },
        {
                unlit = "church_candles:candelabra_silver",
                lit = "church_candles:candelabra_silver_lit",
                --name = "Silver Candelebra",
                --ingot = items.silver_ingot,
                --image = "church_candles_candelabra_silver"
        },
        {
                unlit = "church_candles:candelabra_gold",
                lit = "church_candles:candelabra_gold_lit",
                --name = "Gold Candelebra",
                --ingot = items.gold_ingot,
                --image = "church_candles_candelabra_gold"
        },
        {
                unlit = "church_candles:candelabra_bronze",
                lit = "church_candles:candelabra_bronze_lit",
                --name = "Bronze Candelebra",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candelabra_bronze"
        },
	}

	iadiscordia.register_spell(torch, {
		password="Let there be light",
		callback=function(user)
			local tgts = {}
			for _,data in ipairs(church_candles.types) do
				table.insert(tgts, data.unlit)
			end

			local pos   = user:get_pos()
			local rad   = candle_rad
			local minp  = vector.subtract(pos, rad)
			local maxp  = vector.add     (pos, rad)
			local nps,_ = minetest.find_nodes_in_area(minp, maxp, tgts)
			for _,np in ipairs(nps) do
				local node = minetest.get_node(np)
				local def  = minetest.registered_nodes[node.name]
				def.on_punch(np, node, user)
			end
		end,
	})
	iadiscordia.register_spell(torch, {
		password="The Light is a lie; Darkness is Truth",
		callback=function(user)
			local tgts = {}
			for _,data in ipairs(church_candles.types) do
				table.insert(tgts, data.lit)
			end

			local pos   = user:get_pos()
			local rad   = candle_rad
			local minp  = vector.subtract(pos, rad)
			local maxp  = vector.add     (pos, rad)
			local nps,_ = minetest.find_nodes_in_area(minp, maxp, tgts)
			for _,np in ipairs(nps) do
				local node = minetest.get_node(np)
				local def  = minetest.registered_nodes[node.name]
				def.on_punch(np, node, user)
			end
		end,
	})
end

local flood_rad = 10
--iadiscordia.register_flood_spell = function(src, dst, find, node, callback, password, check_collision)
--	iadiscordia.register_spell(src, {
--		password=password,
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rad    = flood_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area(minp, maxp, find)
--			for _,np in ipairs(nps) do
--				if not check_collision
--				or not iadiscordia.caster_collides(pos, np) then
--					minetest.set_node(np, {name=node,})
--				end
--			end
--
--			if callback ~= nil then
--				callback()
--			end
--
--			return dst
--		end,
--	})
--end
--
--iadiscordia.register_pond_spell = function(src, dst, node, callback, range)
--	iadiscordia.register_spell(src, {
--		password="Pond",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					if range ~= nil and math.sqrt(dx*dx + dz*dz) <= range then
--						-- within striking range
--					else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y-flood_rad,rnd.y+flood_rad do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							my_y = y - 1
--							--my_y = y
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					minetest.set_node(p, {name=node,})
--					end
--				end
--			end
--
--			if callback ~= nil then
--				callback()
--			end
--			
--			return dst
--		end
--	})
--end
--
--iadiscordia.register_avalanche_spell = function(src, callback, offset)
--	iadiscordia.register_spell(src, {
--		password="Avalanche",
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
--					for y=rnd.y+flood_rad,rnd.y-flood_rad,-1 do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							if offset then
--								my_y = y + 1
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
--					--print("spawning poo: "..dump(p))
--					minetest.set_node(p, {name=src,})
--					minetest.spawn_falling_node(p)
--				end
--				end
--			end
--
--			if callback ~= nil then
--				callback()
--			end
--
--			return ""
--		end
--	})
--end

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
--				callback()
--			end
--
--			return ""
--		end
--	})
--end

-- TODO magical liquids
local liquids = { "water", "river_water", "lava",}
if  minetest.get_modpath("bucket")
and minetest.get_modpath("default") then
	for _,liquid in ipairs(liquids) do
		iadiscordia.register_flood_spell("bucket:bucket_"..liquid, bucket_empty, {"air",}, "default:"..liquid.."_source", nil, "Flood", true)
--		iadiscordia.register_spell("bucket:bucket_"..liquid, {
--			password="Flood",
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rad    = flood_rad
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"air",})
--				for _,np in ipairs(nps) do
--					if not caster_collides(pos, np) then
--						minetest.set_node(np, {name="default:"..liquid.."_source",})
--					end
--				end
--
--				return bucket_empty
--			end,
--		})
		iadiscordia.register_spell("bucket:bucket_"..liquid, {
			password="Puddle",
			callback=function(user)
				local pos    = user:get_pos()
				      pos.y  = pos.y - 1
				minetest.set_node(pos, {name="default:"..liquid.."_source",})
				return bucket_empty
			end,
		})
		iadiscordia.register_spell(bucket_empty, {
			password="Sponge "..liquid,
			callback=function(user)
				local pos    = user:get_pos()
				local rad    = flood_rad
				local minp   = vector.subtract(pos, rad)
				local maxp   = vector.add     (pos, rad)
				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"default:"..liquid.."_source", "default:"..liquid.."_flowing",})
				for _,np in ipairs(nps) do
					minetest.remove_node(np)
				end

				return "bucket:bucket_"..liquid
			end,
		})
		iadiscordia.register_pond_spell("bucket:bucket_"..liquid, "", "default:"..liquid.."source", nil, false)
--		iadiscordia.register_spell("bucket:bucket_"..liquid, {
--			password="Pond",
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rnd    = vector.round(pos)
--				for dx=-flood_rad,flood_rad do
--					for dz=-flood_rad,flood_rad do
--						--if math.sqrt(dx*dx + dz*dz) <= 5 then
--							-- within striking range
--						--else
--						local x = rnd.x + dx
--						local z = rnd.z + dz
--						local my_y = nil
--						for y=rnd.y-flood_rad,rnd.y+flood_rad do
--							local p    = {x=x, y=y, z=z}
--							local node = minetest.get_node(p)
--							if node.name == "air" then
--								my_y = y - 1
--								--my_y = y
--								break
--							end
--						end
--						if my_y == nil then
--							my_y   = math.random(-flood_rad, flood_rad)
--						end
--						local p    = {x=x, y=my_y, z=z}
--						minetest.set_node(p, {name="default:"..liquid.."source",})
--					end
--				end
--			end
--		})
	end
	iadiscordia.register_spell(bucket_empty, {
		password="Sponge",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:liquid",})
			local node   = nil
			for _,np in ipairs(nps) do
				node = minetest.get_node(np).name
				minetest.remove_node(np)
			end

			if node ~= nil then return node end -- TODO return bucket of liquid

			return bucket_empty
		end,
	})
end

-- TODO magical liquids
local ice = "default:ice"
if minetest.get_modpath("default") then
	local flood_rad = 10
	iadiscordia.register_flood_spell(ice, "", {"group:liquid",}, ice, nil, "Flood", true)
--	iadiscordia.register_spell(ice, {
--		password="Freeze",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rad    = flood_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:liquid",})--{"default:water_source", "default:river_water_source", "default:lava_source",})
--			--local node   = nil
--			for _,np in ipairs(nps) do
--				if not caster_collides(pos, np) then
--			--		node = minetest.get_node(np).name
--					minetest.set_node(np, {name=ice})
--				end
--			end
--
--			--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
--
--			--return ice
--			return ""
--		end,
--	})
	iadiscordia.register_pond_spell(ice, "", ice, nil, false)
--	iadiscordia.register_spell(ice, {
--		password="Pond",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					--if math.sqrt(dx*dx + dz*dz) <= 5 then
--						-- within striking range
--					--else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y-flood_rad,rnd.y+flood_rad do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							my_y = y - 1
--							--my_y = y
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					minetest.set_node(p, {name=ice,})
--				end
--			end
--		end
--	})
	for _,liquid in ipairs(liquids) do
		iadiscordia.register_flood_spell(ice, "", {ice,}, "default:"..liquid.."_source", nil, "Thaw "..liquid, false)
--		--iadiscordia.register_spell("default:"..liquid.."_source", {
--		iadiscordia.register_spell(ice, {
--			password="Thaw "..liquid,
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rad    = flood_rad
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {ice,})
--				--local node   = nil
--				for _,np in ipairs(nps) do
--				--	node = minetest.get_node(np).name
--					minetest.set_node(np, {name="default:"..liquid.."_source",})
--				end
--
--				--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
--				--return ice
--				return ""
--			end,
--		})
	end
	if minetest.get_modpath("fire") then
		iadiscordia.register_flood_spell(ice, "", {ice,}, basic_flame, nil, "Thaw", false)
--		iadiscordia.register_spell(ice, {
--			password="Thaw",
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rad    = flood_rad
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {ice,})
--				--local node   = nil
--				for _,np in ipairs(nps) do
--				--	node = minetest.get_node(np).name
--					minetest.set_node(np, {name=basic_flame,})
--				end
--
--				--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
--				--return ice
--				return ""
--			end,
--		})
	end
	-- TODO convert between water <==> lava
end

local basic_flame = "fire:basic_flame"
if  minetest.get_modpath("default")
and minetest.get_modpath("stairs") then
	local flood_rad = 10
	local ice_slab = "stairs:slab_ice"
	iadiscordia.register_spell(torch, {
		password="Freeze",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, {"group:liquid",})--{"default:water_source", "default:river_water_source", "default:lava_source",})
			--local node   = nil
			for _,np in ipairs(nps) do
				np = vector.add(np, {x=0, y=1, z=0})
				if not iadiscordia.caster_collides(pos, np) then
			--		node = minetest.get_node(np).name
					minetest.set_node(np, {name=ice_slab})
				end
			end

			--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source

			--return ice_slab
			return ""
		end,
	})
	for _,liquid in ipairs(liquids) do
		--iadiscordia.register_spell("default:"..liquid.."_source", {
		iadiscordia.register_spell(torch, {
			password="Thaw "..liquid,
			callback=function(user)
				local pos    = user:get_pos()
				local rad    = flood_rad
				local minp   = vector.subtract(pos, rad)
				local maxp   = vector.add     (pos, rad)
				local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, {ice_slab,})
				--local node   = nil
				for _,np in ipairs(nps) do
				--	node = minetest.get_node(np).name
					minetest.remove_node(np)
				end
				nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, {ice, "group:ice",})
				for _,np in ipairs(nps) do
					minetest.set_node(np, {name="default:"..liquid.."_source",})
				end

				--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
				--return ice
				return ""
			end,
		})
	end
	if minetest.get_modpath("fire") then
		iadiscordia.register_spell(torch, {
			password="Thaw",
			callback=function(user)
				local pos    = user:get_pos()
				local rad    = flood_rad
				local minp   = vector.subtract(pos, rad)
				local maxp   = vector.add     (pos, rad)
				local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, {ice_slab, ice, "group:ice",})
				--local node   = nil
				for _,np in ipairs(nps) do
				--	node = minetest.get_node(np).name
					minetest.set_node(np, {name=basic_flame,})
				end

				--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
				--return ice
				return ""
			end,
		})
	end
end

if minetest.get_modpath("bonemeal") then
	local bonemeal_rad = 10
	local nodes        = {"group:dirt", "group:sand", "group:soil", "group:flora", "group:can_bonemeal",} -- TODO rip more types from bonemeal/mods.lua
--	iadiscordia.register_bonemeal_spell = function(src, bonemeal)
--		iadiscordia.register_spell(src, {
--			password="Grow",
--			callback=function(user)
--				local rad    = bonemeal_rad
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
--				for _,np in ipairs(nps) do
--					bonemeal:on_use(np, bonemeal, nil)
--				end
--				return ""
--			end,
--		})
--	end
	iadiscordia.register_bonemeal_spell("bonemeal:mulch",      1)
	iadiscordia.register_bonemeal_spell("bonemeal:bonemeal",   2)
	iadiscordia.register_bonemeal_spell("bonemeal:fertiliser", 3)
	iadiscordia.register_bonemeal_spell(kallisti,              4)
--	iadiscordia.register_spell("bonemeal:mulch", {
--		password="AoE",
--		callback=function(user)
--			local rad    = bonemeal_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
--			for _,np in ipairs(nps) do
--				bonemeal:on_use(np, 1, nil)
--			end
--		end,
--	})
--
--	iadiscordia.register_spell("bonemeal:bonemeal", {
--		password="AoE",
--		callback=function(user)
--			local rad    = bonemeal_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
--			for _,np in ipairs(nps) do
--				bonemeal:on_use(np, 2, nil)
--			end
--		end,
--	})
--
--	iadiscordia.register_spell("bonemeal:fertiliser", {
--		password="AoE",
--		callback=function(user)
--			local rad    = bonemeal_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
--			for _,np in ipairs(nps) do
--				bonemeal:on_use(np, 3, nil)
--			end
--		end,
--	})
--
--	iadiscordia.register_spell(kallisti, {
--		password="Grow",
--		callback=function(user)
--			local rad    = bonemeal_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, nodes)
--			for _,np in ipairs(nps) do
--				bonemeal:on_use(np, 4, nil)
--			end
--		end,
--	})
end
-- TODO basalt fertiliser
-- TODO composting ?

if  minetest.get_modpath("default")
and minetest.get_modpath("fire") then
	iadiscordia.register_spell(torch, {
		password="Burning Man",
		callback=function(user)
			local pos    = user:get_pos()
			minetest.set_node(pos, {name=basic_fire,})
		end,
	})
	iadiscordia.register_pond_spell(torch, "", basic_fire, nil, true)
--	iadiscordia.register_spell(torch, {
--		password="Fire Walker",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					if math.sqrt(dx*dx + dz*dz) <= 2 then -- TODO radius
--						-- within striking range
--					else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y-flood_rad,rnd.y+flood_rad do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							my_y = y - 1
--							--my_y = y
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					minetest.set_node(p, {name=basic_fire,})
--					end
--				end
--			end
--			return ""
--		end,
--	})

	local flood_rad = 10
	iadiscordia.register_spell(torch, {
		password="Fire Water",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:liquid",})--{"default:water_source", "default:river_water_source", "default:lava_source",})
			--local node   = nil
			for _,np in ipairs(nps) do
				if not iadiscordia.caster_collides(pos, np) then
			--		node = minetest.get_node(np).name
					minetest.set_node(np, {name=basic_fire,})

					-- TODO testing
					minetest.transforming_liquid_add(np)
				end
			end

			--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source

			--return ice
			return ""
		end,
	})
	iadiscordia.register_spell(torch, {
		password="Extinguish",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {basic_fire,})
			--local node   = nil
			for _,np in ipairs(nps) do
				--if not caster_collides(pos, np) then
			--		node = minetest.get_node(np).name
					minetest.set_node(np, {name="air",})

				--end
			end

			--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source

			--return ice
			return ""
		end,
	})
	iadiscordia.register_spell(torch, {
		password="Wildfire",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area_under_air(minp, maxp, {"group:flammable",})
			--local node   = nil
			local rnd    = vector.round(pos)
			for _,np in ipairs(nps) do
				local node    = minetest.get_node(np).name
				local groups  = minetest.registered_nodes[node].groups
				local flamrad = groups.flammable
				for x=rnd.x-flamrad,rnd.x+flamrad do
					for z=rnd.z-flamrad,rnd.z+flamrad do
						for y=rnd.y-flamrad,rnd.y+flamrad do -- TODO maybe some sort of more efficient iterating strategy
							local my_pos = {x=x, y=y, z=z}
							if vector.distance(pos, my_pos) >= 5 then -- TODO radius
								minetest.set_node(my_pos, {name=basic_flame,})
							end
						end
					end
				end
			end

			return ""
		end,
	})

	iadiscordia.register_spell(torch, {
		password="Chain Fire",
		callback=function(user)
			local pos     = user:get_pos()
			local players = minetest.get_connected_players()
			for _,objref in ipairs(players) do
				local objpos = objref:get_pos()
				if vector.distance(pos, objpos) <= 5 then
					-- within striking range
				else
					minetest.set_node(objpos, {name=basic_flame,})
				end
			end

			return ""
		end,
	})

	iadiscordia.register_spell(stick, {
		password="Forked Fire",
		callback=function(user)
			local pos     = user:get_pos()
			local players = minetest.get_connected_players()
			local targets = {}
			for _,objref in ipairs(players) do
				local objpos = objref:get_pos()
				if vector.distance(pos, objpos) <= 5 then
					-- within striking range
				else
					--table.insert(targets, objpos) -- TODO sorted
					table.insert(targets, objref) -- TODO sorted
				end
			end
			local i       = math.random(1, #targets)
			local target  = targets[i]

			local function helper()
				--lightning.strike(target)
				local objpos = target:get_pos()
				if vector.distance(pos, objpos) <= 5 then
					-- within striking range
				else
					minetest.set_node(objpos, {name=basic_flame,})
				end
			end

			local lightning_cnt = 30
			for cnt=1,lightning_cnt do
				minetest.after(cnt, helper)
			end
			helper()
			return ""
		end,
	})
	-- TODO need variants to follow-strike self, others & self-others
	-- TODO line of fire
	--
	
	--
end

if minetest.get_modpath("invisible") then
	iadiscordia.register_replacement(stick, "invisible:tool", "Invisible")
	iadiscordia.register_spell(stick, {
		password="Visible",
		callback=function(user)
			invisible.toggle(user,true)
		end,
	})
end

if minetest.get_modpath("pooper") then
	local poop_turd        = "pooper:poop_turd"
	local function fart(pos)
		minetest.sound_play("poop_defecate", {pos, gain = 1.0, max_hear_distance = 10,})
	end
	iadiscordia.register_inventory_spell(poop_turd, apple, fart)
--	iadiscordia.register_spell(poop_turd, {
--		password="Feed me, Seymour!",
--		callback=function(user)
--			local inv = user:get_inventory()
--			local sz  = inv:get_size("main")
--			for i=1,sz do
--				local stack = inv:get_stack("main", i)
--				if stack:is_empty() then
--					local new_stack = ItemStack(dst.." 1")
--					--stack:set_name("default:poop_turd")
--					--stack:set_count(1)
--					inv:set_stack("main", i, new_stack)
--				end
--			end
--
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--			return apple
--		end,
--	})

	iadiscordia.register_item_spell(poop_turd, apple, fart)
		
--	iadiscordia.register_spell(poop_turd, {
--		password="Chocolate Rain",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rad    = 5
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"air",})
--			for _,np in ipairs(nps) do
--				minetest.add_item(np, ItemStack(poop_turd.." 1"))
--			end
--
--			--return src
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--			return apple
--		end,
--	})

	local flood_rad = 10
	local poop_pile = "pooper:poop_pile"
	iadiscordia.register_spell(poop_turd, {
		password="Poupon me",
		callback=function(user)
			local pos = user:get_pos()
			pos.y = pos.y + 2
			minetest.set_node(pos, {name=poop_pile,})
			minetest.spawn_falling_node(pos)
		end,
	})
	iadiscordia.register_flood_spell(poop_pile, poop_turd, {"air",}, poop_pile, fart, "Flood", true)
--	iadiscordia.register_spell(poop_pile, {
--		password="Flood",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rad    = flood_rad
--			local minp   = vector.subtract(pos, rad)
--			local maxp   = vector.add     (pos, rad)
--			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"air",})
--			for _,np in ipairs(nps) do
--				if not caster_collides(pos, np) then
--					minetest.set_node(np, {name=poop_pile,})
--				end
--			end
--
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--			return poop_turd
--		end,
--	})
	iadiscordia.register_spell(poop_pile, {
		password="Sponge",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {poop_turd,})
			for _,np in ipairs(nps) do
				minetest.remove_node(np)
				minetest.add_item(np, ItemStack(poop_turd.." 1"))
			end

			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
			return poop_turd
		end,
	})
	iadiscordia.register_pond_spell(poop_pile, "", poop_pile, fart, true)
--	iadiscordia.register_spell(poop_pile, {
--		password="Shit Stepper",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					if math.sqrt(dx*dx + dz*dz) <= 5 then
--						-- within striking range
--					else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y-flood_rad,rnd.y+flood_rad do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							my_y = y - 1
--							--my_y = y
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					minetest.set_node(p, {name=poop_pile,})
--					end
--				end
--			end
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--			return ""
--		end
--	})

	local flood_rad = 10
	iadiscordia.register_spell(poop_pile, {
		password="Shit Creek",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = flood_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:liquid",})--{"default:water_source", "default:river_water_source", "default:lava_source",})
			--local node   = nil
			for _,np in ipairs(nps) do
				if not iadiscordia.caster_collides(pos, np) then
			--		node = minetest.get_node(np).name
					minetest.set_node(np, {name=poop_pile})

					-- TODO testing
					minetest.transforming_liquid_add(np)
				end
			end

			--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source

			--return ice
			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
			return ""
		end,
	})

	for _,liquid in ipairs(liquids) do
		iadiscordia.register_flood_spell(poop_pile, "", {poop_pile,}, "default:"..liquid.."_source", fart, "Thaw "..liquid, false)
--		--iadiscordia.register_spell("default:"..liquid.."_source", {
--		iadiscordia.register_spell(poop_pile, {
--			password="Thaw "..liquid,
--			callback=function(user)
--				local pos    = user:get_pos()
--				local rad    = flood_rad
--				local minp   = vector.subtract(pos, rad)
--				local maxp   = vector.add     (pos, rad)
--				local nps, _ = minetest.find_nodes_in_area(minp, maxp, {poop_pile,})
--				--local node   = nil
--				for _,np in ipairs(nps) do
--				--	node = minetest.get_node(np).name
--					minetest.set_node(np, {name="default:"..liquid.."_source",})
--				end
--
--				--if node ~= nil then return node end -- TODO it's weird to give the player a liquid source
--				--return ice
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--				return ""
--			end,
--		})
	end

	iadiscordia.register_avalanche_spell(poop_pile, fart, true)
--	iadiscordia.register_spell(poop_pile, {
--		password="Shit Avalanche",
--		callback=function(user)
--			local pos    = user:get_pos()
--			local rnd    = vector.round(pos)
--			for dx=-flood_rad,flood_rad do
--				for dz=-flood_rad,flood_rad do
--					if math.sqrt(dx*dx + dz*dz) <= 5 then
--						-- within striking range
--					else
--					local x = rnd.x + dx
--					local z = rnd.z + dz
--					local my_y = nil
--					for y=rnd.y+flood_rad,rnd.y-flood_rad,-1 do
--						local p    = {x=x, y=y, z=z}
--						local node = minetest.get_node(p)
--						if node.name == "air" then
--							my_y = y + 1
--							--my_y = y
--							break
--						end
--					end
--					if my_y == nil then
--						my_y   = math.random(-flood_rad, flood_rad)
--					end
--					local p    = {x=x, y=my_y, z=z}
--					--print("spawning poo: "..dump(p))
--					minetest.set_node(p, {name=poop_pile,})
--					minetest.spawn_falling_node(p)
--				end
--				end
--			end
--			minetest.sound_play("poop_defecate", {pos=user:get_pos(), gain = 1.0, max_hear_distance = 10,})
--			return ""
--		end
--	})

	iadiscordia.register_replacement(gold_lump,      poop_turd, "All that glitters is gold")
	iadiscordia.register_replacement(diamond,        poop_turd, "Diamonds are forever")
	iadiscordia.register_replacement(obsidian_shard, poop_turd, "I want it painted black")
	iadiscordia.register_replacement(mese_crystal,   poop_turd, "I've got the power")

	-- TODO shit storm
	-- TODO convert food to shit (even in inventories)
	-- TODO convert nodes to shit
	-- TODO convert ores to shit
	--
	-- TODO shit-nami tidal wave
	-- TODO shit seeds => shit weeds
	-- TODO shit abyss
	-- TODO shit blizzard
	-- TODO shit hawks
	-- TODO shit line
end

-- TODO rock, paper, scissors => punch everyone who's not playing; give other casters a grace period; kill the loser
local rps_duration = 30
--iadiscordia.register_rps_spell = function(password, safe_mode, lose_mode, message)
--	iadiscordia.register_spell(kallisti, {        
--		password=password,
--		callback=function(user)
--			local function helper()
--				local players = minetest.get_connected_players()
--				for _,player in ipairs(players) do
--					local meta = player:get_meta()
--					local rps  = meta:get_string("rps")
--					if rps ~= nil and rps == safe_mode then
--						-- safe
--					elseif rps ~= nil and rps == lose_mode then -- paper punches rock
--						iadiscordia.chat_send_user(user, message)
--                				user:punch(player, 1.0, {
--                    					full_punch_interval=1.0,
--                    					damage_groups={fleshy=damage},
--                				}, nil)
--					else
--						iadiscordia.chat_send_user(user, S("Rock, paper, scissors"))
--                				player:punch(user, 1.0, {
--                    					full_punch_interval=1.0,
--                    					damage_groups={fleshy=damage},
--                				}, nil)
--					end
--				end
--			end
--			local meta = user:get_meta()
--			meta:set_string("rps", safe_mode)
--			for t=1,rps_duration do
--				minetest.after(t, helper)
--			end
--		end,
--	})
--end
iadiscordia.register_rps_spell("Rock",     "rock",     "paper",    S("Paper beats rock"))
iadiscordia.register_rps_spell("Paper",    "paper",    "scissors", S("Scissors beats paper"))
iadiscordia.register_rps_spell("Scissors", "scissors", "rock",     S("Rock beats scissors"))
--iadiscordia.register_spell(kallisti, {        
--	password="Rock",
--	callback=function(user)
--		local function helper()
--			local players = minetest.get_connected_players()
--			for _,player in ipairs(players) do
--				local meta = player:get_meta()
--				local rps  = meta:get_string("rps")
--				if rps ~= nil and rps == "rock" then
--					-- safe
--				elseif rps ~= nil and rps == "paper" then -- paper punches rock
--					iadiscordia.chat_send_user(user, S("Paper beats rock"))
--                			user:punch(player, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				else
--					iadiscordia.chat_send_user(user, S("Rock, paper, scissors"))
--                			player:punch(user, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				end
--			end
--		end
--		local meta = user:get_meta()
--		meta:set_string("rps", "rock")
--		for t=1,rps_duration do
--			minetest.after(t, helper)
--		end
--	end,
--})
--iadiscordia.register_spell(kallisti, {  
--	password="Paper",
--	callback=function(user)
--		local function helper()
--			local players = minetest.get_connected_players()
--			for _,player in ipairs(players) do
--				local meta = player:get_meta()
--				local rps  = meta:get_string("rps")
--				if rps ~= nil and rps == "paper" then
--					-- safe
--				elseif rps ~= nil and rps == "scissors" then -- scissors punches paper
--					iadiscordia.chat_send_user(user, S("Scissors beats paper"))
--                			user:punch(player, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				else
--					iadiscordia.chat_send_user(user, S("Rock, paper, scissors"))
--                			player:punch(user, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				end
--			end
--		end
--		local meta = user:get_meta()
--		meta:set_string("rps", "paper")
--		for t=1,rps_duration do
--			minetest.after(t, helper)
--		end
--	end,
--})
--iadiscordia.register_spell(kallisti, {
--	password="Scissors",
--	callback=function(user)
--		local function helper()
--			local players = minetest.get_connected_players()
--			for _,player in ipairs(players) do
--				local meta = player:get_meta()
--				local rps  = meta:get_string("rps")
--				if rps ~= nil and rps == "scissors" then
--					-- safe
--				elseif rps ~= nil and rps == "rock" then -- rock punches scissors
--					iadiscordia.chat_send_user(user, S("Rock beats scissors"))
--                			user:punch(player, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				else
--					iadiscordia.chat_send_user(user, S("Rock, paper, scissors"))
--                			player:punch(user, 1.0, {
--                    				full_punch_interval=1.0,
--                    				damage_groups={fleshy=damage},
--                			}, nil)
--				end
--			end
--		end
--		local meta = user:get_meta()
--		meta:set_string("rps", "scissors")
--		for t=1,rps_duration do
--			minetest.after(t, helper)
--		end
--	end,
--})


-- TODO convert items in inventories to fake items

-- TODO convert dirt to leaves ?

-- TODO entropy: glass->sand, brick->stone

-- TODO build line, pit, tunnel, road, wall, pillar, box

-- TODO get all players, spawn things under them (holes, lava baths, etc)
-- TODO get all players, surround them with trees
-- TODO get all players, spawn fire under them
-- TODO get all players, explode
-- TODO get all players, punch them
-- TODO get all players nearby, punch them repeatedly
-- TODO get all players, chocolate rain
-- TODO get all players, give lodestones
-- TODO get all players, replace inv with fake items
-- TODO get all players, replace inv with poop food
-- TODO get all players, drain inv

-- TODO minetest.spawn_tree
-- TODO minetest.transforming_liquid_add


-- TODO mega-tools (tool digs/uses all nodes in area)

-- TODO shit spells
-- TODO cyclone spells (eg for shit storm)
-- TODO avalanche / collapse
-- TODO meteor

-- TODO player effects
-- TODO ../mobf_trader/mob_pickup.lua:minetest.register_privilege("mob_pickup"
-- TODO ../mg_villages/chat_commands.lua:minetest.register_privilege("mg_villages", 
-- TODO deathswap
-- ../cloaking/chatcommands.lua:minetest.register_privilege('cloaking',
-- ../cartographer/commands.lua:minetest.register_privilege("cartographer", {

iadiscordia.register_spell(kallisti, {
	password="Rasputin",
	callback=function(user)
		local meta = user:get_meta()
		local rasp = meta:get_int("rasputin") or 0
		meta:set_int("rasputin", rasp + 1)
	end,
})

if minetest.get_modpath("doors") then
	local knock_rad = 10
	iadiscordia.register_spell(stick, {
		password="Knock",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			for _,np in ipairs(nps) do
				local door = doors.get(np)
				assert(door ~= nil)
				door:open(user) -- TODO open all doors
			end
			return ""
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Lock",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			for _,np in ipairs(nps) do
				local door = doors.get(np)
				assert(door ~= nil)
				door:close(user) -- TODO close all doors
			end
			return ""
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Old screen door",
		--password="Lock test",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			local function helper()
				for _,np in ipairs(nps) do
					local door = doors.get(np)
					assert(door ~= nil)
					door:toggle(user) -- TODO close all doors
				end
			end
			local flap_duration = 10
			for t=1,flap_duration do
				minetest.after(t, helper)
			end
			return ""
		end,
	})
end

--
-- TODO "extra dimensional" magic requires something not of this world (ie the newspaper)

-- TODO evil eye: wear tools of players within sight

-- TODO convert sticks to snakes
