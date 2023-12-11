local function get_marks()
	local marks = require("marks").mark_state:buffer_to_list("table")

	local mark_list = {}

	if marks == nil then
		return mark_list
	end

	for _, mark in ipairs(marks) do
		if mark.text then
			local mark_title = mark.text:gsub("mark%s*([%w%p]+)%s*", "%1 ", 1)
			table.insert(mark_list, mark_title)
		end
	end

	return mark_list
end

return {

	title = "Jumps",

	icon = "󱞯",

	draw = function()
		return { lines = get_marks() }
	end,
}
