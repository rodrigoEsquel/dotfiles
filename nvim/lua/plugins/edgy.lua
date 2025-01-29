return {
	"folke/edgy.nvim",
	dependencies = {
		"nvim-neo-tree/neo-tree.nvim",
	},
	event = "VeryLazy",
	init = function()
		vim.opt.splitkeep = "screen"

		vim.keymap.set("n", "<leader>ee", require("edgy").toggle, { desc = "Open [E]dgy" })
	end,
	opts = {
		options = {
			left = { size = 60 },
			bottom = { size = 20 },
			right = { size = 80 },
			top = { size = 20 },
		},
		exit_when_last = true,

		close_when_all_hidden = false,
		top = {
			{ title = "Git Commit", ft = "gitcommit" },
		},
		bottom = {
			-- { ft = "WhichKey", title = "WhichKey" }, No working as intended
			--
			{ title = "DB Out", ft = "dbout" },
			{ title = "Git", ft = "git" },
			{ title = "Overseer", ft = "OverseerList" },
			{ title = "Fugitive", ft = "fugitive" },
			{ title = "Harpoon", ft = "harpoon" },
			{ title = "Terminal", ft = "terminal-split" },
			{ title = "QuickFix", ft = "qf" },
			{ title = "Diff panel", ft = "diff" },
			{ title = "Repl", ft = "dap-repl" },
			{ title = "Console", ft = "dapui_console" },
			{ title = "Test", ft = "neotest-output-panel" },
		},
		right = {
			{ ft = "terminal-vsplit", title = "Terminal" },
			{
				ft = "help",
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{ title = "Trouble", ft = "trouble" },
			{title = "DB UI", ft = "dbui"},
			{ title = "Scopes", ft = "dapui_scopes" },
			-- keep showing floating window
			-- { title = "Telescope", ft = "TelescopePrompt" },
			-- { title = "Telescope", ft = "TelescopeResults" },
			-- { title = "Oil", ft = "oil" },
			{ title = "Test", ft = "neotest-summary" },
			{ title = "Undo-Tree", ft = "undotree" },
			-- { title = "Breakpoints", ft = "dapui_breakpoints" },
			-- { title = "Stacks", ft = "dapui_stacks" },
			-- { title = "Watches", ft = "dapui_watches" },
			{
				title = "Neo-Tree Git",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "git_status"
				end,
				pinned = true,
				open = "Neotree position=right git_status",
			},
		},
	},
}
