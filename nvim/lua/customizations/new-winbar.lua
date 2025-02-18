local get_items = require("customizations.windbar")

local function highlight(text, group)
	return string.format("%%#%s#%s%%*", group, text)
end

local function get_current_file_path(props)
	local items = get_items(props.file_path)

	local path_items = {}

	if type(items) ~= "table" then
		return {}
	end
	for _, item in ipairs(items) do
		table.insert(path_items, highlight(item.text, item.hl))
	end
	return table.concat(path_items)
end

return function()
	local props = {
		buf = vim.api.nvim_get_current_buf(),
		file_path = vim.fn.expand("%:p"),
	}

	local file_path = get_current_file_path(props)

	local result = file_path

	return result
end
