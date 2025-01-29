return {
	"folke/which-key.nvim",
	config = function()
		local wk = require("which-key")
		wk.setup()
		wk.add({
			{ "<leader>]" , group = "+Next" },
			{ "<leader>[" , group = "+Previous" },
			{ "<leader>b" , group = "+[B]uffer" },
			{ "<leader>c" , group = "+[C]ode" },
			{ "<leader>d" , group = "+[D]iagnostic" },
			{ "<leader>e" , group = "+[E]dgy" },
			{ "<leader>g" , group = "+[G]it" },
			{ "<leader>h" , group = "+[H]arpoon" },
			{ "<leader>n" , group = "+[N]otes" },
			{ "<leader>r" , group = "+[R]un" },
			{ "<leader>o" , group = "+[O]pen]" },
			{ "<leader>s" , group = "+[S]earch" },
			{ "<leader>q" , group = "+[Q]uickfix" },
			{ "<leader>t" , group = "+[T]est" },
			{ "<leader>w" , group = "+[W]indow" },
		})
	end,
}
