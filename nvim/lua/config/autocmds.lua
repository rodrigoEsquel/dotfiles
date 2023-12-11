-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local read_group = vim.api.nvim_create_augroup("ReadFile", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.cmd.checktime()
	end,
	group = read_group,
	pattern = "*",
})

