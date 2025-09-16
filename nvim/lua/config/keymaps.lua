-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Buffer handling
vim.keymap.set("n", "<leader>bd", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "[D]elete [B]uffer", silent = true })
vim.keymap.set("n", "<leader>bc", ":%bd|e#|bd#<CR>", { desc = "[C]lear [B]uffers", silent = true })
-- vim.keymap.set("n", "<leader>bl", ":bnext<CR>", { desc = "Next [B]uffer" })
-- vim.keymap.set("n", "<leader>bh", ":bprev<CR>", { desc = "Previous [B]uffer" })
vim.keymap.set("n", "<leader>bb", ":b#<CR>", { desc = "[B]uffer [B]ack", silent = true })

vim.keymap.set("n", "<leader>w", "<c-w>", { silent = true })

-- manage quickfix lists
vim.keymap.set("n", "<leader>qs", ":copen<CR>", { silent = true, desc = "[O]pen [Q]uickfix" })
vim.keymap.set("n", "<leader>q", function()
	local number = vim.fn.getcharstr()
	local numeric_value = tonumber(number)
	if numeric_value then
		vim.cmd("cc" .. numeric_value)
	end
end, { remap = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>ef", function()
	local filetypes = ""
	local buffers = vim.api.nvim_list_bufs()
	for index, buffer in ipairs(buffers) do
		local filetype = vim.api.nvim_get_option_value("filetype", { buf = buffer })
		filetypes = filetypes .. " %" .. filetype .. "@"
	end
	print(filetypes)
end, { desc = "Print filetype" })

-- Exit to normal mode and save file
vim.keymap.set({ "v", "i" }, "<C-s>", "<cmd>w<cr><esc>")

vim.keymap.set("n", "Q", "@q")

-- Sort selection
vim.keymap.set("v", "<leader><space>", ":sort<cr>")

-- Move lines of text with ease
vim.keymap.set("v", "<c-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<c-k>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("i", "<c-c>", "<ESC>")
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")
vim.keymap.set({ "t", "i" }, "jk", "<C-\\><C-n>")
vim.keymap.set({ "t", "i" }, "kj", "<C-\\><C-n>")
vim.keymap.set("i", "<c-l>", "<del>")

-- vim.keymap.set(
-- 	"n",
-- 	"<leader>ts",
-- 	"<C-w>s:terminal<CR>:set filetype=terminal-split<CR>i",
-- 	{ desc = "[T]erminal [S]plit", silent = true }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>tv",
-- 	"<C-w>v:terminal<CR>:set filetype=terminal-vsplit<CR>i",
-- 	{ desc = "[T]erminal [V]ertical Split", silent = true }
-- )
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>tt",
-- 	"<C-w>s:terminal<CR>:set filetype=terminal-split<CR>inpm run test<CR>",
-- 	{ desc = "[T]erminal Run [T]est", silent = true }
-- )

vim.keymap.set("n", "<leader>cc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[C]ode [C]hange" })
vim.keymap.set("n", "<leader>c<space>", require("customizations.format-file-saving-marks"), { desc = "[C]ode Format" })

vim.keymap.set("n", "<leader>da", ":diffthis<CR>", { desc = "[D]iff [A]dd" })
vim.keymap.set("n", "<leader>do", ":diffoff<CR>", { desc = "[D]iff [O]ff" })

-- open a floating window with a terminal
local open_terminal = function()
	-- Create a buffer for the terminal
	local buf = vim.api.nvim_create_buf(false, true)

	-- Get editor dimensions
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	-- Calculate floating window size (80% of editor size)
	local win_width = math.floor(width * 0.8)
	local win_height = math.floor(height * 0.8)

	-- Calculate starting position to center the window
	local row = math.floor((height - win_height) / 2)
	local col = math.floor((width - win_width) / 2)

	-- Set floating window options
	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = "minimal",
		border = "single",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Open terminal in the buffer
	vim.fn.termopen(vim.o.shell)

	-- Switch to insert mode automatically
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>wt", open_terminal, { desc = "[W]indow [T]erminal" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

local jumplist_popup = require("customizations.jumplist-popup")

local function do_jump(keys)
  -- Convert to proper termcodes
  local term = vim.api.nvim_replace_termcodes(keys, true, false, true)
  -- Feed keys as if typed, preserving normal behavior
  vim.api.nvim_feedkeys(term, "n", false)
  -- Show popup *after* jump, using vim.schedule
  vim.schedule(function()
    jumplist_popup.show_jumplist()
  end)
end

vim.keymap.set("n", "<C-o>", function() do_jump("<C-o>") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-i>", function() do_jump("<C-i>") end, { noremap = true, silent = true })
