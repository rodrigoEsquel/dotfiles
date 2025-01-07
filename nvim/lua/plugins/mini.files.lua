return {
	"echasnovski/mini.files",
	dependencies = {
		{
			"echasnovski/mini.icons",
			opts = {},
		},
	},
	version = "*",
	opts = {
		mappings = {
			go_in = "L",
			go_in_plus = "<CR>",
			go_out = "H",
			go_out_plus = "-",
			reset = "",
		},
		windows = {
			width_nofocus = 35,
			width_focus = 35,
		},
	},
	keys = {
		{ "_", "<cmd>lua MiniFiles.open()<cr>", desc = "Toggle MiniFiles" },
		{
			"-",
			function()
				local MiniFiles = require("mini.files")
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				MiniFiles.reveal_cwd()
			end,
			desc = "Open MiniFiles",
		},
	},
}
