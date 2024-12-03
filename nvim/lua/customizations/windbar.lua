local function filepath()
	local file_path = vim.fn.expand("%:.")
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
		if relative_path == vim.pesc(cwd) then
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
			local folders = {}
			for folder in relative_path:gmatch("[^/]+") do
				table.insert(folders, highlight(folder, "@operator"))
			end

			result = table.concat(folders, " ❯ ")
		else
			-- File path outside CWD
			local folders = split_path(file_path)

			-- Remove duplicate home folder
			if folders[1] == folders[2] then
				table.remove(folders, 1)
			end

			local highlighted_folders = {}
			for i, folder in ipairs(folders) do
				table.insert(highlighted_folders, highlight(folder, "@operator"))
			end

			result = table.concat(highlighted_folders, " ❯ ")
		end
	end

	return result
end

return filepath
