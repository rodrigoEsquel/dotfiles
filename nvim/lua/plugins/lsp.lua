return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		"folke/neoconf.nvim",
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap",
		{
			"davidosomething/format-ts-errors.nvim",
			config = function()
				require("format-ts-errors").setup({})
			end,
		},
		{
			"kevinhwang91/nvim-ufo",
			dependencies = "kevinhwang91/promise-async",
			config = function()
				vim.o.foldcolumn = "0" -- '0' is not bad
				vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true

				-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
				vim.keymap.set("n", "zR", require("ufo").openAllFolds)
				vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			end,
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local on_attach = function(_, bufnr) end
		local lspconfig_util = require("lspconfig.util")

		local servers = {
			ts_ls = {
				maxTsServerMemory = 5000,
				log = "verbose",
				preferences = {
					maxTsServerMemory = 5000,
					log = "verbose",
					importModuleSpecifier = "non-relative",
				},
				typescript = {
					maxTsServerMemory = 5000,
					log = "verbose",
					preferences = {
						maxTsServerMemory = 5000,
						log = "verbose",
						importModuleSpecifier = "non-relative",
					},
				},
				javascript = {
					maxTsServerMemory = 5000,
					log = "verbose",
					preferences = {
						maxTsServerMemory = 5000,
						log = "verbose",
						importModuleSpecifier = "non-relative",
					},
				},
			},
			oxlint = {},
			eslint = {
				root_dir = function(fname)
					local oxlint_root = lspconfig_util.root_pattern(".oxlintrc.json")(fname)
					if oxlint_root then
						return nil
					end

					return lspconfig_util.root_pattern(
						".eslintrc",
						".eslintrc.js",
						".eslintrc.cjs",
						".eslintrc.mjs",
						".eslintrc.json",
						".eslintrc.yaml",
						".eslintrc.yml",
						"eslint.config.js",
						"eslint.config.cjs",
						"eslint.config.mjs",
						"eslint.config.ts",
						"eslint.config.mts",
						"eslint.config.cts",
						"package.json"
					)(fname)
				end,
			},

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		require("neoconf").setup({})
		require("ufo").setup()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_enable = true,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
					})
				end,
			},
		})

		local format_is_enabled = false
		vim.api.nvim_create_user_command("KickstartFormatToggle", function()
			format_is_enabled = not format_is_enabled
			print("Setting autoformatting to: " .. tostring(format_is_enabled))
		end, {})

		local _augroups = {}
		local get_augroup = function(client)
			if not _augroups[client.id] then
				local group_name = "kickstart-lsp-format-" .. client.name
				local id = vim.api.nvim_create_augroup(group_name, { clear = true })
				_augroups[client.id] = id
			end

			return _augroups[client.id]
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
			callback = function(event)
				local nmap = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				local bufnr = event.buf

				if client == nil then
					return
				end

				-- Native document highlights (replacing vim-illuminate)
				if client:supports_method("textDocument/documentHighlight") then
					local hl_group = vim.api.nvim_create_augroup("lsp-document-highlight-" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = bufnr,
						group = hl_group,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = bufnr,
						group = hl_group,
						callback = vim.lsp.buf.clear_references,
					})
				end

				nmap("<leader>cn", vim.lsp.buf.rename, "[C]ode re[N]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				nmap("gd", function()
					require("snacks").picker.lsp_definitions()
				end, "[G]oto [D]efinition")
				nmap("g<c-d>", function()
					require("snacks").picker.lsp_definitions({ jump = { cmd = "vsplit" } })
				end, "[G]oto [D]efinition")
				nmap("gR", function()
					require("snacks").picker.lsp_references()
				end, "[G]oto [R]eferences")
				nmap("gI", function()
					require("snacks").picker.lsp_implementations()
				end, "[G]oto [I]mplementation")
				vim.keymap.set({ "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
				-- Lesser used LSP functionality
				nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Only attach to clients that support document formatting
				if not client.server_capabilities.documentFormattingProvider then
					return
				end

				-- Tsserver usually works poorly. Sorry you work with bad languages
				-- You can remove this line if you know what you're doing :)
				if client.name == "ts_ls" then
					return
				end
				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				-- Create an autocmd that will run *before* we save the buffer.
				--  Run the formatting command for the LSP that has just attached.
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = get_augroup(client),
					buffer = bufnr,
					callback = function()
						if not format_is_enabled then
							return
						end

						require("plugins.marks.format")()
					end,
				})
			end,
		})
	end,
}
