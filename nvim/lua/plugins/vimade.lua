return {
	"tadaa/vimade",
	lazy = false,
	dependencies = { "folke/edgy.nvim" },
	config = function()
		local DEBUG = true
		local log_path = vim.fn.stdpath("cache") .. "/vimade-edgy.log"
		local function log(msg)
			if not DEBUG then
				return
			end
			local f = io.open(log_path, "a")
			if f then
				f:write(os.date("%H:%M:%S") .. " " .. msg .. "\n")
				f:close()
			end
		end

		local function win_info(winid)
			if not winid or not vim.api.nvim_win_is_valid(winid) then
				return tostring(winid) .. "(invalid)"
			end
			local buf = vim.api.nvim_win_get_buf(winid)
			return string.format("%d[ft=%s,bt=%s]", winid, vim.bo[buf].filetype, vim.bo[buf].buftype)
		end

		local function is_edgy(winid)
			if not winid or not vim.api.nvim_win_is_valid(winid) then
				return false
			end
			local ok, edgy = pcall(require, "edgy")
			if not ok then
				log("edgy require failed")
				return false
			end
			return edgy.get_win(winid) ~= nil
		end

		local function is_real_code(winid)
			if not winid or not vim.api.nvim_win_is_valid(winid) then
				return false
			end
			if is_edgy(winid) then
				return false
			end
			local buf = vim.api.nvim_win_get_buf(winid)
			local bt = vim.bo[buf].buftype
			return bt == "" or bt == "acwrite"
		end

		vim.g.vimade_last_code_win = -1
		local cur = vim.api.nvim_get_current_win()
		if is_real_code(cur) then
			vim.g.vimade_last_code_win = cur
		end

		vim.api.nvim_create_autocmd("WinLeave", {
			group = vim.api.nvim_create_augroup("vimade_edgy_track", { clear = true }),
			callback = function()
				local w = vim.api.nvim_get_current_win()
				if is_real_code(w) then
					log("WinLeave save last_code=" .. win_info(w))
					vim.g.vimade_last_code_win = w
				end
			end,
		})

		require("vimade").setup({
			recipe = { "duo", { animate = false } },
			tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.5 } },
			link = {
				edgy_pair = function(win, active)
					local active_edgy = is_edgy(active.winid)
					local win_edgy = is_edgy(win.winid)
					if is_real_code(active.winid) then
						vim.g.vimade_last_code_win = active.winid
					end
					local last = vim.g.vimade_last_code_win
					local result
					if active_edgy then
						result = last ~= -1
							and vim.api.nvim_win_is_valid(last)
							and win.winid == last
					elseif win_edgy then
						result = true
					else
						result = false
					end
					log(string.format(
						"link win=%s(edgy=%s) active=%s(edgy=%s) last_code=%s -> %s",
						win_info(win.winid), tostring(win_edgy),
						win_info(active.winid), tostring(active_edgy),
						tostring(vim.g.vimade_last_code_win),
						tostring(result)
					))
					return result
				end,
			},
		})
		vim.cmd("VimadeEnable")

		vim.api.nvim_create_user_command("VimadeEdgyLog", function()
			vim.cmd("tabnew " .. log_path)
		end, {})
		vim.api.nvim_create_user_command("VimadeEdgyLogClear", function()
			local f = io.open(log_path, "w")
			if f then
				f:close()
			end
		end, {})
	end,
	keys = {
		{ "<leader>f", "<cmd>VimadeToggle<CR>", desc = "Toggle Focus" },
	},
}
