return {
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*", -- Enable for all file types
				css = { rgb_fn = true }, -- Enable RGB functions for CSS files
			})
		end,
	},
}
