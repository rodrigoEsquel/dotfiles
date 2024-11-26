return {
	"gbprod/yanky.nvim",
	dependencies = {
		"gbprod/substitute.nvim",
	},
	config = function()
		vim.keymap.set("n", "R", "r", { noremap = true })

		require("yanky").setup({})

		require("substitute").setup({
			on_substitute = require("yanky.integration").substitute(),
		})

		vim.keymap.set("n", "r", require("substitute").operator, { noremap = true })
		vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
		vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
		vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
		vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
		vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
		vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
		vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
	end,
}
