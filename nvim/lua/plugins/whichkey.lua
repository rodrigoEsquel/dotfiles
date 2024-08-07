return {
	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")
		wk.setup()
		wk.register({
			["<leader>]"] = { name = "+Next" },
			["<leader>["] = { name = "+Previous" },
			["<leader>b"] = { name = "+[B]uffer" },
			["<leader>c"] = { name = "+[C]ode" },
			["<leader>d"] = { name = "+[D]iagnostic" },
			["<leader>e"] = { name = "+[E]dgy" },
			["<leader>g"] = { name = "+[G]it" },
			["<leader>h"] = { name = "+[H]arpoon" },
			["<leader>n"] = { name = "+[N]otes" },
			["<leader>r"] = { name = "+[R]un" },
			["<leader>s"] = { name = "+[S]earch" },
			["<leader>t"] = { name = "+[T]est" },
			["<leader>w"] = { name = "+[W]indow" },
		})
	end,
}
