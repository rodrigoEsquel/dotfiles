local function open_tab(name, onCreate, create)
	-- check if name is number, if so switch to that tab
	if type(name) == "number" then
		vim.cmd(name .. "tabnext")
		return
	end

	-- check if creted is defined (it can be a boolean or undefined)
	create = create == nil and true or create

	-- Iterate through existing tabs
	for i = 1, vim.fn.tabpagenr("$") do
		-- Check if the tab has a name containing "name"
		local tabpage = vim.api.nvim_tabpage_get_number(i)
		local tabname = vim.api.nvim_tabpage_get_var(tabpage, "tabname")
		if string.find(string.lower(tabname), name) then
			-- If found, switch to that tab
			vim.cmd(i .. "tabnext")
			return
		end
	end

	if create then
		vim.cmd("tabnew")
	end

	-- check if onCreate exist
	if onCreate then
		onCreate()
	end

	-- Optionally, set the tab name (if your Neovim setup supports tab naming)
	vim.cmd("LualineRenameTab " .. name)
end

vim.keymap.set("n", "<leader>t", function()
	local number = vim.fn.getcharstr()
	local numeric_value = tonumber(number)

	-- Check if the conversion was successful
	if numeric_value then
		open_tab(numeric_value)
	else
		-- print("Invalid number entered")
	end
end, { remap = true })

return open_tab
