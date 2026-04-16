return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	init = function()
		vim.g.nvim_surround_no_normal_mappings = true
		vim.g.nvim_surround_no_visual_mappings = true
		vim.g.nvim_surround_no_insert_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})

		vim.keymap.set("i", "<C-g>s", "<Plug>(nvim-surround-insert)")
		vim.keymap.set("i", "<C-g>S", "<Plug>(nvim-surround-insert-line)")
		vim.keymap.set("n", "s", "<Plug>(nvim-surround-normal)")
		vim.keymap.set("n", "gss", "<Plug>(nvim-surround-normal-cur)")
		vim.keymap.set("n", "gS", "<Plug>(nvim-surround-normal-line)")
		vim.keymap.set("n", "gSS", "<Plug>(nvim-surround-normal-cur-line)")
		vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)")
		vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)")
		vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)")
		vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)")
		vim.keymap.set("n", "cS", "<Plug>(nvim-surround-change-line)")
	end,
}
