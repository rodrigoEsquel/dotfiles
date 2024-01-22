local highlight = {
	"@lsp.type.selfparameter",
	"@lsp.mod.readonly",
	"@lsp.type.namespace",
	"@lsp.typemod.string.injected",
	"@lsp.type.decorator",
}

return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			vim.g.rainbow_delimiters = {
				highlight = highlight,
			}
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				highlight = highlight,
			},
			-- whitespace = { highlight = highlight },
		},
	},
}
