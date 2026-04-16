-- Jumplist navigation with popup preview
local popup = require("plugins.jumplist.popup")

local function do_jump(keys)
	local term = vim.api.nvim_replace_termcodes(keys .. "zz", true, false, true)
	vim.api.nvim_feedkeys(term, "n", false)
	vim.schedule(function()
		popup.show_jumplist()
	end)
end

vim.keymap.set("n", "<C-o>", function()
	do_jump("<C-o>")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-i>", function()
	do_jump("<C-i>")
end, { noremap = true, silent = true })

return {}
