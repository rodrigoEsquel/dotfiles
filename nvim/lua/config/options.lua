-- See `:help vim.o`
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.autowrite = true -- Enable auto write
vim.opt.confirm = true -- Confirm to save changes before exiting

vim.o.hlsearch = false -- Set highlight on search
vim.wo.number = true -- Make line numbers default
-- vim.opt.relativenumber = true

vim.o.mouse = "a" -- Enable mouse mode
vim.o.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.o.breakindent = true -- Enable break indent

vim.o.undofile = true -- Save undo history

vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true

vim.wo.signcolumn = "number" -- Keep signcolumn on by default

vim.o.jumpoptions = "stack"

vim.o.updatetime = 50 -- Decrease update time
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.completeopt = "menu,menuone,noselect,preview" -- Set completeopt to have a better completion experience

vim.o.termguicolors = true -- NOTE: You should make sure your terminal supports this

vim.o.scrolloff = 20 -- Scroll off
vim.o.sidescrolloff = 20

-- vim.opt.colorcolumn = "80"

vim.o.wrap = false -- Disable line wrap
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0

vim.opt.splitkeep = "screen" -- Keep screen placin on split
vim.o.splitbelow = true -- Sane split placing
vim.o.splitright = true

vim.opt.laststatus = 3

vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	-- fold = "⸱",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

vim.opt.cursorline = true

vim.diagnostic.config({
	float = { border = "rounded" },
})

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})
