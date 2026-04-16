return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		presets = {
			inc_rename = true,
			command_palette = true,
		},
	},
	keys = {
		{
			"<leader>dc",
			":NoiceDismiss<CR>",
			{ noremap = true, desc = "Dismiss notifications" },
		},
	},
}
