return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 18,
			direction = "float",
			float_opts = {
				border = "rounded",
			},
		})

		vim.keymap.set("n", "<leader>T", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
	end,
}
