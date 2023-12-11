return {
	"0x00-ketsu/markdown-preview.nvim",
	ft = { "md", "markdown", "mkd", "mkdn", "mdwn", "mdown", "mdtxt", "mdtext", "rmd", "wiki" },
	config = function()
		require("markdown-preview").setup({
			glow = {
				style = "/home/rodrigo/.config/nvim/md-style.json",
			},
		})

		vim.api.nvim_set_keymap(
			"n",
			"<leader>no",
			"<Cmd>MPToggle<CR>",
			{ noremap = true, silent = false, desc = "[O]pen [N]ote" }
		)
	end,
}
