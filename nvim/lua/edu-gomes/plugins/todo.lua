return {
	"folke/todo-comments.nvim",
	event = "VimEnter",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("todo-comments").setup({
			signs = true,
			diagnostics = true,
			-- Your configuration options here
		})
	end,
}
