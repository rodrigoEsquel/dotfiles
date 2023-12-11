return {
	"ggandor/leap.nvim",
	config = function()
		require("leap").setup({
			vim.keymap.set('n', 's', function ()
  local current_window = vim.fn.win_getid()
  require('leap').leap { target_windows = { current_window } }
end),
			vim.keymap.set('n', "S", function ()
  local focusable_windows_on_tabpage = vim.tbl_filter(
    function (win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  require('leap').leap { target_windows = focusable_windows_on_tabpage }
end)
		})
	end,
}
