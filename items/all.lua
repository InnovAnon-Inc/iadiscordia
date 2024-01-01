-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?



local MODNAME = minetest.get_current_modname()
local path    = minetest.get_modpath(MODNAME) .. "/items/"
local S       = minetest.get_translator(MODNAME)

dofile(path .. "apples.lua")
dofile(path .. "books.lua")
dofile(path .. "stones.lua")
dofile(path .. "sticks.lua")


iadiscordia.register_replacement("fireflies:firefly_bottle", "iadiscordia:fairy_bottle",          "Fairy")


