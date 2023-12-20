local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

iadiscordia.manual = {
	["iadiscordia:golden_apple"]         = S("Engrave then use to obtain Kallisti Artifact"),
	["iadiscordia:apple_mold_with_gold"] = S("Bake to obtain decorative Golden Apple"),
	["iadiscordia:apple_mold"]           = S("Combine with Gold Ingot to obtain Apple Mold with Gold"),
	["iadiscordia:apple_mold_raw"]       = S("Bake to obtain Apple Mold"),
	["iadiscordia:manual"]               = S("Use items on Instruction Manual for more information"),
	["iadiscordia:kallisti"]             = S("Use on books for vague and unspecified results"),
	["iadiscordia:principia_discordia"]  = S("It's a book"),
	["iadiscordia:chaos_star_sticker"]   = S("Combine with a book to obtain the Principia Discordia"),
	["iadiscordia:chao_de_jing"]         = S("It's a book"),
	["iadiscordia:sacred_chao_sticker"]  = S("Combine with a book to obtain the Chao De Jing"),
	["iadiscordia:wand"]                 = S("Engrave then use for vague and unspecified results"),
	["default:paper"]                    = S("TODO"),
	["default:stick"]                    = S("TODO"),
	["iadiscordia:philosopher_stone"]    = S("TODO"),

}
iadiscordia.manual["iadiscordia:manual_open"]                = iadiscordia.manual["iadiscordia:manual"]
iadiscordia.manual["iadiscordia:manual_closed"]              = iadiscordia.manual["iadiscordia:manual"]
iadiscordia.manual["iadiscordia:principia_discordia_open"]   = iadiscordia.manual["iadiscordia:principia_discordia"]
iadiscordia.manual["iadiscordia:principia_discordia_closed"] = iadiscordia.manual["iadiscordia:principia_discordia"]
iadiscordia.manual["iadiscordia:chao_de_jing_open"]          = iadiscordia.manual["iadiscordia:chao_de_jing"]
iadiscordia.manual["iadiscordia:chao_de_jing_closed"]        = iadiscordia.manual["iadiscordia:chao_de_jing"]
