local function open_tab(name, onCreate, create)
	if type(name) == "number" then
		vim.cmd(name .. "tabnext")
		return
	end

	create = create == nil and true or create

	for i = 1, vim.fn.tabpagenr("$") do
		local tabpage = vim.api.nvim_tabpage_get_number(i)
		local tabname = vim.api.nvim_tabpage_get_var(tabpage, "tabname")
		if string.find(string.lower(tabname), name) then
			vim.cmd(i .. "tabnext")
			return
		end
	end

	if create then
		vim.cmd("tabnew")
	end

	if onCreate then
		onCreate()
	end

	vim.cmd("LualineRenameTab " .. name)
end

vim.keymap.set("n", "<leader>t", function()
	local number = vim.fn.getcharstr()
	local numeric_value = tonumber(number)
	if numeric_value then
		open_tab(numeric_value)
	end
end, { remap = true })

package.loaded["plugins.open-tab"] = open_tab
return {}
