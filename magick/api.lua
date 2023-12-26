--
-- Use other mods' APIs
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

--
-- Tides and Floods
--

if  minetest.get_modpath("tidesandfloods")
and minetest.get_modpath("bucket") then
	local flood_rad = 10
	iadiscordia.register_spell(bucket_water, {
		password="Noah's Ark",
		callback=function(user)
			tidesandfloods.water_level = tidesandfloods.water_level + flood_rad
		end,
	})
	iadiscordia.register_spell(bucket_empty, {
		password="Noah's Ark",
		callback=function(user)
			tidesandfloods.water_level = tidesandfloods.water_level - flood_rad
		end,
	})
	iadiscordia.register_spell(bucket_water, {
		password="Reset",
		callback=function(user)
			tidesandfloods.water_level = 0
		end,
	})
	iadiscordia.register_spell(bucket_empty, {
		password="Reset",
		callback=function(user)
			tidesandfloods.water_level = 0
		end,
	})
end

--
-- Sum Air Currents
--

if  minetest.get_modpath("sum_air_currents")
and minetest.get_modpath("default") then
	iadiscordia.register_spell(stick, {
		password="Windy",
		callback=function(user)
			sum_air_currents.wind_speed = sum_air_currents.max_wind_speed
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Calm",
		callback=function(user)
			sum_air_currents.wind_speed = 0
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Random Wind",
		callback=function(user)
			sum_air_currents.wind_speed = math.random(0, sum_air_currents.max_wind_speed)
		end,
	})
end

--
-- Time of Day
--

local mese_crystal   = "default:mese_crystal"
local obsidian_shard = "default:obsidian_shard"
-- TODO maybe just use mese or gold for manipulating the sun cycles
if minetest.get_modpath("default") then
	iadiscordia.register_day_spell("Morning",  0.25)
	iadiscordia.register_day_spell("Midday",   0.5)
	iadiscordia.register_day_spell("Evening",  0.75)
	iadiscordia.register_day_spell("Midnight", 0.0)
end

--
-- Moon Phases
--

-- TODO maybe use silver
if  minetest.get_modpath("moon_phases")
and minetest.get_modpath("default") then
	iadiscordia.register_moon_spell("Waxing Crescent", 1)
	iadiscordia.register_moon_spell("First Quarter",   2)
	iadiscordia.register_moon_spell("Waxing Gibbous",  3)
	iadiscordia.register_moon_spell("Full Moon",       4)
	iadiscordia.register_moon_spell("Waning Gibbous",  5)
	iadiscordia.register_moon_spell("Third Quarter",   6)
	iadiscordia.register_moon_spell("Waning Crescent", 7)
	iadiscordia.register_moon_spell("New Moon",        8)
end

--
-- Bonemeal
--

if minetest.get_modpath("bonemeal") then
	local bonemeal_rad = 10
	local nodes        = {"group:dirt", "group:sand", "group:soil", "group:flora", "group:can_bonemeal",} -- TODO rip more types from bonemeal/mods.lua
	iadiscordia.register_bonemeal_spell("bonemeal:mulch",      1)
	iadiscordia.register_bonemeal_spell("bonemeal:bonemeal",   2)
	iadiscordia.register_bonemeal_spell("bonemeal:fertiliser", 3)
	iadiscordia.register_bonemeal_spell(kallisti,              4)
end
-- TODO basalt fertiliser
-- TODO composting ?

if minetest.get_modpath("invisible") then
	iadiscordia.register_replacement(stick, "invisible:tool", "Invisible")
	iadiscordia.register_spell(stick, {
		password="Visible",
		callback=function(user)
			invisible.toggle(user,true)
		end,
	})
end

--
-- Doors
--

if minetest.get_modpath("doors") then
	local knock_rad = 10
	iadiscordia.register_spell(stick, {
		password="Knock",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			for _,np in ipairs(nps) do
				local door = doors.get(np)
				assert(door ~= nil)
				door:open(user) -- TODO open all doors
			end
			return ""
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Lock",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			for _,np in ipairs(nps) do
				local door = doors.get(np)
				assert(door ~= nil)
				door:close(user) -- TODO close all doors
			end
			return ""
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Old screen door",
		--password="Lock test",
		callback=function(user)
			local pos    = user:get_pos()
			local rad    = knock_rad
			local minp   = vector.subtract(pos, rad)
			local maxp   = vector.add     (pos, rad)
			local nps, _ = minetest.find_nodes_in_area(minp, maxp, {"group:door",})
			local function helper()
				for _,np in ipairs(nps) do
					local door = doors.get(np)
					assert(door ~= nil)
					door:toggle(user) -- TODO close all doors
				end
			end
			local flap_duration = 10
			for t=1,flap_duration do
				minetest.after(t, helper)
			end
			return ""
		end,
	})
end

