local function close_diffview_and_delete_gitsigns_buffers()
	-- Close Diffview
	vim.cmd("DiffviewClose")

	-- Get a list of all buffers
	local buffers = vim.api.nvim_list_bufs()
	-- Loop through each buffer
	for _, buf in ipairs(buffers) do
		local bufname = vim.api.nvim_buf_get_name(buf)
		-- Check if the buffer name contains 'gitsigns'
		if string.match(bufname, "gitsigns") then
			-- Delete the buffer if it matches
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

local function get_default_branch()
	local handle = io.popen("git remote show origin | grep 'HEAD branch' | awk '{print $3}'")
	-- check handle nil
	if handle == nil then
		return "master"
	end
	local result = handle:read("*a")
	handle:close()
	local response = result:gsub("%s+", "") -- Remove any trailing whitespace
	return response
end

local function get_current_branch()
	local handle = io.popen("git symbolic-ref --short HEAD")
	-- check handle nil
	if handle == nil then
		return "master"
	end
	local result = handle:read("*a")
	handle:close()
	local response = result:gsub("%s+", "") -- Remove any trailing whitespace
	return response
end

local function get_diffview_name()
	local current_branch = get_current_branch()
	local default_branch = get_default_branch()
	if current_branch == default_branch then
		vim.cmd("DiffviewOpen origin/HEAD")
		return
	end
	vim.cmd("DiffviewOpen " .. get_default_branch() .. "...HEAD")
end

local function _get_diffview_name()
	local fork_point = vim.cmd("Git merge-base --fork-point master")
	vim.cmd("DiffviewOpen " .. fork_point)
end

return {
	"sindrets/diffview.nvim",
	event = { "BufEnter" },
	setup = function() end,
	keys = {
		{
			"<leader>gq",
			close_diffview_and_delete_gitsigns_buffers,
			desc = "[G]it diff [Q]uit",
			silent = true,
		},
		{
			"<leader>gw",
			":DiffviewFileHistory % -G<c-r><c-w><CR>",
			desc = "[G]it [W]ord file history",
			noremap = true,
		},
		{
			"<leader>gD",
			get_diffview_name,
			-- get_diffview_name,
			desc = "[G]it open [D]iff ",
			noremap = true,
		},
		{
			"<leader>gh",
			":DiffviewFileHistory %<CR>",
			desc = "[G]it [F]ile history",
			noremap = true,
		},
		{
			"<leader>gH",
			":DiffviewFileHistory<CR>",
			desc = "[G]it [H]istory",
			noremap = true,
		},
	},
}
