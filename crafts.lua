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

-- TODO burnable books
