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
			left = { size = 40 },
			bottom = { size = 15 },
			right = { size = 60 },
			top = { size = 15 },
		},
		exit_when_last = true,

		close_when_all_hidden = false,
		top = {
		},
		bottom = {
			-- { ft = "WhichKey", title = "WhichKey" }, No working as intended
			--
			{ title = "Git Commit", ft = "gitcommit" },
			{ title = "DB Out", ft = "dbout" },
			{ title = "Overseer", ft = "OverseerList" },
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
			{ title = "Fugitive", ft = "fugitive" },
			{
				ft = "help",
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{tittle = "DiffView Files", ft = "DiffviewFiles"},
			{ title = "Git", ft = "git" },
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
