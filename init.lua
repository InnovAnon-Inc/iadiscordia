local MODNAME = minetest.get_current_modname()
local path    = minetest.get_modpath(MODNAME) .. "/"

-- Global
iadiscordia = {}

dofile(path .. "util.lua")
dofile(path .. "skills.lua")
dofile(path .. "spells.lua")
dofile(path .. "api.lua")
--<<<<<<< HEAD
--dofile(path .. "items.lua")
--=======
dofile(path .. "books.lua")
dofile(path .. "items/all.lua")
-->>>>>>> 02df97c251da3645c8387b88dd5c28f41fc97d8e
dofile(path .. "crafts.lua")
dofile(path .. "fairy.lua")
dofile(path .. "man.lua")
dofile(path .. "fun.lua")
dofile(path .. "fun.lua")
dofile(path .. "magick/all.lua")

print ("[MOD] IA Discordia loaded")
