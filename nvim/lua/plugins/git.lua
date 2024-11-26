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
				"<leader>g/",
				':Git log -G""<left>',
				desc = "Toggle [G]it sidebar",
			},
			{
				"<leader>g/",
				":'<,'>!Git log -G",
				desc = "Toggle [G]it sidebar",
				mode = {'v'}
			},
			{
				"<leader>gs",
				function()
					vim.cmd("Git add %")
				end,
				desc = "[G]it [S]tage buffer",
			},
			{
				"<leader>ga",
				function()
					vim.cmd("Git add .")
				end,
				desc = "[G]it Stage [A]ll Files",
			},
		},
	},
	"tpope/vim-rhubarb",
}
