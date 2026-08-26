return {
	"HiPhish/rainbow-delimiters.nvim",
	lazy = false,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("rainbow-delimiters.setup").setup({
			strategy = {
				[""] = "rainbow-delimiters.strategy.global",
			},
			query = {
				[""] = "rainbow-delimiters",
			},
			priority = {
				[""] = 210,
			},
			highlight = {
				"RainbowDelimiterYellow",
				"RainbowDelimiterViolet",
				"RainbowDelimiterCyan",
			},
		})
	end,
}
