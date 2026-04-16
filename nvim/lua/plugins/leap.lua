return {
	url = "https://codeberg.org/andyg/leap.nvim",
	config = function()
		require("leap").setup({
			safe_labels = {},
			labels = {
				"a", "s", "d", "f", "g", "h", "j", "k", "l",
				"q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
				"z", "x", "c", "v", "b", "n", "m", "/",
				"A", "S", "D", "F", "G", "H", "J", "K", "L",
				"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
				"Z", "X", "C", "V", "B", "N", "M", "?",
			},
		})
		vim.keymap.set({ "n", "x" }, "S", "<Plug>(leap)")
		vim.keymap.set("o", "S", "<Plug>(leap-forward)")
		vim.keymap.set("n", "<c-s>", function()
			local focusable_windows_on_tabpage = vim.tbl_filter(function(win)
				return vim.api.nvim_win_get_config(win).focusable
			end, vim.api.nvim_tabpage_list_wins(0))
			require("leap").leap({ target_windows = focusable_windows_on_tabpage })
		end)
	end,
}
