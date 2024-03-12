-- function! SaveLastReg()
--     if v:event['regname']==""
--         if v:event['operator']=='y'
--             for i in range(8,1,-1)
--                 exe "let @".string(i+1)." = @". string(i)
--             endfor
--             if exists("g:last_yank")
--                 let @1=g:last_yank
--             endif
--             let g:last_yank=@"
--         endif
--     endif
-- endfunction
--
-- 1
-- 2
-- 3
-- 4
-- 6
-- :autocmd TextYankPost * call SaveLastReg()
function SaveLastReg()
	if vim.v.event["regname"] == "" then
		if vim.v.event["operator"] == "y" then
			for i = 8, 2, -1 do
				vim.fn.setreg((i + 1), vim.fn.getreg(i))
			end
			-- if vim.g.last_yank ~= nil then
			-- 	vim.fn.setreg("1", vim.g.last_yank)
			-- end
			-- vim.g.last_yank = vim.fn.getreg('"')
		end
	end
end

vim.api.nvim_command("autocmd TextYankPost * lua SaveLastReg()")

-- Normal mode mappings
vim.api.nvim_set_keymap("n", "p", [[v:register == '"' ? '"1p' : 'p']], { expr = true })
vim.api.nvim_set_keymap("n", "P", [[v:register == '"' ? '"1P' : 'P']], { expr = true })

-- Visual mode mappings
vim.api.nvim_set_keymap("x", "p", [[v:register == '"' ? '"1p' : 'p']], { expr = true })
vim.api.nvim_set_keymap("x", "P", [[v:register == '"' ? '"1P' : 'P']], { expr = true })
