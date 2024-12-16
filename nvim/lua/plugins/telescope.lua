local function document_symbols_for_selected(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")
	local entry = action_state.get_selected_entry()

	if entry == nil then
		print("No file selected")
		return
	end

	actions.close(prompt_bufnr)

	vim.schedule(function()
		local bufnr = vim.fn.bufadd(entry.path)
		vim.fn.bufload(bufnr)

		local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

		vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result, _, _)
			if err then
				print("Error getting document symbols: " .. vim.inspect(err))
				return
			end

			if not result or vim.tbl_isempty(result) then
				print("No symbols found")
				return
			end

			local excluded_kinds = {
				[vim.lsp.protocol.SymbolKind.Variable] = true,
				[vim.lsp.protocol.SymbolKind.Property] = true,
				[vim.lsp.protocol.SymbolKind.Constant] = true,
				[vim.lsp.protocol.SymbolKind.Function] = true,
			}

			local function flatten_symbols(symbols, parent_name)
				local flattened = {}
				for _, symbol in ipairs(symbols) do
					local name = symbol.name
					if parent_name then
						name = parent_name .. "." .. name
					else
						if symbol.children then
							local children = flatten_symbols(symbol.children, name)
							for _, child in ipairs(children) do
								if not excluded_kinds[child.kind] then
									table.insert(flattened, child)
								end
							end
						end
					end
					table.insert(flattened, {
						name = name,
						kind = symbol.kind,
						range = symbol.range,
						selectionRange = symbol.selectionRange,
					})
				end
				return flattened
			end

			local flat_symbols = flatten_symbols(result)

			-- Filter out properties and variables
			local filtered_symbols = vim.tbl_filter(function(symbol)
				-- Exclude Variable and Property kinds
				return not excluded_kinds[symbol.kind]
			end, flat_symbols)

			-- Define highlight group for symbol kind
			vim.cmd([[highlight TelescopeSymbolKind guifg=#61AFEF]])

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Document Symbols: " .. vim.fn.fnamemodify(entry.path, ":t"),
					finder = require("telescope.finders").new_table({
						results = flat_symbols,
						entry_maker = function(symbol)
							local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Other"
							return {
								value = symbol,
								display = function(entry)
									local display_text = string.format("%-50s %s", entry.value.name, kind)
									return display_text,
										{ { { #entry.value.name + 1, #display_text }, "TelescopeSymbolKind" } }
								end,
								ordinal = symbol.name,
								filename = entry.path,
								lnum = symbol.selectionRange.start.line + 1,
								col = symbol.selectionRange.start.character + 1,
							}
						end,
					}),
					sorter = require("telescope.config").values.generic_sorter({}),
					previewer = require("telescope.config").values.qflist_previewer({}),
					attach_mappings = function(_, map)
						map("i", "<CR>", function(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.cmd("edit " .. selection.filename)
							vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
						end)
						return true
					end,
				})
				:find()
		end)
	end)
end

return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	config = function()
		require("telescope.pickers.layout_strategies").horizontal_merged = function(
			picker,
			max_columns,
			max_lines,
			layout_config
		)
			local layout =
				require("telescope.pickers.layout_strategies").horizontal(picker, max_columns, max_lines, layout_config)

			layout.prompt.title = ""

			layout.results.title = ""
			layout.results.borderchars = { "─", "│", "─", "│", "├", "┤", "╯", "╰" }
			layout.results.line = layout.results.line - 1
			layout.results.height = layout.results.height + 1

			if layout.preview then
				layout.preview.title = ""
			end

			return layout
		end

		require("telescope").setup({

			defaults = {
				file_ignore_patterns = {
					".git/",
					"node_modules/",
				},
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",
				results_title = false,
				-- layout_strategy = "horizontal_merged",
				layout_strategy = "horizontal",
				prompt_title = false,
				-- dynamic_preview_title = true,
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				initial_mode = "insert",
				-- sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						height = { padding = 2 },
						preview_width = 0.5,
						width = { padding = 5 },
						-- prompt_position = "top",
					},
					vertical = {
						-- height = { padding = 2 },
						-- -- preview_width = 0.5,
						-- width = { padding = 5 },
						prompt_position = "top",
						mirror = true,
						preview_cutoff = 20,
					},
				},
				mappings = {
					i = {
						-- ["<esc>"] = actions.close,
						-- ["<C-t>"] = trouble.open,

						["<C-s>"] = document_symbols_for_selected,
					},

					n = {
						-- ["<C-t>"] = trouble.open,
						["<C-s>"] = document_symbols_for_selected,
					},
				},
				path_display = { "truncate" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		-- Enable telescope fzf native, if installed
		pcall(require("telescope").load_extension, "fzf")
		-- pcall(require("telescope").load_extension, "macros")

		-- See `:help telescope.builtin`
		vim.keymap.set(
			"n",
			"<leader>?",
			require("telescope.builtin").oldfiles,
			{ desc = "[?] [S]earch recently opened files" }
		)

		-- vim.keymap.set("n", "<leader><space>", function()
		-- 	require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
		-- 		previewer = false,
		-- 		borderchars = {
		-- 			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
		-- 			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
		-- 			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		-- 		},
		-- 	}))
		-- end, { desc = "[ ] [S]earch existing buffers" })

		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require("telescope.builtin").current_buffer_fuzzy_find()
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>s?", require("telescope.builtin").help_tags, { desc = "[S]earch help[?]" })
		vim.keymap.set(
			"n",
			"<leader>sw",
			require("telescope.builtin").grep_string,
			{ desc = "[S]earch current [W]ord" }
		)
		vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sh", ":Telescope harpoon marks<CR>", { desc = "[S]earch [H]arpoon marks" })
		vim.keymap.set("n", "<leader>sm", ":Telescope macros<CR>", { desc = "[S]earch [M]acros" })
		vim.keymap.set("n", "<leader>ss", ":Telescope git_status<CR>", { desc = "[S]earch git [S]tatus" })
		vim.keymap.set("n", "<leader>sc", ":Telescope git_commits<CR>", { desc = "[S]earch git [C]ommits" })
		vim.keymap.set("n", "<leader>sb", ":Telescope git_branches<CR>", { desc = "[S]earch git [B]ranches" })
		vim.keymap.set("n", "<leader>s<space>", ":Telescope resume<CR>", { desc = "Resume [S]earch" })
	end,
}
