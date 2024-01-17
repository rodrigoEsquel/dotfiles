local M = require("lualine.component"):extend()

local Path = require("plenary.path")
local harpoon_utils = require("customizations.harpoon-utils")
local web_devicons = require("nvim-web-devicons")
local highlights = require("lualine.highlight")

local component_icon = ""

local function is_current_file(file_path)
	local root_dir = vim.loop.cwd()
	local current_file = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

	local current_file_normalized = Path:new(current_file):make_relative(root_dir)

	return current_file_normalized == file_path
end

local function create_item(index, file_path)
	local item = ""
	local icon, _ = web_devicons.get_icon(file_path)
	local file_name = file_path:match("[^/]+$")
	item = " " .. index .. " " .. icon .. " " .. file_name .. " "
	return item
end

local function apply_highlights(is_current, item)
	local new_state = ""
	if is_current then
		new_state = "%#lualine_a" .. highlights.get_mode_suffix() .. "#" .. item .. ""
	else
		new_state = "%#lualine_a_inactive#" .. item .. ""
	end
	return new_state
end

function M:init(options)
	component_icon = options.component_icon or ""
	M.super.init(self, options)
end

function M:update_status()
	local state = "%#lualine_a_inactive#" .. component_icon .. " "
	local harpoon_files = harpoon_utils.list.items
	for index, item in ipairs(harpoon_files) do
		local value = item.value
		local new_item = create_item(index, value)
		local is_current = is_current_file(value)
		new_item = apply_highlights(is_current, new_item)
		state = state .. new_item
	end
	return state .. "%##"
end

return M
