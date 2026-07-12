return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Alternar Zen Mode" },
	},
	opts = {
		window = {
			width = 120,
			options = {
				colorcolumn = "",
				wrap = true,
				linebreak = true,
				breakindent = true,
			},
		},
	},
}
