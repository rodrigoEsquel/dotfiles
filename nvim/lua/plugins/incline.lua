return {
	"b0o/incline.nvim",
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")
		local get_items = require("customizations.windbar")
		local colors = require("kanagawa.colors").setup({ theme = "wave" }).theme

		local function get_diagnostic_label(props)
			local icons = {
				Error = "",
				Warn = "",
				Info = "",
				Hint = "",
			}

			local label = {}
			for severity, icon in pairs(icons) do
				local n = #vim.diagnostic.get(props.buf,
					{ severity = vim.diagnostic.severity[string.upper(severity)] })
				if n > 0 then
					local fg = "#"
					    .. string.format(
						    "%06x",
						    vim.api.nvim_get_hl_by_name("DiagnosticSign" .. severity, true)
						    ["foreground"]
					    )
					table.insert(label, { icon .. " " .. n .. " ", guifg = fg })
				end
			end
			return label
		end

		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			debounce_threshold = { falling = 500, rising = 250 },
			render = function(props)
				local file_path = vim.api.nvim_buf_get_name(props.buf)
				local is_oil = file_path:match("oil://")
				local ft_icon, ft_color
				if is_oil then
					ft_icon, ft_color = "", colors.diag.warning
				else
					ft_icon, ft_color = devicons.get_icon_color(file_path)
				end

				local diagnostics = get_diagnostic_label(props)
				local items = get_items(file_path)
				local res = {
					-- modified and {
					-- 	" ",
					-- 	"",
					-- 	" ",
					-- 	guibg = helpers.contrast_color(colors.ui.bg),
					-- 	guifg = colors.ui.bg,
					-- } or "",
					props.focused
					and ft_icon
					and {
						" ",
						ft_icon,
						" ",
						guifg = helpers.contrast_color(ft_color),
						guibg = ft_color,
					}
					or "",
					" ",
					guibg = colors.ui.bg_dim,
				}
				for i, item in ipairs(items) do
					if props.focused or i == #items then
						table.insert(res, {
							{ item.text, group = item.hl },
						})
					end
				end

				table.insert(res, {
					" ",
				})
				if #diagnostics > 0 then
					table.insert(diagnostics, { "| ", guifg = "grey" })
				end
				for _, buffer_ in ipairs(res) do
					table.insert(diagnostics, buffer_)
				end
				return diagnostics
			end,
		})
	end,
}
