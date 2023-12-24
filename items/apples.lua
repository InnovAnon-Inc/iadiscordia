-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?



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
		def.groups          =  {dig_immediate=1, hard = 1, metal = 1, not_in_creative_inventory=1,}
	else
		def.groups          =  {dig_immediate=1, hard = 1, metal = 1,}
	end
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	def.wield_image     = image
	def.inventory_image = image
	def.tiles           = {image,}
	def.on_use          = on_use
	if magic then
		def.light_source    = minetest.LIGHT_MAX

		print('apple magic right click registered')
		def.on_rightclick   = function(pos, node, clicker, itemstack, pointed_thing)
			print('magic apple on right click')
			return iadiscordia.on_use_generic(itemstack, clicker, pointed_thing)
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

