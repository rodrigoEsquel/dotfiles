return {

	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	{
		"rbong/vim-flog",
		config = function()
			vim.keymap.set("n", "<leader>gl", "<cmd>vert Flogsplit<cr>")
		end,
	},
}
