local function reorderTable(inputTable)
	-- Create a new table to hold the result
	local result = {}

	-- Create a temporary array to hold numeric keys and their values
	local numericEntries = {}
	local nonNumericEntries = {}

	-- Separate numeric and non-numeric keys
	for k, v in pairs(inputTable) do
		if type(k) == "number" then
			table.insert(numericEntries, { key = k, value = v })
		else
			nonNumericEntries[k] = v
		end
	end

	-- Sort numeric entries by their original keys
	table.sort(numericEntries, function(a, b)
		return a.key < b.key
	end)

	-- Add the sorted numeric entries to the result with consecutive indices
	for i, entry in ipairs(numericEntries) do
		result[i] = entry.value
	end

	-- Add the non-numeric entries to the result with their original keys
	for k, v in pairs(nonNumericEntries) do
		result[k] = v
	end

	return result
end

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
			local items = harpoon:list():remove()
			harpoon:list().items = reorderTable(items.items)
			vim.g.harpoon_has_changed = true
		end, { desc = "[H]arpoon [D]elete file" })

		vim.keymap.set("n", "<leader>hc", function()
			harpoon:list():clear()
			vim.g.harpoon_has_changed = true
		end, { desc = "[H]arpoon [C]lear all" })

		vim.keymap.set("n", "<leader>hs", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "[H]arpoon [L]ist" })

		-- vim.keymap.set("n", "<leader>hh", function()
		-- 	harpoon:list():select(1)
		-- end, { desc = "[H]arpoon file 1" })
		-- vim.keymap.set("n", "<leader>ht", function()
		-- 	harpoon:list():select(2)
		-- end, { desc = "[H]arpoon file 2" })
		-- vim.keymap.set("n", "<leader>hn", function()
		-- 	harpoon:list():select(3)
		-- end, { desc = "[H]arpoon file 3" })
		-- vim.keymap.set("n", "<leader>hl", function()
		-- 	harpoon:list():select(4)
		-- end, { desc = "[H]arpoon file 4" })

		vim.keymap.set("n", "[h", function()
			harpoon:list():prev()
		end, { desc = "[H]arpoon Previous" })
		vim.keymap.set("n", "]h", function()
			harpoon:list():next()
		end, { desc = "[H]arpoon Next" })

		vim.keymap.set("n", "<leader>h", function()
			local number = vim.fn.getcharstr()
			local numeric_value = tonumber(number)

			-- Check if the conversion was successful
			if numeric_value then
				harpoon:list():select(numeric_value)
			else
				-- print("Invalid number entered")
			end
		end, { remap = true })
		-- vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [M]ark file" })
		-- vim.keymap.set("n", "<leader>hc", mark.rm_file, { desc = "[H]arpoon [C]lear marked file" })
		-- vim.keymap.set("n", "<leader>hr", mark.clear_all, { desc = "[H]arpoon [R]eset" })
	end,
}
