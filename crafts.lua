--
-- Recipes for our items
--

local MODNAME = minetest.get_current_modname()
minetest.register_craft({
   type         = "cooking",
   output       = 'iadiscordia:golden_apple',
   recipe       = "iadiscordia:apple_mold_with_gold",
   cooktime     = 3,
})

minetest.register_craft({
   type         = "shapeless",
   output       = 'iadiscordia:apple_mold_with_gold',
   recipe       = {
       "default:gold_ingot",
       "iadiscordia:apple_mold",
   },
})

minetest.register_craft({
   type         = "cooking",
   output       = 'iadiscordia:apple_mold',
   recipe       = "iadiscordia:apple_mold_raw",
   cooktime     = 3,
})

minetest.register_craft({
   type         = "shaped",
   output       = 'iadiscordia:apple_mold_raw 2',
   recipe       = {
       {"default:clay_lump", "default:clay_lump", "default:clay_lump",},
       {"default:clay_lump", "default:apple",     "default:clay_lump",},
       {"default:clay_lump", "default:clay_lump", "default:clay_lump",},
   },
   replacements = {
       {"default:apple", "default:apple",},
   },
})

minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:manual',
  recipe        = {
      'default:book',
      'iadiscordia:kallisti',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:principia_discordia',
  recipe        = {
      'default:book',
      'iadiscordia:chaos_star_sticker',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:chao_de_jing',
  recipe        = {
      'default:book',
      'iadiscordia:sacred_chao_sticker',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:naos',
  recipe        = {
      'default:book',
      'iadiscordia:naos_sticker',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:sanatan_dharma',
  recipe        = {
      'default:book',
      'iadiscordia:gunas_sticker',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:long_life',
  recipe        = {
      'default:book',
      'iadiscordia:bagua_sticker',
  },
})
minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:necronomicon',
  recipe        = {
      'default:book',
      'iadiscordia:elder_sticker',
  },
})

minetest.register_craft({
  type          = "shapeless",
  output        = 'iadiscordia:grimoire',
  recipe        = {
      'iadiscordia:manual',               -- 1
      'iadiscordia:chao_de_jing',         -- 2
      'iadiscordia:principia_discordia',  -- 3
      'iadiscordia:naos',                 -- 4
      'iadiscordia:sanatan_dharma',       -- 5
      'iadiscordia:long_life',            -- 6
      'iadiscordia:necronomicon',         -- 7
      'default:book',                     -- 8
      'default:book_written',             -- 9
  },
})

-- TODO death note recipe

-- TODO burnable books
