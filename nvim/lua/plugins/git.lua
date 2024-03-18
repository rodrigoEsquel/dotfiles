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
		},
	},
	"tpope/vim-rhubarb",
}
