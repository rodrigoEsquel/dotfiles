return {
	'mvllow/modes.nvim',
	tag = 'v0.2.0',
	config = function()
		local theme = require("kanagawa.colors").setup({ theme = "wave" }).theme
		require('modes').setup({
			colors = {
				insert = theme.syn.string,
			},
			set_number = false,
		}
		)
	end
}
