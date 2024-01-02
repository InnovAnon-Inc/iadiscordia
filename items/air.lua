-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?


local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

local air = "air"
local def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Darkness")
def.sunlight_propagates = false
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":darkness", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Brightness")
def.light_source = minetest.LIGHT_MAX
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":brightness", def)

iadiscordia.register_replacement("default:glass", MODNAME..":darkness",       "Darkness")
iadiscordia.register_replacement("default:glass", MODNAME..":brightness",       "Light")
iadiscordia.register_replacement("default:glass", MODNAME..":brightness",       "Void")
-- TODO

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Void")
def.drowning = 1
def.damage_per_second = 1
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":void", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Gravity") -- falling nodes
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":gravity", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Decay")
def.damage_per_second = 1
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":decay", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Blackhole") -- digs
def.drowning = 1
def.damage_per_second = 1
def.walkable = false
def.groups.air = 1
minetest.register_node(MODNAME..":blackhole", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Supernova")
def.damage_per_second = 10
def.walkable = false
def.groups.igniter = 5
def.light_source = minetest.LIGHT_MAX
def.groups.air = 1
minetest.register_node(MODNAME..":supernova", def)
--
--
--






-- TODO
if true then
minetest.register_abm({
	label     = "Langoliers",
	nodenames = {MODNAME..":void",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		--minetest.remove_node(pos)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					if dx ~= 0 or dy ~= 0 or dz ~= 0 then
						local p = vector.add(pos, {x=dx, y=dy, z=dz})
						local n = minetest.get_node_or_nil(p)
						if n ~= nil and n.name ~= MODNAME..":void" then
							-- TODO check whether node is already void
							minetest.set_node(p, {name=MODNAME..":void",})
							-- TODO freeze/evaporate liquids ?
							return
						end
					end
				end
			end
		end
	end,
})
end
if true then
minetest.register_abm({
	label     = "Atlas Shrugged",
	nodenames = {MODNAME..":gravity",},
	--neighbors = {},
	interval  = 10.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						if name ~= MODNAME..":gravity" then
							if minetest.spawn_falling_node(p) then
								return
							--elseif not minetest.spawn_falling_node(p) then
							--elseif not minetest.dig_node(p) then
								-- really hard to move
							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								minetest.set_node(p, {name=MODNAME..":gravity",})
								return
							end
						end
					end
				end
			end
		end
	end,
})
end
if true then
local decay = {
	-- dirt
	["default:dirt"]                        = "default:dry_dirt",
	["default:dirt_with_grass"]             = "default:dirt_with_dry_grass",
	["default:dirt_with_dry_grass"]         = "default:dry_dirt_with_dry_grass",
	["default:dry_dirt_with_dry_grass"]     = "default:dry_dirt",
	["default:dirt_with_snow"]              = "default:dirt",
	["default:dirt_with_coniferous_litter"] = "default:dirt",
	["default:dirt_with_rainforest_litter"] = "default:dirt",

	-- sand / flora
	["default:kelp"]                        = "default:sand", -- TODO
	["default:grass"]                       = "default:dry_grass",
	["default:marram_grass"]                = "default:dry_grass",
	["default:jungle_grass"]                = "default:dry_grass",

	-- liquids
	["default:water_source"]                = "air",
	["default:river_water_source"]          = "air",
	["default:ice"]                         = "water_source",
	["default:snowblock"]                   = "water_source",

	-- solids
	["default:obsidian"]                    = "default:lava_source",
	["default:obsidianbrick"]               = "default:lava_source",
	["default:lava_source"]                 = "default:stone",
	["default:stone"]                       = "default:cobble",
	["default:stonebrick"]                  = "default:cobble",
	["default:mossycobble"]                 = "default:cobble",
	["default:cobble"]                      = "default:gravel",
	["default:gravel"]                      = "default:sand",

	["default:sandstonebrick"]              = "default:sand",
	["default:sandstone"]                   = "default:sand",

	["default:desert_stonebrick"]           = "default:desert_cobble",
	["default:desert_stone"]                = "default:desert_cobble",
	["default:desert_cobble"]               = "default:desert_sand",

	["default:desert_sandstone"]            = "default:desert_sand",
	["default:desert_sandstone_brick"]      = "default:desert_sand",

	["default:silver_sandstone_brick"]      = "default:silver_sand",
	["default:silver_sandstone"]            = "default:silver_sand",

	["default:brick"]                       = "default:clay",
	["default:clay"]                        = "default:dirt",
	
	-- TODO brick to cobble
}
minetest.register_abm({
	label     = "Winter is Coming",
	nodenames = {MODNAME..":decay",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						if name ~= MODNAME..":decay" then
	
							if minetest.get_item_group(name, "tree") > 0
							or minetest.get_item_group(name, "wood") > 0 then
								minetest.dig_node(p)
								return
							elseif minetest.get_item_group(name, "leaves") > 0
							or     minetest.get_item_group(name, "leafdecay") > 0 then
								minetest.dig_node(p)
								return

							elseif minetest.get_item_group(name, "ore") > 0
							and    name ~= "default:stone" then
								minetest.swap_node(p, {name="default:stone",})
							elseif minetest.get_item_group(name, "stone") > 0
							and name ~= "default:cobble" then
								minetest.swap_node(p, {name="default:cobble",})
								minetest.spawn_falling_node(p)
								return

							elseif decay[name] ~= nil then
								assert(name ~= decay[name])
								minetest.swap_node(p, {name=decay[name],})
								minetest.spawn_falling_node(p)
								return

							elseif minetest.get_item_group(name, "soil") > 0
							and name ~= "default:dirt"
							and name ~= decay["default:dirt"] then
								minetest.swap_node(p, {name="default:dirt",})
								return

							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								minetest.set_node(p, {name=MODNAME..":decay",})
								return
							--elseif minetest.dig_node(p) then
							--	return
							end
						end
					end
				end
			end
		end
	end,
})
end
if true then
minetest.register_abm({
	label     = "Blackhole Sun",
	nodenames = {MODNAME..":blackhole",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						if name ~= MODNAME..":blackhole" then
							if minetest.dig_node(p) then
								-- TODO set velocity
								return
							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								minetest.set_node(p, {name=MODNAME..":blackhole",})
								return
							end
						end
					end
				end
			end
		end
	end,
})
end
if true then
minetest.register_abm({
	label     = "Supernova",
	nodenames = {MODNAME..":supernova",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						if name ~= MODNAME..":supernova" then
							if minetest.remove_node(p) then
								-- TODO play sound
								-- TODO spawn particles
								return
							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								minetest.set_node(p, {name=MODNAME..":supernova",})
								return
							end
						end
					end
				end
			end
		end
	end,
})
end

-- TODO fiery air
-- TODO frozen air

-- TODO wtf

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Hot Air")
def.damage_per_second = 1
def.walkable = false
def.groups.igniter = 5
def.groups.lava = 3
def.groups.air = 1
minetest.register_node(MODNAME..":hot_air", def)
if true then
minetest.register_abm({
	label     = "Hot Air",
	nodenames = {MODNAME..":hot_air",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						if name ~= MODNAME..":hot_air" then
							if minetest.get_item_group(name, "water") > 0 then
								minetest.set_node(p, {name="default:lava_flowing",})
								return
							elseif minetest.get_item_group(name, "flammable") > 0
							--or     minetest.get_item_group(name, "tree") > 0
							--or     minetest.get_item_group(name, "leafdecay") > 0
								then
								minetest.set_node(p, {name="fire:basic_flame",})
								return
							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								minetest.set_node(p, {name=MODNAME..":hot_air",})
								return
							--elseif minetest.remove_node(p) then
							--	-- TODO play sound
							--	-- TODO spawn particles
							--	return
							end
						end
					end
				end
			end
		end
	end,
})
end

-- TODO fiery air
-- TODO frozen air

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Cold Air")
def.damage_per_second = 1
def.walkable = false
def.groups.puts_out_fire = 5
def.groups.water = 3
def.groups.cools_lava = 3
def.groups.air = 1
minetest.register_node(MODNAME..":cold_air", def)
-- TODO replace grass with snow, freeze water
if true then
minetest.register_abm({
	label     = "Cold Air",
	nodenames = {MODNAME..":cold_air",},
	--neighbors = {},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		pos = vector.round(pos)
		for dx=-1,1 do
			for dy=-1,1 do
				for dz=-1,1 do
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					--local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local node = minetest.get_node_or_nil(p)
					if node ~= nil then
						local name = node.name
						--print('name: '..name)
						if name ~= MODNAME..":cold_air" then
							if minetest.get_item_group(name, "water") > 0
							and name ~= "default:ice" then
								--print('water')
								minetest.swap_node(p, {name="default:ice",})
								return
							elseif minetest.get_item_group(name, "liquid") > 0
							and name ~= "default:water_flowing" then
								--print('water')
								minetest.swap_node(p, {name="default:water_flowing",})
								return
	
							elseif minetest.get_item_group(name, "tree") > 0
							or     minetest.get_item_group(name, "wood") > 0
							--or     minetest.get_item_group(name, "flammable") > 0
							then
								--print('tree')
								minetest.swap_node(p, {name="default:ice",})
								return
							elseif minetest.get_item_group(name, "leafdecay") > 0
							or     minetest.get_item_group(name, "leaves") > 0
							or     minetest.get_item_group(name, "flora") > 0 then
								--print('leaf')
								minetest.swap_node(p, {name="default:snowblock",})
								return
	
							elseif minetest.get_item_group(name, "soil") > 0
							and name ~= "default:permafrost" then
								--print('soil')
								minetest.swap_node(p, {name="default:permafrost",})
								return
							elseif name == "default:dirt_with_grass"
							or     name == "default:dirt"
							then
								--print('dirt')
								minetest.swap_node(p, {name="default:dirt_with_snow",})
								return
	
							elseif name == "air"
							or minetest.get_item_group(name, "air") > 0 then
								--print('air')
								minetest.set_node(p, {name=MODNAME..":cold_air",})
								return
							--elseif minetest.get_item_group(name, "leafdecay", "flora") then
							end
						end
					end
				end
			end
		end
	end,
})
end



















local dirt = "default:dirt"
def = minetest.registered_nodes[dirt]
def = table.copy(def)
def.description = S("Tainted Dirt")
def.damage_per_second = 1
def.groups.soil = 0
def.groups.air = 1
minetest.register_node(MODNAME..":tainted_dirt", def)
if true then
minetest.register_abm({
	label     = "Taint",
	nodenames = {MODNAME..":tainted_dirt",},
	neighbors = {"group:soil",},
	interval  = 1.0,
	chance    = 1.0,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		local p = minetest.find_node_near(pos, 1, {"group:soil",})
		local node = minetest.get_node_or_nil(p)
		if node ~= nil then
			local name = node.name
			--print('name: '..name)
			if name ~= MODNAME..":tainted_dirt" then
				if minetest.get_item_group(name, "soil") > 0
				and name ~= MODNAME..":tainted_dirt" then
					--print('soil')
					minetest.swap_node(p, {name=MODNAME..":tainted_dirt",})
					--return
				end
			end
		end
	end,
})
end






















if true then
minetest.register_abm({
	label     = "Darkness",
	nodenames = {MODNAME..":darkness",},
	neighbors = {"air",},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		local np = minetest.find_node_near(pos, 1, {"air",})
		minetest.set_node(np, {name=MODNAME..":darkness",})
	end,
})
end
if true then
minetest.register_abm({
	label     = "Brightness",
	nodenames = {MODNAME..":brightness",},
	neighbors = {"air",},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		local np = minetest.find_node_near(pos, 1, {"air",})
		minetest.set_node(np, {name=MODNAME..":brightness",})
	end,
})
end










def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Tiamat")
def.walkable = false
def.groups.air = 1
def.drowning = 1
minetest.register_node(MODNAME..":abyss", def)
if true then
minetest.register_abm({
	label     = "Watery Abyss",
	nodenames = {MODNAME..":abyss",},
	--neighbors = {"air",},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)

		local np = minetest.find_node_near(pos, 1, {"air",})
		if np ~= nil then
			minetest.set_node(np, {name=MODNAME..":abyss",})
			return
		end

		np = minetest.find_node_near(pos, 1, {MODNAME..":abyss",})
		if np ~= nil then
			minetest.set_node(np, {name="default:water_source",})
			return
		end
	end,
})
end

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Aesir")
def.walkable = false
def.groups.air = 1
def.drowning = 1
minetest.register_node(MODNAME..":brimstone", def)
if true then
minetest.register_abm({
	label     = "Lake of Fire",
	nodenames = {MODNAME..":brimstone",},
	--neighbors = {"air",},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)

		local np = minetest.find_node_near(pos, 1, {"air",})
		if np ~= nil then
			minetest.set_node(np, {name=MODNAME..":brimstone",})
			return
		end

		np = minetest.find_node_near(pos, 1, {MODNAME..":brimstone",})
		if np ~= nil then
			minetest.set_node(np, {name="default:lava_source",})
			return
		end
	end,
})
end















-- TODO
--def = minetest.registered_nodes[air]
--def = table.copy(def)
--def.description = S("Midas")
--def.walkable = false
--def.groups.air = 1
--def.drowning = 1
--minetest.register_node(MODNAME..":midas", def)
--if true then
--minetest.register_abm({
--	label     = "All that Glitters is Gold",
--	nodenames = {MODNAME..":midas",},
--	--neighbors = {"air",},
--	interval  = 1.0,
--	chance    = 1,
--	--catch_up  = true,
--	action    = function(
--		pos, node, active_object_count, active_object_count_wider)
--
--		local np = minetest.find_node_near(pos, 1, {"air",})
--		if np ~= nil then
--			minetest.set_node(np, {name=MODNAME..":midas",})
--			return
--		end
--
--		np = minetest.find_node_near(pos, 1, {MODNAME..":midas",})
--		if np ~= nil then
--			minetest.set_node(np, {name="default:goldblock",})
--			return
--		end
--	end,
--})
--end


-- TODO
--def = minetest.registered_nodes[air]
--def = table.copy(def)
--def.description = S("Sands of Time")
--def.walkable = false
--def.groups.air = 1
--minetest.register_node(MODNAME..":allsands", def)
--if true then
--minetest.register_abm({
--	label     = "Foundation of Sand",
--	nodenames = {
--		"group:soil",
--		"group:stone",
--		"default:gravel", "default:cobble", "default:cobblestone",
--		"default:stone_brick",
--		"default:desert_stone_brick",
--		"default:desert_sandstone_brick",
--	},
--	neighbors = {MODNAME..":allsands",},
--	interval  = 1.0,
--	chance    = 1,
--	--catch_up  = true,
--	action    = function(
--		pos, node, active_object_count, active_object_count_wider)
--
--		minetest.set_node(pos, {name="default:sand",})
--			return
--	end,
--})
--minetest.register_abm({
--	label     = "Sands of Time",
--	nodenames = {MODNAME..":allsands",},
--	neighbors = {"group:air",},
--	interval  = 1.0,
--	chance    = 1,
--	--catch_up  = true,
--	action    = function(
--		pos, node, active_object_count, active_object_count_wider)
--		local n = minetest.get_node(pos)
--		if n.name ~= MODNAME..":allsands" then
--			minetest.swap_node(pos, {name=MODNAME..":allsands",})
--		end
--	end,
--})
--end

























local function register_liquid(liquid_name, liquid_desc)
-- TODO param/param2
local stone = "default:"..liquid_name -- stone"
local def_source = minetest.registered_nodes[stone]
def_source = table.copy(def_source)
def_source.description = S(liquid_desc .. " Source")
def_source.walkable = false
--def_source.pointable = false
--def_source.diggable = false
--def_source.buildable_to = false
def_source.floodable = true
def_source.liquidtype = "source"
def_source.liquid_alternative_flowing = MODNAME..":"..liquid_name.."_flowing"
def_source.liquid_viscosity = 7
def_source.liquid_renewable = false
--def_source.liquid_range = 1
def_source.liquid_range = 0
def_source.drowning = 1
def_source.damage_per_second = 1
def_source.groups.liquid = 4
def_source.groups.quicksand = 1
def_source.drop = ""
minetest.register_node(MODNAME..":"..liquid_name.."_source", def_source)

local def_flowing = minetest.registered_nodes[stone]
def_flowing = table.copy(def_flowing)
def_flowing.description = S(liquid_desc .. " Flowing")
def_flowing.walkable = false
--def_flowing.pointable = false
--def_flowing.diggable = false
--def_flowing.buildable_to = false
def_flowing.floodable = true
def_flowing.liquidtype = "flowing"
def_flowing.liquid_alternative_source = MODNAME..":"..liquid_name.."_source"
def_flowing.liquid_viscosity = 7
def_flowing.liquid_renewable = false
def_flowing.liquid_range = 0
def_flowing.drowning = 1
def_flowing.damage_per_second = 1
def_flowing.groups.liquid = 4
--def_flowing.groups.quicksand = 1
def_flowing.groups.not_in_creative_inventory = 1
def_flowing.drop = ""
minetest.register_node(MODNAME..":"..liquid_name.."_flowing", def_flowing)
if true then
minetest.register_abm({
	label     = "Liquify",
	nodenames = {"default:"..liquid_name,},
	--neighbors = {MODNAME..":"..liquid_name.."_source",},
	neighbors = {"group:quicksand",},
	interval  = 1.0,
	chance    = 1,
	--catch_up  = true,
	action    = function(
		pos, node, active_object_count, active_object_count_wider)
		minetest.swap_node(pos, {name=MODNAME..":"..liquid_name.."_source",})
	end,
})
end
end
register_liquid("stone", "Stone")
register_liquid("gravel", "Gravel")
register_liquid("cobble", "Cobblestone")
register_liquid("mossycobble", "Mossy Cobblestone")
register_liquid("sandstone", "Sandstone")
register_liquid("desert_stone", "Desert Stone")
register_liquid("desert_sandstone", "Desert Sand Stone")
register_liquid("silver_sandstone", "Silver Sand Stone")
register_liquid("sand", "Sand")
register_liquid("desert_sand", "Desert Sand")
register_liquid("silver_sand", "Silver Sand")
register_liquid("dirt", "Dirt")
register_liquid("dirt_with_grass", "Dirt with Grass")
register_liquid("dry_dirt", "Dry Dirt")
register_liquid("dirt_with_dry_grass", "Dirt with Dry Grass")
register_liquid("dry_dirt_with_dry_grass", "Dry Dirt with Dry Grass")
register_liquid("dirt_with_snow", "Dirt with Snow")
register_liquid("dirt_with_coniferous_litter", "Dirt with Coniferous Litter")
register_liquid("dirt_with_rainforest_litter", "Dirt with Rainforest Litter")
register_liquid("ice", "Ice")
register_liquid("snowblock", "Snow Block")
