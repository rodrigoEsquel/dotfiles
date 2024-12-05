local function filepath()
	local file_path = vim.fn.expand("%:p")
	local cwd = vim.fn.getcwd()

	if file_path == "" then
		return ""
	end

	-- Function to apply highlights
	local function highlight(text, group)
		return string.format("%%#%s#%s%%*", group, text)
	end

	-- Function to split path
	local function split_path(path)
		local folders = {}
		for folder in path:gmatch("[^/]+") do
			table.insert(folders, folder)
		end
		return folders
	end

	-- Handle different path scenarios
	local result
	local folders = {}

	local is_oil = file_path:match("oil://")

	if is_oil then
		-- Oil protocol path (file)
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

	for i, folder in ipairs(file_folders) do
		local group = ((i == #file_folders) and not is_oil) and "@function" or "@variable"
		table.insert(folders, highlight(folder, group))

		if i < #file_folders then
			table.insert(folders, highlight(" ❯ ", "@boolean"))
		end
	end

	result = table.concat(folders)

	return result
end

return filepath
