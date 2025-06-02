local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Custom action to add selected files to avante context
local function add_selected_to_avante_context(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local multi_selection = picker:get_multi_selection()

	-- If no multi-selection, use current selection
	if #multi_selection == 0 then
		local current_selection = action_state.get_selected_entry()
		if current_selection then
			multi_selection = { current_selection }
		end
	end

	-- Close telescope
	actions.close(prompt_bufnr)

	-- Add selected files to avante context
	for _, entry in ipairs(multi_selection) do
		local filepath = entry.path or entry.filename or entry.value
		if filepath then
			-- Call avante's add to context function
			require("avante").current.sidebar.file_selector:add_selected_file(filepath)
			print("Added to avante context: " .. filepath)
		end
	end
end

-- Custom action to add ALL files from current picker to avante context
local function add_all_to_avante_context(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local manager = picker.manager

	-- Close telescope first
	actions.close(prompt_bufnr)

	-- Get all entries from the picker
	local all_entries = {}
	for entry in manager:iter() do
		table.insert(all_entries, entry)
	end

	-- Add all files to avante context
	local count = 0
	for _, entry in ipairs(all_entries) do
		local filepath = entry.path or entry.filename or entry.value
		if filepath then
			require("avante").current.sidebar.file_selector:add_selected_file(filepath)
			count = count + 1
		end
	end

	print("Added " .. count .. " files to avante context")
end
return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	config = function()
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						-- Ctrl+a to add selected files to avante context
						["<C-a>"] = add_selected_to_avante_context,
						-- Ctrl+Shift+a to add ALL files to avante context
						["<C-S-a>"] = add_all_to_avante_context,
					},
					n = {
						-- 'a' in normal mode to add selected files to avante context
						["a"] = add_selected_to_avante_context,
						-- 'A' in normal mode to add ALL files to avante context
						["A"] = add_all_to_avante_context,
					},
				},
			},
		})
		require("avante").setup({
			-- add any opts here
			-- for example
			provider = "gemini",
			gemini = {
				endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
				model = "gemini-2.0-flash",
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0.75,
				max_tokens = 8192,
			},
		})
	end,
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make BUILD_FROM_SOURCE=true",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
