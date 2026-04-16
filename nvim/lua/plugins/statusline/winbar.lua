local ok, devicons = pcall(require, "nvim-web-devicons")

local hl_divider = "lualine_b_replace"
local hl_file = "lualine_b_normal"
local hl_folder = "lualine_b_command"

local function create_highlight_group(file_type, guifg)
	local highlight_group = "FileType" .. file_type
	vim.api.nvim_command("highlight " .. highlight_group .. " guifg=" .. guifg .. " guibg=#1f1f28 gui=bold cterm=bold")
	return highlight_group
end

local function get_highlight_group(file_path)
	if not ok then
		return "", hl_divider
	end
	local icon, color = devicons.get_icon_color(file_path)
	local file_type = vim.fn.fnamemodify(file_path, ":e")
	if icon == nil then
		return "", hl_divider
	end
	local highlight_group = create_highlight_group(file_type, color)
	return icon, highlight_group
end

local function get_items(file_path)
	if file_path == nil then
		file_path = vim.fn.expand("%:p")
	end
	local cwd = vim.fn.getcwd()

	if file_path == "" then
		return ""
	end

	local function highlight(text, group)
		return string.format("%%#%s#%s%%*", group, text)
	end

	local function split_path(path)
		local folders = {}
		for folder in path:gmatch("[^/]+") do
			table.insert(folders, folder)
		end
		return folders
	end

	local items = {}
	local folders = {}

	local is_oil = file_path:match("oil://")

	if is_oil then
		file_path = file_path:gsub("^oil://", "")
	end

	local cwd_folders = split_path(cwd)
	local file_folders = split_path(file_path)

	local is_in_cwd = file_path:match("^" .. vim.pesc(cwd))

	if is_in_cwd then
		for i, _ in ipairs(cwd_folders) do
			if i < (#cwd_folders - 1) then
				table.remove(file_folders, 1)
			end
		end
		table.remove(file_folders, 1)
	else
		table.insert(file_folders, 1, "/")
	end

	local icon, icon_hl
	if is_oil then
		icon, icon_hl = "", hl_divider
	else
		icon, icon_hl = get_highlight_group(file_path)
	end

	table.insert(items, 1, { text = (icon or "") .. " ", hl = icon_hl })

	for i, folder in ipairs(file_folders) do
		local group = ((i == #file_folders) and not is_oil) and hl_file or hl_folder
		table.insert(items, { text = folder, hl = group })

		if i < #file_folders then
			table.insert(items, { text = " ❯ ", hl = hl_divider })
		end
	end

	for _, item in ipairs(items) do
		table.insert(folders, highlight(item.text, item.hl))
	end

	return items
end

local function highlight(text, group)
	return string.format("%%#%s#%s%%*", group, text)
end

return function()
	local props = {
		buf = vim.api.nvim_get_current_buf(),
		file_path = vim.fn.expand("%:p"),
		file_type = vim.bo.filetype,
	}

	local items = get_items(props.file_path)

	local path_items = {}

	if type(items) ~= "table" then
		return props.file_type or " "
	end
	for _, item in ipairs(items) do
		table.insert(path_items, highlight(item.text, item.hl))
	end
	return table.concat(path_items)
end
