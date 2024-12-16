return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
		"nvim-treesitter/playground",
	},
	version = false, -- last release is way too old and doesn't work on Windows
	build = ":TSUpdate",
	event = { "VeryLazy" },
	init = function(plugin)
		-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
		-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
		-- no longer trigger the **nvim-treeitter** module to be loaded in time.
		-- Luckily, the only thins that those plugins need are the custom queries, which we make available
		-- during startup.
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	config = function()
		require("treesitter-context").setup({
			max_lines = 4,
			min_window_height = 10,
		})

		require("nvim-treesitter.configs").setup({
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = {
				"c",
				"cpp",
				"go",
				"lua",
				"html",
				"python",
				"rust",
				"tsx",
				"typescript",
				"vimdoc",
				"vim",
			},

			-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true, disable = { "python" } },
			injections = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>v",
					node_incremental = "<CR>",
					node_decremental = "<BS>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_previous = {
						["<leader>k"] = "@parameter.inner",
					},
					swap_next = {
						["<leader>j"] = "@parameter.inner",
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>cu", function()
			require("treesitter-context").go_to_context()
		end, { silent = true, desc = "Go [U]p to [C]ode context" })

		local function set_template_literal_lang_from_comment(match, _, bufnr, pred, metadata)
			local comment_node = match[pred[2]]
			if comment_node then
				local success, comment = pcall(vim.treesitter.get_node_text, comment_node, bufnr)
				if success then
					local tag = comment:match("/%*%s*(%w+)%s*%*/")
					if tag then
						local language = tag:lower() == "svg" and "html"
						    or vim.filetype.match({ filename = "a." .. tag })
						    or tag:lower()
						metadata["injection.include-children"] = true
						metadata["injection.language"] = language
					end
				end
			end
		end
		local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

		-- Enable SQL injection for JavaScript and TypeScript
		parser_configs.javascript = {
			filetype = "javascript",
			-- Explicitly add SQL as an injectable language
			injection = {
				languages = { "sql" },
			},
		}

		parser_configs.typescript = {
			filetype = "typescript",
			-- Explicitly add SQL as an injectable language
			injection = {
				languages = { "sql" },
			},
		}

		vim.treesitter.query.add_directive(
			"set-template-literal-lang-from-comment!",
			set_template_literal_lang_from_comment,
			{}
		)
	end,
}
