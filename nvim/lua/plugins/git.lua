return {

	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			{
				"<leader>gg",
				function()
					vim.cmd("vert to Git ")
				end,
				desc = "Toggle [G]it sidebar",
			},
			{
				"<leader>gs",
				function()
					vim.cmd("Git add %")
				end,
				desc = "[G]it [S]tage buffer",
			},
		},
	},
	"tpope/vim-rhubarb",
}
