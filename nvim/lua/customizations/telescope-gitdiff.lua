local pickers = require("telescope.pickers")
local from_entry = require("telescope.from_entry")
local make_entry = require("telescope.make_entry")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local putils = require("telescope.previewers.utils")
local previewers = require("telescope.previewers")

local function defaulter(f, default_opts)
	default_opts = default_opts or {}
	return {
		new = function(opts)
			if conf.preview == false and not opts.preview then
				return false
			end
			opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
			if type(conf.preview) == "table" then
				for k, v in pairs(conf.preview) do
					opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
				end
			end
			return f(opts)
		end,
		__call = function()
			local ok, err = pcall(f(default_opts))
			if not ok then
				error(debug.traceback(err))
			end
		end,
	}
end

-- Modified previewer to accept base_branch parameter
local function create_previewer(base_branch)
	return defaulter(function(opts)
		return previewers.new_buffer_previewer({
			title = "Git File Diff Preview",
			get_buffer_by_name = function(_, entry)
				return entry.value
			end,

			define_preview = function(self, entry, status)
				if entry.status and (entry.status == "??" or entry.status == "A ") then
					local p = from_entry.path(entry, true, false)
					if p == nil or p == "" then
						return
					end
					conf.buffer_previewer_maker(p, self.state.bufnr, {
						bufname = self.state.bufname,
						winid = self.state.winid,
						preview = opts.preview,
						file_encoding = opts.file_encoding,
					})
				else
					-- Use base_branch instead of "HEAD"
					putils.job_maker(
						{ "git", "--no-pager", "diff", base_branch, "--", entry.value },
						self.state.bufnr,
						{
							value = entry.value,
							bufname = self.state.bufname,
							cwd = opts.cwd,
							callback = function(bufnr)
								if vim.api.nvim_buf_is_valid(bufnr) then
									putils.regex_highlighter(bufnr, "diff")
								end
							end,
						}
					)
				end
			end,
		})
	end, {})
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

-- Function to get the base branch
local function get_base_branch()
	-- First, try to get the default branch from origin
	local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'")
	local branch = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if branch and branch ~= "" then
		return branch
	end

	-- Try to get the remote's default branch
	local handle = io.popen("git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5")
	local remote_branch = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if remote_branch and remote_branch ~= "" then
		return remote_branch
	end

	-- Get current branch and find merge base with common branches
	local handle = io.popen("git branch --show-current 2>/dev/null")
	local current_branch = handle:read("*a"):gsub("%s+", "")
	handle:close()

	if current_branch and current_branch ~= "" then
		local branches = { "main", "master", "develop" }

		for _, branch in ipairs(branches) do
			-- Check if branch exists
			local handle = io.popen("git show-ref --verify --quiet refs/heads/" .. branch .. " 2>/dev/null")
			local result = handle:close()

			if result then
				-- Check if there's a merge base (meaning it's a potential base branch)
				local handle = io.popen("git merge-base " .. branch .. " " .. current_branch .. " 2>/dev/null")
				local merge_base = handle:read("*a"):gsub("%s+", "")
				handle:close()

				if merge_base and merge_base ~= "" then
					return branch
				end
			end
		end
	end

	-- Final fallback: check which common branch exists
	local branches = { "main", "master", "develop" }
	for _, branch in ipairs(branches) do
		local handle = io.popen("git show-ref --verify --quiet refs/heads/" .. branch .. " 2>/dev/null")
		local result = handle:close()
		if result then
			return branch
		end
	end

	-- Ultimate fallback
	return "main"
end

-- Function to get files with diff from base branch
local function get_diff_files(base_branch)
	local files = {}

	-- Get modified/added/deleted files compared to base branch
	local current_branch = get_current_branch()
	local handle = io.popen(
		"git diff --name-only " .. base_branch .. (current_branch == base_branch and "" or "...HEAD") .. " 2>/dev/null"
	)
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
		return "A"
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

	-- Create previewer with base_branch
	local previewer_instance = create_previewer(base_branch)

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
						status = entry.status, -- Pass status to entry for previewer
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewer_instance.new(opts),
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
	git_diff_picker({})
end, {})

-- Optional: Create a keymap
vim.keymap.set("n", "<leader>sS", function()
	git_diff_picker()
end, { desc = "Git diff files" })

-- Export the function for use in other configs
return {
	git_diff_picker = git_diff_picker,
}
