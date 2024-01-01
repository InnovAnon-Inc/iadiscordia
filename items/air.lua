-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?


local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

local air = "air"
local def = minetest.registered_nodes[air]
def = table.copy(def)
def.sunlight_propagates = false
minetest.register_node(MODNAME..":darkness", def)

def = minetest.registered_nodes[air]
def = table.copy(def)
def.light_source = minetest.LIGHT_MAX
minetest.register_node(MODNAME..":brightness", def)

iadiscordia.register_replacement("default:glass", MODNAME..":darkness",       "Darkness")
iadiscordia.register_replacement("default:glass", MODNAME..":brightness",       "Light")





-- TODO param/param2
local stone = "default:stone"
local def_source = minetest.registered_nodes[stone]
def_source = table.copy(def_source)
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

