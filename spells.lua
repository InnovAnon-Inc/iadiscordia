iadiscordia.spells = {}

local S = minetest.get_translator("iadiscordia")

function iadiscordia.register_spell(title, text)
	assert(title ~= nil)
	assert(text  ~= nil)
	assert(iadiscordia.spells[title] == nil)
	assert(text.password ~= nil)
	assert(text.callback ~= nil)
	iadiscordia.spells[title] = text

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
function iadiscordia.spell_cost(user)
	assert(user ~= nil)
	local set_id = user:get_player_name()
	assert(set_id ~= nil)
	local m      = mana.get   (set_id)
	assert(m ~= nil)
	local mm     = mana.getmax(set_id)
	assert(mm ~= nil)
	local r      = (mm - m) / mm
	assert(r ~= nil)
	local prop   = user:get_properties()
	assert(prop ~= nil)
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

local DEBUG_CAST_SPELL = false
local TEST_CAST_SPELL  = false
local hash_len         = 40
function iadiscordia.cast_spell(user, actual, expected)
	-- returns whether to do it
	
	if not iadiscordia.spell_cost(user) then
		iadiscordia.chat_send_user(user, S('Fatally insufficient MP and/or HP'))
		return false
	end

	if TEST_CAST_SPELL then
		-- it's a lot easier if we're not crypto mining
		actual = minetest.sha1(actual)
		assert(#actual == hash_len)
	end
	expected = minetest.sha1(expected)

	local set_id = user:get_player_name()
	local lvl   = SkillsFramework.get_level(set_id, "iadiscordia:Chaos Magick")
	assert(lvl ~= nil)
	local lr    = math.ceil(hash_len * 1 / (lvl + 1))
	assert(1  <= lr)
	assert(lr <= hash_len)
	--hash(owner+text) matches hash(command)
	if DEBUG_CAST_SPELL then
	print('actual: '..actual)
	print('expected: '..expected)
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
	for i=0,lr,1 do
		if DEBUG_CAST_SPELL then
		print('i: '..i)
		end
		if actual[i] ~= expected[i] then
			iadiscordia.chat_send_user(user, S('Spell incorrect'))
			return false
		end
	end
	iadiscordia.chat_send_user(user, S('Casting spell'))
	return true
end

local DEBUG_ON_USE = false
function iadiscordia.on_use(itemstack, user, pointed_thing)
	if pointed_thing.type ~= "node" then
		iadiscordia.chat_send_user(user, S('Expecting a node'))
		return nil
	end

	local pos  = pointed_thing.under
        local node = minetest.get_node(pos)
	if DEBUG_ON_USE then
	print('node name: '..node.name)
	end
	if node.name ~= "default:book_open" then
		iadiscordia.chat_send_user(user, S('Expecting an open book'))
		return nil
	end

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

	local actual   = owner..text
	local spell    = iadiscordia.spells[title]
	if spell == nil then
		print('spell does not exist')
		iadiscordia.chat_send_user(user, S('Unrecognized spell'))
		return nil
	end
	local expected = spell.password
	if TEST_CAST_SPELL then -- it's easier to guess if we give you the salt
		expected = owner..expected
	end

	if iadiscordia.cast_spell(user, actual, expected) then
		-- increase magick XP
		local set_id = user:get_player_name()
		Skillsframework.add_experience(set_id, "iadiscordia:Chaos Magick", 1)
		Skillsframework.append_skills(set_id, "iadiscordia:"..title)

		print('ok now do spell')
		expected.callback(user)
	else
		-- TODO punish player
	end
	
	itemstack:take_item()
	return itemstack
end
