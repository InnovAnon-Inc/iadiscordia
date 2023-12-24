-- TODO stone doesn't do anything
-- TODO add groups so wizard villager has an easier time
-- TODO could the magic items also gain xp or otherwise be upgraded ?



local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

iadiscordia.register_replacement("default:stone", "iadiscordia:lodestone",           "Lode")
if minetest.get_modpath("iamedusa") then
iadiscordia.register_replacement("default:stone", "iamedusa:medusa",                 "Medusa")
iadiscordia.register_replacement("default:stone", "iamedusa:baphomet",               "Baphomet")
iadiscordia.register_replacement("default:stone", "iamedusa:gargoyle",               "Gargoyle")
end
-- TODO infinity stones, unique

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


iadiscordia.register_stoneblock = function(name, magic)
	assert(name ~= nil)
	--assert(description ~= nil)
	--assert(image ~= nil)
	--assert(on_use ~= nil)
	assert(magic ~= nil)
	local def           = table.copy(minetest.registered_nodes["default:stone"])
	--def.name = name
	--def.description     = description
	def.groups.not_in_creative_inventory = 1
	--def.overlay_tiles   = {}
	--def.special_tiles   = {}
	--def.wield_image     = image
	--def.inventory_image = image
	--def.tiles           = {image,}
	--def.on_use          = on_use
	if magic then
		def.light_source    = minetest.LIGHT_MAX

		--def.on_rightclick   = function(pos, node, clicker, itemstack, pointed_thing)
		--	iadiscordia.on_use_generic(itemstack, clicker, pointed_thing)
		--end
	end

	def.stack_max = 1

	def.on_place = function(itemstack, placer, pointed_thing)
		return itemstack
	end
	def.on_drop = function(itemstack, dropper, pos)
		return itemstack
	end


	--def.after_place_node = function(pos, placer, itemstack)
	--	minetest.set_node(pos, {name=name, param2=1})
	--end
	minetest.register_node(name, def)
end
--minetest.register_on_player_receive_fields(function(player, formname, fields)
--    local inv = player:get_inventory()
--    local itemstack = inv:get_stack("main", inv:get_current_index())
--
--    if itemstack:get_name() == "iadiscordia:lodestone" then
--        -- Check if the player is trying to put or move the lodestone item into an inventory
--        if fields.put or fields.move then
--            -- Clear the fields to prevent the action
--            return true
--        end
--    end
--end)
-- TODO prevent transferring inventory
iadiscordia.register_stoneblock("iadiscordia:lodestone", false)




-- TODO walkable stone
--iadiscordia.register_replacement("default:stone", "iadiscordia:stone",  "Star")

-- TODO exploding trap


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

