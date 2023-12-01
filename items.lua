local S = minetest.get_translator("iadiscordia")

--local epic = core.settings:get "iadiscordia_epic" or 9000
function on_use_forgery(itemstack, user, pointed_thing)
	if itemstack:get_name() ~= "iadiscordia:golden_apple" then return nil end
	local cnt  = itemstack:get_count()

	if not iadiscordia.spell_cost(user) then
		iadiscordia.chat_send_user(user, S('Fatally insufficient MP or HP'))
		return nil
	end

	local set_id = user:get_player_name()
	local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")
	--if level <= epic then return nil end

	cnt = math.floor(cnt * (1 - 1 / (level + 1)))
	if cnt == 0 then
		iadiscordia.chat_send_user(user, S('Technical success: insufficient magick level or stack count'))
		itemstack:clear()
		return itemstack
	end
	
	Skillsframework.add_experience(set_id, "iadiscordia:Chaos Magick", 1)
	local newstack = ItemStack("iadiscordia:kallisti", cnt)
	return newstack
end

local def = table.copy(minetest.registered_items["default:apple"])
def.description     = S("Fancy Replica Apple")
def.groups          =  {hard = 1, metal = 1,}
def.inventory_image = "golden_apple.png"
def.on_use          = on_use_forgery
minetest.register_craftitem("iadiscordia:golden_apple", def)

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
def.inventory_image = "kallisti.png"
def.on_use          = iadiscordia.on_use
minetest.register_craftitem("iadiscordia:kallisti", def)

def = table.copy(minetest.registered_items["default:book"])
def.description     = S("Chao De Jing")
def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7=chao.png\\^\\[resize\\:23x23"
--def.on_use          = iadiscordia.on_use
minetest.register_craftitem("iadiscordia:chao_de_jing", def)

minetest.register_craftitem("iadiscordia:sacred_chao_sticker", {
	description     = S("Sacred Chao Sticker"),
	inventory_image = "chao.png",
})

def = table.copy(minetest.registered_items["default:book"])
def.description     = S("Principia Discordia")
def.inventory_image = "[combine:64x64:0,0=default_book.png\\^\\[resize\\:64x64]:21,7=chaos_star.png\\^\\[resize\\:23x23"
--def.on_use          = iadiscordia.on_use
minetest.register_craftitem("iadiscordia:principia_discordia", def)

minetest.register_craftitem("iadiscordia:chaos_star_sticker", {
	description     = S("Chaos Star Sticker"),
	inventory_image = "chaos_star.png",
})
