return {
	"tadaa/vimade",
	lazy = false,
	config = function()
		require("vimade").setup({
			recipe = { "duo", { animate = false } },
			tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.5 } },
		})
		vim.cmd("VimadeEnable")
	end,
	keys = {
		{ "<leader>f", "<cmd>VimadeToggle<CR>", desc = "Toggle Focus" },
	},
}
