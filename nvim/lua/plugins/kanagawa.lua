return {
	"rebelot/kanagawa.nvim",
	config = function()
		require("kanagawa").setup({
			theme = "wave",
		})
		vim.cmd("colorscheme kanagawa")
		vim.cmd("highlight FloatBorder guibg=NONE")
	end,
}
