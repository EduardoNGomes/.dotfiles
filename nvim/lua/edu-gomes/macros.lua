-- Create a macro to log to the console

-- JS/TS macro
vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "JSLogMacro",
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	callback = function()
		vim.keymap.set("n", "<leader>cl", function()
			local word = vim.fn.expand("<cword>")
			vim.api.nvim_input('oconsole.log("' .. word .. '", ' .. word .. ");<Esc>")
		end, { desc = "Log variable under cursor" })

		vim.fn.setreg("l", 'oconsole.log("0", 0);', "c")
	end,
})

-- Go macro
vim.api.nvim_create_augroup("GoLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "GoLogMacro",
	pattern = { "go" },
	callback = function()
		vim.keymap.set("n", "<leader>cl", function()
			local word = vim.fn.expand("<cword>")
			vim.api.nvim_input('ofmt.Println("' .. word .. '", ' .. word .. ")")
		end, { desc = "Log variable under cursor" })

		vim.fn.setreg("l", 'ofmt.Println("0", 0)', "c")
	end,
})
