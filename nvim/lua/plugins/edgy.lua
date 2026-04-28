return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	init = function()
		vim.opt.splitkeep = "screen"

		vim.keymap.set("n", "<leader>ee", require("edgy").toggle, { desc = "Open [E]dgy" })
	end,
	opts = {
		options = {
			left = { size = 60 },
			bottom = { size = 15 },
			right = { size = 0.4 },
			top = { size = 15 },
		},
		exit_when_last = true,
		close_when_all_hidden = false,
		top = {},
		bottom = {
			{ title = "Vim", ft = "vim" },
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
			{ title = "Trouble", ft = "trouble" },
		},
		right = {
			{ ft = "terminal-vsplit", title = "Terminal" },
			{ title = "Fugitive", ft = "fugitive" },
			{
				ft = "help",
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{ title = "DiffView Files", ft = "DiffviewFiles" },
			{ ft = "snacks_terminal", title = "Agent" },
			{ title = "DB UI", ft = "dbui" },
			{ title = "Scopes", ft = "dapui_scopes" },
			{ title = "Test", ft = "neotest-summary" },
			{ title = "Undo-Tree", ft = "undotree" },
			{ title = "Undo-Tree", ft = "nvim-undotree" },
		},
	},
}
