--
-- Copied from `books`
--

--[[ Placeable Books by everamzah
	Copyright (C) 2016 James Stevenson
	LGPLv2.1+
	See LICENSE for more information ]]

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)
local F = minetest.formspec_escape

iadiscordia.books         = {}

local lpp = 14 -- Lines per book's page

local function copymeta(frommeta, tometa)
	tometa:from_table( frommeta:to_table() )
end

iadiscordia.on_place_book = function(itemstack, placer, pointed_thing)
	if minetest.is_protected(pointed_thing.above, placer:get_player_name()) then
		-- TODO: record_protection_violation()
		return itemstack
	end

	local pointed_on_rightclick = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].on_rightclick
	if pointed_on_rightclick and not placer:get_player_control().sneak then
		return pointed_on_rightclick(pointed_thing.under, minetest.get_node(pointed_thing.under), placer, itemstack)
	end
	local data = itemstack:get_meta()
	local data_owner = data:get_string("owner")

	local name = itemstack:get_name()
	local new_name = iadiscordia.books[name].closed

	local stack = ItemStack({name = new_name})
	if data and data_owner then
		copymeta(itemstack:get_meta(), stack:get_meta() )
	end
	local _, placed = minetest.item_place_node(stack, placer, pointed_thing, nil)
	if placed then
		itemstack:take_item()
	end
	return itemstack
end

iadiscordia.after_place_node_book = function(pos, placer, itemstack, pointed_thing)

	local itemmeta = itemstack:get_meta()
	if itemmeta then
		local nodemeta = minetest.get_meta(pos)
		copymeta(itemmeta, nodemeta)
		nodemeta:set_string("infotext", S("@1\n\nby @2", itemmeta:get_string("title"),
			itemmeta:get_string("owner")))
	end
end

local function formspec_display(meta, player_name, pos)
	-- Courtesy of minetest_game/mods/default/craftitems.lua
	local title, text, owner = "", "", player_name
	local page, page_max, lines, string = 1, 1, {}, ""

	if meta:to_table().fields.owner then
		title = meta:get_string("title")
		text = meta:get_string("text")
		owner = meta:get_string("owner")

		for str in (text .. "\n"):gmatch("([^\n]*)[\n]") do
			lines[#lines+1] = str
		end

		if meta:to_table().fields.page then
			page = meta:to_table().fields.page
			page_max = meta:to_table().fields.page_max

			for i = ((lpp * page) - lpp) + 1, lpp * page do
				if not lines[i] then break end
				string = string .. lines[i] .. "\n"
			end
		end
	end

	local formspec
	if owner == player_name
	or (minetest.check_player_privs(player_name, {editor = true})
	and minetest.get_player_by_name(player_name):get_wielded_item():get_name() == "books:admin_pencil" ) then
		formspec = "size[8,8]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			"field[-4,-4;0,0;owner;"..F(S("Owner:"))..";" .. owner .. "]" ..

			"field[0.5,1;7.5,0;title;"..F(S("Title:"))..";" ..
				F(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;text;"..F(S("Contents:"))..";" ..
				F(text) .. "]" ..
			"button_exit[2.5,7.5;3,1;save;"..F(S("Save")).."]"
			-- TODO FIXME WE NEED TO SET A HIDDEN "owner" FIELD !!
	else
		formspec = "size[8,8]" ..
			default.gui_bg ..
			default.gui_bg_img ..
			"label[0.5,0.5;by " .. owner .. "]" ..
			"tablecolumns[color;text]" ..
			"tableoptions[background=#00000000;highlight=#00000000;border=false]" ..
			"table[0.4,0;7,0.5;title;#FFFF00," .. F(title) .. "]" ..
			"textarea[0.5,1.5;7.5,7;;" ..
				F(string ~= "" and string or text) .. ";]" ..
			"button[2.4,7.6;0.8,0.8;book_prev;<]" ..
			"label[3.2,7.7;"..F(S("Page @1 of @2", page, page_max)) .. "]" ..
			"button[4.9,7.6;0.8,0.8;book_next;>]"
	end

	--local node = minetest.get_node(pos)
	--local name = node.name
	--local new_name
	--if  name:sub(1, 32) ~= "iadiscordia:principia_discordia_" then
	--	new_name = 'iadiscordia:principia_discordia_'
	--elseif name:sub(1, 24) ~= "iadiscordia:chao_de_jing" then
	--	new_name = 'iadiscordia:chao_de_jing_'
	--end
	-- TODO
	minetest.show_formspec(player_name,
			'default:book_' .. minetest.pos_to_string(pos), formspec)
end

iadiscordia.on_rightclick_book = function(pos, node, clicker, itemstack, pointed_thing)
	if node.name == "iadiscordia:manual_open" then
		local name = itemstack:get_name()
		if name ~= "" then
			local message = iadiscordia.manual[name] or S("Unrecognized item")
			iadiscordia.chat_send_user(clicker, message)
			local meta = minetest.get_meta(pos)
			local player_name = clicker:get_player_name()
			--if player_name == meta:get_string("owner") then
				meta:set_string("title",     name)
				meta:set_string("text",      message)
				meta:set_string("owner",     clicker:get_player_name())
				meta:set_string("infotext",  message)
				meta:set_int   ("text_len",  message:len())
				meta:set_int("page", 1)
				meta:set_int("page_max", math.ceil((message:gsub("[^\n]", ""):len() + 1) / lpp))
			--end
			return nil
		end
	end
	if node.name == "iadiscordia:death_note_open" then
		local meta = minetest.get_meta(pos)
		local target = meta:get_string("text")
		local victim = minetest.get_player_by_name(target)
		if victim == nil then
			iadiscordia.chat_send_user(clicker, "Player not found")
			return nil
		end
		iadiscordia.chat_send_user(clicker, "Death note")
		victim:set_hp(-100)
		return
	end
	if node.name == "iadiscordia:necronomicon_open" then
		local meta   = clicker:get_meta()
		local sanity = meta:get_int("sanity") or 0
		local diff   = math.random() -- TODO check level ?
		iadiscordia.chat_send_user(clicker, "You feel yourself slipping into madness")
		meta:set_int("sanity", sanity - diff)
	end

	local book = iadiscordia.books[node.name]
	if book.is_open then
		print('book is open')
		local player_name = clicker:get_player_name()
		local meta = minetest.get_meta(pos)
		formspec_display(meta, player_name, pos)
	elseif book.is_closed then
		print('book was closed')
		node.name = book.open
		minetest.swap_node(pos, node)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext",
				meta:get_string("text"))
	else
		print('else')
	end
end

iadiscordia.on_punch_book = function(pos, node, puncher, pointed_thing)
	local book = iadiscordia.books[node.name]
	if book.is_open then
		print('book was open')
		node.name = book.closed
		minetest.swap_node(pos, node)
		local meta = minetest.get_meta(pos)
		if meta:get_string("owner") ~= "" then
			meta:set_string("infotext",
					S("@1\n\nby @2", meta:get_string("title"),
					meta:get_string("owner")))
		end
	elseif book.is_closed then
		print('book was closed')
		minetest.swap_node(pos, node)
		local meta = minetest.get_meta(pos)
		if meta:get_string("owner") ~= "" then
			meta:set_string("infotext",
					S("@1\n\nby @2", meta:get_string("title"),
					meta:get_string("owner")))
		end
	else
		print('else')
	end
end

iadiscordia.on_dig_book = function(pos, node, digger)
	if minetest.is_protected(pos, digger:get_player_name()) then
		-- TODO: record_protection_violation()
		return false
	end

	local nodemeta = minetest.get_meta(pos)
	local stack

	local name = minetest.get_node(pos)

	if nodemeta:get_string("owner") ~= "" then
		--stack = ItemStack({name = name})
		stack = ItemStack(name)
		copymeta(nodemeta, stack:get_meta() )
	else
		--stack = ItemStack({name = "default:book"})
		stack = ItemStack(name)
	end

	local adder = digger:get_inventory():add_item("main", stack)
	if adder then
		minetest.item_drop(adder, digger, digger:getpos())
	end
	minetest.remove_node(pos)
end





minetest.register_on_player_receive_fields(function(player, formname, fields)
	--if  formname:sub(1, 32) ~= "iadiscordia:principia_discordia_"
	--and formname:sub(1, 24) ~= "iadiscordia:chao_de_jing" then
	--	return
	--end
	if formname:sub(1, 13) ~= "default:book_" then return end

	if fields.save and fields.title ~= "" and fields.text ~= "" then
		local pos = minetest.string_to_pos(formname:sub(14))
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		local text = fields.text:gsub("\r\n", "\n"):gsub("\r", "\n"):sub(1, 10000)
		local title = fields.title:sub(1, 80)

		meta:set_string("title", title)
		meta:set_string("text", text)
		meta:set_string("owner", fields.owner or player:get_player_name() )
		meta:set_string("infotext", text)
		meta:set_int("text_len", text:len())
		meta:set_int("page", 1)
		meta:set_int("page_max", math.ceil((text:gsub("[^\n]", ""):len() + 1) / lpp))
	elseif fields.book_next or fields.book_prev then
		local pos = minetest.string_to_pos(formname:sub(14))
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)

		if fields.book_next then
			meta:set_int("page", meta:get_int("page") + 1)
			if meta:get_int("page") > meta:get_int("page_max") then
				meta:set_int("page", 1)
			end
		elseif fields.book_prev then
			meta:set_int("page", meta:get_int("page") - 1)
			if meta:get_int("page") == 0 then
				meta:set_int("page", meta:get_int("page_max"))
			end
		end

		formspec_display(meta, player:get_player_name(), pos)
	end
end)
