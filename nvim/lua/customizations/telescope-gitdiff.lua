local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Function to get the base branch (usually main or master)
local function get_base_branch()
	-- Try common base branch names
	local branches = { "main", "master", "develop" }

	for _, branch in ipairs(branches) do
		local handle = io.popen("git show-ref --verify --quiet refs/heads/" .. branch .. " 2>/dev/null")
		local result = handle:close()
		if result then
			return branch
		end
	end

	-- Fallback: try to get the default branch from origin
	local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'")
	local branch = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if branch and branch ~= "" then
		return branch
	end

	-- Final fallback
	return "main"
end

-- Function to get files with diff from base branch
local function get_diff_files(base_branch)
	local files = {}

	-- Get modified/added/deleted files compared to base branch
	local handle = io.popen("git diff --name-only " .. base_branch .. "...HEAD 2>/dev/null")
	if handle then
		for line in handle:lines() do
			if line ~= "" then
				table.insert(files, line)
			end
		end
		handle:close()
	end

	-- Get untracked files
	local handle = io.popen("git ls-files --others --exclude-standard 2>/dev/null")
	if handle then
		for line in handle:lines() do
			if line ~= "" then
				table.insert(files, line)
			end
		end
		handle:close()
	end

	-- Remove duplicates and sort
	local unique_files = {}
	local seen = {}
	for _, file in ipairs(files) do
		if not seen[file] then
			seen[file] = true
			table.insert(unique_files, file)
		end
	end

	table.sort(unique_files)
	return unique_files
end

-- Function to get file status (M, A, D, U for modified, added, deleted, untracked)
local function get_file_status(file, base_branch)
	-- Check if file is untracked
	local handle = io.popen("git ls-files --others --exclude-standard | grep -Fx '" .. file .. "' 2>/dev/null")
	local untracked = handle:read("*a")
	handle:close()

	if untracked and untracked ~= "" then
		return "U"
	end

	-- Check status compared to base branch
	local handle = io.popen("git diff --name-status " .. base_branch .. "...HEAD | grep '" .. file .. "' 2>/dev/null")
	local status = handle:read("*a")
	handle:close()

	if status and status ~= "" then
		return status:sub(1, 1) -- Return first character (M, A, D, etc.)
	end

	return "M" -- Default to modified
end

-- Main telescope picker function
local function git_diff_picker(opts)
	opts = opts or {}

	local base_branch = get_base_branch()
	local diff_files = get_diff_files(base_branch)

	if #diff_files == 0 then
		print("No files with differences found between HEAD and " .. base_branch)
		return
	end

	-- Create entries with file status
	local entries = {}
	for _, file in ipairs(diff_files) do
		local status = get_file_status(file, base_branch)
		local display = string.format("[%s] %s", status, file)
		table.insert(entries, {
			value = file,
			display = display,
			ordinal = file,
			status = status,
		})
	end

	pickers
		.new(opts, {
			prompt_title = "Git Diff Files (vs " .. base_branch .. ")",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry.value,
						display = entry.display,
						ordinal = entry.ordinal,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("edit " .. selection.value)
				end)

				-- Optional: Add mapping to show diff
				map("i", "<C-d>", function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd("Git diff " .. base_branch .. " -- " .. selection.value)
				end)

				return true
			end,
		})
		:find()
end

-- Create the command
vim.api.nvim_create_user_command("TelescopeGitDiff", function()
	git_diff_picker(require("telescope.themes").get_dropdown({}))
end, {})

-- Optional: Create a keymap
vim.keymap.set("n", "<leader>sS", function()
	git_diff_picker(require("telescope.themes").get_dropdown({}))
end, { desc = "Git diff files" })

-- Export the function for use in other configs
return {
	git_diff_picker = git_diff_picker,
}
