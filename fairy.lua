	local MODNAME = minetest.get_current_modname()
	local S       = minetest.get_translator(MODNAME)
	local image = "navi.png"
	--image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:18,29="..image.."\\^\\[resize\\:23x23"
	--image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:44x44]:18,29="..image.."\\^\\[resize\\:23x23"
	image = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:20,33="..image.."\\^\\[resize\\:18x18"
	--local anim = "church_candles_hive_busybees.png"
	--anim = "[combine:64x64:0,0=vessels_glass_bottle.png\\^\\[resize\\:64x64]:7,27="..anim.."\\^\\[resize\\:23x23"
	minetest.register_node(MODNAME .. ":fairy_bottle", {
		description = S("Fairy in a Bottle"),
		inventory_image = image, 
		wield_image = image,
		tiles = {{
			--name = anim, -- TODO put it in the jar
			--animation = {
			--	type = "vertical_frames",
			--	aspect_w = 16,
			--	aspect_h = 16,
			--	length = 2,
			--},
			name = "fireflies_bottle_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.5
			},
		}},
		drawtype = "plantlike",
		paramtype = "light",
		sunlight_propagates = true,
		light_source = 9,
		walkable = false,
		groups = {vessel = 1, dig_immediate = 3, attached_node = 1, not_in_creative_inventory = 1},
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
		},
		sounds = default.node_sound_glass_defaults(),
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local lower_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
			if minetest.is_protected(pos, player:get_player_name()) or
					minetest.get_node(lower_pos).name ~= "air" then
				return
			end
	
			local upper_pos = {x = pos.x, y = pos.y + 2, z = pos.z}
			local firefly_pos
	
			if not minetest.is_protected(upper_pos, player:get_player_name()) and
					minetest.get_node(upper_pos).name == "air" then
				firefly_pos = upper_pos
			elseif not minetest.is_protected(lower_pos, player:get_player_name()) then
				firefly_pos = lower_pos
			end
	
			if firefly_pos then
				minetest.set_node(pos, {name = "vessels:glass_bottle"})
				--minetest.set_node(firefly_pos, {name = "iadecor:fairy"})
				minetest.set_node(firefly_pos, {name = "fireflies:firefly"})
				minetest.get_node_timer(firefly_pos):start(1)
			end
		end,
--		on_use = make_on_use(minetest.registered_nodes["fireflies:firefly_bottle"], "church_candles:busybees"),--"bees"),
	})

--	minetest.register_craft( {
--		output = "iadecor:fairy_bottle",
--		recipe = {
--			{"church_candles:busybees"},
--			{"vessels:glass_bottle"}
--		}
--	})

