return {
	"folke/edgy.nvim",
	dependencies = {
		"nvim-neo-tree/neo-tree.nvim",
	},
	event = "VeryLazy",
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"

		vim.keymap.set("n", "<leader>ee", require("edgy").toggle, { desc = "Open [E]dgy" })
	end,
	opts = {
		options = {
			left = { size = 40 },
			bottom = { size = 10 },
			right = { size = 80 },
			top = { size = 20 },
		},
		exit_when_last = true,
		top = {
			{ title = "Git Commit", ft = "gitcommit" },
		},
		bottom = {
			"Trouble",
			{ ft = "qf", title = "QuickFix" },
		},
		right = {
			{
				ft = "help",
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
		},
		left = {
			{
				title = "Oil",
				ft = "oil",
			},
			{
				title = "Fugitive",
				ft = "fugitive",
			},
			{
				title = "Undo-Tree",
				ft = "undotree",
			},
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
