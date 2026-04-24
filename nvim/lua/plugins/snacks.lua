local function get_base_branch()
	local output = vim.fn.systemlist("git remote show origin 2>/dev/null")
	for _, line in ipairs(output) do
		local branch = line:match("^%s*HEAD branch:%s*(.+)$")
		if branch then
			return branch
		end
	end
	return "master"
end

local function git_diff_base()
	local base_branch = get_base_branch()
	require("snacks").picker.git_diff({ base = base_branch, group = true })
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		picker = {
			enabled = true,
			ui_select = true,
		},
	},
	keys = {
		{ "<leader>?", function() require("snacks").picker.recent() end, desc = "[?] [S]earch recently opened files" },
		{ "<leader>/", function() require("snacks").picker.lines() end, desc = "[/] Fuzzily search in current buffer" },
		{ "<leader><space>", function() require("snacks").picker.buffers() end, desc = "[ ] [S]earch existing buffers" },
		{ "<leader>sf", function() require("snacks").picker.files({ hidden = true }) end, desc = "[S]earch [F]iles" },
		{ "<leader>s?", function() require("snacks").picker.help() end, desc = "[S]earch help[?]" },
		{ "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[S]earch current [W]ord" },
		{ "<leader>sg", function() require("snacks").picker.grep() end, desc = "[S]earch by [G]rep" },
		{ "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "[S]earch [D]iagnostics" },
		{ "<leader>ss", function() require("snacks").picker.git_status() end, desc = "[S]earch git [S]tatus" },
		{ "<leader>sC", function() require("snacks").picker.git_log() end, desc = "[S]earch git [C]ommits" },
		{
			"<leader>sc",
			function()
				require("snacks").picker.git_log({
					confirm = function(picker, item)
						picker:close()
						if item then
							vim.cmd("DiffviewOpen " .. item.commit .. "^!")
							vim.cmd("LualineRenameTab diff " .. item.commit:sub(1, 7))
						end
					end,
				})
			end,
			desc = "[S]earch [c]ommit diff",
		},
		{ "<leader>sb", function() require("snacks").picker.git_branches() end, desc = "[S]earch git [B]ranches" },
		{ "<leader>s<space>", function() require("snacks").picker.resume() end, desc = "Resume [S]earch" },
		{ "<leader>sS", git_diff_base, desc = "Git diff files" },
		{
			"<leader>aa",
			function()
				require("snacks").terminal.toggle(nil, {
					cwd = vim.fn.getcwd(),
					win = { position = "right", width = 0.4 },
				})
			end,
			desc = "Toggle agent terminal",
			mode = { "n", "t" },
		},
	},
}
