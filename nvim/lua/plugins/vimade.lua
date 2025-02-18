return {
	"tadaa/vimade",
	-- default opts (you can partially set these or configure them however you like)
	config = function()
		require("vimade").setup({
			recipe = { "duo", { animate = true } },
			tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.5 } },
		})
	end,
	keys = {
		{ "<leader>f", "<cmd>VimadeToggle<CR>", desc = "Toggle Focus" },
	},
}
