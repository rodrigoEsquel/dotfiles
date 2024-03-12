local M = {}

function M.new()
	return setmetatable({}, { __index = M })
end

local cmp = require("cmp")

function M:complete(request, callback)
	local defaultOpts = {
		registers = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	}
	local opts = vim.tbl_deep_extend("force", defaultOpts, request.option or {})

	local registers = {}

	for index, register in ipairs(opts.registers) do
		local reg_contents = vim.fn.getreg(register)
		if reg_contents ~= "" then
			table.insert(registers, {
				label = reg_contents,
				insertText = reg_contents,
				filterText = reg_contents,
				documentation = "Content of register " .. register,
				priority = 1 / index,
			})
		end
	end

	callback({ items = registers })
end

cmp.register_source("registers", M.new())

cmp.setup({
	mapping = {
		["<C-p>"] = cmp.mapping.complete({
			config = {
				sources = {
					{ name = "registers" },
				},
			},
		}),
	},
})

vim.keymap.set(
	"i",
	"<C-p>",
	"<Cmd>lua require('cmp').complete({ config = { sources = { { name = 'registers' } } } })<CR>",
	{ desc = "Open completion with yanky registers" }
)
