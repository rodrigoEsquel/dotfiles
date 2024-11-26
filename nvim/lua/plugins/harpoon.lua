return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				enter_on_sendcmd = true,
			},
		})
		-- REQUIRED

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
			vim.g.harpoon_has_changed = true
		end, { desc = "[H]arpoon [A]dd mark to file" })

		vim.keymap.set("n", "<leader>hd", function()
			harpoon:list():remove()
			vim.g.harpoon_has_changed = true
		end, { desc = "[H]arpoon [D]elete file" })

		vim.keymap.set("n", "<leader>hc", function()
			harpoon:list():clear()
			vim.g.harpoon_has_changed = true
		end, { desc = "[H]arpoon [C]lear all" })

		vim.keymap.set("n", "<leader>hs", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })

		vim.keymap.set("n", "<leader>hh", function()
			harpoon:list():select(1)
		end, { desc = "[H]arpoon file 1" })
		vim.keymap.set("n", "<leader>ht", function()
			harpoon:list():select(2)
		end, { desc = "[H]arpoon file 2" })
		vim.keymap.set("n", "<leader>hn", function()
			harpoon:list():select(3)
		end, { desc = "[H]arpoon file 3" })
		vim.keymap.set("n", "<leader>hl", function()
			harpoon:list():select(4)
		end, { desc = "[H]arpoon file 4" })

		vim.keymap.set("n", "<leader>(", function()
			harpoon:list():prev()
		end, { desc = "[H]arpoon Previous" })
		vim.keymap.set("n", "<leader>)", function()
			harpoon:list():next()
		end, { desc = "[H]arpoon Next" })
		-- vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [M]ark file" })
		-- vim.keymap.set("n", "<leader>hc", mark.rm_file, { desc = "[H]arpoon [C]lear marked file" })
		-- vim.keymap.set("n", "<leader>hr", mark.clear_all, { desc = "[H]arpoon [R]eset" })
	end,
}
