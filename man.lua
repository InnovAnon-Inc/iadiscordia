--
-- In-game documentation system
--

local MODNAME = minetest.get_current_modname()
local S       = minetest.get_translator(MODNAME)

iadiscordia.manual = {
	["iadiscordia:golden_apple"]         = S("Engrave then use to obtain Kallisti Artifact"),
	["iadiscordia:apple_mold_with_gold"] = S("Bake to obtain decorative Golden Apple"),
	["iadiscordia:apple_mold"]           = S("Combine with Gold Ingot to obtain Apple Mold with Gold"),
	["iadiscordia:apple_mold_raw"]       = S("Bake to obtain Apple Mold"),
	["iadiscordia:kallisti"]             = S("Use on books for vague and unspecified results; likewise use items on it"),
	["iadiscordia:wand"]                 = S("Engrave then use for vague and unspecified results"),
	["default:paper"]                    = S("TODO"),
	["default:stick"]                    = S("Use on penciled nodes for vague and unspecified results"),
	["default:stone"]                    = S("TODO"),
	["fireflies:firefly_bottle"]         = S("TODO"),
	["iadiscordia:chaos_star_sticker"]   = S("Combine with a book to obtain the Principia Discordia"),
	["iadiscordia:sacred_chao_sticker"]  = S("Combine with a book to obtain the Chao De Jing"),
	["iadiscordia:naos_sticker"]         = S("Combine with a book to obtain the NAOS Tome"),
	["iadiscordia:gunas_sticker"]        = S("Combine with a book to obtain the History of the Eternal Way"),
	["iadiscordia:bagua_sticker"]        = S("Combine with a book to obtain the Taoist Book of Longevity"),
	["iadiscordia:elder_sticker"]        = S("Combine with a book to obtain the Accursed Tome"),
	["iadiscordia:philosopher_stone"]    = S("TODO"),
	["iadiscordia:manual"]               = S("Use items on Instruction Manual for more information"),
	["iadiscordia:principia_discordia"]  = S("It's a book. Randomizes the stack count"),
	["iadiscordia:chao_de_jing"]         = S("It's a book. Randomizes the mana cost"),
	["iadiscordia:naos"]                 = S("It's a book. Randomizes the experience reward"),
	["iadiscordia:sanatan_dharama"]      = S("It's a book. Randomizes the spellcasting level"),
	["iadiscordia:long_life"]            = S("It's a book. Randomizes the health cost"),
	["iadiscordia:necronomicon"]         = S("It's a book. Randomizes which component is randomized"),
	["iadiscordia:grimoire"]             = S("It's a book. Randomizes all components"),
	["iamedusa:medusa"]                  = S("Don't look at it"),
	["iadiscordia:fairy_bottle"]         = S("Keep it with you just in case"),
	["default:copper_ingot"]             = S("TODO"),
	-- TODO death note
}
iadiscordia.manual["iadiscordia:manual_open"]                = iadiscordia.manual["iadiscordia:manual"]
iadiscordia.manual["iadiscordia:manual_closed"]              = iadiscordia.manual["iadiscordia:manual"]
iadiscordia.manual["iadiscordia:principia_discordia_open"]   = iadiscordia.manual["iadiscordia:principia_discordia"]
iadiscordia.manual["iadiscordia:principia_discordia_closed"] = iadiscordia.manual["iadiscordia:principia_discordia"]
iadiscordia.manual["iadiscordia:chao_de_jing_open"]          = iadiscordia.manual["iadiscordia:chao_de_jing"]
iadiscordia.manual["iadiscordia:chao_de_jing_closed"]        = iadiscordia.manual["iadiscordia:chao_de_jing"]
iadiscordia.manual["iadiscordia:naos_open"]                  = iadiscordia.manual["iadiscordia:naos"]
iadiscordia.manual["iadiscordia:naos_closed"]                = iadiscordia.manual["iadiscordia:naos"]
iadiscordia.manual["iadiscordia:sanatan_dharma_open"]        = iadiscordia.manual["iadiscordia:sanatan_dharma"]
iadiscordia.manual["iadiscordia:sanatan_dharma_closed"]      = iadiscordia.manual["iadiscordia:sanatan_dharma"]
iadiscordia.manual["iadiscordia:long_life_open"]             = iadiscordia.manual["iadiscordia:long_life"]
iadiscordia.manual["iadiscordia:long_life_closed"]           = iadiscordia.manual["iadiscordia:long_life"]
iadiscordia.manual["iadiscordia:necronomicon_open"]          = iadiscordia.manual["iadiscordia:necronomicon"]
iadiscordia.manual["iadiscordia:necronomicon_closed"]        = iadiscordia.manual["iadiscordia:necronomicon"]
iadiscordia.manual["iadiscordia:grimoire_open"]              = iadiscordia.manual["iadiscordia:grimoire"]
iadiscordia.manual["iadiscordia:grimoire_closed"]            = iadiscordia.manual["iadiscordia:grimoire"]
