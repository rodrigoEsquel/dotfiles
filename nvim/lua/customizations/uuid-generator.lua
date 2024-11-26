local function generate_uuid4()
	-- Seed the random generator
	math.randomseed(os.time())

	-- Function to generate a random hexadecimal string
	local function random_hex(length)
		local result = ""
		for _ = 1, length do
			result = result .. string.format("%x", math.random(0, 15))
		end
		return result
	end

	-- Variant bits modification for RFC 4122 compliance
	local variant_hex = string.format("%x", math.random(8, 11))

	-- Construct UUID manually to avoid format string issues
	local uuid = string.format(
		"%s-%s-4%s-%s%s-%s",
		random_hex(8), -- time_low
		random_hex(4), -- time_mid
		random_hex(3), -- time_high
		variant_hex, -- clock_seq_hi
		random_hex(1), -- clock_seq_low
		random_hex(12) -- node
	)

	return uuid:lower()
end

-- Function to generate and copy UUID to Neovim's paste registry
local function generate_and_copy_uuid()
	local uuid = generate_uuid4()

	-- Copy to Neovim's + register (system clipboard)
	vim.fn.setreg("+", uuid)
end

-- Create a Neovim command
vim.api.nvim_create_user_command("GenerateUUID", generate_and_copy_uuid, {})

vim.api.nvim_set_keymap("n", "<leader>gu", ":GenerateUUID<CR>", { noremap = true, silent = true })
