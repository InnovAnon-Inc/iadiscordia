local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

-- Global
iadiscordia = {}

dofile(path .. "util.lua")
dofile(path .. "skills.lua")
dofile(path .. "spells.lua")
dofile(path .. "api.lua")
dofile(path .. "items.lua")
dofile(path .. "crafts.lua")
-- TODO
--dofile(path .. "books.lua")

print ("[MOD] IA Discordia loaded")
