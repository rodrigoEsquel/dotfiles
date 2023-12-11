local function cleanRegister(inputString)
	local _, startIndex = inputString:find("%S") -- Find the first non-whitespace character
	if startIndex then
		local endIndex = inputString:find("\n", startIndex) -- Find the first newline character after the first non-whitespace character
		if endIndex then
			local firstLine = inputString:sub(startIndex, endIndex - 1) -- Extract the first line
			return firstLine
		else
			return inputString:sub(startIndex) -- If no newline character found, return the rest of the string
		end
	else
		return "" -- Return an empty string if the input only contains whitespace
	end
end

-- local inputString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
--
-- for i = 1, #inputString do
-- 	local char = inputString:sub(i, i)
-- 	print(char)
-- 		vim.fn.setreg(char, '')
-- end

local function get_registers()
	local storage = require("yanky.history").storage
	local register_list = {}

	if storage == nil then
		return register_list
	end

	for i = 1, 5, 1 do
		local register = storage.get(i)
		if register and register.regcontents then
			table.insert(register_list, i .. ". " .. cleanRegister(register.regcontents))
		end
	end
	return register_list
end

return {

	title = "Registers",

	icon = "󱃕",

	draw = function()
		return { lines = get_registers() }
	end,
}
