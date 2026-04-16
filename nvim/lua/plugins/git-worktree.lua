local function split_args(input)
	if input == nil or input == "" then
		return {}
	end
	return vim.fn.split(input, " ")
end

local function run_worktree_script(script, args)
	local scripts_dir = vim.loop.cwd() .. "/scripts"
	local script_path = scripts_dir .. "/" .. script

	if vim.fn.filereadable(script_path) == 0 then
		vim.notify("Worktree script not found: " .. script_path, vim.log.levels.ERROR)
		return
	end

	local command = { script_path }
	for _, arg in ipairs(args or {}) do
		if arg ~= "" then
			table.insert(command, arg)
		end
	end

	local task = require("overseer").new_task({
		name = "Worktree: " .. script,
		cmd = command,
		cwd = vim.loop.cwd(),
		components = { "default" },
	})

	task:start()
end

local function close_worktree()
	local input = vim.fn.input("Close worktree (name + flags): ")
	local args = split_args(input)
	if #args == 0 then
		return
	end
	run_worktree_script("close-worktree", args)
end

local function update_worktree()
	local input = vim.fn.input("Update worktree (optional name + flags): ")
	local args = split_args(input)
	if #args == 0 then
		run_worktree_script("update-worktree")
		return
	end
	run_worktree_script("update-worktree", args)
end

local function open_worktree_tab(path, branch)
	vim.cmd("tabnew")
	vim.cmd("tcd " .. vim.fn.fnameescape(path))
	local tab_name = branch or vim.fn.fnamemodify(path, ":t")
	vim.cmd("LualineRenameTab " .. vim.fn.fnameescape(tab_name))
end

local function list_worktrees()
	local lines = vim.fn.systemlist("git worktree list --porcelain 2>/dev/null")
	local items = {}
	local current = {}

	for _, line in ipairs(lines) do
		local key, value = line:match("^(%S+)%s*(.*)$")
		if key == "worktree" then
			if current.path then
				table.insert(items, current)
			end
			current = { path = value }
		elseif key == "branch" then
			current.branch = value:gsub("^refs/heads/", "")
		elseif key == "detached" then
			current.branch = "detached"
		end
	end

	if current.path then
		table.insert(items, current)
	end

	return items
end

local function guess_branch_arg(args)
	for _, arg in ipairs(args or {}) do
		if arg ~= "" and not vim.startswith(arg, "-") then
			return arg
		end
	end
	return nil
end

local function open_worktree_picker()
	local items = {}
	for _, worktree in ipairs(list_worktrees()) do
		local branch = worktree.branch or "detached"
		local display = string.format("%s  %s", branch, worktree.path)
		table.insert(items, {
			text = display,
			path = worktree.path,
			branch = branch,
		})
	end

	if #items == 0 then
		vim.notify("No git worktrees found", vim.log.levels.WARN)
		return
	end

	require("snacks").picker.pick({
		title = "Git Worktrees",
		items = items,
		format = "text",
		preview = "none",
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			open_worktree_tab(item.path, item.branch)
		end,
	})
end

local function open_worktree()
	local input = vim.fn.input("Open worktree (name + flags): ")
	local args = split_args(input)
	if #args == 0 then
		return
	end

	local before = {}
	for _, worktree in ipairs(list_worktrees()) do
		before[worktree.path] = true
	end

	local desired_branch = guess_branch_arg(args)
	local command = { "open-worktree" }
	for _, arg in ipairs(args) do
		if arg ~= "" then
			table.insert(command, arg)
		end
	end

	local scripts_dir = vim.loop.cwd() .. "/scripts"
	local script_path = scripts_dir .. "/open-worktree"
	if vim.fn.filereadable(script_path) == 0 then
		vim.notify("Worktree script not found: " .. script_path, vim.log.levels.ERROR)
		return
	end

	command[1] = script_path
	local task = require("overseer").new_task({
		name = "Worktree: open",
		cmd = command,
		cwd = vim.loop.cwd(),
		components = { "default" },
	})

	task:subscribe("on_complete", function(_, status)
		if status ~= "SUCCESS" then
			vim.notify("Worktree creation failed", vim.log.levels.ERROR)
			return
		end

		local after = list_worktrees()
		local new_items = {}
		for _, worktree in ipairs(after) do
			if not before[worktree.path] then
				table.insert(new_items, worktree)
			end
		end

		local target = nil
		if #new_items == 1 then
			target = new_items[1]
		elseif desired_branch then
			for _, worktree in ipairs(after) do
				if worktree.branch == desired_branch then
					target = worktree
					break
				end
			end
		end

		if not target and #new_items > 0 then
			target = new_items[1]
		end

		if not target then
			vim.notify("Worktree created, but could not locate path", vim.log.levels.WARN)
			return
		end

		open_worktree_tab(target.path, target.branch)
	end)

	task:start()
end

return {
	{
		"ThePrimeagen/git-worktree.nvim",
		config = function()
			require("git-worktree").setup({
				change_directory_command = "tcd",
				update_on_change = true,
				update_on_change_command = "e .",
			})
		end,
		keys = {
			{
				"<leader>gT",
				function()
					open_worktree_picker()
				end,
				desc = "[G]it [T]rees",
			},
			{ "<leader>gN", open_worktree, desc = "[G]it tree [N]ew" },
			{ "<leader>gX", close_worktree, desc = "[G]it tree [X] close" },
			{ "<leader>gP", update_worktree, desc = "[G]it tree [P]ull/refresh" },
		},
	},
}
