local MODNAME = minetest.get_current_modname()
local path    = minetest.get_modpath(MODNAME) .. "/"

-- Global
iadiscordia = {}

dofile(path .. "util.lua")
dofile(path .. "skills.lua")
dofile(path .. "spells.lua")
dofile(path .. "api.lua")
dofile(path .. "books.lua")
dofile(path .. "items/all.lua")
dofile(path .. "crafts.lua")
dofile(path .. "fairy.lua")
dofile(path .. "man.lua")
dofile(path .. "fun.lua")
dofile(path .. "fun.lua")
dofile(path .. "magick/all.lua")

print ("[MOD] IA Discordia loaded")
