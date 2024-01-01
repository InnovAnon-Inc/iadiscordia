local S = minetest.get_translator("iadiscordia")

--local def = table.copy(minetest.registered_items["default:apple"])
local def = table.copy(minetest.registered_nodes["default:apple"])
def.description     = S("Fancy Replica Apple")
def.groups          =  {hard = 1, metal = 1,}
--def.tiles           = {"golden_apple.png",}
--def.overlay_tiles   = {}
--def.special_tiles   = {}
def.wield_image     = "golden_apple.png"
def.inventory_image = "golden_apple.png"
def.on_use          = iadiscordia.on_use_generic -- engrave password on item then cast spell
--minetest.register_craftitem("iadiscordia:golden_apple", def)
-- TODO on place...
minetest.register_node("iadiscordia:golden_apple", def)

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

def = table.copy(def)
def.description     = S("Replica Mythological Artifact")
def.wield_image     = "kallisti.png"
def.inventory_image = "kallisti.png"
def.on_use          = iadiscordia.on_use -- write password in book then cast spell
--minetest.register_craftitem("iadiscordia:kallisti", def)
-- TODO on place...
minetest.register_node("iadiscordia:kallisti", def)

def = table.copy(minetest.registered_items["default:book"])
def.description     = S("Chao De Jing")
def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7=chao.png\\^\\[resize\\:23x23"
def.on_use          = iadiscordia.on_use_node -- pencil password onto node then cast spell
-- TODO register node
minetest.register_craftitem("iadiscordia:chao_de_jing", def)

minetest.register_craftitem("iadiscordia:sacred_chao_sticker", {
	description     = S("Sacred Chao Sticker"),
	inventory_image = "chao.png",
})

-- TODO for use on players
def = table.copy(minetest.registered_items["default:book"])
def.description     = S("Principia Discordia")
def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7=chaos_star.png\\^\\[resize\\:23x23"
--def.on_use          = iadiscordia.on_use_node
-- TODO register node
iadiscordia.get_connected_nodes = function(pos, param2, cnt)
    local list = {}

    local list_to_add = {}
    iaflyingships.add_to_table(list_to_add, pos)

    while #list_to_add > 0 do
        minetest.log("action", "Connecting nodes from " .. minetest.pos_to_string(pos))
        local just_added = {}

        for _,tpos in ipairs(list_to_add) do
            if not(iaflyingships.pos_in_table(list, tpos)) then
                iaflyingships.add_to_table(list, tpos)
                iaflyingships.add_to_table(just_added, tpos)
            end
        end

        list_to_add = {}

        --if #list > iaflyingships.MAX_BLOCKS_PER_SHIP then -- TODO mana
        if #list > cnt then
            return list
        end

        for _,tpos in ipairs(just_added) do
            for i=1,#iaflyingships.DIRS do
                local npos = vector.add(tpos, iaflyingships.DIRS[i])

                local nodename = minetest.get_node(npos).name

                if nodename ~= "air" and not(iaflyingships.pos_in_table(list, npos)) then
                    iaflyingships.add_to_table(list_to_add, npos)
                end
            end
        end
    end

    if #list > 0 then
        for i, tpos in ipairs(list) do
            local t = vector.subtract(tpos, pos)
--            if param2 ~= nil then
                local q = iaflyingships.facedir_to_rotate(param2):conjugate()
                t = q:rotate_no_scale(t)
--            end
            list[i] = t
        end
        return list
    else
        return nil
    end
end
function iadiscordia.avalanche(pos, cnt)
	minetest.spawn_falling_node(pos)
	local nodes = iadiscordia.get_connected_nodes(pos, 0, cnt)
	if nodes ~= nil then
		for _,node in ipairs(nodes) do
			minetest.spawn_falling_node(node)
		end
	end
end
def.on_use = function(itemstack, user, pointed_thing)
	if pointed_thing.type ~= "node" then return nil end

	local above = pointed_thing.above
	local under = pointed_thing.under

	-- TODO mana
	
	if above == nil and under == nil then return nil end

	if not iadiscordia.spell_cost(user) then
		iadiscordia.chat_send_user(user, S('Fatally insufficient MP or HP'))
		return nil
	end

	local cnt    = itemstack:get_count()
	local set_id = user:get_player_name()
	local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")

	cnt = math.floor(cnt * (1 - 1 / (level + 1)))
	if cnt == 0 then
		iadiscordia.chat_send_user(user, S('Technical success: insufficient magick level or stack count'))
		itemstack:clear()
		return itemstack
	end

	if above ~= nil then iadiscordia.avalance(above, cnt) end
	if under ~= nil then iadiscordia.avalance(under, cnt) end

	return nil
end
minetest.register_craftitem("iadiscordia:principia_discordia", def)

minetest.register_craftitem("iadiscordia:chaos_star_sticker", {
	description     = S("Chaos Star Sticker"),
	inventory_image = "chaos_star.png",
})



iadiscordia.register_replacement("iadiscordia:golden_apple", "iadiscordia:kallisti", "Hail Eris!")
-- TODO need a way to use engraved items on a magick item to check them and cast the spell
--iadiscordia.register_replacement("default:paper", "iadiscordia:sacred_chao_sticker", "Chao")
--iadiscordia.register_replacement("default:paper", "iadiscordia:chaos_star_sticker",  "Star")




-- TODO walkable stone
--iadiscordia.register_replacement("default:stone", "iadiscordia:chaos_star_sticker",  "Star")

-- TODO exploding trap
-- TODO lodestone

