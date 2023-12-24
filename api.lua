--
-- The original extended API
--

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator("iadiscordia")

iadiscordia.epic = core.settings:get "iadiscordia_epic" or 9000

function iadiscordia.register_replacement(name, repl, password)
	iadiscordia.register_spell(name, {
		password=password,
		callback=function(user)
			return repl
		end,
	})
end

if minetest.get_modpath("engrave") then
function iadiscordia.on_use_generic(itemstack, user, pointed_thing)
	--if itemstack:get_name() ~= "iadiscordia:golden_apple" then return nil end

	--if not iadiscordia.spell_cost(user) then
	--	iadiscordia.chat_send_user(user, S('Fatally insufficient MP or HP'))
	--	return nil
	--end

	local set_id      = user:get_player_name()          -- something you are
 	local itemname    = itemstack:get_name()            -- something you have
    	local meta        = itemstack:get_meta()
    	local description = meta:get_string("description")  -- something you know
	if description == nil then
		print('no description')
		iadiscordia.chat_send_user(user, S('Missing Arcane Inscription'))
		return nil
	end

	--local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")

	--if level <= epic then return nil end
	
	-- TODO check whether itemname should grant special effects
	local random_mp  = false
	local random_hp  = false
	local random_xp  = false
	local random_lvl = false
	local random_cnt = false
	local random_rnd = false
	print('itemname: '..itemname)
	print('description: '..description)
	-- TODO callback needs target
	return iadiscordia.on_use_helper(itemstack, user, itemname, description, set_id,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)--, false)
end
end

if minetest.get_modpath("pencil_redo") then
function iadiscordia.on_use_node(itemstack, user, pointed_thing)
	if pointed_thing.type ~= "node" then
		iadiscordia.chat_send_user(user, S('Expecting a node'))
		return nil
	end

	local pos  = pointed_thing.under
        local node = minetest.get_node(pos)
	if DEBUG_ON_USE then
	print('node name: '..node.name)
	end
	--if node.name ~= "default:book_open" then
	--	iadiscordia.chat_send_user(user, S('Expecting an open book'))
	--	return nil
	--end

	local meta  = minetest.get_meta(pos)
	local title = node.name
	local text  = meta:get_string("infotext")
	local owner = user:get_player_name()
	if DEBUG_ON_USE then
	print('title: '..title)
	print('text : '..text)
	print('owner: '..owner)
	end

	if text == nil then
		print('no description')
		iadiscordia.chat_send_user(user, S('Missing Arcane Inscription'))
		return nil
	end

	-- TODO replace targeted node
	--if not minetest.dig_node(pos) then -- should work great with hbhunger
	--	print('spell failed to dig')
	--	iadiscordia.chat_send_user(user, S('Failed to dig'))
	--	return nil
	--end

	-- TODO check whether title should grant special effects
	local random_mp  = false
	local random_hp  = false
	local random_xp  = false
	local random_lvl = false
	local random_cnt = false
	local random_rnd = false
	-- TODO callback needs target
	local newnode = iadiscordia.on_use_helper(itemstack, user, title, text, owner,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)--, false)
	if newnode == nil then return nil end
	minetest.remove_node(pos)
	--minetest.set_node(pos, newnode)
	return newnode
end
end
