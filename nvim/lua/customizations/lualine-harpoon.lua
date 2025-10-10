local M = require("lualine.component"):extend()

local Path = require("plenary.path")
local harpoon_utils = require("customizations.harpoon-utils")
local web_devicons = require("nvim-web-devicons")
local highlights = require("lualine.highlight")

local component_icon = ""

local function highlight(text, group)
	-- vim.print(group)
	return string.format("%%#%s#%s%%*", group, text)
end

local function is_current_file(file_path)
	local root_dir = vim.loop.cwd()
	local current_file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local current_file_normalized = Path:new(current_file):make_relative(root_dir)
	return current_file_normalized == file_path
end

local function get_filename(file_path)
	local isOil = file_path:match("oil://")
	if isOil then
		return file_path:match("([^/]+)/$")
	else
		return file_path:match("[^/]+$")
	end
end

local function get_parent_dir(file_path)
	local isOil = file_path:match("oil://")
	if isOil then
		local parent = file_path:match("oil://(.+)/[^/]+/$")
		return parent and parent:match("[^/]+$") or nil
	else
		local parent = file_path:match("(.+)/[^/]+$")
		return parent and parent:match("[^/]+$") or nil
	end
end

local function truncate_string(str, max_length)
	if #str <= max_length then
		return str
	end

	local end_part_length = 10
	local start_part_length = max_length - end_part_length - 3
	local start_part = str:sub(1, start_part_length)
	local end_part = str:sub(-end_part_length)
	return start_part .. "..." .. end_part
end

local function process_harpoon_items(harpoon_files)
	local filename_counts = {}
	local processed_items = {}
	for _, item in pairs(harpoon_files) do
		local filename = get_filename(item.value)
		if filename then
			filename_counts[filename] = (filename_counts[filename] or 0) + 1
		end
	end
	for index, item in pairs(harpoon_files) do
		local file_path = item.value
		local filename = get_filename(file_path)
		local display_name = ""
		local icon = ""
		local isOil = file_path:match("oil://")
		if filename and filename_counts[filename] > 1 then
			local parent = get_parent_dir(file_path)
			if parent then
				display_name = parent .. "/" .. filename
			else
				display_name = filename
			end
		else
			display_name = filename or file_path
		end

		display_name = truncate_string(display_name, 25)

		if isOil then
			icon = ""
		else
			icon, _ = web_devicons.get_icon(file_path)
			if icon == nil then
				icon = ""
			end
		end
		processed_items[index] = {
			file_path = file_path,
			display_name = display_name,
			icon = icon,
			is_current = is_current_file(file_path),
		}
	end
	return processed_items
end

local function create_item(index, processed_item)
	local item = " " .. index .. " " .. processed_item.icon .. " " .. processed_item.display_name .. " "
	return item
end

local function create_reverse_highlight(existing_group)
	local new_group = existing_group .. "_reverse"
	local hl = vim.api.nvim_get_hl(0, { name = new_group })
	if next(hl) ~= nil then
		return new_group
	end
	local existing_hl = vim.api.nvim_get_hl(0, { name = existing_group })

	vim.api.nvim_set_hl(0, new_group, {
		fg = existing_hl.bg,
		bg = "NONE",
		ctermfg = existing_hl.ctermbg,
		ctermbg = "NONE",
	})

	return new_group
end

local divisor = ""
local reverse_divisor = ""
local empty_divisor = ""

local function apply_highlights(is_current, item)
	local new_state = ""
	local highlight_group = "lualine_a" .. highlights.get_mode_suffix()
	local reverse_highlight_group = create_reverse_highlight(highlight_group)
	if is_current then
		new_state = new_state .. highlight(reverse_divisor, reverse_highlight_group)
		new_state = new_state .. highlight(item, highlight_group)
		new_state = new_state .. highlight(divisor, reverse_highlight_group)
	else
		new_state = new_state .. " " .. item .. " "
	end

	return new_state
end

function M:init(options)
	component_icon = options.component_icon or ""
	M.super.init(self, options)
end

local state
vim.g.harpoon_has_changed = true

function M:update_status()
	if vim.g.harpoon_has_changed then
		state = component_icon .. " "

		local harpoon_files = harpoon_utils.list.items

		local processed_items = process_harpoon_items(harpoon_files)

		for index, processed_item in pairs(processed_items) do
			local new_item = create_item(index, processed_item)
			local hightlighted_item = apply_highlights(processed_item.is_current, new_item)
			state = state .. hightlighted_item
		end

		-- add an empty string with Normal highlight gr
		-- vim.g.harpoon_has_changed = false
	end
	return state
end

return M
