-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?



local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

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
--iadiscordia.register_stick("iadiscordia:wand", S("Abracadabra"), "default_stick.png", iadiscordia.on_use_generic, true)
iadiscordia.register_stick("iadiscordia:wand", S("Abracadabra"), "default_stick.png", iadiscordia.on_use_node, true)


