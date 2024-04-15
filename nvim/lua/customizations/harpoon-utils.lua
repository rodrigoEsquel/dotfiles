local Path = require("plenary.path")
local harpoon = require("harpoon")

local M = {}

M.list = harpoon:list()

function M:get_file_from_buffer(bufnr)
	local file = Path:new(vim.api.nvim_buf_get_name(bufnr)):make_relative(vim.loop.cwd())
	return file
end

function M:has_value(table, targetValue)
	for _, value in ipairs(table) do
		if value == targetValue then
			return true
		end
	end
	return false
end

function M:buf_is_harpooned(bufnr)
	if bufnr == nil then
		return false
	end

	local harpoon_files = harpoon:list()
	local bufrn_file = M:get_file_from_buffer(bufnr)
	local file_paths = {}

	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end
	local is_harpooned = M:has_value(file_paths, bufrn_file)
	return is_harpooned
end

function M:get_harpoon_index(bufnr)
	if bufnr == nil then
		return false
	end

	local harpoon_files = harpoon:list()
	local bufrn_file = M:get_file_from_buffer(bufnr)
	local file_index = 0

	for index, item in ipairs(harpoon_files.items) do
		if bufrn_file == item.value then
			file_index = index
		end
	end

	if file_index then
		return file_index
	end
	return false
end

return M
