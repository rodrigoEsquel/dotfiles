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

vim.o.diffopt = "internal,filler,closeoff,algorithm:histogram,context:5,linematch:60"

vim.o.scrolloff = 10 -- Scroll off
vim.o.sidescrolloff = 10

-- vim.opt.colorcolumn = "80"

vim.o.wrap = false -- Disable line wrap
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0

vim.opt.splitkeep = "screen" -- Keep screen placin on split
vim.o.splitbelow = true -- Sane split placing
vim.o.splitright = true

vim.opt.laststatus = 0

vim.opt.fillchars = {
	foldopen = "▾",
	foldclose = "▸",
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

function _G.qftf(info)
	local fn = vim.fn
	local items
	local ret = {}

	local root = fn.getcwd()
	vim.cmd(("noa lcd %s"):format(fn.fnameescape(root)))

	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end

	-- Find max filename and max column length for consistent formatting
	local max_filename_len = 0
	local max_col_len = 0
	for _, item in ipairs(items) do
		local fname = fn.bufname(item.bufnr)
		max_filename_len = math.max(max_filename_len, #fname)
		local col = item.col > 0 and tostring(item.col) or "-"
		max_col_len = math.max(max_col_len, #col)
	end

	-- Format each item
	for _, item in ipairs(items) do
		local fname = fn.bufname(item.bufnr)
		local lnum = item.lnum > 0 and tostring(item.lnum) or "-"
		local col = item.col > 0 and tostring(item.col) or "-"

		-- Pad filename to consistent length
		fname = fname .. string.rep(" ", max_filename_len - #fname)

		-- Left-align column number with padding on the right
		col = col .. string.rep(" ", max_col_len - #col)

		local text = item.text:gsub("^%s+", ""):gsub("%s+$", "")

		-- Format: filename | line | col | text
		local formatted = string.format("%s │%3d:%-3d│ %s", fname, lnum, col, text)

		table.insert(ret, formatted)
	end

	return ret
end

-- Set the quickfix formatting function
vim.o.qftf = "v:lua.qftf"
