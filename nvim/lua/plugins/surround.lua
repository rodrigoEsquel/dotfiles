return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "gs",
				normal_cur = "gss",
				normal_line = "gS",
				normal_cur_line = "gSS",
				visual = "gs",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			}, -- Configuration here, or leave empty to use defaults
		})

		vim.keymap.set("x", "(", "gs)", { remap = true })
		vim.keymap.set("x", ")", "gs)", { remap = true })
		vim.keymap.set("x", "[", "gs]", { remap = true })
		vim.keymap.set("x", "]", "gs]", { remap = true })
		vim.keymap.set("x", "{", "gs}", { remap = true })
		vim.keymap.set("x", "}", "gs}", { remap = true })
	end,
}
