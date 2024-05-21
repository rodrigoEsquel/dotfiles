-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Buffer handling
vim.keymap.set("n", "<leader>bc", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "[C]lose [B]uffer", silent = true })
vim.keymap.set("n", "<leader>br", ":%bd|e#|bd#<CR>", { desc = "[C]lose [R]eset", silent = true })
vim.keymap.set("n", "<leader>bl", ":bnext<CR>", { desc = "Next [B]uffer" })
vim.keymap.set("n", "<leader>bh", ":bprev<CR>", { desc = "Previous [B]uffer" })
vim.keymap.set("n", "<leader>bb", ":b#<CR>", { desc = "[B]uffer [B]ack", silent = true })

vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "[W]indow" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "ef", function()
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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
