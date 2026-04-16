-- UUID v4 generator (RFC 4122)
local function generate_uuid4()
	math.randomseed(os.time())

	local function random_hex(length)
		local result = ""
		for _ = 1, length do
			result = result .. string.format("%x", math.random(0, 15))
		end
		return result
	end

	local variant_hex = string.format("%x", math.random(8, 11))

	local uuid = string.format(
		"%s-%s-4%s-%s%s-%s",
		random_hex(8),
		random_hex(4),
		random_hex(3),
		variant_hex,
		random_hex(3),
		random_hex(12)
	)

	return uuid:lower()
end

local function generate_and_copy_uuid()
	local uuid = generate_uuid4()
	vim.fn.setreg("+", uuid)
end

vim.api.nvim_create_user_command("GenerateUUID", generate_and_copy_uuid, {})
vim.api.nvim_set_keymap("n", "<leader>ci", ":GenerateUUID<CR>", { noremap = true, silent = true })

return {}
