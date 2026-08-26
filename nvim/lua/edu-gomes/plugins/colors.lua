-- Tokyo Night is kept as an easy fallback. Uncomment this block to enable it again.
--[[
return {
	-- TokyoNight theme setup
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
				on_colors = function() end, -- Empty function
				on_highlights = function() end, -- Empty function
				style = "night", -- Default style
				light_style = "day", -- Default light style
				terminal_colors = true, -- Default value
				day_brightness = 0.3, -- Default value
				dim_inactive = false, -- Default value
				lualine_bold = false, -- Default value
				cache = true, -- Default value
				plugins = {
					-- Add empty plugin configurations
					cmp = true,
					gitsigns = true,
					indent_blankline = true,
					nvim_tree = true,
					telescope = true,
					treesitter = true,
					which_key = true,
				},
			})
		end,
	},
}
]]

return {}
