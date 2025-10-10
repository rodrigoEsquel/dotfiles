return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	config = function()
		require("kanagawa").setup({
			theme = "dragon",
			-- dimInactive = true, -- dim inactive window `:h hl-NormalNC`
			transparent = true,
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
					-- TelescopePromptBorder = { fg = theme.ui.fg_dim },
					-- TelescopePreviewBorder = { fg = theme.ui.fg_dim },
					-- TelescopeResultsBorder = { fg = theme.ui.fg_dim },
					-- vim.cmd("highlight NoiceCmdlinePopupBorderCmdline guibg=" .. color.bg)
					-- vim.cmd("highlight NoiceCmdlinePopupBorderSearch guibg=" .. color.bg)
					--
					-- transparent background
					Normal = { bg = "none" },
					NormalFloat = { bg = "none" },
					FloatBorder = { fg = theme.ui.fg, bg = "none" },
					Pmenu = { bg = "none" },
					Terminal = { bg = "none" },
					EndOfBuffer = { bg = "none" },
					FoldColumn = { bg = "none" },
					Folded = { bg = "none" },
					SignColumn = { bg = "none" },
					NormalNC = { bg = "none" },
					WhichKeyFloat = { bg = "none" },
					TelescopeBorder = { fg = theme.ui.fg_dim, bg = "none" },
					TelescopeNormal = { bg = "none" },
					TelescopePromptBorder = { bg = "none" },
					TelescopePromptTitle = { bg = "none" },

					NeoTreeNormal = { bg = "none" },
					NeoTreeNormalNC = { bg = "none" },
					NeoTreeVertSplit = { bg = "none" },
					NeoTreeWinSeparator = { bg = "none" },
					NeoTreeEndOfBuffer = { bg = "none" },

					NvimTreeNormal = { bg = "none" },
					NvimTreeVertSplit = { bg = "none" },
					NvimTreeEndOfBuffer = { bg = "none" },

					NotifyINFOBody = { bg = "none" },
					NotifyERRORBody = { bg = "none" },
					NotifyWRNBody = { bg = "none" },
					NotifyTRCEBody = { bg = "none" },
					NotifyDEBUGBody = { bg = "none" },
					NotifyINFOTitle = { bg = "none" },
					NotifyERRORTitle = { bg = "none" },
					NotifyWARNTitle = { bg = "none" },
					NotifyTRACETitle = { bg = "none" },
					NotifyDEBUGTitle = { bg = "none" },
					NotifyINFOBorder = { bg = "none" },
					NotifyERRORBorder = { bg = "none" },
					NotifyWARNBorder = { bg = "none" },
					NotifyTRACEBorder = { bg = "none" },
					NotifyDEBUGBorder = { bg = "none" },
				}
			end,
		})
		vim.cmd("colorscheme kanagawa")
		-- vim.cmd("highlight FloatBorder guibg=NONE")
	end,
}
