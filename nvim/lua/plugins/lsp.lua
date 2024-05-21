return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{
			"williamboman/mason.nvim",
			opts = {
				registries = {
					"github:nvim-java/mason-registry",
					"github:mason-org/mason-registry",
				},
			},
		},
		"williamboman/mason-lspconfig.nvim",
		"folke/neoconf.nvim",
		"nvim-java/lua-async-await",
		"nvim-java/nvim-java-core",
		"nvim-java/nvim-java-test",
		"nvim-java/nvim-java-dap",
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap",
		"nvim-java/nvim-java",

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{
			"j-hui/fidget.nvim",
			opts = {},
		},

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},
	config = function()
		-- LSP settings.
		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.

			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>cn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
			nmap("gt", require("telescope.builtin").lsp_type_definitions, "[T]ype Definition")

			-- nmap(
			-- 	"<leader>sS",
			-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
			-- 	"[W]orkspace [S]ymbols",
			-- )

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			vim.keymap.set({ "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end
		-- LSP settings (for overriding per client)
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
				{ border = "rounded" }),

		}

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		local servers = {
			jdtls = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			tsserver = {
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

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		-- Setup neovim lua configuration
		require("neodev").setup({})
		require("java").setup()
		require("neoconf").setup({})

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		mason_lspconfig.setup_handlers({
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					handlers = handlers,
				})
			end,
		})

		local format_is_enabled = false
		vim.api.nvim_create_user_command("KickstartFormatToggle", function()
			format_is_enabled = not format_is_enabled
			print("Setting autoformatting to: " .. tostring(format_is_enabled))
		end, {})

		-- Create an augroup that is used for managing our formatting autocmds.
		--      We need one augroup per client to make sure that multiple clients
		--      can attach to the same buffer without interfering with each other.
		local _augroups = {}
		local get_augroup = function(client)
			if not _augroups[client.id] then
				local group_name = "kickstart-lsp-format-" .. client.name
				local id = vim.api.nvim_create_augroup(group_name, { clear = true })
				_augroups[client.id] = id
			end

			return _augroups[client.id]
		end

		-- Whenever an LSP attaches to a buffer, we will run this function.
		--
		-- See `:help LspAttach` for more information about this autocmd event.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
			-- This is where we attach the autoformatting for reasonable clients
			callback = function(args)
				local client_id = args.data.client_id
				local client = vim.lsp.get_client_by_id(client_id)
				local bufnr = args.buf

				-- Only attach to clients that support document formatting
				if not client.server_capabilities.documentFormattingProvider then
					return
				end

				-- Tsserver usually works poorly. Sorry you work with bad languages
				-- You can remove this line if you know what you're doing :)
				if client.name == "tsserver" then
					return
				end

				-- Create an autocmd that will run *before* we save the buffer.
				--  Run the formatting command for the LSP that has just attached.
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = get_augroup(client),
					buffer = bufnr,
					callback = function()
						if not format_is_enabled then
							return
						end

						require("customizations.format-file-saving-marks")()
					end,
				})
			end,
		})
	end,
}
