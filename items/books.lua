-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?


local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

iadiscordia.register_book = function(name, description, image, on_use, magic,
	random_mp, random_hp, random_xp, random_lvl, random_cnt)

	assert(name ~= nil)
	assert(description ~= nil)
	assert(image ~= nil)
	--assert(on_use ~= nil)
	assert(magic ~= nil)
	
	assert(random_mp ~= nil)
	assert(random_hp ~= nil)
	assert(random_xp ~= nil)
	assert(random_lvl ~= nil)
	assert(random_cnt ~= nil)

	local def           = table.copy(minetest.registered_items["default:book"])
	--def.name = name
	def.description     = description
	def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7="..image.."\\^\\[resize\\:23x23"
	def.on_use          = on_use

	if magic then
		def.groups          = {not_in_creative_inventory=1, spellbook=1,}
		def.light_source    = minetest.LIGHT_MAX
	end

	-- TODO register node
	assert(iadiscordia.on_place_book ~= nil)
	def.on_place = iadiscordia.on_place_book

	minetest.register_craftitem(name, def)
	iadiscordia.books[name]        = {
		open       = name.."_open",
		closed     = name.."_closed",
		random_mp  = random_mp,
		random_hp  = random_hp,
		random_xp  = random_xp,
		random_lvl = random_lvl,
		random_cnt = random_cnt,
	}
	assert(iadiscordia.books[name] ~= nil)
	assert(iadiscordia.books[name].open ~= nil)
	iadiscordia.books[iadiscordia.books[name].open]   = {
		base       = name,
		closed     = iadiscordia.books[name].closed,
		is_open    = true,
		random_mp  = random_mp,
		random_hp  = random_hp,
		random_xp  = random_xp,
		random_lvl = random_lvl,
		random_cnt = random_cnt,
	}
	assert(iadiscordia.books[name].closed ~= nil)
	iadiscordia.books[iadiscordia.books[name].closed] = {
		base       = name,
		open       = iadiscordia.books[name].open,
		is_closed  = true,
		random_mp  = random_mp,
		random_hp  = random_hp,
		random_xp  = random_xp,
		random_lvl = random_lvl,
		random_cnt = random_cnt,
	}

	minetest.register_node(iadiscordia.books[name].open, {
		description = description,
		-- TODO correct images
		--inventory_image = "default_book.png",
		inventory_image = def.inventory_image,
		tiles = {
			"books_book_open_top.png",	-- Top
			"books_book_open_bottom.png",	-- Bottom
			"books_book_open_side.png",	-- Right
			"books_book_open_side.png",	-- Left
			"books_book_open_front.png",	-- Back
			"books_book_open_front.png"	-- Front
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.47, -0.282, 0.375, -0.4125, 0.282}, -- Top
				{-0.4375, -0.5, -0.3125, 0.4375, -0.47, 0.3125},
			}
		},
		--groups = {attached_node = 1}, -- FIXME
		groups = {not_in_creative_inventory = 1},
		on_punch = iadiscordia.on_punch_book,
		on_rightclick = iadiscordia.on_rightclick_book,

		light_source = def.light_source,
	})
	minetest.register_node(iadiscordia.books[name].closed, {
		description = description,
		--inventory_image = "default_book.png",
		inventory_image = def.inventory_image,
		tiles = {
			"[combine:64x64:0,0=books_book_closed_topbottom.png\\^\\[resize\\:64x64]:21,14="..image.."\\^\\[resize\\:23x23",
			--"books_book_closed_topbottom.png",	-- Top
			"books_book_closed_topbottom.png",	-- Bottom
			"books_book_closed_right.png",	-- Right
			"books_book_closed_left.png",	-- Left
			"books_book_closed_front.png^[transformFX",	-- Back
			"books_book_closed_front.png"	-- Front
		},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		sunlight_propagates = true,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.25, -0.5, -0.3125, 0.25, -0.35, 0.3125},
			}
		},
		groups = {oddly_breakable_by_hand = 3, dig_immediate = 2, not_in_creative_inventory = 1}, --, attached_node = 1}, -- FIXME
		on_dig = iadiscordia.on_dig_book,
		on_rightclick = iadiscordia.on_rightclick_book,
		after_place_node = iadiscordia.after_place_node_book,

		light_source = def.light_source,
	})
end
-- TODO on_use_node might not work for nodes (only items)
--local book_on_use = minetest.registered_items["default:book"].on_use
iadiscordia.register_book("iadiscordia:manual", S("IA Discordia User Manual"), "kallisti.png", iadiscordia.on_use_node, true,
	-- no special effects
	false, false, false, false, false, false)

iadiscordia.register_book("iadiscordia:chao_de_jing", S("Chao De Jing"), "chao.png", iadiscordia.on_use_node, true,
	-- randomized mana cost
	true, false, false, false, false, false)
minetest.register_craftitem("iadiscordia:sacred_chao_sticker", {
	description     = S("Sacred Chao Sticker"),
	inventory_image = "chao.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:principia_discordia", S("Principia Discordia"), "chaos_star.png", iadiscordia.on_use_node, true,
	-- randomized count
	false, false, false, false, true, false)
minetest.register_craftitem("iadiscordia:chaos_star_sticker", {
	description     = S("Chaos Star Sticker"),
	inventory_image = "chaos_star.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:naos", S("NAOS: A Practical Guide to Modern Magick"), "naos.png", iadiscordia.on_use_node, true,
	-- randomized experience reward
	false, false, true, false, false, false)
minetest.register_craftitem("iadiscordia:naos_sticker", {
	description     = S("NAOS Sticker"),
	inventory_image = "naos.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:sanatan_dharma", S("Sanatan Dharma, Hinduism Exhumed and Resurrected"), "gunas.png", iadiscordia.on_use_node, true,
	-- cast spell at a randomized level
	false, false, false, true, false, false)
minetest.register_craftitem("iadiscordia:gunas_sticker", {
	description     = S("Gunas Sticker"),
	inventory_image = "gunas.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:long_life", S("Sex, Health and Long Life"), "bagua.png", iadiscordia.on_use_node, true,
	-- randomized health cost
	false, true, false, false, false, false)
minetest.register_craftitem("iadiscordia:bagua_sticker", {
	description     = S("Bagua Sticker"),
	inventory_image = "bagua.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:necronomicon", S("The Tome of Abdul Alhazred"), "elder.png", iadiscordia.on_use_node, true,
	-- random randomized effect
	false, false, false, false, false, true)
minetest.register_craftitem("iadiscordia:elder_sticker", {
	description     = S("Elder Sticker"),
	inventory_image = "elder.png",
	groups          = {not_in_creative_inventory=1,},
})

iadiscordia.register_book("iadiscordia:grimoire", S("The Culmination of your Studies"), "stone.png", iadiscordia.on_use_node, true,
	-- all randomized effects
	true, true, true, true, true, false)

-- TODO needs recipe
iadiscordia.register_book("iadiscordia:death_note", S("Write your friends' names"), "stone.png", iadiscordia.on_use_node, true, -- TODO image
	false, false, false, false, false, false)

-- TODO chakra books, kundalini

iadiscordia.register_replacement("default:paper", "iadiscordia:sacred_chao_sticker", "Chao")
iadiscordia.register_replacement("default:paper", "iadiscordia:chaos_star_sticker",  "Star")
iadiscordia.register_replacement("default:paper", "iadiscordia:naos_sticker",        "NAOS")
iadiscordia.register_replacement("default:paper", "iadiscordia:gunas_sticker",       "Gunas")
iadiscordia.register_replacement("default:paper", "iadiscordia:bagua_sticker",       "Bagua")
iadiscordia.register_replacement("default:paper", "iadiscordia:elder_sticker",       "Elder")

