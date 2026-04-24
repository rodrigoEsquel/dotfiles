local M = {}

local presets = {
	notification = { text = "needs input", level = vim.log.levels.WARN, timeout = false },
	stop = { text = "finished", level = vim.log.levels.INFO, timeout = 6000 },
	subagent_stop = { text = "subagent finished", level = vim.log.levels.INFO, timeout = 4000 },
}

local function find_claude_terminal()
	local best_buf, best_time = nil, -1
	for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		if vim.bo[info.bufnr].buftype == "terminal" and info.lastused > best_time then
			best_buf, best_time = info.bufnr, info.lastused
		end
	end
	return best_buf
end

local function focus_terminal()
	local buf = find_claude_terminal()
	if not buf then
		local ok, snacks = pcall(require, "snacks")
		if ok and snacks.terminal then
			snacks.terminal.toggle(nil, {
				cwd = vim.fn.getcwd(),
				win = { position = "right", width = 0.4 },
			})
		end
		return
	end
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_set_current_win(win)
			return
		end
	end
	vim.cmd("vsplit")
	vim.api.nvim_win_set_buf(0, buf)
end

local function switch_tmux(pane)
	if not pane or pane == "" then
		return
	end
	local current = vim.env.TMUX_PANE or ""
	if pane == current then
		return
	end
	local sess = vim.fn.systemlist({ "tmux", "display-message", "-p", "-t", pane, "#{session_name}" })[1]
	if sess and sess ~= "" then
		vim.fn.system({ "tmux", "switch-client", "-t", sess })
	end
	vim.fn.system({ "tmux", "select-window", "-t", pane })
	vim.fn.system({ "tmux", "select-pane", "-t", pane })
end

local function make_on_open(pane)
	return function(win)
		local buf = vim.api.nvim_win_get_buf(win)
		local function act()
			pcall(vim.api.nvim_win_close, win, true)
			switch_tmux(pane)
			focus_terminal()
		end
		local opts = { buffer = buf, nowait = true, silent = true }
		vim.keymap.set("n", "<CR>", act, opts)
		vim.keymap.set("n", "<LeftMouse>", act, opts)
		vim.keymap.set("n", "<2-LeftMouse>", act, opts)
		vim.keymap.set("n", "q", function()
			pcall(vim.api.nvim_win_close, win, true)
		end, opts)
	end
end

function M.notify(event, cwd, tmux_pane)
	local p = presets[event] or { text = tostring(event), level = vim.log.levels.INFO, timeout = 4000 }
	local text = "Claude " .. p.text
	local pane = (tmux_pane and tmux_pane ~= "") and tmux_pane or nil
	vim.schedule(function()
		vim.notify(text, p.level, {
			title = "Claude Code",
			timeout = p.timeout,
			on_open = make_on_open(pane),
		})
	end)
	return 1
end

return M
