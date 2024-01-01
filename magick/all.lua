-- TODO falling node spells
-- TODO liquid stone spells
-- TODO light/dark spells
-- TODO wormhole (blackhole in one position, explosion in another. blackhole drops items at explosion pos


--
-- Meta-file to include all spells
--

local MODNAME = minetest.get_current_modname()
local path    = minetest.get_modpath(MODNAME) .. "/magick/"
local S       = minetest.get_translator(MODNAME)

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

dofile(path .. "privs.lua")
dofile(path .. "cross.lua")
dofile(path .. "api.lua")
dofile(path .. "ez.lua")

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


local bucket_water       = "bucket:bucket_water"
local bucket_empty       = "bucket:bucket_empty"
local bucket_river_water = "bucket:bucket_river_water"
local bucket_lava        = "bucket:lava"






local flood_rad = 10

-- TODO magical liquids
local liquids = { "water", "river_water", "lava",}
if  minetest.get_modpath("bucket")
and minetest.get_modpath("default") then
	for _,liquid in ipairs(liquids) do
		iadiscordia.register_flood_spell("bucket:bucket_"..liquid, bucket_empty, {"air",}, "default:"..liquid.."_source", nil, "Flood", true)
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
	iadiscordia.register_pond_spell(ice, "", ice, nil, false)
	for _,liquid in ipairs(liquids) do
		iadiscordia.register_flood_spell(ice, "", {ice,}, "default:"..liquid.."_source", nil, "Thaw "..liquid, false)
	end
	if minetest.get_modpath("fire") then
		iadiscordia.register_flood_spell(ice, "", {ice,}, basic_flame, nil, "Thaw", false)
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


if minetest.get_modpath("pooper") then
	local poop_turd        = "pooper:poop_turd"
	local function fart(pos)
		minetest.sound_play("poop_defecate", {pos, gain = 1.0, max_hear_distance = 10,})
	end
	iadiscordia.register_inventory_spell(poop_turd, apple, fart)

	iadiscordia.register_item_spell(poop_turd, apple, fart)
		

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
	end

	iadiscordia.register_avalanche_spell(poop_pile, fart, true)

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



--
-- TODO "extra dimensional" magic requires something not of this world (ie the newspaper)

-- TODO evil eye: wear tools of players within sight

-- TODO convert sticks to snakes
