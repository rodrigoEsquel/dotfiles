local Path = require("plenary.path")
local strings = require("plenary.strings")

local pickers = require("telescope.pickers")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")
local telescope_utils = require("telescope.utils")
local themes = require("telescope.themes")

local harpoon = require("harpoon")

local function printTable(table)
	for key, value in pairs(table) do
		if type(value) == "table" then
			printTable(value)
		else
			print(key, value)
		end
	end
end

local function get_file_from_buffer(bufnr)
	local file = Path:new(vim.api.nvim_buf_get_name(bufnr)):make_relative(vim.loop.cwd())
	return file
end

local function has_value(table, targetValue)
	for _, value in ipairs(table) do
		if value == targetValue then
			return true
		end
	end
	return false
end

local function buf_is_harpooned(bufnr)
	local harpoon_files = harpoon:list()
	local bufrn_file = get_file_from_buffer(bufnr)
	local file_paths = {}

	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end
	local is_harpooned = has_value(file_paths, bufrn_file)
	return is_harpooned
end

local function get_harpoon_index(bufnr)
	local harpoon_files = harpoon:list()
	local bufrn_file = get_file_from_buffer(bufnr)
	local file_index = 0

	for index, item in ipairs(harpoon_files.items) do
		if bufrn_file == item.value then
			file_index = index
		end
	end

	return file_index
end

local function toggle_buffer_mark(prompt_bufnr)
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	local mark = " "
	local old = " "
	if not buf_is_harpooned(entry.bufnr) then
		local config = harpoon:list().config
		local file_path = get_file_from_buffer(entry.bufnr)
		local item = config.create_list_item(config, file_path)
		harpoon:list():append(item)
		local index = tostring(get_harpoon_index(entry.bufnr))
		mark = index
		old = " "
	else
		-- local harpoon_item = harpoon:list():get(index)
		local index = get_harpoon_index(entry.bufnr)
		harpoon:list():removeAt(index)
		old = tostring(index)
		mark = " "
	end

	local row = current_picker:get_selection_row()
	local col = current_picker:is_multi_selected(entry) and #current_picker.multi_icon
	    or #current_picker.selection_caret
	vim.api.nvim_buf_set_text(current_picker.results_bufnr, row, col, row, col + #old, { mark })
end

local entry_from_buffer = function(opts)
	local icon_width = 0
	local icon, _ = telescope_utils.get_devicons("fname", false)
	icon_width = strings.strdisplaywidth(icon)

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = 3 },
			{ width = icon_width },
			{ remaining = true },
		},
	})

	local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

	local make_display = function(entry)
		-- marked + bufnr_width + modes + icon + 4 spaces + : + lnum
		opts.__prefix = 1 + opts.bufnr_width + 4 + icon_width + 4 + 1 + #tostring(entry.lnum)
		local display_file_name = entry.filename
		local display_icon, hl_group = telescope_utils.get_devicons(entry.filename, false)
		local index = tostring(get_harpoon_index(entry.bufnr))
		local mark = index

		return displayer({
			{
				entry.marked and mark or " ",
				"TelescopeResultsConstant",
			},
			{ entry.indicator, "TelescopeResultsIdentifier" },
			{ display_icon,    hl_group },
			display_file_name .. ":" .. entry.lnum,
		})
	end

	return function(entry)
		local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
		-- if bufname is inside the cwd, trim that part of the string
		bufname = Path:new(bufname):normalize(cwd)

		local changed = entry.info.changed == 1 and "+" or " "

		local indicator = entry.flag .. " " .. changed
		local lnum = 1

		-- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
		if entry.info.lnum ~= 0 then
			-- but make sure the buffer is loaded, otherwise line_count is 0
			if vim.api.nvim_buf_is_loaded(entry.bufnr) then
				local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
				lnum = math.max(math.min(entry.info.lnum, line_count), 1)
			else
				lnum = entry.info.lnum
			end
		end

		-- NOTE: This caches the state of the of the results
		return make_entry.set_default_entry_mt({
			bufnr = entry.bufnr,
			display = make_display,
			filename = bufname,
			indicator = indicator,
			lnum = lnum,
			marked = buf_is_harpooned(entry.bufnr),
			ordinal = entry.bufnr .. " : " .. bufname,
			value = bufname,
		}, opts)
	end
end

local buffer_sorter = function()
	local sorter = sorters.get_fzy_sorter()
	sorter.internal = sorter.scoring_function
	sorter.scoring_function = function(s, prompt, line, entry)
		if buf_is_harpooned(entry.bufnr) then
			local index = get_harpoon_index(entry.bufnr)

			return 2 ^ (1 - (20 / index))
		end
		return sorter.internal(s, prompt, line, entry)
	end

	return sorter
end

local function bufferpick(opts)
	opts.bufnr_width = 3 -- account for up to 3 digits buf numbers

	local bufnrs = vim.tbl_filter(function(b)
		if 1 ~= vim.fn.buflisted(b) or not vim.api.nvim_buf_is_loaded(b) then
			return false
		end

		if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
			return false
		end

		if opts.cwd and not string.find(vim.api.nvim_buf_get_name(b), opts.cwd, 1, true) then
			return false
		end

		return true
	end, vim.api.nvim_list_bufs())

	if not next(bufnrs) then
		return
	end

	table.sort(bufnrs, function(a, b)
		if buf_is_harpooned(a) and buf_is_harpooned(b) then
			return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
		end

		if buf_is_harpooned(a) then
			return true
		end

		if buf_is_harpooned(b) then
			return false
		end

		return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
	end)

	local buffers = {}
	for _, bufnr in ipairs(bufnrs) do
		table.insert(buffers, {
			bufnr = bufnr,
			flag = (bufnr == vim.fn.bufnr("")) and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " "),
			info = vim.fn.getbufinfo(bufnr)[1],
		})
	end

	pickers
	    .new(opts, {
		    finder = finders.new_table({
			    results = buffers,
			    entry_maker = entry_from_buffer(opts),
		    }),
		    previewer = conf.grep_previewer(opts),
		    sorter = buffer_sorter(),
		    default_selection_index = 1,
		    attach_mappings = function(_, map)
			    map("i", "<tab>", toggle_buffer_mark)
			    map("i", "<C-d>", require("telescope.actions").delete_buffer)
			    return true
		    end,
	    })
	    :find()
end
local get_dropdown = function(opts)
	opts = vim.tbl_extend("force", {}, opts or {})
	local dropdown = themes.get_dropdown({
		previewer = false,
		borderchars = {
			prompt = { "▄", "█", "█", "█", "▄", "▄", "█", "█" },
			results = { "▄", "█", "█", "█", "▄", "▄", "█", "█" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
	})
	return vim.tbl_extend("force", dropdown, opts)
end

local my_dropdown = get_dropdown({})

vim.keymap.set("n", "<leader>bm", function()
	harpoon:list():remove()
end, { desc = "[M]ark [B]uffer" })

vim.keymap.set("n", "<leader><space>", function()
	bufferpick(my_dropdown)
end, { desc = "[ ] [S]earch existing buffers" })
