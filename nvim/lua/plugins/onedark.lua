return {
	-- Theme inspired by Atom
	"navarasu/onedark.nvim",
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "deep",
		})
		require("onedark").load()
		vim.cmd.colorscheme("onedark")
	end,
}
