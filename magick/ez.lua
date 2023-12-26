--
-- Use this mod's API
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

--
-- Golden Apple & Kallisti
--

local golden_apple = "iadiscordia:golden_apple"
local kallisti     = "iadiscordia:kallisti"
local stick        = "default:stick"
local apple        = "default:apple"

if minetest.get_modpath("default") then
	local apples = {
		golden_apple = apple,
		kallisti     = golden_apple,
	}
	for src,dst in pairs(apples) do
		iadiscordia.register_inventory_spell(src, dst, nil)
		iadiscordia.register_item_spell(src, dst, nil)
	end
	-- TODO convert nodes in area to apples
end

--
-- Convert Expensive Items
--

local diamond   = "default:diamond"
local gold_lump = "default:gold_lump"
if minetest.get_modpath("default") then
	iadiscordia.register_replacement(mese_crystal,   gold_lump,      "All that glitters is gold")
	iadiscordia.register_replacement(diamond,        gold_lump,      "All that glitters is gold")
	iadiscordia.register_replacement(obsidian_shard, gold_lump,      "All that glitters is gold")

	iadiscordia.register_replacement(mese_crystal,   diamond,        "Diamonds are forever")
	iadiscordia.register_replacement(gold_lump,      diamond,        "Diamonds are forever")
	iadiscordia.register_replacement(obsidian_shard, diamond,        "Diamonds are forever")

	iadiscordia.register_replacement(mese_crystal,   obsidian_shard, "I want it painted black")
	iadiscordia.register_replacement(diamond,        obsidian_shard, "I want it painted black")
	iadiscordia.register_replacement(gold_lump,      obsidian_shard, "I want it painted black")

	iadiscordia.register_replacement(diamond,        mese_crystal,   "I've got the power")
	iadiscordia.register_replacement(gold_lump,      mese_crystal,   "I've got the power")
	iadiscordia.register_replacement(obsidian_shard, mese_crystal,   "I've got the power")
end

-- TODO rock, paper, scissors => punch everyone who's not playing; give other casters a grace period; kill the loser
iadiscordia.register_rps_spell("Rock",     "rock",     "paper",    S("Paper beats rock"))
iadiscordia.register_rps_spell("Paper",    "paper",    "scissors", S("Scissors beats paper"))
iadiscordia.register_rps_spell("Scissors", "scissors", "rock",     S("Rock beats scissors"))

iadiscordia.register_spell(kallisti, {
	password="Rasputin",
	callback=function(user)
		local meta = user:get_meta()
		local rasp = meta:get_int("rasputin") or 0
		meta:set_int("rasputin", rasp + 1)
	end,
})

