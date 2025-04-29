local M = require("lualine.component"):extend()

local Path = require("plenary.path")
local harpoon_utils = require("customizations.harpoon-utils")
local web_devicons = require("nvim-web-devicons")
local highlights = require("lualine.highlight")

local component_icon = ""

local function highlight(text, group)
	return string.format("%%#%s#%s%%*", group, text)
end

local function is_current_file(file_path)
	local root_dir = vim.loop.cwd()
	local current_file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

	local current_file_normalized = Path:new(current_file):make_relative(root_dir)

	return current_file_normalized == file_path
end

local function create_item(index, file_path)
	local item = ""
	local icon = ""
	local item_name = ""
	local isOil = file_path:match("oil://")
	local _ = ""
	if isOil then
		icon = ""
		item_name = file_path:match("([^/]+)/$")
	else
		icon, _ = web_devicons.get_icon(file_path)
		item_name = file_path:match("[^/]+$")
	end
	if icon == nil then
		icon = ""
	end
	item = " " .. index .. " " .. ( icon  ) .. " " .. item_name .. " "
	return item
end

local function create_reverse_highlight(existing_group)
	local new_group = existing_group .. "_reverse"
	-- Create the new highlight group with cterm=reverse
	local existing_hl = vim.api.nvim_get_hl_by_name(existing_group, true)

	vim.api.nvim_set_hl(0, new_group, {
		fg = existing_hl.background,
		bg = existing_hl.foreground,
		ctermfg = existing_hl.background,
		ctermbg = existing_hl.foreground,
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
-- local divisor = ""
-- local empty_divisor = "❱"

function M:update_status()
	if vim.g.harpoon_has_changed then
		state = component_icon .. "  "

		local harpoon_files = harpoon_utils.list.items
		for index, item in pairs(harpoon_files) do
			local value = item.value
			local new_item = create_item(index, value)
			local is_current = is_current_file(value)
			new_item = apply_highlights(is_current, new_item)
			state = state .. new_item
		end

		-- state = state .. "%##"
		-- vim.g.harpoon_has_changed = false
	end
	return state
end

return M
