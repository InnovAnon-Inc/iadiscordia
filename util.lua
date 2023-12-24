--
-- Utility function(s) copied from somewhere
--

local MODNAME = minetest.get_current_modname()
function iadiscordia.chat_send_user(user, text)			
	-- Check if user is a "fake player" (unofficial imitation of a the player data structure)
	if not type(user) == "player" then return end
	if not user:is_player() then return end
	if type(user) ~= "userdata" then return end
	local name = user:get_player_name()
	minetest.chat_send_player(name, text)
end
