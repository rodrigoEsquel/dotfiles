local open_tab = require("customizations.open-tab")
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

local float_group = vim.api.nvim_create_augroup("FloatGroup", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
	end,
	group = float_group,
})

local harpoon_group = vim.api.nvim_create_augroup("harpoon_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.g.harpoon_has_changed = true
	end,
	group = harpoon_group,
})

-- local incline_group = vim.api.nvim_create_augroup("incline_group", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
-- 	callback = function()
-- 		local incline = require("incline")
-- 		incline.refresh()
-- 	end,
-- 	group = incline_group,
-- })

local enter_group = vim.api.nvim_create_augroup("enter_group", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("LualineRenameTab code")
		vim.keymap.set("n", "<leader>oc", function()
			open_tab("code")
		end, { desc = "open tab" })
	end,
	group = enter_group,
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
