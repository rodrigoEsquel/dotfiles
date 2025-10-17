return {

	"monkoose/neocodeium",
	event = "VeryLazy",
	config = function()
		local neocodeium = require("neocodeium")
		neocodeium.setup()
		vim.keymap.set("i", "<A-c>", neocodeium.clear)
		-- vim.keymap.set("i", "<A-tab>", neocodeium.accept)
		vim.keymap.set("i", "<A-f>", neocodeium.accept)
		vim.keymap.set("i", "<A-n>", function()
			neocodeium.cycle(1)
		end)
		-- vim.keymap.set("i", "<A-p>", function () neocodeium.cycle(-1) end)
	end,
}
