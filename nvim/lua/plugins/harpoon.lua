return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():append()
		end, { desc = "[H]arpoon [A]dd mark to file" })
		vim.keymap.set("n", "<leader>hl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<leader>hh>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<leader>ht>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<leader>hn>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<leader>hs>", function()
			harpoon:list():select(4)
		end)

		-- vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [M]ark file" })
		-- vim.keymap.set("n", "<leader>hc", mark.rm_file, { desc = "[H]arpoon [C]lear marked file" })
		-- vim.keymap.set("n", "<leader>hr", mark.clear_all, { desc = "[H]arpoon [R]eset" })
	end,
}
