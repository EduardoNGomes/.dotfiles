return {
	{
		"catgoose/nvim-colorizer.lua",
		name = "colorizer-catgoose",
		config = function()
			require("colorizer").setup({
				filetypes = { "*", css = { rgb_fn = true } },
			})
		end,
	},
}
