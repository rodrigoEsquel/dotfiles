return {
	"ThePrimeagen/harpoon",
	config = function()
		require("harpoon").setup({
			enter_on_sendcmd = true,
			-- tabline = false,
			-- tabline_prefix = "  ",
			-- tabline_suffix = "  ",
			-- menu = {
			-- 	width = vim.api.nvim_win_get_width(0) - 40,
			-- },
		})
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")
		vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [M]ark file" })
		vim.keymap.set("n", "<leader>hc", mark.rm_file, { desc = "[H]arpoon [C]lear marked file" })
		vim.keymap.set("n", "<leader>hr", mark.clear_all, { desc = "[H]arpoon [R]eset" })
		vim.keymap.set("n", "<leader>hh", function()
			ui.nav_file(1)
		end, { desc = "Go to file 0" })
		vim.keymap.set("n", "<leader>ht", function()
			ui.nav_file(2)
		end, { desc = "Go to file 1" })
		vim.keymap.set("n", "<leader>hn", function()
			ui.nav_file(3)
		end, { desc = "Go to file 2" })
		vim.keymap.set("n", "<leader>hs", function()
			ui.nav_file(4)
		end, { desc = "Go to file 3" })
		vim.keymap.set("n", "<leader>[h", ui.nav_prev, { desc = "Go to previous harpoon file" })
		vim.keymap.set("n", "<leader>]h", ui.nav_next, { desc = "Go to next harpoon file" })
	end,
}
