--
-- Manipulate the Church Crosses
--

local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

local golden_apple       = "iadiscordia:golden_apple"
local kallisti           = "iadiscordia:kallisti"
local stick              = "default:stick"
local apple              = "default:apple"
local bucket_water       = "bucket:bucket_water"
local bucket_empty       = "bucket:bucket_empty"
local bucket_river_water = "bucket:bucket_river_water"
local bucket_lava        = "bucket:lava"
local mese_crystal       = "default:mese_crystal"
local obsidian_shard     = "default:obsidian_shard"
local diamond            = "default:diamond"
local gold_lump          = "default:gold_lump"
local torch              = "default:torch"
local ice                = "default:ice"
local basic_flame        = "fire:basic_flame"
local ice_slab           = "stairs:slab_ice"
local poop_turd          = "pooper:poop_turd"
local poop_pile          = "pooper:poop_pile"

local apple_rad          = 5
local rps_duration       = 30
local flood_rad          = 10
local bonemeal_rad       = 10

if  minetest.get_modpath("church_cross")
and minetest.get_modpath("iadecor") then
	-- TODO other crosses
	local cross_rad  = 30
	local cross_gold = "church_cross:cross_gold"
	iadiscordia.register_spell(cross_gold, {
		password="Holy",
		callback=function(user)
			local pos   = user:get_pos()
			local rad   = cross_rad
			iamedusa.fix_crosses(pos, rad)
		end,
	})
	iadiscordia.register_spell(cross_gold, {
		password="Unholy",
		callback=function(user)
			local pos   = user:get_pos()
			local rad   = cross_rad
			iamedusa.invert_crosses(pos, rad)
		end,
	})
end

local torch = "default:torch"
if  minetest.get_modpath("church_candles")
and minetest.get_modpath("default") then
	local candle_rad = 30
	local church_candles = {}
	church_candles.types = {
        {
                unlit = "church_candles:candle",
                lit = "church_candles:candle_lit",
                --name = "Candle",
                --ingot = nil,
                --image = "church_candles_candle"
        },
                {
                unlit = "church_candles:candle_floor_steel",
                lit = "church_candles:candle_floor_steel_lit",
                --name = "Steel Candle Stick",
                --ingot = items.steel_ingot,
                --image = "church_candles_candle_steel"
        },
        {
                unlit = "church_candles:candle_floor_copper",
                lit = "church_candles:candle_floor_copper_lit",
                --name = "Copper Candle Stick",
                --ingot = items.copper_ingot,
                --image = "church_candles_candle_copper"
        },
        {
                unlit = "church_candles:candle_floor_silver",
                lit = "church_candles:candle_floor_silver_lit",
                --name = "Silver Candle Stick",
                --ingot = items.silver_ingot,
                --image = "church_candles_candle_silver"
        },
        {
                unlit = "church_candles:candle_floor_gold",
                lit = "church_candles:candle_floor_gold_lit",
                --name = "Gold Candle Stick",
                --ingot = items.gold_ingot,
                --image = "church_candles_candle_gold"
        },
        {
                unlit = "church_candles:candle_floor_bronze",
                lit = "church_candles:candle_floor_bronze_lit",
                --name = "Bronze Candle Stick",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candle_bronze"
        },
        {
                unlit = "church_candles:candle_wall_steel",
                lit = "church_candles:candle_wall_steel_lit",
                --name = "Steel Wall-Mount Candle",
                --ingot = items.steel_ingot,
                --image = "church_candles_candle_steel"
        },
        {
                unlit = "church_candles:candle_wall_copper",
                lit = "church_candles:candle_wall_copper_lit",
                --name = "Copper Wall-Mount Candle",
                --ingot = items.copper_ingot,
                --image = "church_candles_candle_copper"
        },
        {
                unlit = "church_candles:candle_wall_silver",
                lit = "church_candles:candle_wall_silver_lit",
                --name = "Silver Wall-Mount Candle",
                --ingot = items.silver_ingot,
                --image = "church_candles_candle_silver"
        },
        {
                unlit = "church_candles:candle_wall_gold",
                lit = "church_candles:candle_wall_gold_lit",
                --name = "Gold Wall-Mount Candle",
                --ingot = items.gold_ingot,
                --image = "church_candles_candle_gold"
        },
        {
                unlit = "church_candles:candle_wall_bronze",
                lit = "church_candles:candle_wall_bronze_lit",
                --name = "Bronze Wall-Mount Candle",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candle_bronze"
        },
        {
                unlit = "church_candles:candelabra_steel",
                lit = "church_candles:candelabra_steel_lit",
                --name = "Steel Candelebra",
                --ingot = items.steel_ingot,
                --image = "church_candles_candelabra_steel"
        },
        {
                unlit = "church_candles:candelabra_copper",
                lit = "church_candles:candelabra_copper_lit",
                --name = "Copper Candelebra",
                --ingot = items.copper_ingot,
                --image = "church_candles_candelabra_copper"
        },
        {
                unlit = "church_candles:candelabra_silver",
                lit = "church_candles:candelabra_silver_lit",
                --name = "Silver Candelebra",
                --ingot = items.silver_ingot,
                --image = "church_candles_candelabra_silver"
        },
        {
                unlit = "church_candles:candelabra_gold",
                lit = "church_candles:candelabra_gold_lit",
                --name = "Gold Candelebra",
                --ingot = items.gold_ingot,
                --image = "church_candles_candelabra_gold"
        },
        {
                unlit = "church_candles:candelabra_bronze",
                lit = "church_candles:candelabra_bronze_lit",
                --name = "Bronze Candelebra",
                --ingot = items.bronze_ingot,
                --image = "church_candles_candelabra_bronze"
        },
	}

	iadiscordia.register_spell(torch, {
		password="Let there be light",
		callback=function(user)
			local tgts = {}
			for _,data in ipairs(church_candles.types) do
				table.insert(tgts, data.unlit)
			end

			local pos   = user:get_pos()
			local rad   = candle_rad
			local minp  = vector.subtract(pos, rad)
			local maxp  = vector.add     (pos, rad)
			local nps,_ = minetest.find_nodes_in_area(minp, maxp, tgts)
			for _,np in ipairs(nps) do
				local node = minetest.get_node(np)
				local def  = minetest.registered_nodes[node.name]
				def.on_punch(np, node, user)
			end
		end,
	})
	iadiscordia.register_spell(torch, {
		password="The Light is a lie; Darkness is Truth",
		callback=function(user)
			local tgts = {}
			for _,data in ipairs(church_candles.types) do
				table.insert(tgts, data.lit)
			end

			local pos   = user:get_pos()
			local rad   = candle_rad
			local minp  = vector.subtract(pos, rad)
			local maxp  = vector.add     (pos, rad)
			local nps,_ = minetest.find_nodes_in_area(minp, maxp, tgts)
			for _,np in ipairs(nps) do
				local node = minetest.get_node(np)
				local def  = minetest.registered_nodes[node.name]
				def.on_punch(np, node, user)
			end
		end,
	})
end

