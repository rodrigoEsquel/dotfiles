local function toggle_agent()
	local cli = require("sidekick.cli")
	local state = require("sidekick.cli.state")
	local attached = state.get({ attached = true })
	local current = nil

	for _, item in ipairs(attached) do
		if item.tool.name == "codex" or item.tool.name == "opencode" then
			current = item.tool.name
			break
		end
	end

	if current == "codex" then
		cli.hide({ name = "codex" })
		cli.toggle({ name = "opencode", focus = true })
		return
	end

	if current == "opencode" then
		cli.hide({ name = "opencode" })
		cli.toggle({ name = "codex", focus = true })
		return
	end

	cli.toggle({ name = "codex", focus = true })
end

return {
	"folke/sidekick.nvim",
	opts = {
		nes = { enabled = false },
	},
	keys = {
		{
			"<leader>aa",
			toggle_agent,
			desc = "Toggle Codex/OpenCode",
			mode = { "n", "t" },
		},
		{
			"<leader>ao",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Toggle agent panel",
			mode = { "n", "t" },
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Select agent tool",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			desc = "Agent prompt",
			mode = { "n", "x" },
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}" })
			end,
			desc = "Send this",
			mode = { "n", "x" },
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send file to agent",
		},
		{
			"<leader>al",
			function()
				require("sidekick.cli").send({ msg = "{line}" })
			end,
			desc = "Send line to agent",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			desc = "Send selection to agent",
			mode = { "x" },
		},
	},
}
