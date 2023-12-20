local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator("iadiscordia")

--
-- Apples
--

iadiscordia.register_apple = function(name, description, image, on_use)
	local def           = table.copy(minetest.registered_nodes["default:apple"])
	def.description     = description
	def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.on_use          = on_use
	--minetest.register_craftitem(name, def)
	-- TODO on place...
	minetest.register_node(name, def)
end

iadiscordia.register_apple("iadiscordia:golden_apple", S("Fancy Replica Apple"), "golden_apple.png", iadiscordia.on_use_generic)

local apple_mold_png = "apple_mold.png"
minetest.register_craftitem("iadiscordia:apple_mold_raw", {
	description = S("Clay Mold for Casting Apples (Raw)"),
	inventory_image = apple_mold_png,
})

-- Tint of baked tools.
local brown_tint = "#964B00"
-- Opacity of said tint (0-255)
local opacity    = 40
minetest.register_craftitem("iadiscordia:apple_mold", {
	description = S("Clay Mold for Casting Apples (Baked)"),
	inventory_image = apple_mold_png.."^[colorize:"..brown_tint..":"..opacity
})

local gold_tint = "#d4af37"
local opacity2  = 160
minetest.register_craftitem("iadiscordia:apple_mold_with_gold", {
	description = S("Clay Mold for Casting Apples (Ready)"),
	inventory_image = apple_mold_png.."^[colorize:"..gold_tint..":"..opacity2
})

iadiscordia.register_apple("iadiscordia:kallisti", S("Replica Mythological Artifact"), "kallisti.png", iadiscordia.on_use)

iadiscordia.register_replacement("iadiscordia:golden_apple", "iadiscordia:kallisti", "Hail Eris!")

--
-- Books
--

iadiscordia.register_book = function(name, description, image, on_use)
	local def           = table.copy(minetest.registered_items["default:book"])
	def.description     = description
	def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7="..image.."\\^\\[resize\\:23x23"
	def.on_use          = on_use
	-- TODO register node
	minetest.register_craftitem(name, def)
end
--local book_on_use = minetest.registered_items["default:book"].on_use
iadiscordia.register_book("iadiscordia:manual", S("IA Discordia User Manual"), "kallisti.png", 

function(itemstack, user, pointed_thing)
	-- TODO tell player how to use the pointed_thing
    	--local meta        = itemstack:get_meta()
	--local title = meta:set_string("title", S("IA Discordia User Manual"))
	--local text  = meta:set_string("text", S("Engrave a golden apple, then use it to get a Kallisti artifact.\nUse the Kallisti artifact on books to learn spells for the owner.\nUse the Chao De Jing on penciled nodes.\nUse engraved items on the Principia Discordia.")) -- TODO engraved items
	--local owner = meta:set_string("owner")
	--return book_on_use(itemstack, user, pointed_thing)
end)

minetest.register_craftitem("iadiscordia:sacred_chao_sticker", {
	description     = S("Sacred Chao Sticker"),
	inventory_image = "chao.png",
})

iadiscordia.register_book("iadiscordia:chao_de_jing", S("Chao De Jing"), "chao.png", iadiscordia.on_use_node)

minetest.register_craftitem("iadiscordia:sacred_chao_sticker", {
	description     = S("Sacred Chao Sticker"),
	inventory_image = "chao.png",
})

iadiscordia.register_book("iadiscordia:principia_discordia", S("Principia Discordia"), "chaos_star.png", 
-- TODO
function(itemstack, user, pointed_thing)
end)

minetest.register_craftitem("iadiscordia:chaos_star_sticker", {
	description     = S("Chaos Star Sticker"),
	inventory_image = "chaos_star.png",
})

--
-- Stones
--

-- TODO need a way to use engraved items on a magick item to check them and cast the spell
--iadiscordia.register_replacement("default:paper", "iadiscordia:sacred_chao_sticker", "Chao")
--iadiscordia.register_replacement("default:paper", "iadiscordia:chaos_star_sticker",  "Star")

iadiscordia.register_stone = function(name, description, image, on_use)
	local def           = table.copy(minetest.registered_items["default:mese_crystal"])
	def.description     = description
	--def.groups          =  {hard = 1, metal = 1,}
	--def.tiles           = {image,}
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.on_use          = on_use
	minetest.register_craftitem(name, def)
	-- TODO on place...
	--minetest.register_node(name, def)
end
iadiscordia.register_stone("iadiscordia:philosopher_stone", S("Salve et Coagula"), "stone.png", 
-- TODO do alchemy on bones => set human trans flag on player
-- => create philosopher's stone
-- use philosopher's stone on player or bones => increment counter in stone
-- 
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

