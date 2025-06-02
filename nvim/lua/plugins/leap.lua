return {
	"ggandor/leap.nvim",
	config = function()
		require("leap").setup({
			safe_labels = {},
			labels = {
				"h",
				"u",
				"t",
				"e",
				"n",
				"o",
				"l",
				"a",
				"d",
				"i",
				"g",
				"c",
				"r",
				"s",
				"p",
				"f",
				"y",
				"j",
				"k",
				"m",
				"b",
				"w",
				"v",
				"q",
				"x",
				"z",
				"/",
				"S",
				"F",
				"N",
				"J",
				"K",
				"L",
				"H",
				"O",
				"D",
				"W",
				"E",
				"I",
				"M",
				"B",
				"U",
				"Y",
				"V",
				"R",
				"G",
				"T",
				"A",
				"Q",
				"P",
				"C",
				"X",
				"Z",
				"?",
			},
		})
		vim.keymap.set({ "n", "x" }, "S", "<Plug>(leap)")
		-- vim.keymap.set("n", "S", function()
		-- 	require("leap").leap({ backward = true })
		-- end)
		vim.keymap.set("o", "S", "<Plug>(leap-forward)")
		vim.keymap.set("n", "<c-s>", function()
			local focusable_windows_on_tabpage = vim.tbl_filter(function(win)
				return vim.api.nvim_win_get_config(win).focusable
			end, vim.api.nvim_tabpage_list_wins(0))
			require("leap").leap({ target_windows = focusable_windows_on_tabpage })
		end)
	end,
}
