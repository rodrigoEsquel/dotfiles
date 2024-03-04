return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
		vim.api.nvim_set_keymap(
			"n",
			"<leader>dc",
			":NoiceDismiss<CR>",
			{ noremap = true, desc = "Dismiss notifications" }
		),
	},
	config = function()
		require("noice").setup()
		local color = require("kanagawa.colors").setup({ theme = "wave" }).theme.ui
		vim.cmd("highlight NoiceCmdlinePopupBorderCmdline guibg=" .. color.bg)
		vim.cmd("highlight NoiceCmdlinePopupBorderSearch guibg=" .. color.bg)
	end,
}
