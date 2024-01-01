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
minetest.register_node(MODNAME..":darkness", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Brightness")
def.light_source = minetest.LIGHT_MAX
def.walkable = false
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
minetest.register_node(MODNAME..":void", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Gravity") -- falling nodes
def.walkable = false
minetest.register_node(MODNAME..":gravity", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Decay")
def.damage_per_second = 1
def.walkable = false
minetest.register_node(MODNAME..":decay", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Blackhole") -- digs
def.drowning = 1
def.damage_per_second = 1
def.walkable = false
minetest.register_node(MODNAME..":blackhole", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.description = S("Supernova")
def.damage_per_second = 10
def.walkable = false
def.groups.igniter = 5
def.light_source = minetest.LIGHT_MAX
minetest.register_node(MODNAME..":supernova", def)
--
--
--

-- TODO param/param2
local stone = "default:stone"
local def_source = minetest.registered_nodes[stone]
def_source = table.copy(def_source)
def_source.description = S("Liquid Stone Source")
def_source.walkable = false
--def_source.pointable = false
--def_source.diggable = false
--def_source.buildable_to = false
def_source.floodable = true
def_source.liquidtype = "source"
def_source.liquid_alternative_flowing = MODNAME..":stone_flowing"
def_source.liquid_viscosity = 7
def_source.liquid_renewable = false
def_source.liquid_range = 1
def_source.drowning = 1
def_source.damage_per_second = 1
def_source.groups.liquid = 4
def_source.drop = ""
minetest.register_node(MODNAME..":stone_source", def_source)

local def_flowing = minetest.registered_nodes[stone]
def_flowing = table.copy(def_flowing)
def_flowing.description = S("Liquid Stone Flowing")
def_flowing.walkable = false
--def_flowing.pointable = false
--def_flowing.diggable = false
--def_flowing.buildable_to = false
def_flowing.floodable = true
def_flowing.liquidtype = "flowing"
def_flowing.liquid_alternative_source = MODNAME..":stone_source"
def_flowing.liquid_viscosity = 7
def_flowing.liquid_renewable = false
def_flowing.liquid_range = 1
def_flowing.drowning = 1
def_flowing.damage_per_second = 1
def_flowing.groups.liquid = 4
def_flowing.drop = ""
minetest.register_node(MODNAME..":stone_flowing", def_flowing)





-- TODO
if false then
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
					local p = vector.add(pos, {x=dx, y=dy, z=dz})
					minetest.set_node(p, {name=MODNAME..":void",})
					-- TODO freeze/evaporate liquids ?
					return
				end
			end
		end
	end,
})
end
if false then
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
					local node = minetest.get_node(p)
					local name = node.name
					if name ~= MODNAME..":gravity" then
					if name == "air" then
						minetest.set_node(p, {name=MODNAME..":gravity",})
						return
					elseif minetest.spawn_falling_node(p) then
						return
					--elseif not minetest.spawn_falling_node(p) then
					--elseif not minetest.dig_node(p) then
						-- really hard to move
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
	["default:snow"]                        = "water_source",

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
					local node = minetest.get_node(p)
					local name = node.name
					if name ~= MODNAME..":decay" then
					if name == "air" then
						minetest.set_node(p, {name=MODNAME..":decay",})
						return
					elseif minetest.get_item_group(name, "tree") > 0 then
						minetest.dig_node(p)
						return
					elseif minetest.get_item_group(name, "leaves") > 0 then
						minetest.dig_node(p)
						return
					elseif minetest.get_item_group(name, "ore") > 0 then
						minetest.swap_node(p, {name="default:stone",})
					elseif minetest.get_item_group(name, "stone") > 0 then
						minetest.swap_node(p, {name="default:cobble",})
						minetest.spawn_falling_node(p)
						return
					elseif minetest.get_item_group(name, "soil") > 0 then
						minetest.swap_node(p, {name="default:dirt",})
						return
					elseif decay[name] ~= nil then
						minetest.swap_node(p, {name=decay[name],})
						minetest.spawn_falling_node(p)
						return
					--elseif minetest.dig_node(p) then
					--	return
					end
					end
				end
			end
		end
	end,
})
end
if false then
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
					local node = minetest.get_node(p)
					local name = node.name
					if name ~= MODNAME..":blackhole" then
					if name == "air" then
						minetest.set_node(p, {name=MODNAME..":blackhole",})
						return
					elseif minetest.dig_node(p) then
						-- TODO set velocity
						return
					end
					end
				end
			end
		end
	end,
})
end
if false then
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
					local node = minetest.get_node(p)
					local name = node.name
					if name ~= MODNAME..":supernova" then
					if name == "air" then
						minetest.set_node(p, {name=MODNAME..":supernova",})
						return
					elseif minetest.remove_node(p) then
						-- TODO play sound
						-- TODO spawn particles
						return
					end
					end
				end
			end
		end
	end,
})
end
