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

local harpoon_group = vim.api.nvim_create_augroup("harpoon_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.g.harpoon_has_changed = true
	end,
	group = harpoon_group,
})
-- vim.api.nvim_exec(
-- 	[[
--   augroup FileExplorer
--     autocmd!
--     autocmd VimEnter * silent!
--   augroup END
-- ]],
-- 	false
-- )

local term_group = vim.api.nvim_create_augroup("OnTerm", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		local nsp = vim.api.nvim_create_namespace("Terminal")
		local colors = require("kanagawa.colors").setup({ theme = "wave" }).theme
		vim.api.nvim_set_hl(nsp, "Normal", { bg = colors.ui.bg_m2 })
		vim.api.nvim_win_set_hl_ns(0, nsp)
		-- vim.cmd("startinsert!")
	end,
	group = term_group,
	desc = "Terminal Options",
})

vim.api.nvim_create_autocmd(
        { "FocusLost", "ModeChanged", "TextChanged", "BufEnter" },
        { desc = "autosave", pattern = "*", command = "silent! update" }
)
