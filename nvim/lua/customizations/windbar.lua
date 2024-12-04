local function is_path_inside_cwd(path, working_dir)
	-- Normalize paths by removing trailing slashes and ensuring they end with a slash
	path = path:gsub("/$", "") .. "/"
	working_dir = working_dir:gsub("/$", "") .. "/"

	return path:sub(1, #working_dir) == working_dir
end

local function filepath()
	local file_path = vim.fn.expand("%:p")
	local cwd = vim.fn.getcwd()

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
	if file_path:match("^oil:///") then
		-- Oil protocol path (directory)
		local relative_path = file_path:gsub("^oil://", "")

		local folders = {}
		-- Check if path is inside or outside CWD
		if relative_path:match("^" .. vim.pesc(cwd)) then
			-- Inside CWD
			relative_path = relative_path:sub(#cwd + 1)
		else
			-- Outside CWD, relative to root
			relative_path = relative_path:gsub("^/", "")
			table.insert(folders, highlight("/", "@operator"))
		end

		for folder in relative_path:gmatch("[^/]+") do
			table.insert(folders, highlight(folder, "@operator"))
		end

		result = table.concat(folders, " ❯ ")
	else
		-- Determine if file is inside or outside current working directory
		if file_path:match("^" .. vim.pesc(cwd)) then
			-- File path inside CWD
			local relative_path = file_path:sub(#cwd + 2)

			local folders = split_path(cwd)
			local relative_folders = split_path(file_path)
			for i, folder in ipairs(relative_folders) do
				if folder == folders[i] then
					table.remove(relative_folders, i)
				end
			end
			local highlighted_folders = {}
			for i, folder in ipairs(relative_folders) do
				local group = (i == #relative_folders) and "@keyword" or "@operator"

				table.insert(highlighted_folders, highlight(folder, group))
			end

			result = table.concat(highlighted_folders, " ❯ ")
		else
			-- File path outside CWD
			local folders = split_path(file_path)
			table.insert(folders, 1, "/")

			-- Remove duplicate home folder
			if folders[1] == folders[2] then
				table.remove(folders, 1)
			end
			local highlighted_folders = {}
			for i, folder in ipairs(folders) do
				local group = (i == #folders) and "@keyword" or "@operator"
				table.insert(highlighted_folders, highlight(folder, group))
			end

			result = table.concat(highlighted_folders, " ❯ ")
		end
	end

	return result
end

return filepath
