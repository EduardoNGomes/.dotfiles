return {
	"prisma/vim-prisma",
	config = function()
		vim.api.nvim_set_keymap("n", "<leader>pf", ":!prisma format<CR>", { noremap = true, silent = true })
	end,
}
