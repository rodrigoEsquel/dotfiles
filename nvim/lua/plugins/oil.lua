return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			-- default_file_explorer = false,
			view_options = {
				show_hidden = true,
			},
			columns = {
				"icon",
				-- "permissions",
			},
			delete_to_trash = true,
			float = {
				border = "none",
			},
			lsp_file_methods = {
				autosave_changes = true,
			},
			constrain_cursor = "editable",
			win_options = {
				wrap = false,
				signcolumn = "no",
				cursorcolumn = false,
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				concealcursor = "nvic",
			},
			keymaps = {
				["<C-s>"] = "actions.select_split",
				["<C-v>"] = "actions.select_vsplit",
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
		})
		-- vim.keymap.set("n", "-", "<CMD>Oil <CR>", { desc = "Open parent directory" })
		-- vim.keymap.set("n", "_", "<CMD>Oil .<CR>", { desc = "Open root directory" })
	end,
}
