return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	config = function()
		require("kanagawa").setup({
			theme = "wave",
			-- dimInactive = true, -- dim inactive window `:h hl-NormalNC`
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { fg = theme.ui.fg_dim, bg = "none" },
					FloatTitle = { bg = "none" },
					WinSeparator = { fg = theme.ui.fg_dim },
					-- NormalNC = { bg = theme.ui.fg_dim },
					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					CursorLineNr = { bg = theme.ui.bg_p2 },
					CursorLineSign = { bg = theme.ui.bg_p2 },
					CursorLineFold = { bg = theme.ui.bg_p2 },
					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					NoiceCmdlinePopupBorderCmdline = { fg = theme.ui.fg_dim },
					NoiceCmdlinePopupBorderSearch = { fg = theme.ui.fg_dim },
					TelescopeBorder = { fg = theme.ui.fg_dim },
					-- TelescopePromptBorder = { fg = theme.ui.fg_dim },
					-- TelescopePreviewBorder = { fg = theme.ui.fg_dim },
					-- TelescopeResultsBorder = { fg = theme.ui.fg_dim },
					-- vim.cmd("highlight NoiceCmdlinePopupBorderCmdline guibg=" .. color.bg)
					-- vim.cmd("highlight NoiceCmdlinePopupBorderSearch guibg=" .. color.bg)
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
		-- vim.cmd("highlight FloatBorder guibg=NONE")
	end,
}
