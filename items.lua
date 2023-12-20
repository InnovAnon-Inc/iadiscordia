-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time



local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

--
-- Apples
--

iadiscordia.register_apple = function(name, description, image, on_use, magic)
	assert(name ~= nil)
	assert(description ~= nil)
	assert(image ~= nil)
	--assert(on_use ~= nil)
	assert(magic ~= nil)
	local def           = table.copy(minetest.registered_nodes["default:apple"])
	--def.name = name
	def.description     = description
	if magic then
		def.groups          =  {dig_immediate=3, hard = 1, metal = 1, not_in_creative_inventory=1,}
	else
		def.groups          =  {dig_immediate=3, hard = 1, metal = 1,}
	end
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.tiles           = {image,}
	def.on_use          = on_use
	if magic then
		def.light_source    = minetest.LIGHT_MAX

		def.on_rightclick   = function(pos, node, clicker, itemstack, pointed_thing)
			iadiscordia.on_use_generic(itemstack, clicker, pointed_thing)
		end
	end
	def.after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name=name, param2=1})
	end
	--if magic then
	--	def.after_dig_node = function(pos, oldnode, oldmetadata, digger)
	--		--if oldnode.param2 == 0 then
	--			--minetest.set_node(pos, {name="default:apple_mark"})
	--			minetest.spawn_tree(pos, {"default:tree",})
	--			minetest.remove_node(pos)
	--		--end
	--	end
	--end
	minetest.register_node(name, def)
end

iadiscordia.register_apple("iadiscordia:golden_apple", S("Fancy Replica Apple"), "golden_apple.png", iadiscordia.on_use_generic, false)

local apple_mold_png = "apple_mold.png"
minetest.register_craftitem("iadiscordia:apple_mold_raw", {
	description     = S("Clay Mold for Casting Apples (Raw)"),
	inventory_image = apple_mold_png,
})

-- Tint of baked tools.
local brown_tint = "#964B00"
-- Opacity of said tint (0-255)
local opacity    = 40
minetest.register_craftitem("iadiscordia:apple_mold", {
	description     = S("Clay Mold for Casting Apples (Baked)"),
	inventory_image = apple_mold_png.."^[colorize:"..brown_tint..":"..opacity
})

local gold_tint = "#d4af37"
local opacity2  = 160
minetest.register_craftitem("iadiscordia:apple_mold_with_gold", {
	description     = S("Clay Mold for Casting Apples (Ready)"),
	inventory_image = apple_mold_png.."^[colorize:"..gold_tint..":"..opacity2
})

iadiscordia.register_apple("iadiscordia:kallisti", S("Replica Mythological Artifact"), "kallisti.png", iadiscordia.on_use, true)

iadiscordia.register_replacement("iadiscordia:golden_apple", "iadiscordia:kallisti", "Hail Eris!")

--
-- Books
--

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
		def.groups          = {not_in_creative_inventory=1,}
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


--
-- Stones
--

iadiscordia.register_replacement("default:paper", "iadiscordia:sacred_chao_sticker", "Chao")
iadiscordia.register_replacement("default:paper", "iadiscordia:chaos_star_sticker",  "Star")
iadiscordia.register_replacement("default:paper", "iadiscordia:naos_sticker",        "NAOS")
iadiscordia.register_replacement("default:paper", "iadiscordia:gunas_sticker",       "Gunas")
iadiscordia.register_replacement("default:paper", "iadiscordia:bagua_sticker",       "Bagua")
iadiscordia.register_replacement("default:paper", "iadiscordia:elder_sticker",       "Elder")
iadiscordia.register_replacement("default:stick", "iadiscordia:wand",                "Wand")

iadiscordia.register_stick = function(name, description, image, on_use, magic)
	assert(name ~= nil)
	assert(description ~= nil)
	assert(image ~= nil)
	--assert(on_use ~= nil)
	assert(magic ~= nil)
	local def           = table.copy(minetest.registered_items["default:stick"])
	--def.name = name
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.on_use          = on_use

	if magic then
		def.groups          = {not_in_creative_inventory=1,}
		def.light_source    = minetest.LIGHT_MAX
	end

	--minetest.register_craftitem(name, def)
	minetest.register_tool(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end
iadiscordia.register_stick("iadiscordia:wand", S("Abracadabra"), "default_stick.png", iadiscordia.on_use_generic, true)

iadiscordia.register_stone = function(name, description, image, on_use)
	local def           = table.copy(minetest.registered_items["default:mese_crystal"])
	--def.name = name
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.on_use          = on_use

	def.groups          = {not_in_creative_inventory=1,}
	def.light_source    = minetest.LIGHT_MAX

	minetest.register_craftitem(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end
iadiscordia.register_stone("iadiscordia:philosopher_stone", S("Salve et Coagula"), "stone.png", 


-- register_replacement => transmutation circles
-- transmutation circle casts spell with bypass; just needs spell title encoded

-- philosopher's stone should store mana&levels from victims and be consumable
-- philosopher's stone can be used as fuel in trans circle => auto magic (use mana)
-- philosopher's stone can be used as upgrades in trans circle => cast at higher level
-- on_use => item eat => next spell will be cast at effective level

-- transmutation circles => cast spells without all the guesswork
-- human transmutation circle => set human trans flag on player
-- how to create philosopher's stone ?
-- use philosopher's stone to power transmutation circles
-- use transmutation circle on human trans player => ascension
function(itemstack, user, pointed_thing)
end)







-- TODO walkable stone
--iadiscordia.register_replacement("default:stone", "iadiscordia:stone",  "Star")

-- TODO exploding trap
-- TODO lodestone


---- TODO for use on players
--def = table.copy(minetest.registered_items["default:book"])
--def.description     = S("Principia Discordia")
--def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7=chaos_star.png\\^\\[resize\\:23x23"
--def.on_use          = iadiscordia.on_use_node
-- TODO register node
--iadiscordia.get_connected_nodes = function(pos, param2, cnt)
--    local list = {}
--
--    local list_to_add = {}
--    iaflyingships.add_to_table(list_to_add, pos)
--
--    while #list_to_add > 0 do
--        minetest.log("action", "Connecting nodes from " .. minetest.pos_to_string(pos))
--        local just_added = {}
--
--        for _,tpos in ipairs(list_to_add) do
--            if not(iaflyingships.pos_in_table(list, tpos)) then
--                iaflyingships.add_to_table(list, tpos)
--                iaflyingships.add_to_table(just_added, tpos)
--            end
--        end
--
--        list_to_add = {}
--
--        --if #list > iaflyingships.MAX_BLOCKS_PER_SHIP then -- TODO mana
--        if #list > cnt then
--            return list
--        end
--
--        for _,tpos in ipairs(just_added) do
--            for i=1,#iaflyingships.DIRS do
--                local npos = vector.add(tpos, iaflyingships.DIRS[i])
--
--                local nodename = minetest.get_node(npos).name
--
--                if nodename ~= "air" and not(iaflyingships.pos_in_table(list, npos)) then
--                    iaflyingships.add_to_table(list_to_add, npos)
--                end
--            end
--        end
--    end
--
--    if #list > 0 then
--        for i, tpos in ipairs(list) do
--            local t = vector.subtract(tpos, pos)
----            if param2 ~= nil then
--                local q = iaflyingships.facedir_to_rotate(param2):conjugate()
--                t = q:rotate_no_scale(t)
----            end
--            list[i] = t
--        end
--        return list
--    else
--       k return nil
--    end
--end
--function iadiscordia.avalanche(pos, cnt)
--	minetest.spawn_falling_node(pos)
--	local nodes = iadiscordia.get_connected_nodes(pos, 0, cnt)
--	if nodes ~= nil then
--		for _,node in ipairs(nodes) do
--			minetest.spawn_falling_node(node)
--		end
--	end
--end
--def.on_use = function(itemstack, user, pointed_thing)
--	if pointed_thing.type ~= "node" then return nil end
--
--	local above = pointed_thing.above
--	local under = pointed_thing.under
--
--	-- TODO mana
--	
--	if above == nil and under == nil then return nil end
--
--	if not iadiscordia.spell_cost(user) then
--		iadiscordia.chat_send_user(user, S('Fatally insufficient MP or HP'))
--		return nil
--	end
--
--	local cnt    = itemstack:get_count()
--	local set_id = user:get_player_name()
--	local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")
--
--	cnt = math.floor(cnt * (1 - 1 / (level + 1)))
--	if cnt == 0 then
--		iadiscordia.chat_send_user(user, S('Technical success: insufficient magick level or stack count'))
--		itemstack:clear()
--		return itemstack
--	end
--
--	if above ~= nil then iadiscordia.avalance(above, cnt) end
--	if under ~= nil then iadiscordia.avalance(under, cnt) end
--
--	return nil
--end
--minetest.register_craftitem("iadiscordia:principia_discordia", def)

