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
	pattern = "*.*",
})

local ts_group = vim.api.nvim_create_augroup("OnNvimEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		local first_arg = vim.v.argv[3]
		if first_arg and vim.fn.isdirectory(first_arg) == 1 then
			-- Vim creates a buffer for folder. Close it.
			vim.cmd(":Alpha")
			-- require("telescope.builtin").find_files()
		end
	end,
	group = ts_group,
})

vim.api.nvim_exec(
	[[
  augroup FileExplorer
    autocmd!
    autocmd VimEnter * silent!
  augroup END
]],
	false
)
