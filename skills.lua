SkillsFramework.define_skill({
	mod="iadiscordia",
	name="Chaos Magick",
	cost_func=iaskills.cost_func,
	group="Magick",
	min=iaskills.start,
})

minetest.register_on_newplayer(function(ref)
	local set_id = ref:get_player_name()
	assert(set_id ~= "")
	--SkillsFramework.attach_skillset(set_id, {
	SkillsFramework.append_skills(set_id, {
		"iadiscordia:Chaos Magick",
	})
end)
