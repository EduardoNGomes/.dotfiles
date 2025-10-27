return {
	"andythigpen/nvim-coverage",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("coverage").setup({
			auto_reload = true,
		})
		vim.keymap.set("n", "<leader>cs", "<cmd>CoverageLoad<CR><cmd>CoverageShow<CR>", { desc = "Show coverage" })

		vim.keymap.set("n", "<leader>ch", "<cmd>CoverageHide<CR>", { desc = "Hide coverage" })
	end,
}
