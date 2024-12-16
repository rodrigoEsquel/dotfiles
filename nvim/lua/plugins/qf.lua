return {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	dependencies = {

		-- optional
		{
			"junegunn/fzf",
			build = function()
				vim.fn["fzf#install"]()
			end,
		},
		-- optional, highly recommended
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	},
	config = function()
		require("bqf").setup({
			auto_enable = true,
			preview = {
				auto_preview = true,
			},
		})
	end,
}
