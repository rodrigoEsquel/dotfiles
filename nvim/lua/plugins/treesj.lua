return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local tsj = require("treesj")

		tsj.setup({
			use_default_keymaps = false,
		})
		-- For use default preset and it work with dot
		vim.keymap.set("n", "<leader>ct", require("treesj").toggle, { desc = "[C]ode [T]oggle" })
		-- For extending default preset with `recursive = true`, but this doesn't work with dot
		vim.keymap.set("n", "<leader>cT", function()
			require("treesj").toggle({ split = { recursive = true } })
		end, { desc = "[C]ode [T]oggle recursive" })
	end,
}
