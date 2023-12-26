--
-- Grant Privileges
--

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

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

local stick         = "default:stick"
local kyber_crystal = "adv_lightsabers:kyber_crystal"

if minetest.get_modpath("playerplus") then
	iadiscordia.register_spell(stick, {
		password="Knockback Off",
		callback=function(user)
			local name  = user:get_player_name()
			--local privs = minetest.get_player_privs(name)
			--privs = table.copy(privs)
			--privs.no_knockback = true
			minetest.set_player_privs(name, { no_knockback = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Knockback On",
		callback=function(user)
			local name  = user:get_player_name()
			--local privs = minetest.get_player_privs(name)
			--privs = table.copy(privs)
			--privs.no_knockback = true
			minetest.set_player_privs(name, { no_knockback = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Knockback",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { no_knockback = not priv.no_knockback, })
		end,
	})
end

if minetest.get_modpath("adv_lightsabers") then
	iadiscordia.register_spell(kyber_crystal, {
		password="Jedi",
		callback=function(user)
			local name = user:get_player_name()
			minetest.set_player_privs(name, { force_abilities = true, })
		end
	})
	iadiscordia.register_spell(kyber_crystal, {
		password="Squib",
		callback=function(user)
			local name = user:get_player_name()
			minetest.set_player_privs(name, { force_abilities = false, })
		end
	})
	iadiscordia.register_spell(kyber_crystal, {
		password="Force",
		callback=function(user)
			local name = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { force_abilities = not priv.force_abilities, })
		end
	})
end

if minetest.get_modpath("locks") then
	iadiscordia.register_spell(stick, {
		password="Dig Locks On",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { diglocks = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Dig Locks Off",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { diglocks = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Dig Locks",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { diglocks = not priv.diglocks, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks On",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { openlocks = true, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks Off",
		callback=function(user)
			local name  = user:get_player_name()
			minetest.set_player_privs(name, { openlocks = false, })
		end,
	})
	iadiscordia.register_spell(stick, {
		password="Open Locks",
		callback=function(user)
			local name  = user:get_player_name()
			local priv  = minetest.get_player_privs(name)
			minetest.set_player_privs(name, { openlocks = not priv.openlocks, })
		end,
	})
end

