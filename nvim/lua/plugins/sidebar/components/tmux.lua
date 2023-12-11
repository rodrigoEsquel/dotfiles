local function get_tmux_sessions()
	local sessions_cmd = vim.api.nvim_exec2("! tmux list-sessions -F \\\\#{\\\\#{session_name}:\\\\#{session_id}}", {
		output = true,
	})

	local order_sessions_list = {}

	for session in string.gmatch(sessions_cmd.output, "[^" .. "\n]+") do
		local value, id = session:match("(.-):$(%d)")
		if value then
			local id_int = math.floor(tonumber(id))
			table.insert(order_sessions_list, id_int, value)
		end
	end

	local sessions_list = {}

	for _, session in pairs(order_sessions_list) do
		table.insert(sessions_list, session)
	end

	return sessions_list
end

return {

	title = "Tmux session",

	icon = "",

	draw = function()
		return { lines = get_tmux_sessions() }
	end,
}
