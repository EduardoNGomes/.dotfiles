function ChangeTheme(theme)
	theme = theme or "tokyonight-night"

	vim.cmd.colorscheme(theme)

	--	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

vim.keymap.set("n", "<Leader>t1", function()
	ChangeTheme("tokyonight-night")
end, { desc = "Switch to Tokyo Night" })
vim.keymap.set("n", "<Leader>t2", function()
	ChangeTheme("catppuccin")
end, { desc = "Switch to Catppuccin" })
vim.keymap.set("n", "<Leader>t3", function()
	ChangeTheme("tokyodark")
end, { desc = "Switch to Tokyodark" })
vim.keymap.set("n", "<Leader>t4", function()
	ChangeTheme("onedark")
end, { desc = "Switch to Onedark" })

return {
	-- TokyoNight theme setup
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
			vim.g.tokyonight_transparent = true
			vim.cmd.colorscheme("tokyonight-night")
			vim.cmd.hi("Comment gui=none")
		end,
		config = function()
			require("tokyonight").setup({
				transparent = true,
			})
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},

	-- Tokyodark theme setup
	{
		"tiagovla/tokyodark.nvim",
		priority = 1000,
		opts = {
			transparent_background = true,
			gamma = 1.00,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				identifiers = { italic = true },
				functions = {},
				variables = {},
			},
			custom_highlights = function(highlights, palette)
				return {}
			end,
			custom_palette = function(palette)
				return {}
			end,
			terminal_colors = true,
		},
		config = function(_, opts)
			require("tokyodark").setup(opts)
			vim.cmd("colorscheme tokyodark")
		end,
	},

	-- Catppuccin theme setup
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			ChangeTheme("catppuccin")
		end,
	},

	-- Onedarkpro theme
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		name = "onedarkpro",
		config = function()
			require("onedarkpro").setup({
				options = {
					transparency = true, -- Enable transparent background
				},
			})
			ChangeTheme("onedark")
		end,
	},
}
