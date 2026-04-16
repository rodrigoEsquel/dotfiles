return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup({
			prompt_func_return_type = {
				go = true,
				cpp = true,
				c = true,
				java = true,
			},
			prompt_func_param_type = {
				go = true,
				cpp = true,
				c = true,
				java = true,
			},
		})

		vim.keymap.set("x", "<leader>cf", function()
			require("refactoring").refactor("Extract Function")
		end, { desc = "Extract Function" })
		vim.keymap.set("x", "<leader>cF", function()
			require("refactoring").refactor("Extract Function To File")
		end, { desc = "Extract Function To File" })
		vim.keymap.set("x", "<leader>cv", function()
			require("refactoring").refactor("Extract Variable")
		end, { desc = "Extract Variable" })
		vim.keymap.set("n", "<leader>cb", function()
			require("refactoring").refactor("Extract Block")
		end, { desc = "Extract Block" })
		vim.keymap.set("n", "<leader>cB", function()
			require("refactoring").refactor("Extract Block To File")
		end, { desc = "Extract Block To File" })
		vim.keymap.set({ "x", "n" }, "<leader>cp", function()
			require("refactoring").debug.printf({})
		end, { desc = "Print Variable" })
		vim.keymap.set("n", "<leader>cP", function()
			require("refactoring").debug.cleanup({})
		end, { desc = "Cleanup Print Variable" })
	end,
}
