return {
	"b0o/incline.nvim",
	config = function()
		local devicons = require("nvim-web-devicons")
		local get_items = require("customizations.windbar")
		local colors = require("kanagawa.colors").setup({ theme = "wave" }).theme

		local function get_git_diff(props)
			local icons = { removed = " ", changed = " ", added = " " }
			local signs = vim.b[props.buf].gitsigns_status_dict
			local labels = {}
			if signs == nil then
				return labels
			end
			for name, icon in pairs(icons) do
				if tonumber(signs[name]) and signs[name] > 0 then
					table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
				end
			end
			if #labels > 0 then
				table.insert(labels, { "| " })
			end
			return labels
		end

		local function get_diagnostic_label(props)
			local icons = { error = " ", warn = " ", info = " ", hint = " " }
			local label = {}

			for severity, icon in pairs(icons) do
				local n = #vim.diagnostic.get(props.buf,
					{ severity = vim.diagnostic.severity[string.upper(severity)] })
				if n > 0 then
					table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
				end
			end
			if #label > 0 then
				table.insert(label, { "| " })
			end
			return label
		end

		-- local function get_harpoon_items()
		-- 	local harpoon = require("harpoon")
		-- 	local marks = harpoon:list().items
		-- 	local current_file_path = vim.fn.expand("%:p:.")
		-- 	local label = {}
		--
		-- 	for id, item in ipairs(marks) do
		-- 		if item.value == current_file_path then
		-- 			table.insert(label, { id .. " ", guifg = "#FFFFFF", gui = "bold" })
		-- 		else
		-- 			table.insert(label, { id .. " ", guifg = "#434852" })
		-- 		end
		-- 	end
		--
		-- 	if #label > 0 then
		-- 		table.insert(label, 1, { "󰛢 ", guifg = "#61AfEf" })
		-- 		table.insert(label, { "| " })
		-- 	end
		-- 	return label
		-- end

		local function get_file_name(props)
			local label = {}
			local file_path = vim.api.nvim_buf_get_name(props.buf)
			local items = get_items(file_path)
			local is_oil = file_path:match("oil://")
			local ft_icon, ft_color
			if is_oil then
				ft_icon, ft_color = "", colors.diag.warning
			else
				ft_icon, ft_color = devicons.get_icon_color(file_path)
			end
			table.insert(label, { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" })
			table.insert(label, { vim.bo[props.buf].modified and " " or "", guifg = "#d19a66" })
			for i, item in ipairs(items) do
				if props.focused or i == #items then
					table.insert(label, {
						{ item.text, group = item.hl },
					})
				end
			end

			return label
		end

		require("incline").setup({
			window = {
				placement = {
					vertical = "top",
					horizontal = "center",
				},
				padding = 0,
				margin = { vertical = 1, horizontal = 0 },
			},
			hide = {
				cursorline = true,
			},
			render = function(props)
				return {
					{ "", guifg = props.focused and colors.ui.bg_m2 or colors.ui.bg_p2 },
					{
						{ get_diagnostic_label(props) },
						{ get_git_diff(props) },
						-- { get_harpoon_items() },
						{ get_file_name(props) },
						guibg = props.focused and colors.ui.bg_m2 or colors.ui.bg_p2,
					},
					{ "", guifg = props.focused and colors.ui.bg_m2 or colors.ui.bg_p2 },
				}
			end,
		})
	end,
}
