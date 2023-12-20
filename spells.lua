iadiscordia.spells = {}
local MODNAME = minetest.get_current_modname()

local S = minetest.get_translator("iadiscordia")

function iadiscordia.register_spell(title, text)
	assert(title ~= nil)
	assert(text  ~= nil)
	--assert(iadiscordia.spells[title] == nil)
	assert(text.password ~= nil)
	assert(text.callback ~= nil)
	if iadiscordia.spells[title] == nil then
		iadiscordia.spells[title] = {}
	end
	table.insert(iadiscordia.spells[title], text)

	SkillsFramework.define_skill({
		mod="iadiscordia",
		name=title,
		cost_func=function(level)
			return 100^level
		end,
		group="Chaos Magick",
		min=0,
	})
end

local DEBUG_SPELL_COST = false
function iadiscordia.spell_cost(user, random_mp, random_hp)
	assert(user ~= nil)
	assert(random_mp ~= nil)
	assert(random_hp ~= nil)
	local set_id = user:get_player_name()
	assert(set_id ~= nil)
	-- TODO random_mp
	local m      = mana.get   (set_id)
	assert(m ~= nil)
	local mm     = mana.getmax(set_id)
	assert(mm ~= nil)
	local r      = (mm - m) / mm
	assert(r ~= nil)
	local prop   = user:get_properties()
	assert(prop ~= nil)
	-- TODO random_hp
	local h      = user:get_hp()
	assert(h ~= nil)
	local hm     = prop["hp_max"] or 20 -- should work with upgrades
	assert(hm ~= nil)
	mana.set(set_id, 0)
	local hf     = math.floor(h - hm*r)
	assert(hf ~= nil)
	user:set_hp(hf)

	if DEBUG_SPELL_COST then
	print('mana cur: '..m)
	print('mana max: '..mm)
	print('ratio: '..r)
	print('hp   cur: '..h)
	print('hp   max: '..hm)
	print('hp   new: '..hf)
	end

	return user:get_hp() > 0
end

local DEBUG_CAST_SPELL = true
local TEST_CAST_SPELL  = true
local hash_len         = 40
function iadiscordia.cast_spell(user, actual, expected, random_lvl)
	assert(user ~= nil)
	assert(actual ~= nil)
	assert(expected ~= nil)
	assert(random_lvl ~= nil)
	if DEBUG_CAST_SPELL then
	print('actual: '..actual)
	print('expected: '..expected)
	end
	-- returns whether to do it
	
	--if not iadiscordia.spell_cost(user) then
	--	iadiscordia.chat_send_user(user, S('Fatally insufficient MP and/or HP'))
	--	return false
	--end

	if TEST_CAST_SPELL then
		-- it's a lot easier if we're not crypto mining
		actual = minetest.sha1(actual)
		assert(#actual == hash_len)
	end
	expected = minetest.sha1(expected)

	local set_id = user:get_player_name()
	-- TODO random lvl
	local lvl   = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")
	assert(lvl ~= nil)
	-- if spell is epic then lvl = lvl - 9000
	local lr    = math.ceil(hash_len * 1 / (lvl + 1))
	assert(1  <= lr)
	assert(lr <= hash_len)
	--hash(owner+text) matches hash(command)
	if DEBUG_CAST_SPELL then
	print('actual: '..actual)
	print('expected: '..expected)
	print('lr: '..lr)
	end
	--if(#actual ~= hash_len) then
	if(#actual > hash_len) then
		iadiscordia.chat_send_user(user, S('Spell too long'))
		return false
	end
	if(#actual < lr) then
		iadiscordia.chat_send_user(user, S('Spell too short'))
		return false
	end
	assert(#expected == hash_len)
	if string.sub(actual,1,lr) ~= string.sub(expected,1,lr) then
		iadiscordia.chat_send_user(user, S('Spell incorrect'))
		return false
	end
	--for i=1,lr,1 do
	--	if DEBUG_CAST_SPELL then
	--	print('i['..i..']: '..sub(actual,i,i)..'   '..sub(expected,i,i))
	--	end
	--	if sub(actual,i,i) ~= sub(expected,i,i) then
	--		iadiscordia.chat_send_user(user, S('Spell incorrect'))
	--		return false
	--	end
	--end
	iadiscordia.chat_send_user(user, S('Casting spell'))
	return true
end

function iadiscordia.on_use_helper(itemstack, user, title, text, owner,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)

	assert(itemstack ~= nil)
	assert(user ~= nil)
	assert(title ~= nil)
	assert(text ~= nil)
	assert(owner ~= nil)
	assert(random_mp ~= nil)
	assert(random_hp ~= nil)
	assert(random_xp ~= nil)
	assert(random_lvl ~= nil)
	assert(random_cnt ~= nil)
	assert(random_rnd ~= nil)

	local actual   = owner..text
	local spell    = iadiscordia.spells[title]
	if spell == nil then
		print('spell does not exist')
		iadiscordia.chat_send_user(user, S('Unrecognized spell'))
		return nil
	end
	if not iadiscordia.spell_cost(user, random_mp, random_hp) then
		print('not enough mana')
		iadiscordia.chat_send_user(user, S('Fatally insufficient MP and/or HP'))
		return nil
	end
	local flag = false
	for _, subspell in ipairs(spell) do
		local expected = subspell.password
		if TEST_CAST_SPELL then -- it's easier to guess if we give you the salt
			expected = owner..expected
		end

		if iadiscordia.cast_spell(user, actual, expected, random_lvl) then
			print('spell found')
			iadiscordia.chat_send_user(user, S('Spell found!'))
			flag = true
			break
		end
	end
	if not flag then
		-- TODO punish player
		return nil
	end

	if minetest.get_modpath("spacecannon") then
		local pos = user:get_pos()
		minetest.add_particlespawner({
				amount = 5,
				time = 0.5,
				minpos = pos,
				maxpos = pos,
				minvel = {x = -2, y = -2, z = -2},
				maxvel = {x = 2, y = 2, z = 2},
				minacc = {x = -3, y = -3, z = -3},
				maxacc = {x = 3, y = 3, z = 3},
				minexptime = 1,
				maxexptime = 2.5,
				minsize = 0.5,
				maxsize = 0.75,
				texture = "spacecannon_spark.png",
				glow = 5
		})
	end

	local cnt    = itemstack:get_count()
	local set_id = user:get_player_name()
	local level  = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")

	-- if spell is epic then level = level - 9000

	-- TODO random_cnt
	cnt = math.floor(cnt * (1 - 1 / (level + 1)))
	if cnt == 0 then
		iadiscordia.chat_send_user(user, S('Technical success: insufficient magick level or stack count'))
		itemstack:clear()
		return itemstack
	end
	itemstack:set_count(cnt)

	print('ok now do spell')
	local newname = expected.callback(user)

	-- TODO random_xp
	-- increase magick XP
	Skillsframework.add_experience(set_id, "iadiscordia:Chaos Magick", 1)
	Skillsframework.append_skills(set_id, "iadiscordia:"..title)

	if newname == nil then return itemstack end
	print('item converted')
	iadiscordia.chat_send_user(user, S('Alchemy Success'))
	itemstack:set_name(newname)
	return itemstack
end

local function get_random_mp(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_mp
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end
local function get_random_hp(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_hp
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end
local function get_random_xp(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_xp
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end
local function get_random_lvl(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_lvl
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end
local function get_random_cnt(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_cnt
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end
local function get_random_rnd(name)
	local book = iadiscordia.books[name]
	if book == nil then return false end

	local res  = book.random_rnd
	if res == nil then return false end
	assert(res == true or res == false)
	return res
end

local DEBUG_ON_USE = false
function iadiscordia.on_use(itemstack, user, pointed_thing)
	assert(itemstack ~= nil)
	assert(user ~= nil)
	assert(pointed_thing ~= nil)
	if pointed_thing.type ~= "node" then
		iadiscordia.chat_send_user(user, S('Expecting a node'))
		return nil
	end

	local pos  = pointed_thing.under
        local node = minetest.get_node(pos)
	local name = node.name
	if DEBUG_ON_USE then
	print('node name: '..name)
	end
	--if node.name ~= "default:book_open" then
	--	iadiscordia.chat_send_user(user, S('Expecting an open book'))
	--	return nil
	--end
	--if node.name == "iadiscordia:manual_open" then
	--	local message = iadiscordia.manual[itemstack:get_name()] or S("Unrecognized item")
	--	iadiscordia.chat_send_user(user, message)
	--	return nil
	--end

	local meta  = minetest.get_meta(pos)
	local title = meta:get_string("title")
	local text  = meta:get_string("text")
	local owner = meta:get_string("owner")
	if DEBUG_ON_USE then
	print('title: '..title)
	print('text : '..text)
	print('owner: '..owner)
	end

	if not minetest.dig_node(pos) then -- should work great with hbhunger
		print('spell failed to dig')
		iadiscordia.chat_send_user(user, S('Failed to dig'))
		return nil
	end

	local random_mp  = get_random_mp(name)
	local random_hp  = get_random_hp(name)
	local random_xp  = get_random_xp(name)
	local random_lvl = get_random_lvl(name)
	local random_cnt = get_random_cnt(name)
	local random_rnd = get_random_rnd(name)
	return iadiscordia.on_use_helper(itemstack, user, title, text, owner,
	random_mp, random_hp, random_xp, random_lvl, random_cnt, random_rnd)
end

