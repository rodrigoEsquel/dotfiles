-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
local js_based_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

return {
	{ "nvim-neotest/nvim-nio" },
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			local icons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}

			for name, sign in pairs(icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define("Dap" .. name, {
					text = sign[1],
					texthl = sign[2] or "DiagnosticInfo",
					linehl = sign[3],
					numhl = sign[3],
				})
			end

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					-- Debug single nodejs files
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
					},
					-- Debug nodejs processes (make sure to add --inspect when you run the process)
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = vim.fn.getcwd(),
						sourceMaps = true,
					},
					-- Debug web applications (client side)
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:3000",
								}, function(url)
									if url == nil or url == "" then
										return
									else
										coroutine.resume(co, url)
									end
								end)
							end)
						end,
						webRoot = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						userDataDir = false,
					},
					-- Divider for the launch.json derived configs
					{
						name = "----- ↓ launch.json configs ↓ -----",
						type = "",
						request = "launch",
					},
				}
			end
		end,
		keys = {
			{
				"<leader>rB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>rb",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>rc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>r<space>",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>oc",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes, { border = "rounded" })
				end,
				desc = "[O]pen [C]ontext",
			},
			-- {
			-- 	"<leader>rg",
			-- 	function()
			-- 		require("dap").goto_()
			-- 	end,
			-- 	desc = "Go to Line (No Execute)",
			-- },
			{
				"<leader>ri",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			-- {
			-- 	"<leader>rj",
			-- 	function()
			-- 		require("dap").down()
			-- 	end,
			-- 	desc = "Down",
			-- },
			-- {
			-- 	"<leader>rk",
			-- 	function()
			-- 		require("dap").up()
			-- 	end,
			-- 	desc = "Up",
			-- },
			-- {
			-- 	"<leader>rl",
			-- 	function()
			-- 		require("dap").run_last()
			-- 	end,
			-- 	desc = "Run Last",
			-- },
			-- {
			-- 	"<leader>rp",
			-- 	function()
			-- 		require("dap").pause()
			-- 	end,
			-- 	desc = "Pause",
			-- },
			-- {
			-- 	"<leader>rr",
			-- 	function()
			-- 		require("dap").repl.toggle()
			-- 	end,
			-- 	desc = "Toggle REPL",
			-- },
			{
				"<leader>rs",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>rt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>rw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
			{
				"<leader>rO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>ro",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>ra",
				function()
					if vim.fn.filereadable(".vscode/launch.json") then
						local dap_vscode = require("dap.ext.vscode")
						dap_vscode.load_launchjs(nil, {
							["pwa-node"] = js_based_languages,
							["chrome"] = js_based_languages,
							["pwa-chrome"] = js_based_languages,
						})
					end
					require("dap").continue()
				end,
				desc = "Run with Args",
			},
			{
				"<leader>ru",
				function()
					require("dapui").toggle({})
				end,
				desc = "Dap UI",
			},
			{
				"K",
				function()
					require("dapui").eval()
				end,
				desc = "Eval",
				mode = { "n", "v" },
			},
		},
		dependencies = {
			-- fancy UI for the debugger
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio", "LiadOz/nvim-dap-repl-highlights" },
				-- stylua: ignore
				opts = {
					layouts = {  {
						elements = { {
							id = "scopes",
							size = 0.5
						}, {
							id = "repl",
							size = 0.5
						} },
						position = "bottom",
						size = 10
					} }
				},
				config = function(_, opts)
					-- setup dap config by VsCode launch.json file
					-- require("dap.ext.vscode").load_launchjs()
					local dap = require("dap")
					local dapui = require("dapui")
					require("nvim-dap-repl-highlights").setup()
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},

			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},

			-- which key integration
			{
				"folke/which-key.nvim",
				optional = true,
				opts = {
					defaults = {
						["<leader>d"] = { name = "+debug" },
					},
				},
			},

			-- mason.nvim integration
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					-- Makes a best effort to setup the various debuggers with
					-- reasonable debug configurations
					automatic_installation = true,

					-- You can provide additional configuration to the handlers,
					-- see mason-nvim-dap README for more information
					handlers = {},

					-- You'll need to check that you have the required things installed
					-- online, please don't ask me how to install them :)
					ensure_installed = {
						-- Update this to ensure that you have the debuggers for the langs you want
					},
				},
			},
			-- Install the vscode-js-debug adapter
			{
				"microsoft/vscode-js-debug",
				-- After install, build it and rename the dist directory to out
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					---@diagnostic disable-next-line: missing-fields
					require("dap-vscode-js").setup({
						-- Path of node executable. Defaults to $NODE_PATH, and then "node"
						-- node_path = "node",

						-- Path to vscode-js-debug installation.
						debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

						-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
						-- debugger_cmd = { "js-debug-adapter" },

						-- which adapters to register in nvim-dap
						adapters = {
							"chrome",
							"pwa-node",
							"pwa-chrome",
							"pwa-msedge",
							"pwa-extensionHost",
							"node-terminal",
							"node",
						},

						-- Path for file logging
						-- log_file_path = "(stdpath cache)/dap_vscode_js.log",

						-- Logging level for output to file. Set to false to disable logging.
						-- log_file_level = false,

						-- Logging level for output to console. Set to false to disable console output.
						-- log_console_level = vim.log.levels.ERROR,
					})
				end,
			},
			{
				"Joakker/lua-json5",
				build = "./install.sh",
			},
		},
	},
}
